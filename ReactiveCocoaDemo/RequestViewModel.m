//
//  RequestViewModel.m
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/29.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import "RequestViewModel.h"
#import "Book.h"
#import <AFNetworking.h>

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        
        [self initialBind];
    }
    return self;
}

- (void)initialBind {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSDictionary *parameters = @{@"q" : @"基础"};
            
            [[AFHTTPSessionManager manager] GET:@"https://api.douban.com/v2/book/search" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
            } failure:nil];
            
            return nil;
        }];
        
        return [requestSignal map:^id(NSDictionary *value) {
            NSMutableArray *dictArr = value[@"books"];
            NSArray *modelArr = [[dictArr.rac_sequence map:^id(id value) {
                return [[Book alloc] initWithDictionary:value error:nil];
            }] array];
            
            return modelArr;
        }];
        
    }];
}

@end
