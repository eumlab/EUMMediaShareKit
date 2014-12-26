//
//  ULShareController.h
//  uke101
//
//  Created by 蔡 国 on 14-6-9.
//  Copyright (c) 2014年 蔡 国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSShareController : NSObject

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController;
+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController;

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
    completionHandler;
+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
    completionHandler;

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon;

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon
              andSourcePoint:(CGPoint)point;

+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon;

+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon
           andSourcePoint:(CGPoint)point;
@end
