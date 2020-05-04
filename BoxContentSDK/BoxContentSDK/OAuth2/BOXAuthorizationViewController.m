//
//  BOXAuthorizationViewController.m
//  BoxContentSDK
//
//  Created on 2/20/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

@import WebKit;
#import "BOXAuthorizationViewController.h"
#import "BOXLog.h"
#import "BOXUser.h"
#import "BOXContentClient+User.h"
#import "BOXUserRequest.h"
#import "BOXContentSDKErrors.h"
#import "UIApplication+ExtensionSafeAdditions.h"
#import "BOXContentClient+Authentication.h"
#import "BOXOAuth2Session.h"
#import "BOXAppUserSession.h"


typedef void (^BOXAuthCompletionBlock)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error);
typedef void (^BOXAuthCancelBlock)(BOXAuthorizationViewController *authorizationViewController);

@interface BOXAuthorizationViewController () <WKNavigationDelegate>

@property (nonatomic, readwrite, strong) NSError *connectionError;
@property (nonatomic, readwrite, strong) NSString *connectionErrorMessage;
@property (nonatomic, readwrite, strong) NSURLAuthenticationChallenge *authenticationChallenge;
@property (nonatomic, readwrite, strong) NSURLCredential *authenticationChallengeCredential;

@property (nonatomic, readwrite, strong) BOXContentClient *SDKClient;
@property (nonatomic, readwrite, copy) BOXAuthCompletionBlock completionBlock;
@property (nonatomic, readwrite, copy) BOXAuthCancelBlock cancelBlock;
@property (nonatomic, readwrite, strong) NSURL *authorizeURL;
@property (nonatomic, readwrite, strong) NSString *redirectURI;
@property (nonatomic, readwrite, strong) NSDictionary *headers;

@property (nonatomic, readwrite, assign) BOOL isNTLMAuth;
@property (nonatomic, readwrite, assign) NSInteger ntlmAuthFailures;
@property (nonatomic, readwrite, assign) NSInteger authChallengeCycles;

@property (nonatomic, readwrite, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, readwrite) UIBackgroundTaskIdentifier backgroundTaskID;

#define kMaxNTLMAuthFailuresPriorToExit 3
#define kMaxAuthChallengeCycles 100

- (void)loadAuthorizationURL;
- (void)cancel:(id)sender;

@end

@implementation BOXAuthorizationViewController

@synthesize authorizeURL = _authorizeURL;

static NSString *viewPortScriptString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '1.0'); meta.setAttribute('maximum-scale', '1.0'); meta.setAttribute('minimum-scale', '1.0'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);";
static NSString *disableSelectionScriptString = @"document.documentElement.style.webkitUserSelect='none';";
static NSString *disableCalloutScriptString = @"document.documentElement.style.webkitTouchCallout='none';";

- (instancetype)initWithSDKClient:(BOXContentClient *)SDKClient
                  completionBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error))completionBlock
                      cancelBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController))cancelBlock
{
    return [self initWithSDKClient:SDKClient
                      authorizeURL:nil
                       redirectURI:nil
                           headers:nil
                   completionBlock:completionBlock
                       cancelBlock:cancelBlock];
}

- (instancetype)initWithSDKClient:(BOXContentClient *)SDKClient
                     authorizeURL:(NSURL *)authorizeURL
                      redirectURI:(NSString *)redirectURI
                          headers:(NSDictionary *)headers
                  completionBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error))completionBlock
                      cancelBlock:(void (^)(BOXAuthorizationViewController *authorizationViewController))cancelBlock
{
    self = [super init];
    if (self != nil) {
        _SDKClient = SDKClient;
        _completionBlock = completionBlock;
        _cancelBlock = cancelBlock;
        _authorizeURL = authorizeURL;
        _redirectURI = redirectURI;
        _headers = headers;

        _ntlmAuthFailures = 0;
        _authChallengeCycles = 0;
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                 target:self
                                                                                                 action:@selector(cancel:)]];
        _backgroundTaskID = UIBackgroundTaskInvalid;
    }

    return self;
}

- (void)dealloc
{
    WKWebView *webView = (WKWebView *)self.view;
    webView.navigationDelegate = nil;
    [webView stopLoading];
}

- (void)loadView
{
    WKUserContentController *controller = [WKUserContentController new];
    WKUserScript *viewPortScript = [[WKUserScript alloc] initWithSource:viewPortScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *disableSelectionScript = [[WKUserScript alloc] initWithSource:disableSelectionScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserScript *disableCalloutScript = [[WKUserScript alloc] initWithSource:disableCalloutScriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [controller addUserScript:viewPortScript];
    [controller addUserScript:disableSelectionScript];
    [controller addUserScript:disableCalloutScript];

    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.userContentController = controller;
    config.websiteDataStore = [WKWebsiteDataStore nonPersistentDataStore];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
    webView.scrollView.scrollEnabled = YES;
    webView.scrollView.bounces = NO;
    webView.allowsBackForwardNavigationGestures = NO;
    webView.contentMode = UIViewContentModeScaleToFill;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.navigationDelegate = self;

    self.view = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.SDKClient.session isKindOfClass:[BOXOAuth2Session class]]) {
        [self loadAuthorizationURL];
    } else if ([self.SDKClient.session isKindOfClass:[BOXAppUserSession class]]) {
        __weak BOXAuthorizationViewController *me = self;
        [self.SDKClient autheticateAppUserWithCompletionBlock:^(BOXUser *user, NSError *error) {
            me.completionBlock(me, user, error);
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.connectionError != nil) {
        [self handleConnectionErrorWithError:self.connectionError
                                     message:self.connectionErrorMessage];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveBackgroundNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self endBackgroundTask];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];

    [super viewWillDisappear:animated];
}

// Fixes a bug starting iOS 11.3, where backgrounding the app to respond to
// 2FA could cause the login to fail.
- (void)didReceiveBackgroundNotification:(NSNotification *)notification
{
    [self endBackgroundTask];
    __weak BOXAuthorizationViewController *weakSelf = self;
    self.backgroundTaskID = [[UIApplication box_sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [weakSelf endBackgroundTask];
    }];
}

- (void)didReceiveForegroundNotification:(NSNotification *)notification
{
    [self endBackgroundTask];
}

- (void)endBackgroundTask
{
    if (self.backgroundTaskID != UIBackgroundTaskInvalid) {
        [[UIApplication box_sharedApplication] endBackgroundTask:self.backgroundTaskID];
        self.backgroundTaskID = UIBackgroundTaskInvalid;
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.activityIndicator.center = self.view.center;
}

#pragma mark - property getters and setters

- (NSURL *)authorizeURL
{
    if (_authorizeURL == nil) {
        _authorizeURL = ((BOXOAuth2Session *)self.SDKClient.session).authorizeURL;
    }

    return _authorizeURL;
}

- (void)setAuthorizeURL:(NSURL *)authorizeURL
{
    if ([authorizeURL isEqual:self.authorizeURL] == NO) {
        _authorizeURL = authorizeURL;
        if (self.isViewLoaded) {
            [self loadAuthorizationURL];
        }
    }
}

- (NSString *)redirectURI
{
    if (_redirectURI == nil) {
        _redirectURI = ((BOXOAuth2Session *)self.SDKClient.session).redirectURIString;
    }

    return _redirectURI;
}

#pragma mark - Actions

- (void)cancel:(id)sender
{
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}

#pragma mark - Private helper methods

- (void)loadAuthorizationURL
{
    if (self.activityIndicator == nil) {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.view addSubview:self.activityIndicator];
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.authorizeURL];
    if (self.headers != nil) {
        for (NSString *key in self.headers) {
            NSString *value = [self.headers valueForKey:key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    WKWebView *webView = (WKWebView *)self.view;
    [webView loadRequest:[request copy]];
}

- (void)failAuthenticationWithMessage:(NSString *)message
                                error:(NSError *)error
{
    // We can only handle the connection error if we're in the view hierarchy. It would be difficult to display UIAlertControllers when not sure we're in the view hierarchy. We will try again after viewDidAppear
    dispatch_async(dispatch_get_main_queue(), ^{
        //dispatch on main thread UI-related activities
        if (self.view.window) {
            [self handleConnectionErrorWithError:error message:message];
        } else {
            self.connectionError = error;
            self.connectionErrorMessage = message;
            // We still want to report the completion block so that the necessary cleanup is done up in the call tree.
            if (self.completionBlock) {
                self.completionBlock(self, nil, self.connectionError);
            }
        }
        [self.activityIndicator stopAnimating];
     });
}

- (void)handleConnectionErrorWithError:(NSError *)error message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unable to Log In", @"Alert view title: Title for failed SSO login due to authentication issue")
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    __weak typeof(self) weakSelf = self;
    void (^completion)(UIAlertAction *action) = ^void(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];

        if (self.connectionError == nil && weakSelf.completionBlock) {
            weakSelf.completionBlock(weakSelf, nil, error);
        } else {
            weakSelf.connectionError = nil;
            weakSelf.connectionErrorMessage = nil;
        }
        // Clear out the authentication challenge in memory
        weakSelf.authenticationChallenge = nil;
    };

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Label: Allow the user to accept the current condition, often used on buttons to dismiss alerts")
                                                       style:UIAlertActionStyleDefault
                                                     handler:completion];

    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)isLoginRedirectionRequest:(NSURLRequest *)request
{
    BOOL requestIsForLoginRedirectScheme = NO;
    if ([self.redirectURI length] > 0) {
        requestIsForLoginRedirectScheme = [[[request URL] scheme] isEqualToString:[[NSURL URLWithString:self.redirectURI] scheme]];
    }
    return (requestIsForLoginRedirectScheme && [[[request URL] absoluteString] hasPrefix:self.redirectURI]);
}

#pragma mark - WKNavigationDelegate methods

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURLRequest *request = navigationAction.request;

    BOXLog(@"Web view should start request %@ with navigation type %ld", request, (long)navigationType);
    BOXLog(@"Request Headers \n%@", [request allHTTPHeaderFields]);

    // Never load about:blank
    if ([[request.URL.absoluteString lowercaseString] isEqualToString:@"about:blank"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    // Mailto URLs can be encountered if there is a hyperlink for sending an email. Don't handle in the login view.
    if ([[[[request URL] scheme] lowercaseString] isEqualToString:@"mailto"]) {
        [self openURL:request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    // Never load file:// urls.
    if ([[request URL] isFileURL]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    // Figure out whether this request is the redirect used at the end of the authentication process
    BOOL requestIsForLoginRedirection = [self isLoginRedirectionRequest:request];

    if (requestIsForLoginRedirection) {
        [self.activityIndicator startAnimating];

        BOXOAuth2Session *OAuth2Session = (BOXOAuth2Session *)self.SDKClient.session;
        __weak BOXAuthorizationViewController *me = self;
        [OAuth2Session performAuthorizationCodeGrantWithReceivedURL:request.URL withCompletionBlock:^(BOXAbstractSession *session, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (me.completionBlock) {
                        me.completionBlock(me, nil, error);
                    }
                } else {
                    BOXUserRequest *userRequest = [me.SDKClient currentUserRequest];
                    userRequest.requestAllUserFields = YES;
                    [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
                        if (me.completionBlock) {
                            me.completionBlock(me, user, error);
                        }
                    }];
                }
            });
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    if (@available(iOS 11.0, *)) {
        if (![WKWebView handlesURLScheme:request.URL.scheme]) {
            // Open custom scheme links
            [self openURL:request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    BOXLogFunction();
    [self.activityIndicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    BOXLog(@"Web view %@ did fail load with error %@", webView, error);

    // The following error scenarios are benign and do not actually signify that loading the login page has failed:
    // 1. WebKitErrorDomain > WebKitErrorFrameLoadInterruptedByPolicyChange - Indicates that a frame load was interrupted by a policy change.
    //  These constants seem to only be declared for OS X in the WebKit framework, but we're seeing them in iOS.
    // 2. NSURLErrorDomain > NSURLErrorCancelled - Returned when an asynchronous load is canceled. A Web Kit framework delegate will receive this error when it performs a cancel operation on a loading resource.
    // 3. The load attempt was for an iframe rather than the full page

    BOOL ignoreError = NO;
    //NOTE: WebKitErrorDomain and WebKitErrorFrameLoadInterruptedByPolicyChange are only defined on OS X in the WebKit framework
    // however the error is occuring on iOS, thus we use the values directly in the conditional below.
    if ([[error domain] isEqualToString:@"WebKitErrorDomain"] && [error code] == 102) {
        BOXLog(@"Ignoring error with code 102 (WebKitErrorFrameLoadInterruptedByPolicyChange)");
        ignoreError = YES;
    } else if ([[error domain] isEqualToString:NSURLErrorDomain] && [error code] == NSURLErrorCancelled) {
        BOXLog(@"Ignoring error with code URLErrorCancelled");
        ignoreError = YES;
    } else if ([[error domain] isEqualToString:NSURLErrorDomain]) {
        // Check if its just an iframe loading error
        // Note - The suggested key for checking the failed URL is NSURLErrorFailingURLStringErrorKey.
        // However, in testing, this was not found in iOS 5, and only the deprecated value NSErrorFailingURLStringKey
        // was used.  We use the string value instead of the constant as the constant gives a (presumably erronous)
        // deprecated (in iOS 4) warning.
        NSString *requestURLString = [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey];
        if ([requestURLString length] == 0) {
            requestURLString = [[error userInfo] objectForKey:@"NSErrorFailingURLStringKey"];
        }

        BOXLog(@"Checking if error is due to an iframe request.");
        BOXLog(@"Request URL is %@ while main document URL is %@", requestURLString, webView.URL);

        BOOL isMainDocumentURL = [requestURLString isEqualToString:[webView.URL absoluteString]];
        if (isMainDocumentURL == NO) {
            // If the failing URL is not the main document URL, then the load error is in an iframe and can be ignored
            BOXLog(@"Ignoring error as the load failure is in an iframe");
            ignoreError = YES;
        }
    }

    if (ignoreError == NO) {
        BOXLog(@"Presenting error");
        // The error is usually in HTML to be shown to the user.
        // Use about:blank as a placeholder to prevent access to the file-system scope
        // (nil and file:// URLs would allow scoped access to the file-system).
        // Not using box.com since when the error is not valid HTML, the base URL gets loaded.
        [webView loadHTMLString:[error localizedDescription] baseURL:[NSURL URLWithString:@"about:blank"]];
    }

    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    BOXLogFunction();
    [self.activityIndicator stopAnimating];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    BOXLog(@"WebView %@ did receive authentication challenge %@", webView, challenge);

    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodNTLM]) {
        self.isNTLMAuth = YES;
    }

    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        BOXLog(@"Server trust authentication challenge");
        SecTrustResultType trustResult = kSecTrustResultOtherError;
        OSStatus status = SecTrustEvaluate([[challenge protectionSpace] serverTrust], &trustResult);

        // Allow a certificate if its status was evaluated successfully and the result is that it should be trusted
        BOOL shouldTrustServer = (status == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified));

        if (shouldTrustServer) {
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            NSURLCredential *serverTrustCredential = [NSURLCredential credentialForTrust:serverTrust];
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeUseCredential, serverTrustCredential);
            } else {
                [[challenge sender] useCredential:serverTrustCredential
                       forAuthenticationChallenge:challenge];
            }
        } else {
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
            } else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unable to Log In", @"Alert view title: Title for failed SSO login due to authentication issue")
                                                                                         message:NSLocalizedString(@"Could not complete login because the SSO server is untrusted. Please contact your administrator for more information.", @"Alert view message: message for failed SSO login due to untrusted (for example: self signed) certificate")
                                                                                  preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"Label: Allow the user to accept the current condition, often used on buttons to dismiss alerts")
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action) {
                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
    } else {
        BOXLog(@"Authentication challenge of type %@", [[challenge protectionSpace] authenticationMethod]);

        if (self.authChallengeCycles > kMaxAuthChallengeCycles) {
            // Too many auth challenges, fail out
            BOXLog(@"Too many (%ld) authentication challenges - aborting.", (long)self.authChallengeCycles);
            if (completionHandler) {
                completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
            } else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
            NSString *message = NSLocalizedString(@"Unable to log in. Too many authentication challenges issued by the server.", @"Alert view message: message for failed Single-Sign-On login due to encountering too many authentication challenges (a technical network/server issue).");
            NSError *myError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:nil];
            [self failAuthenticationWithMessage:message error:myError];
        } else {
            self.authChallengeCycles++;

            //  The NTLM protocol issues a 401 as part of the negotiation process.
            //  In iOS 8 and later, this 401 results in NSURLAuthenticationChallenge returning a "failureResponse".
            //  However, NSURLAuthenticationChallenge does not return this in iOS 7.
            //  As seen from the CFNetworking logs, NSURLAuthenticationChallenge handles the 401 negotiation,
            //  and the process is seamless in iOS 7.
            //  However, in iOS 8 and later, the last step of the NTLM protocol returns an error that
            //  the developer must handle (as seen from CFNetworking and our app logs).
            //  We only support versions of iOS newer than iOS 8.
            BOOL shouldApplyiOS8_NTLM_WAR = (self.isNTLMAuth &&
                                             [challenge previousFailureCount] > 0 &&
                                             (self.ntlmAuthFailures < kMaxNTLMAuthFailuresPriorToExit));

            // Handle the authentication challenge as a basic HTTP authentication challenge
            // (certificate-based, among other methods, is not currently supported).
            if (shouldApplyiOS8_NTLM_WAR) {
                BOXLog(@"Applying iOS8 NTLM WAR, ntlmAuthFaulures = %ld", (long)self.ntlmAuthFailures);
                self.ntlmAuthFailures++;
                if (completionHandler) {
                    completionHandler(NSURLSessionAuthChallengeUseCredential, NULL);
                } else {
                    [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
                }
            } else if (([challenge previousFailureCount] > 0 &&
                        self.authenticationChallengeCredential == nil) ||
                       [challenge previousFailureCount] > 1) {
                BOXLog(@"Have %ld previous failures", (long)[challenge previousFailureCount]);
                if (completionHandler) {
                    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
                } else {
                    [[challenge sender] cancelAuthenticationChallenge:challenge];
                }
                NSString *message = NSLocalizedString(@"Unable to log in. Please check your username and password and try again.", @"Alert view message: message for failed SSO login due bad username or password");
                NSError *myError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:nil];
                [self failAuthenticationWithMessage:message error:myError];
            } else {
                if ([challenge previousFailureCount] > 0) {
                    // If we've previously failed, clear out the saved credential and try prompting one more time.
                    self.authenticationChallengeCredential = nil;
                }
                // For certificate based auth, try the default handling
                if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodClientCertificate])
                {
                    BOXLog(@"Client certificate authentication challenge, not currently supported, trying the default handling");
                    if (completionHandler) {
                        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, NULL);
                    } else {
                        [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
                    }
                } else {
                    // Otherwise assume the challenge should be handled the same as HTTP Basic Authentication
                    if (self.authenticationChallengeCredential != nil) {
                        BOXLog(@"Resubmitting previous credential for authentication challenge %@", challenge);
                        if (completionHandler) {
                            completionHandler(NSURLSessionAuthChallengeUseCredential, self.authenticationChallengeCredential);
                        } else {
                            [[challenge sender] useCredential:self.authenticationChallengeCredential
                                   forAuthenticationChallenge:challenge];
                        }
                    } else {
                        BOXLog(@"Presenting modal username and password window");
                        self.authenticationChallenge = challenge;

                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Please Log In", @"Alert view title: title for SSO authentication challenge")
                                                                                                     message:nil
                                                                                              preferredStyle:UIAlertControllerStyleAlert];

                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Label: Cancel action. Usually used on buttons.")
                                                                                   style:UIAlertActionStyleCancel
                                                                                 handler:^(UIAlertAction *action) {
                                                                                     BOXLog(@"Cancel");
                                                                                     if (completionHandler) {
                                                                                         completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
                                                                                     } else {
                                                                                         [[self.authenticationChallenge sender] cancelAuthenticationChallenge:self.authenticationChallenge];
                                                                                     }
                                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];
                                                                                 }];
                            UIAlertAction *submitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Submit", @"Alert view button: submit button for authentication challenge")
                                                                                   style:UIAlertActionStyleDefault
                                                                                 handler:^(UIAlertAction *action) {
                                                                                     [alertController dismissViewControllerAnimated:YES completion:nil];

                                                                                     BOXLog(@"Submitting credential for authentication challenge %@", self.authenticationChallenge);
                                                                                     UITextField *login = alertController.textFields.firstObject;
                                                                                     UITextField *password = alertController.textFields.lastObject;

                                                                                     self.authenticationChallengeCredential = [NSURLCredential credentialWithUser:[login text]
                                                                                                                                                         password:[password text]
                                                                                                                                                      persistence:NSURLCredentialPersistenceNone];
                                                                                     if (completionHandler) {
                                                                                         completionHandler(NSURLSessionAuthChallengeUseCredential, self.authenticationChallengeCredential);
                                                                                     } else {
                                                                                         [[self.authenticationChallenge sender] useCredential:self.authenticationChallengeCredential
                                                                                                                   forAuthenticationChallenge:self.authenticationChallenge];
                                                                                     }

                                                                                     // Clear out the authentication challenge in memory
                                                                                     self.authenticationChallenge = nil;
                                                                                 }];

                            [alertController addAction:cancelAction];
                            [alertController addAction:submitAction];

                            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
                             {
                                 textField.placeholder = NSLocalizedString(@"Username", @"Alert view text placeholder: Placeholder for where to enter user name for SSO authentication challenge");
                             }];

                            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                                textField.placeholder = NSLocalizedString(@"Password", @"Alert view text placeholder: Placeholder for where to enter password for SSO authentication challenge");
                                textField.secureTextEntry = YES;
                            }];

                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    }
                }
            }
        }
    }
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    BOXLog(@"didReceiveServerRedirectForProvisionalNavigation to %@", webView.URL);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    BOXLog(@"didFailProvisionalNavigation for %@", webView.URL);
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    BOXLogFunction();
}

#pragma mark - Private methods

- (void)openURL:(NSURL *_Nonnull)url
{
    UIApplication *shared = [UIApplication box_sharedApplication];
    if ([shared respondsToSelector:@selector(openURL:)]) {
        [shared performSelector:@selector(openURL:) withObject:url];
    }
}

@end
