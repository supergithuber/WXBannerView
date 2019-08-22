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
    WXPageControl *control = [[WXPageControl alloc]
                              initWithControlStyle:WXPageControlStyleRectangle
                              totalPages:8
                              itemWidth:8
                              itemMargin:4];
    control.frame = CGRectMake(0, 100, self.view.frame.size.width, 15);
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
