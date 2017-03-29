//
//  RequestViewModel.h
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/29.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

@interface RequestViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;
@property (nonatomic, strong, readonly) NSArray *models;

@end
