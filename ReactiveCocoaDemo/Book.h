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

@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *pubdate;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *binding;
@property (nonatomic, copy) NSString *catalog;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

@end
