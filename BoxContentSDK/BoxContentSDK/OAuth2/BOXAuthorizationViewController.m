//
//  BOXAuthorizationViewController.m
//  BoxContentSDK
//
//  Created on 2/20/13.
//  Copyright (c) 2013 Box. All rights reserved.
//

#import "BOXAuthorizationViewController.h"
#import "BOXLog.h"
#import "BOXUser.h"
#import "BOXContentClient+User.h"
#import "BOXUserRequest.h"
#import "BOXContentSDKErrors.h"

#define BOX_SSO_SERVER_TRUST_ALERT_TAG (1)
#define BOX_SSO_CREDENTIALS_ALERT_TAG (2)
#define BOX_SSO_CONNECTION_ERROR_ALERT_TAG (3)

// http://stackoverflow.com/a/5337804/527393
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

typedef void (^BOXAuthCompletionBlock)(BOXAuthorizationViewController *authorizationViewController, BOXUser *user, NSError *error);
typedef void (^BOXAuthCancelBlock)(BOXAuthorizationViewController *authorizationViewController);

@interface BOXAuthorizationViewController () <NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSURLResponse *connectionResponse;
@property (nonatomic, readwrite, strong) NSMutableData *connectionData;
@property (nonatomic, readwrite, strong) NSError *connectionError;
@property (nonatomic, readwrite, strong) NSURLAuthenticationChallenge *authenticationChallenge;
@property (nonatomic, readwrite, strong) NSURLCredential *authenticationChallengeCredential;
@property (nonatomic, readwrite, strong) NSMutableSet *hostsThatCanUseWebViewDirectly;

@property (nonatomic, readwrite, strong) NSArray *preexistingCookies;
@property (nonatomic, readwrite, assign) NSHTTPCookieAcceptPolicy preexistingCookiePolicy;

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

#define kMaxNTLMAuthFailuresPriorToExit 3
#define kMaxAuthChallengeCycles 100

- (void)loadAuthorizationURL;
- (void)cancel:(id)sender;
- (void)completeServerTrustAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge shouldTrust:(BOOL)trust;
- (void)failAuthenticationWithConnection:(NSURLConnection *)connection
                               challenge:(NSURLAuthenticationChallenge *)challenge
                                 message:(NSString *)message
                                   error:(NSError *)error;
- (void)clearCookies;
- (void)setWebViewCanBeUsedDirectly:(BOOL)canUseWebViewDirectly forHost:(NSString *)host;
- (BOOL)webViewCanBeUsedDirectlyForHost:(NSString *)host;

@end

@implementation BOXAuthorizationViewController

@synthesize authorizeURL = _authorizeURL;

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
        _connectionData = [[NSMutableData alloc] init];
        _hostsThatCanUseWebViewDirectly = [NSMutableSet set];

        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                 target:self
                                                                                                 action:@selector(cancel:)]];

        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        _preexistingCookies = [[cookieStorage cookies] copy];
        _preexistingCookiePolicy = [cookieStorage cookieAcceptPolicy];
    }

    return self;
}

- (void)dealloc
{
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = nil;
    [webView stopLoading];
    [_connection cancel];

    [self clearCookies];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:_preexistingCookiePolicy];
}

- (void)loadView
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    UIWebView *webView = [[UIWebView alloc] init];
    [webView setScalesPageToFit:YES];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.delegate = self;

    self.view = webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadAuthorizationURL];
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
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.authorizeURL];
    if (self.headers != nil) {
        for (NSString *key in self.headers) {
            NSString *value = [self.headers valueForKey:key];
            [request addValue:value forHTTPHeaderField:key];
        }
    }
    UIWebView *webView = (UIWebView *)self.view;
    [webView loadRequest:[request copy]];
}

- (void)completeServerTrustAuthenticationChallenge:(NSURLAuthenticationChallenge *)authenticationChallenge shouldTrust:(BOOL)trust
{
    if (trust) {
        SecTrustRef serverTrust = [[authenticationChallenge protectionSpace] serverTrust];
        NSURLCredential *serverTrustCredential = [NSURLCredential credentialForTrust:serverTrust];
        [[authenticationChallenge sender] useCredential:serverTrustCredential
                             forAuthenticationChallenge:authenticationChallenge];
    } else {
        UIAlertView *loginFailureAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to Log In", @"Alert view title: Title for failed SSO login due to authentication issue")
                                                                        message:NSLocalizedString(@"Could not complete login because the SSO server is untrusted. Please contact your administrator for more information.", @"Alert view message: message for failed SSO login due to untrusted (for example: self signed) certificate")
                                                                       delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OK", @"Label: Allow the user to accept the current condition, often used on buttons to dismiss alerts")
                                                              otherButtonTitles:nil];

        [loginFailureAlertView show];
    }
    [self.activityIndicator stopAnimating];
}

- (void)failAuthenticationWithConnection:(NSURLConnection *)connection
                               challenge:(NSURLAuthenticationChallenge *)challenge
                                 message:(NSString *)message
                                   error:(NSError *)error
{
    // Failure at the connection layer implies we don't have anything to show in the web view,
    // so instead of letting the user see the issue and exit/cancel themselves, we show an alert
    // view with the error information and then call the completion block with that error.
    [[challenge sender] cancelAuthenticationChallenge:challenge];
    self.connection = nil;
    self.connectionResponse = nil;
    [self setWebViewCanBeUsedDirectly:NO forHost:connection.currentRequest.URL.host];

    if (self.view.window) {
        self.connectionError = error;
        UIAlertView *loginFailureAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unable to Log In", @"Alert view title: Title for failed SSO login due to authentication issue")
                                                                        message:message
                                                                       delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"OK", @"Label: Allow the user to accept the current condition, often used on buttons to dismiss alerts")
                                                              otherButtonTitles:nil];
        loginFailureAlertView.tag = BOX_SSO_CONNECTION_ERROR_ALERT_TAG;
        [loginFailureAlertView show];
    }
    [self.activityIndicator stopAnimating];
}

- (void)clearCookies
{
    BOXLog(@"Attempt to clear cookies");
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [[cookieStorage cookies] copy];
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([self.preexistingCookies containsObject:cookie] == NO)
        {
            [cookieStorage deleteCookie:cookie];
            BOXLog(@"Clearing cookie with domain %@, name %@", cookie.domain, cookie.name);
        }
    }
    //NOTE: Using standardUserDefaults because this is for saving system cookies.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setWebViewCanBeUsedDirectly:(BOOL)canUseWebViewDirectly forHost:(NSString *)host
{
    if (host.length > 0) {
        if (canUseWebViewDirectly) {
            [self.hostsThatCanUseWebViewDirectly addObject:host];
        } else {
            [self.hostsThatCanUseWebViewDirectly removeObject:host];
        }
    }
}

- (BOOL)webViewCanBeUsedDirectlyForHost:(NSString *)host
{
    return [self.hostsThatCanUseWebViewDirectly containsObject:host];
}

- (BOOL)isLoginRedirectionRequest:(NSURLRequest *)request
{
    BOOL requestIsForLoginRedirectScheme = NO;
    if ([self.redirectURI length] > 0) {
        requestIsForLoginRedirectScheme = [[[request URL] scheme] isEqualToString:[[NSURL URLWithString:self.redirectURI] scheme]];
    }
    return (requestIsForLoginRedirectScheme && [[[request URL] absoluteString] hasPrefix:self.redirectURI]);
}

#pragma mark - UIWebViewDelegate methods

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOXLog(@"Web view should start request %@ with navigation type %ld", request, (long)navigationType);
    BOXLog(@"Request Headers \n%@", [request allHTTPHeaderFields]);

    // Before we proceed with handling this request, check if it's about:blank - if it is, do not attempt to load it.
    // Background: We've run into a scenario where an admin included a support help-desk plugin on their SSO page
    // which would (probably erroneously) first load about:blank, then attempt to load its icon. The web view would
    // fail to load about:blank, which would cause the whole page to not appear. So we realized that we can and should
    // generally protect against loading about:blank.
    if ([request.URL isEqual:[NSURL URLWithString:@"about:blank"]]) {
        return NO;
    }

    // Mailto URLs can be encountered if there is a hyperlink for sending an email.
    if ([[[request URL] scheme] isEqual:@"mailto"]) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }

    [self.activityIndicator startAnimating];

    // Figure out whether this request is the redirect used at the end of the authentication process
    BOOL requestIsForLoginRedirection = [self isLoginRedirectionRequest:request];

    if (requestIsForLoginRedirection) {
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
                    [userRequest performRequestWithCompletion:^(BOXUser *user, NSError *error) {
                        if (me.completionBlock) {
                            me.completionBlock(me, user, error);
                        }
                    }];
                }
            });
        }];
    } else if (![[[request URL] absoluteString] isEqualToString:[[request mainDocumentURL] absoluteString]]) {
        // If it is an iFrame, there's not much we can do. We have to just let the UIWebView do the load.
        // If we tried to use NSURLConnection to make this request, we would not know how to properly populate the
        // iframe with the response.
        // This means we cannot handle scenarios such as:
        // a) The iFrame request requires HTTP Auth. We would normally want to pop up a custom dialog to collect credentials.
        // b) The iFrame request has an invalid SSL certificate. We would normally want to pop up a warning dialog and let the user decide what to do.
        return YES;
    } else if ([self webViewCanBeUsedDirectlyForHost:request.URL.host] == NO) {
        BOXLog(@"Was not authenticated, launching URLConnection and not loading the request in the web view");
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        BOXLog(@"URLConnection is %@", self.connection);
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    BOXLogFunction();
    [self.activityIndicator startAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    BOXLog(@"Web view %@ did fail load with error %@", webView, error);

    // The following error scenarios are benign and do not actually signify that loading the login page has failed:
    // 1. WebKitErrorDomain > WebKitErrorFrameLoadInterruptedByPolicyChange - Indicates that a frame load was interrupted by a policy change.
    //  These constants seem to only be declared for OS X in the WebKit framework, but we're seeing them in iOS.
    // 2. NSURLErrorDomain > NSURLErrorCancelled - Returned when an asynchronous load is canceled. A Web Kit framework delegate will receive this error when it performs a cancel operation on a loading resource. Note that an NSURLConnection or NSURLDownload delegate will not receive this error if the download is canceled.
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
        BOXLog(@"Request URL is %@ while main document URL is %@", requestURLString, [webView.request mainDocumentURL]);

        BOOL isMainDocumentURL = [requestURLString isEqualToString:[[webView.request mainDocumentURL] absoluteString]];
        if (isMainDocumentURL == NO) {
            // If the failing URL is not the main document URL, then the load error is in an iframe and can be ignored
            BOXLog(@"Ignoring error as the load failure is in an iframe");
            ignoreError = YES;
        }
    }

    if (ignoreError == NO) {
        BOXLog(@"Presenting error");
        // The error is usually in HTML to be shown to the user.
        [webView loadHTMLString:[error localizedDescription] baseURL:nil];
    }

    [self.activityIndicator stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    BOXLogFunction();
    [self.activityIndicator stopAnimating];
}

#pragma mark - NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    BOXLog(@"connection %@ did receive authentication challenge %@", connection, challenge);

    // This is separate from the block below, it is just tracking if there is NTLM in any point
    // of the authorization.
    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodNTLM]) {
        self.isNTLMAuth = YES;
    }

    if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        BOXLog(@"Server trust authentication challenge");
        SecTrustResultType trustResult = kSecTrustResultOtherError;
        OSStatus status = SecTrustEvaluate([[challenge protectionSpace] serverTrust], &trustResult);

        // Allow a certificate if its status was evaluated successfully and the result is that it should be trusted
        BOOL shouldTrustServer = (status == errSecSuccess && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified));

        [self completeServerTrustAuthenticationChallenge:challenge shouldTrust:shouldTrustServer];
    } else {
        BOXLog(@"Authentication challenge of type %@", [[challenge protectionSpace] authenticationMethod]);


        if (self.authChallengeCycles > kMaxAuthChallengeCycles) {
            // Too many auth challenges, fail out
            BOXLog(@"Too many (%ld) authentication challenges - aborting.", (long)self.authChallengeCycles);
            NSString *message = NSLocalizedString(@"Unable to log in. Too many authentication challenges issued by the server.", @"Alert view message: message for failed Single-Sign-On login due to encountering too many authentication challenges (a technical network/server issue).");
            NSError *myError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:nil];
            [self failAuthenticationWithConnection:connection challenge:challenge message:message error:myError];
        } else {
            self.authChallengeCycles++;

            //  The NTLM protocol issues a 401 as part of the negotiation process.
            //  In iOS 8, this 401 results in NSURLAuthenticationChallenge returning a "failureResponse".
            //  However, NSURLAuthenticationChallenge does not return this in iOS 7.
            //  As seen from the CFNetworking logs, NSURLAuthenticationChallenge handles the 401 negotiation,
            //  and the process is seamless in iOS 7.
            //  However, in iOS 8, the last step of the NTLM protocol returns an error that
            //  the developer must handle (as seen from CFNetworking and our app logs).
            BOOL shouldApplyiOS8_NTLM_WAR = (self.isNTLMAuth &&
                                             [challenge previousFailureCount] > 0 &&
                                             SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") &&
                                             (self.ntlmAuthFailures < kMaxNTLMAuthFailuresPriorToExit));

            // Handle the authentication challenge as a basic HTTP authentication challenge
            // (certificate-based, among other methods, is not currently supported).
            if (shouldApplyiOS8_NTLM_WAR) {
                BOXLog(@"Applying iOS8 NTLM WAR, ntlmAuthFaulures = %ld", (long)self.ntlmAuthFailures);
                self.ntlmAuthFailures++;
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            } else if (([challenge previousFailureCount] > 0 &&
                        self.authenticationChallengeCredential == nil) ||
                       [challenge previousFailureCount] > 1) {
                BOXLog(@"Have %ld previous failures", (long)[challenge previousFailureCount]);
                NSString *message = NSLocalizedString(@"Unable to log in. Please check your username and password and try again.", @"Alert view message: message for failed SSO login due bad username or password");
                NSError *myError = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorUserAuthenticationRequired userInfo:nil];
                [self failAuthenticationWithConnection:connection challenge:challenge message:message error:myError];
            } else {
                if ([challenge previousFailureCount] > 0) {
                    // If we've previously failed, clear out the saved credential and try prompting one more time.
                    self.authenticationChallengeCredential = nil;
                }
                // For certificate based auth, try the default handling
                if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodClientCertificate])
                {
                    BOXLog(@"Client certificate authentication challenge, not currently supported, trying the default handling");
                    [[challenge sender] performDefaultHandlingForAuthenticationChallenge:challenge];
                } else {
                    // Otherwise assume the challenge should be handled the same as HTTP Basic Authentication

                    if (self.authenticationChallengeCredential != nil) {
                        BOXLog(@"Resubmitting previous credential for authentication challenge %@", challenge);
                        [[challenge sender] useCredential:self.authenticationChallengeCredential
                               forAuthenticationChallenge:challenge];
                    } else {
                        BOXLog(@"Presenting modal username and password window");
                        self.authenticationChallenge = challenge;
                        // Create the alert view
                        UIAlertView *challengeAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please Log In", @"Alert view title: title for SSO authentication challenge")
                                                                                     message:nil
                                                                                    delegate:self
                                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"Label: Cancel action. Usually used on buttons.")
                                                                           otherButtonTitles:NSLocalizedString(@"Submit", @"Alert view button: submit button for SSO authentication challenge"), nil];
                        challengeAlertView.tag = BOX_SSO_CREDENTIALS_ALERT_TAG;
                        challengeAlertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
                        // Change the login text field's placeholder text to Username (it defaults to Login).
                        [[challengeAlertView textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"Username", @"Alert view text placeholder: Placeholder for where to enter user name for SSO authentication challenge")];
                        [challengeAlertView show];
                    }
                }
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    BOXLog(@"Connection %@ did fail with error %@", connection, error);
    if ([error code] != NSURLErrorUserCancelledAuthentication)
    {
        [self failAuthenticationWithConnection:connection challenge:nil message:[error localizedDescription] error:error];
    }
}

#pragma mark - NSURLConnectionDataDelegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    BOXLog(@"Connection %@ did receive response %@", connection, response);
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        BOXLog(@"HTTP Headers were: %@", [(NSHTTPURLResponse *)response allHeaderFields]);
    }
    self.connectionResponse = response;
    [self.connectionData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    BOXLog(@"Connection %@ did receive %lu bytes of data", connection, (unsigned long)[data length]);
    [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    BOXLog(@"Connection %@ did finish loading. Requesting that the webview load the data (%lu bytes) with reponse %@", connection, (unsigned long)[self.connectionData length], self.connectionResponse);
    [self setWebViewCanBeUsedDirectly:YES forHost:connection.currentRequest.URL.host];
    [self setWebViewCanBeUsedDirectly:YES forHost:[self.connectionResponse URL].host];
    [(UIWebView *)self.view loadData:self.connectionData
                            MIMEType:[self.connectionResponse MIMEType]
                    textEncodingName:[self.connectionResponse textEncodingName]
                             baseURL:[self.connectionResponse URL]];

    self.connection = nil;
    self.connectionResponse = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    // No cached response should be stored for the connection.
    return nil;
}

#pragma mark - UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOXLog(@"Alert view with tag %ld clicked button at index %ld", (long)alertView.tag, (long)buttonIndex);
    if (alertView.tag == BOX_SSO_CREDENTIALS_ALERT_TAG) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            BOXLog(@"Cancel");
        } else {
            UITextField *usernameField = nil;
            UITextField *passwordField = nil;
            if ([alertView alertViewStyle] == UIAlertViewStyleLoginAndPasswordInput) {
                usernameField = [alertView textFieldAtIndex:0];
                passwordField = [alertView textFieldAtIndex:1];
            } else {
                BOXAssertFail(@"The alert view is not of login and password input style. Cannot safely extract the user's credentials.");
            }

            BOXLog(@"Submitting credential for authentication challenge %@", self.authenticationChallenge);
            [self setWebViewCanBeUsedDirectly:YES forHost:self.connection.currentRequest.URL.host];
            self.authenticationChallengeCredential = [NSURLCredential credentialWithUser:[usernameField text]
                                                                                password:[passwordField text]
                                                                             persistence:NSURLCredentialPersistenceNone];
            [[self.authenticationChallenge sender] useCredential:self.authenticationChallengeCredential
                                      forAuthenticationChallenge:self.authenticationChallenge];
        }
    } else if (alertView.tag == BOX_SSO_SERVER_TRUST_ALERT_TAG) {
        if (self.completionBlock) {
            NSError *error = [[NSError alloc] initWithDomain:BOXContentSDKErrorDomain code:BOXContentSDKAPIErrorServerCertError userInfo:nil];
            self.completionBlock(self, nil, error);            
        }
    } else if (alertView.tag == BOX_SSO_CONNECTION_ERROR_ALERT_TAG) {
        if (self.completionBlock) {
            NSError *error = self.connectionError;
            self.connectionError = nil;
            self.completionBlock(self, nil, error);
        }
    }
    
    // Clear out the authentication challenge in memory
    self.authenticationChallenge = nil;
}

@end
