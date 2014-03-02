//
//  IconView.m
//  talk
//
//  Created by wangsh on 13-12-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "IconView.h"

@implementation IconView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        icon = [[NSArray alloc]initWithObjects: @"photog150.png",@"camera_icon150.png",@"microphonefat.png",nil];
    }
    return self;
}

-(void)loadIconView:(int)page size:(CGSize)size
{
	//row number
    NSArray * array = [[NSArray alloc]initWithObjects:@"Choose a Photo",@"Camera",@"Audio", nil];
	for (int i=0; i<1; i++) {
		//column numer
		for (int y=0; y<3; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*(size.width+60)+40, i*size.height, size.width, size.height)];
            NSString * str = [icon objectAtIndex:i*3+y];
            UIImage *image = [UIImage imageNamed:str];
            [button setImage:image forState:UIControlStateNormal];
            button.tag=i*3+y;
            [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(y*(size.width+62), size.height, 116, 20)];
            label.text= [array objectAtIndex:y];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:10.0f];
            [self addSubview:label];
            [label setBackgroundColor:[UIColor clearColor]];
            if (y!=2) {
                UIButton * separatorButton  = [UIButton buttonWithType:UIButtonTypeCustom];
                [separatorButton setFrame:CGRectMake(y*106+108, 10, 5, size.height-20)];
                [separatorButton setImage:[UIImage imageNamed:@"separator.png"] forState:UIControlStateNormal];
                [self addSubview:separatorButton];
            }
            
        }
    }
}
-(void)selected:(UIButton*)bt
{
    
        NSString *str=[icon objectAtIndex:bt.tag];
        NSLog(@"点击其他%@",str);

        [delegate selectedIconView:bt.tag];
}


@end
