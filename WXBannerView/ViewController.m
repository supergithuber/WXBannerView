//
//  ViewController.m
//  WXBannerView
//
//  Created by Wuxi on 2019/8/5.
//  Copyright © 2019 wuxi. All rights reserved.
//

#import "ViewController.h"
#import "WXPageControl.h"
#import "WXBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupBanner];
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

- (void)setupBanner{
    WXBannerView *banner2 = [[WXBannerView alloc]initWithFrame:CGRectMake(0, 150+self.view.frame.size.width*0.4, self.view.frame.size.width, self.view.frame.size.width*0.4)];
    banner2.imgCornerRadius = 15;
    banner2.autoScrollTimeInterval = 2;
    banner2.isZoom = YES;
    banner2.itemSpace = -10;
    banner2.itemWidth = self.view.frame.size.width-120;
    banner2.imageType = WXBannerViewImageTypeMix;
    NSString *gif = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564463770360&di=c93e799328198337ed68c61381bcd0be&imgtype=0&src=http%3A%2F%2Fimg.mp.itc.cn%2Fupload%2F20170714%2F1eed483f1874437990ad84c50ecfc82a_th.jpg";
    banner2.imageDatas = @[gif,@"timg",@"jita",
                           @"http://photos.tuchong.com/285606/f/4374153.jpg",
                           ];
    [self.view addSubview:banner2];
}
- (void)setupControl{
    WXPageControl *control = [[WXPageControl alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 15)];
    control.backgroundColor = UIColor.redColor;
    control.style = WXPageControlStyleRectangle;
    control.normalColor = UIColor.lightGrayColor;
    control.selectedColor = UIColor.whiteColor;
    control.totalPages = 8;
    control.itemMargin = 4;
    control.itemWidth = 8;
    [self.view addSubview:control];
}
@end
