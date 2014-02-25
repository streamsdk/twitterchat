//
//  MainViewController.h
//  talk
//
//  Created by wangsh on 13-10-31.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "STreamXMPPProtocol.h"
#import "IconView.h"
#import "FacialView.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageSendProtocol.h"
#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 216
#define  toolBarHeight 40
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  buttonWh 34
#define  ICONHEIGHT 80
@interface MainController : UIViewController<UIBubbleTableViewDataSource,facialViewDelegate,UIVideoEditorControllerDelegate,UITextFieldDelegate,IconViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,ImageSendProtocol>
{
    NSURL  *videoPath;
    
}


@property (nonatomic,strong) UIBubbleTableView *bubbleTableView;

@property (nonatomic,strong) UIToolbar *toolBar;

@property (nonatomic,strong) UIButton * recordOrKeyboardButton;

@property(nonatomic,strong)  UIButton * keyBoardButton;

@property (nonatomic,strong) UIButton * recordButton;

@property (nonatomic,strong) UIButton * iconButton;

@property (nonatomic,strong) UIButton * faceButton;

@property (nonatomic,strong) UITextField *messageText;

@end
