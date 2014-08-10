//
//  ULShareController.m
//  uke101
//
//  Created by 蔡 国 on 14-6-9.
//  Copyright (c) 2014年 蔡 国. All rights reserved.
//

#import "ULShareController.h"
//#import <SCSoundCloud.h>
//#import <SCUI.h>

@implementation ULShareController

+ (instancetype) sharedShareController {
    static id _sharedShareController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedShareController = [[self alloc] init];
    });
    return _sharedShareController;
}

+ (void)shareVideoWithURL:(NSURL *)filePath title:(NSString *)title FromViewController:(UIViewController *)viewController {
}


+ (void)shareAudioWithURL:(NSURL *)filePath title:(NSString *)title FromViewController:(UIViewController *)viewController {
}


@end
