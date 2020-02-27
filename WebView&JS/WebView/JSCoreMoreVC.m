//
//  JSCoreMoreVC.m
//  WebView
//
//  Created by zainguo on 2020/2/27.
//  Copyright © 2020 zainguo. All rights reserved.
//

#import "JSCoreMoreVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "YY_JSObject.h"
@interface JSCoreMoreVC ()
<UIWebViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UILabel *showLabel;
@property (nonatomic, strong) JSContext *jsContext;
@property (nonatomic,strong) UIImagePickerController *imagePicker;


@end

@implementation JSCoreMoreVC
- (void)dealloc {
    NSLog(@"dealloc走了");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.showLabel];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 124, self.view.bounds.size.width, self.view.bounds.size.height - 124)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"index2.html" withExtension:nil];;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"点我" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick)];
    
}

- (void)setupJS {
     
    
    __weak typeof(self) weakSelf = self;
    
    // 传递参数arr
    [self.jsContext evaluateScript:@"var arr = ['aaaa', 'bbbb', 'cccc', '哈哈']"];
    // 异常处理
    self.jsContext.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        context.exception = exception;
        NSLog(@"exception == %@",exception);
        NSLog(@"%@",context);
    };
    // JS调用OC
    self.jsContext[@"showMessage"] = ^{
        // 参数 (JS 带过来的)
         NSArray *args = [JSContext currentArguments];
         NSLog(@"args = %@",args);
         NSLog(@"currentThis   = %@",[JSContext currentThis]);
         NSLog(@"currentCallee = %@",[JSContext currentCallee]);
         NSLog(@"currentThread = %@",[NSThread currentThread]);
         
         // OC调用JS
         NSDictionary *dict = @{@"name":@"zain", @"age":@18};
         [[JSContext currentContext][@"ocCalljs"] callWithArguments:@[dict,@"咸鱼"]];
    };
    // JS调用OC
    self.jsContext[@"showDict"] = ^{
        
        NSArray *arr = [JSContext currentArguments];
        NSLog(@"----->%@", arr);
    };
    // 获取变量
    JSValue *arrValue = self.jsContext[@"arr"];
    NSLog(@"arrValue == %@",arrValue);
    
    // JS 操作对象
    YY_JSObject *yyObject = [[YY_JSObject alloc] init];
    self.jsContext[@"yyObject"] = yyObject;
    NSLog(@"yyObject == %d",[yyObject getSum:10 num2:20]);
    
    // 打开相册
    self.jsContext[@"getImage"] = ^() {
        weakSelf.imagePicker = [[UIImagePickerController alloc] init];
        weakSelf.imagePicker.delegate = weakSelf;
        weakSelf.imagePicker.allowsEditing = YES;
        weakSelf.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:weakSelf.imagePicker animated:YES completion:nil];
    };

    
}
#pragma mark - Target Methods

- (void)rightItemClick {
    
    // OC调用JS
    [self.jsContext evaluateScript:@"showAlert()"];
}
#pragma mark -  UIWebViewDelegate
// 加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    // JSContext H5上下文
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

    self.jsContext = jsContext;
    
    // 执行下面的业务逻辑
    [self setupJS];
  
}
#pragma mark -  UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *imageString = [self removeSpaceAndNewline:encodedImageStr];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 照片上传
    NSString *jsFuncStr = [NSString stringWithFormat:@"showImage('%@')", imageString];
    [self.jsContext evaluateScript:jsFuncStr];
}
- (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}
- (void)openAlbum{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}


#pragma mark - Lazy Loads
- (UILabel *)showLabel{
    if (!_showLabel) {
        _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 64+20, 100, 30)];
        _showLabel.textColor = [UIColor orangeColor];
        _showLabel.font = [UIFont systemFontOfSize:16];
        _showLabel.text = @"我是一个文本";
    }
    return _showLabel;
}


@end
