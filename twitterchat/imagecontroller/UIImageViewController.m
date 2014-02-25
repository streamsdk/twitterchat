//
//  UIImageViewController.m
//  talk
//
//  Created by wangsh on 13-12-16.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "UIImageViewController.h"
@interface UIImageViewController ()

@end
#define IMAGE_TAG 2000
#define ZOOMSCALE 3.0
@implementation UIImageViewController
@synthesize image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
//    CGFloat imgWidth = image.size.width;
//    CGFloat imgHeight = image.size.height;
    
//    if (imgWidth > width) {
//        imgWidth = width;
//    }
//    if (imgHeight > height) {
//        imgHeight = height;
//    }
    UIImageView*imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width,height)];
    [imageView setImage:image];
    imageView.tag = IMAGE_TAG;
    imageView.userInteractionEnabled=YES;
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [imageView addGestureRecognizer:pinchGestureRecognizer];
    
    [self.view addSubview:imageView];
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,44)];
    [view setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.1]];
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 9, 50, 26)];
    [[backButton layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[backButton layer] setBorderWidth:1];
    [[backButton layer] setCornerRadius:4];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleTapGesture) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:backButton];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(self.view.frame.size.width-60, 9, 50, 26)];
    [[saveButton layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[saveButton layer] setBorderWidth:1];
    [[saveButton layer] setCornerRadius:4];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:saveButton];
    [self.view addSubview:view];

}
-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:IMAGE_TAG];

    UIPanGestureRecognizer*pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [imageview addGestureRecognizer:pan];
}
-(void)pan:(UIPanGestureRecognizer*)pan

{
    
    CGPoint point=[pan translationInView:self.view];
    
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:IMAGE_TAG];
    
    imageview.frame=CGRectMake(imageview.frame.origin.x+point.x, imageview.frame.origin.y+point.y, imageview.frame.size.width, imageview.frame.size.height);
    
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
-(void) saveClicked {
    UIImageView *imageview = (UIImageView *)[self.view viewWithTag:IMAGE_TAG];
    UIImageWriteToSavedPhotosAlbum([imageview image], nil, nil,nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"The photo has been successfully stored in photo album"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
-(void) handleTapGesture
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        NSLog(@"back");
        
    }];
}
-(void)handleTappressGesture{
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
