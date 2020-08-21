//
//  SJExcelViewController.m
//  SJExportExcel
//
//  Created by mac on 2020/8/18.
//  Copyright © 2020 songjiang. All rights reserved.
//

#import "SJExcelViewController.h"
#import <WebKit/WebKit.h>

@interface SJExcelViewController ()<WKUIDelegate,WKNavigationDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic,strong) UIButton *exportButton;
@property (nonatomic,strong) UIDocumentInteractionController *documentController;

@end

@implementation SJExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initUI{
    
    self.exportButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [self.exportButton setTitle:@"导出" forState:UIControlStateNormal];
    [self.exportButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.exportButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.exportButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, -10);
    [self.exportButton addTarget:self action:@selector(exportClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *exportItem = [[UIBarButtonItem alloc] initWithCustomView:self.exportButton];
    self.navigationItem.rightBarButtonItem = exportItem;
    
    // 简单展示
    [self.view addSubview:self.webView];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"sks.xlsx"];
    NSURL *url = [NSURL fileURLWithPath:filePath]; // 注意：使用[NSURL URLWithString:filePath]无效
    NSURLRequest *urlRequest = [[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:urlRequest];

}

#pragma mark - 导出excel
- (void)exportClick{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:@"sks.xlsx"];
    NSURL *url = [NSURL fileURLWithPath:filePath]; // 注意：使用[NSURL URLWithString:filePath]无效
    
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:url];
    _documentController.delegate = self;
    
    [self presentOpenInMenu];
}

- (void)presentOpenInMenu{
    [_documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES]; // 菜单操作
}

#pragma mark - WKWebView Delegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面开始加载时调用");
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    NSLog(@"当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成之后调用");
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载失败时调用");
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"接收到服务器跳转请求之后调用");
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
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


- (WKWebView *)webView{
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 88, ScreenWidth, ScreenHeight-88)];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        webView.backgroundColor = [UIColor purpleColor];
        _webView = webView;
    }
    return _webView;
}

@end
