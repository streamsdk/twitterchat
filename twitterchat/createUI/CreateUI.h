//
//  CreateUI.h
//  talk
//
//  Created by wangsh on 13-11-7.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateUI : NSObject <UITextFieldDelegate>
{
    UIButton  * button;
    UITextField * textFiled;
}
-(UIButton *)setButtonFrame:(CGRect)frame withTitle:(NSString *)title;
-(UITextField *)setTextFrame:(CGRect)frame;
-(UIButton *)setButtonFrame:(CGRect)frame withTitle:(NSString *)title withImage:(UIImage *)image;
@end
