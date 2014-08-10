//
//  EUMYoutubeActivity.m
//  ukeTube
//
//  Created by caiguo on 14-8-7.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "EUMYoutubeActivity.h"
#import "MSYoutubeViewController.h"

@interface EUMYoutubeActivity ()

@property (strong, nonatomic) NSURL *url;
@property (nonatomic, strong) MSYoutubeViewController *youtubeViewController;

@end

@implementation EUMYoutubeActivity

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryShare;
}

- (NSString *)activityType
{
    return NSStringFromClass([self class]);
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"AppIcon60x60"];
}

- (NSString *)activityTitle
{
    return @"Youtube";
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            _url = activityItem;
        }
    }
}

- (UIViewController *)activityViewController {
    if (!self.youtubeViewController) {
       UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"youtube" bundle:nil];
        UINavigationController *navigationController = [mainStoryboard instantiateInitialViewController];
        
        self.youtubeViewController = (id)navigationController.topViewController;
        self.youtubeViewController.url = self.url;
        __block typeof(self) weakSelf = self;
        self.youtubeViewController.finishBlock = ^(BOOL completed) {
            [weakSelf activityDidFinish:completed];
        };
    }
    return self.youtubeViewController.navigationController;
}


@end
