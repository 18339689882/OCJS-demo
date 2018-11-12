//
//  ViewController.m
//  WSoc调用js
//
//  Created by Sunweisheng on 2018/11/12.
//  Copyright © 2018年 Sunweisheng. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "NSObject+InvokeMoreMethods.h"
@interface ViewController ()<WKUIDelegate, WKNavigationDelegate>

//@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    //ios加载自己写的 网页。
    [_webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"]]];
}

//无参数的调用
-(void)ocMethod:(NSString *)str
{
    //输出控制器名字，方法名。
    NSLog(@"++++%s+++%@++", __func__, str);
}


//oc调用js的回调方法
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //调用js中自定义的方法、
//    [webView stringByEvaluatingJavaScriptFromString:@"jsMethod()"];
}

-(void)call:(NSString *)str
{
    NSLog(@"+++%s, %@+++", __func__, str);
}

-(void)call:(NSString *)str number2:(NSString *)str1
{
    NSLog(@"+++%s, %@, %@+++", __func__, str, str1);
}

-(void)call:(NSString *)str number2:(NSString *)str1 number3:(NSString *)str2
{
    NSLog(@"+++%s, %@, %@, %@+++", __func__, str, str1, str2);
}

//wkWEbView 调用.
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *urlStr = navigationAction.request.URL.absoluteString;
    NSLog(@"navigationAction.request.URL = %@", navigationAction.request.URL);
    
    NSArray *subArr = [urlStr componentsSeparatedByString:@"?"];
    NSString *preUrl = @"hs://";
    
    if ([urlStr hasPrefix:preUrl]) {
        NSString *preStr = [subArr firstObject];
        
        NSString *methodStr = [[preStr substringFromIndex:preUrl.length] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        NSArray *params = nil;
        if (subArr.count == 2) {
            params = [[subArr lastObject] componentsSeparatedByString:@"&"];
        }
        
        [self performSelector:NSSelectorFromString(methodStr) withObjects:params];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

//多个参数js调用oc uiwebView
- (BOOL)webView:(WKWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlStr = request.URL.absoluteString;
    NSArray *subArr = [urlStr componentsSeparatedByString:@"?"];
    NSString *preUrl = @"hs://";
    
    if ([urlStr hasPrefix:preUrl]) {
        NSString *preStr = [subArr firstObject];
        
        NSString *methodStr = [[preStr substringFromIndex:preUrl.length] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        
        NSArray *params = nil;
        if (subArr.count == 2) {
            params = [[subArr lastObject] componentsSeparatedByString:@"&"];
        }
        
        [self performSelector:NSSelectorFromString(methodStr) withObjects:params];
    }
    
    return YES;
}

//js调用oc使用的方法
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSLog(@"request.URL = %@", request.URL);
//    NSString *urlStr = request.URL.absoluteString;
//    //截取字符串。
//    NSString *preStr = @"hh://";
//    //判断是否有前缀
//    if ([urlStr hasPrefix:preStr]) {
//        //从哪个开始到末尾结束  以下为调用一个参数的。
//        NSString *methodStr = [urlStr substringFromIndex:preStr.length];
//        NSArray *strArr = [methodStr componentsSeparatedByString:@"?"];
//        NSString *preStr1 = [strArr firstObject];
//        NSString *preStr2 = [preStr1 stringByReplacingOccurrencesOfString:@"_" withString:@":"];
//
//        NSString *lastStr = [strArr lastObject];
//        [self performSelector:NSSelectorFromString(preStr2) withObject:lastStr];
//    }
//
//    return YES;
//}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    //    DLOG(@"msg = %@ frmae = %@",message,frame);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // 禁止放大缩小
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
}

@end
