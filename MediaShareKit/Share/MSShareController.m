//
//  ULShareController.m
//  uke101
//
//  Created by 蔡 国 on 14-6-9.
//  Copyright (c) 2014年 蔡 国. All rights reserved.
//

#import "MSShareController.h"
#import "MSYoutubeActivity.h"
#import "MSSoundCloudActivity.h"

@implementation MSShareController

+ (instancetype)sharedShareController {
  static id _sharedShareController;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ _sharedShareController = [[self alloc] init]; });
  return _sharedShareController;
}

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController {
  [self shareVideoWithURL:url FromViewController:viewController complete:nil];
}

+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController {
  [self shareAudioWithURL:url FromViewController:viewController complete:nil];
}

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
                 completionHandler {
  UIActivityViewController *controller = [[UIActivityViewController alloc]
      initWithActivityItems:@[ url ]
      applicationActivities:@[ [MSYoutubeActivity new] ]];
  controller.completionHandler = completionHandler;
  [viewController presentViewController:controller animated:YES completion:^{}];
}

+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
                 completionHandler {
  UIActivityViewController *controller = [[UIActivityViewController alloc]
      initWithActivityItems:@[ url ]
      applicationActivities:@[ [MSSoundCloudActivity new] ]];
  controller.completionHandler = completionHandler;
  [viewController presentViewController:controller animated:YES completion:^{}];
}

+ (void)shareVideoWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon{
    MSYoutubeActivity *ac = [MSYoutubeActivity new];
    ac.icon = icon;
    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[ url ]
                                            applicationActivities:@[ ac ]];
    controller.completionHandler = completionHandler;
    [viewController presentViewController:controller animated:YES completion:^{}];
}

+ (void)shareAudioWithURL:(NSURL *)url
       FromViewController:(UIViewController *)viewController
                 complete:(UIActivityViewControllerCompletionHandler)
completionHandler andIcon:(UIImage *)icon{
    MSSoundCloudActivity *ac = [MSSoundCloudActivity new];
    ac.icon = icon;
    UIActivityViewController *controller = [[UIActivityViewController alloc]
                                            initWithActivityItems:@[ url ]
                                            applicationActivities:@[ ac ]];
    controller.completionHandler = completionHandler;
    [viewController presentViewController:controller animated:YES completion:^{}];
    
    
}


@end
