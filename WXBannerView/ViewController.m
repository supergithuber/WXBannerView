//
//  ViewController.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/5.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "ViewController.h"
#import "WXPageControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WXPageControl *control = [[WXPageControl alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 15)];
    control.backgroundColor = UIColor.redColor;
    control.style = WXPageControlStyleRectangle;
    control.normalColor = UIColor.lightGrayColor;
    control.selectedColor = UIColor.whiteColor;
    control.totalPages = 8;
    control.itemMargin = 4;
    control.itemWidth = 8;
    [self.view addSubview:control];
    
//    dispatch_queue_t queue = dispatch_queue_create("com.sivan.wu", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//        
//    });
//    [NSThread sleepForTimeInterval:1];
//    dispatch_async(queue, ^{
//        NSLog(@"%@", [NSThread currentThread]);
//        
//    });
}


@end
