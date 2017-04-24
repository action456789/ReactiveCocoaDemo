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
#import "RACmetamacros.h"

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
//    [self bindModel];
    
//    [self requestData];
    
    // 1. 冷信号
//    [self test1];
    
    // 2. 热信号
//    [self test2];
    
    // 3. 副作用
     [self test3];
    
    // 4. RACReplaySubject
//    [self test4];
    
    // 5. replayLazily
//    [self test5];
    // 6. RACCommand
//    [self test6];
}

- (void)test6 {
    RACCommand *requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSLog(@"开始请求网络数据");
            [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
                [subscriber sendNext:@"1"];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
    RACSignal *requestSignal = [requestCommand execute:nil];
    
    [requestSignal subscribeNext:^(NSArray *x) {
        NSLog(@"订阅者1:%@", x);
    }];
    
    [requestSignal subscribeNext:^(NSArray *x) {
        NSLog(@"订阅者2:%@", x);
    }];
    
    [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
        [requestSignal subscribeNext:^(NSArray *x) {
            NSLog(@"订阅者3:%@", x);
        }];
    }];
}

// 解决方式一：使用 replayLazily
- (void)test5 {
    RACSignal *requestSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"开始请求网络数据");
        [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
        }];
        return nil;
    }] replayLazily]; // modify here!!
    
    [requestSignal subscribeNext:^(id x) {
        NSLog(@"订阅者1:%@", x);
    }];
    
    [requestSignal subscribeNext:^(NSArray *x) {
        NSLog(@"订阅者2:%@", x);
    }];
    
    [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
        [requestSignal subscribeNext:^(NSArray *x) {
            NSLog(@"订阅者3:%@", x);
        }];
    }];
}

// 解决方式一：使用 maticast
- (void)test4 {
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"开始请求网络数据");
        [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
//    RACMulticastConnection *connection = [requestSignal multicast:[RACSubject subject]];
    RACMulticastConnection *connection = [requestSignal multicast:[RACReplaySubject subject]];
    [connection connect];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"订阅者1:%@", x);
    }];
    
    [connection.signal subscribeNext:^(NSArray *x) {
        NSLog(@"订阅者2:%@", x);
    }];
    
    [RACScheduler.mainThreadScheduler afterDelay:2 schedule:^{
        [connection.signal subscribeNext:^(NSArray *x) {
            NSLog(@"订阅者3:%@", x);
        }];
    }];
}

- (void)test3 {
    
    // 多次订阅会多次执行
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"开始请求网络数据");
        [RACScheduler.mainThreadScheduler afterDelay:1 schedule:^{
            [subscriber sendNext:@"1"];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
    
//    // 【请求数据次数 +1】
//    [requestSignal subscribeNext:^(id x) {
//        NSLog(@"订阅者1");
//    }];
//
//    // 【请求数据次数 +1】
//    [requestSignal subscribeNext:^(NSArray *x) {
//        NSLog(@"订阅者2");
//    }];

    
    // 将信号转换为内容为2的信号
    RACSignal *signal1 = [requestSignal flattenMap:^RACStream *(id value) {
        return [RACSignal return:@"2"];
    }];
    
//    // 将signal1信号所有错误信息转换为字符串@"Error"
//    [signal1 catchTo:[RACSignal return:@"Error"]];
//
//    // 在没有获取值之前以字符串@"Loading..."占位
//    [signal1 startWith:@"Loading..."];
//    
//    // 将信号进行绑定
//    // 【请求数据次数 +1】
//    RAC(self.acountField, text) = signal1;
//    
//    // 订阅多个信号的任何错误，并且弹出UIAlertView
//    // 【请求数据次数 +2】
//    [[RACSignal merge:@[requestSignal, signal1]] subscribeError:^(NSError *error) {
//        NSLog(@"发生错误");
//    }];
}

- (void)test2 {
    RACMulticastConnection *connection = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
            [subscriber sendNext:@1];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
            [subscriber sendNext:@2];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@3];
            [subscriber sendCompleted];
        }];
        return nil;
    }] publish];
    
    [connection connect];
    
    NSLog(@"Signal was created.");
    [[RACScheduler mainThreadScheduler] afterDelay:1.1 schedule:^{
        [connection.signal subscribeNext:^(id x) {
            NSLog(@"Subscriber1 recveive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:2.1 schedule:^{
        [connection.signal subscribeNext:^(id x) {
            NSLog(@"Subscriber2 recveive: %@", x);
        }];
    }];
}

- (void)test1 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@3];
        [subscriber sendCompleted];
        return nil;
    }];
    NSLog(@"Signal was created.");
    [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber1 recveive: %@", x);
        }];
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:1 schedule:^{
        [signal subscribeNext:^(id x) {
            NSLog(@"Subscriber2 recveive: %@", x);
        }];
    }];
}

- (void)requestData {
    // RACCommand多次订阅，只会执行一次
    self.requestViewModel = [[RequestViewModel alloc] init];
    
    RACSignal *requestSignal = [self.requestViewModel.requestCommand execute:nil];
    [requestSignal subscribeNext:^(NSArray *x) {
//        NSLog(@"%@", x);
        NSLog(@"订阅者1");
    }];
    
    [requestSignal subscribeNext:^(NSArray *x) {
        NSLog(@"订阅者2");
    }];
    
    [[requestSignal flattenMap:^RACStream *(id value) {
        return [RACSignal return:@"1"];
    }] subscribeNext:^(id x) {
        NSLog(@"订阅者3");
    }];
}

- (void)bindModel {
    RAC(self.loginViewModel.account, userName) = self.acountField.rac_textSignal;
    RAC(self.loginViewModel.account, pwd) = self.passwordField.rac_textSignal;
    
    RAC(self.loginButton, enabled) = self.loginViewModel.enableLoginSignal;
    
    // 监听登录按钮点击
    @weakify(self)
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
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
