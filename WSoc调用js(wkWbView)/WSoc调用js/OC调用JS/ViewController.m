//
//  ViewController.m
//  OC调用JS
//
//  Created by 王泽 on 2017/8/7.
//  Copyright © 2017年 Huashankeji. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+InvokeMoreMethods.h"

@interface ViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html"]]];
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


#pragma --mark UIWebViewDelegate


//JS调用OC中的无参方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    NSArray *subArr = [urlString componentsSeparatedByString:@"?"];
    
    NSString *preUrl = @"hs://";
    
    if ([urlString hasPrefix:preUrl])
    {
        NSString *preString = [subArr firstObject];
        NSString *methodStr = [[preString substringFromIndex:preUrl.length] stringByReplacingOccurrencesOfString:@"_" withString:@":"];
        // 参数 10086&10010
        NSArray *params = nil;
        if (subArr.count == 2)
        {
            params = [[subArr lastObject] componentsSeparatedByString:@"&"];
        }
        
        // 调用
        [self performSelector:NSSelectorFromString(methodStr) withObjects:params];
        
        return NO;
    }
    
    NSLog(@"%@", request.URL);
    
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
    
}


@end
