//
//  IconView.h
//  talk
//
//  Created by wangsh on 13-12-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol IconViewDelegate

-(void)selectedIconView:(NSInteger)buttonTag;

@end

@interface IconView : UIView
{
    NSArray *icon;
}
@property(nonatomic,assign)id<IconViewDelegate>delegate;

-(void)loadIconView:(int)page size:(CGSize)size;


@end
