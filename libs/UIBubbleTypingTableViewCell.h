//
//  UIBubbleTypingTableCell.h
//  UIBubbleTableViewExample
//
//  Created by Александр Баринов

//

#import <UIKit/UIKit.h>
#import "UIBubbleTableView.h"


@interface UIBubbleTypingTableViewCell : UITableViewCell

+ (CGFloat)height;

@property (nonatomic) NSBubbleTypingType type;
@property (nonatomic) BOOL showAvatar;

@end
