//
//  MSYoutubeViewController.h
//  MedisShareKit
//
//  Created by caiguo on 14-8-8.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YoutubeViewControllerFinishBlock)(BOOL completed);

@interface MSYoutubeViewController : UITableViewController

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) YoutubeViewControllerFinishBlock finishBlock;

@end
