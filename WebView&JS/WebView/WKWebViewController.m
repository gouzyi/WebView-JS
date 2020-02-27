//
//  WKWebViewController.m
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>
@interface WKWebViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKWebViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    configure.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configure];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index3.html" withExtension:nil];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
    
}
#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    decisionHandler(WKNavigationActionPolicyAllow);
//    NSString *str = [NSString stringWithFormat:@"%@", navigationAction.request.URL];
//    if ([str isEqualToString:@""]) {
//        // 不跳转, 添加处理
//        decisionHandler(WKNavigationActionPolicyCancel)
//    }
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.title = webView.title;
}

////请求之前，决定是否要跳转:用户点击网页上的链接，需要打开新页面时，将先调用这个方法。
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;
////接收到相应数据后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler;
////页面开始加载时调用
//- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//// 主机地址被重定向时调用
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation;
//// 页面加载失败时调用
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//// 当内容开始返回时调用
//- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation;
//// 页面加载完毕时调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation;
////跳转失败时调用
//- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error;
//// 如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
//- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullable credential))completionHandler;
////9.0才能使用，web内容处理中断时会触发
//- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0);


@end
