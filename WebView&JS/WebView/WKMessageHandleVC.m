//
//  WKMessageHandleVC.m
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import "WKMessageHandleVC.h"
#import <WebKit/WebKit.h>

@interface WKMessageHandleVC ()<WKUIDelegate, WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *webView;

@end

@implementation WKMessageHandleVC

#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"dealloc:走了");
}
//self - webView - configuration - userContentController - self
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:@"messgaeOC"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"messgaeOC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WKMessageHandler";
    
    WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    configure.userContentController = wkUController;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configure];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index3.html" withExtension:nil];
    [self.webView loadFileURL:url allowingReadAccessToURL:url];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    // OC调用JS
    NSString *jsStr = @"var arr = [3, 'aaaa', 'cccc']";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}
#pragma mark - Target Methods
- (void)rightItemClick {
    
    // OC调用JS
    NSString *jsStr = @"showAlert('messageHandle: OC调用JS')";
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id result, NSError * _Nullable error) {
        NSLog(@"%@----%@",result, error);
    }];
}
#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
   
    // 拦截JS
    if (message.name) {
        // OC 实现
    }
    NSLog(@"message == %@ --- %@",message.name,message.body);
}


#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
