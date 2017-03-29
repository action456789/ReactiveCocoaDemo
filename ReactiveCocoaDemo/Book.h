//
//  Model.h
//  ReactiveCocoaDemo
//
//  Created by sen.ke on 2017/3/29.
//  Copyright © 2017年 ke sen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface Book : JSONModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger total;

@end
