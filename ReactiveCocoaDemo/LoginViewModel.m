//
//  LoginModal.m
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/29.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (Account *)account
{
    if (_account == nil) {
        _account = [[Account alloc] init];
    }
    return _account;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 监听账号的属性值改变，把他们聚合成一个信号。
        _enableLoginSignal = [RACSignal combineLatest:@[RACObserve(self.account, userName), RACObserve(self.account, pwd)] reduce:^id(NSString *account,NSString *pwd){
            return @(account.length && pwd.length);
        }];
        
        [self createLoginCommand];
    
    }
    return self;
}

- (void)createLoginCommand {
    // 处理登录业务逻辑
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"点击了登录");
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"登陆成功"];
                [subscriber sendCompleted];
            });
            
            return nil;
        }];
    }];
    
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x isEqualToString:@"登陆成功"]) {
            NSLog(@"登陆成功");
        }
    }];
    
    [[_loginCommand.executing skip:1] subscribeNext:^(id x) {
        if ([x isEqualToNumber:@(YES)]) {
            NSLog(@"正在登陆");
        } else {
//            NSLog(@"登陆成功");
        }
    }];
}

@end
