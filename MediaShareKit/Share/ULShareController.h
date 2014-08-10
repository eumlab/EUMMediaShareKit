//
//  ULShareController.h
//  uke101
//
//  Created by 蔡 国 on 14-6-9.
//  Copyright (c) 2014年 蔡 国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ULShareController : NSObject

+ (void)shareVideoWithURL:(NSURL *)filePath title:(NSString *)title FromViewController:(UIViewController *)viewController;
+ (void)shareAudioWithURL:(NSURL *)filePath title:(NSString *)title FromViewController:(UIViewController *)viewController;

@end
