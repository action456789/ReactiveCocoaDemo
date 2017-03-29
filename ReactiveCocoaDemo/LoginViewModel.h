//
//  LoginModal.h
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/29.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface LoginViewModel : NSObject

@property (nonatomic, strong) Account *account;
@property (nonatomic, strong, readonly) RACSignal *enableLoginSignal;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;

@end
