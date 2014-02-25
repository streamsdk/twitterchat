//
//  Progress.h
//  talk
//
//  Created by wangsh on 14-2-12.
//  Copyright (c) 2014年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Progress : NSObject
@property(nonatomic,strong)UIProgressView *progressView;
@property (nonatomic,strong) UILabel * label;
@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@end
