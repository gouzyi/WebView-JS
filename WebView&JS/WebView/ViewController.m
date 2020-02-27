//
//  ViewController.m
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 124, self.view.bounds.size.width, self.view.bounds.size.height - 124)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (IBAction)leftBtnClick:(id)sender {
}

- (IBAction)rightBtnClick:(id)sender {
    
    // OC调用JS
    NSString *str = [self.webView stringByEvaluatingJavaScriptFromString:@"showAlert('小仙女')('漂亮')"];
    NSLog(@"%@",str);
}
- (void)getSum:(id)str {
    NSLog(@"-------getSum: %@", str);
}
#pragma mark - UIWebViewDelegate
// 加载所有请求数据, 以及控制是否加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"request = %@",request);
    // 路由能力 --
    NSLog(@"URL = %@",request.URL.pathComponents);
    NSLog(@"scheme = %@",request.URL.scheme);
    
    NSString *scheme = request.URL.scheme;
      if ([scheme isEqualToString:@"lgedu"]) {
          NSLog(@"------------");
          NSArray *arr = request.URL.pathComponents;
          NSLog(@"---------%@", arr);
          if (arr.count) {
              NSString *methodName = arr[1];
              if ([methodName isEqualToString:@"getSum"]) {
                  // array[2],array[3]
                  NSLog(@"%@-%@",arr[2],arr[3]);
              }
              // 调用OC方法
              // arr 传递的方法参数
              [self performSelector:@selector(getSum:) withObject:arr afterDelay:0];
          }
        return NO;
    }
    return YES;
}
// 开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView {
    //  进度条
    NSLog(@"开始加载咯!!!!");
}
// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // OC调用JS
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    NSLog(@"加载完成了咯!!!!");
}
// 加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败了咯,为什么:%@",error);
}
@end
