//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/28.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewModel.h"
#import <ReactiveCocoa.h>

#import "RequestViewModel.h"

@interface ViewController ()

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@property (weak, nonatomic) IBOutlet UITextField *acountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, strong) RequestViewModel *requestViewModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 视图模型绑定
    [self bindModel];
    
    [self requestData];
}

- (void)requestData {
    // ReactiveCocoa网络请求
    self.requestViewModel = [[RequestViewModel alloc] init];
    
    RACSignal *requestSignal = [self.requestViewModel.requestCommand execute:nil];
    [requestSignal subscribeNext:^(NSArray *x) {
        NSLog(@"%@", x);
    }];
    
}

- (void)bindModel {
    RAC(self.loginViewModel.account, userName) = self.acountField.rac_textSignal;
    RAC(self.loginViewModel.account, pwd) = self.passwordField.rac_textSignal;
    
    RAC(self.loginButton, enabled) = self.loginViewModel.enableLoginSignal;
    
    // 监听登录按钮点击
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.loginViewModel.loginCommand execute:nil];
    }];
}

- (LoginViewModel *)loginViewModel
{
    if (_loginViewModel == nil) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}


@end
