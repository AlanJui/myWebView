//
//  ViewController.m
//  myWebView
//
//  Created by 居正中 on 12/10/6.
//  Copyright (c) 2012年 CCC Studio. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    BOOL keyboardIsShown;
}
@end

@implementation ViewController
@synthesize urlText;
@synthesize loadingIndicator;
@synthesize theWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self goButtonPressed:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardIsShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardIsHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView處理

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [request.URL absoluteString];
    NSLog(@"URL: %@", urlString);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadingIndicator stopAnimating];
}

#pragma mark - 鍵盤處理

- (void)keyboardIsShown:(NSNotification *) notify
{
    if (keyboardIsShown) {
        return;
    }
    keyboardIsShown = YES;
    
    NSDictionary *info = [notify userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect newRectFrame = self.theWebView.frame;
    newRectFrame.size.height -= keyboardSize.height;
    self.theWebView.frame = newRectFrame;
}

- (void)keyboardIsHidden:(NSNotification *) notify
{
    if (keyboardIsShown) {
        return;
    }
    keyboardIsShown = NO;
    
    NSDictionary *info = [notify userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGRect newRectFrame = self.theWebView.frame;
    newRectFrame.size.height += keyboardSize.height;
    self.theWebView.frame = newRectFrame;
}
/**
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [urlText resignFirstResponder];
    
    return YES;
}
 **/

- (IBAction)goButtonTapped:(id)sender
{
    [urlText resignFirstResponder];
    [self goToURL];
}

- (void) goToURL
{
    NSURL *urlString = [NSURL URLWithString:urlText.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    [self.theWebView loadRequest:request];
}

#pragma mark - UI 控制處理

- (IBAction)goButtonPressed:(id)sender {
    [self goToURL];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.theWebView goBack];
}


- (IBAction)forwardButtonPressed:(id)sender {
    [self.theWebView goForward];
}

- (IBAction)stopButtonPressed:(id)sender {
    [self.theWebView stopLoading];
}

- (IBAction)reloadButtonPressed:(id)sender {
    [self.theWebView reload];
}


@end
