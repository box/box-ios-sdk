//
//  ProgressView.m
//  BoxContentSDKSampleApp
//
//  Created by Clement Rousselle on 1/8/15.
//  Copyright (c) 2015 Box. All rights reserved.
//

#import "BOXSampleProgressView.h"

@interface BOXSampleProgressView()

@property (nonatomic, readwrite, strong) UILabel *label;
@property (nonatomic, readwrite, strong) UIProgressView *progressView;

@end

@implementation BOXSampleProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        [self addSubview:self.label];
        [self addSubview:self.progressView];
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.progressView.center = CGPointMake(self.center.x, self.center.y + 5.0f);
}

#pragma mark - Lazy Instantiated properties

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 4.0, CGRectGetWidth(self.bounds), 16.0f)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:12.0f];
        _label.text = @"API Operation Progress";
        _label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return _label;
}

- (UIProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 20.0f)];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    
    return _progressView;
}

@end
