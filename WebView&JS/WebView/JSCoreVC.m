//
//  JSCoreVC.m
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import "JSCoreVC.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface JSCoreVC ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@end

@implementation JSCoreVC
- (IBAction)rightItemClick:(id)sender {
    [self.navigationController pushViewController:[NSClassFromString(@"JSCoreMoreVC") new] animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index1.html" withExtension:nil];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
}
#pragma mark -  UIWebViewDelegate

// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    // JSContext H5上下文
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    // 传递参数arr
    [jsContext evaluateScript:@"var arr = ['aaaa', 'bbbb', 'cccc', '哈哈']"];
    
    jsContext[@"showMessage"] = ^{
        NSArray *arr = [JSContext currentArguments];
        NSLog(@"args = %@", arr);
    };
}


@end
