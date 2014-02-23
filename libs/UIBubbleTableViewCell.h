//
//  UIBubbleTableViewCell.h
//
//  Created by Alex Barinov

//

#import <UIKit/UIKit.h>
#import "NSBubbleData.h"

@interface UIBubbleTableViewCell : UITableViewCell

@property (nonatomic, strong) NSBubbleData *data;
@property (nonatomic) BOOL showAvatar;
@property (nonatomic,retain) UIProgressView * progressView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) UILabel * label;
@end
