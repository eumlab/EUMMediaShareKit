//
//  EUMYoutubeActivity.m
//  ukeTube
//
//  Created by caiguo on 14-8-7.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSYoutubeActivity.h"
#import "MSYoutubeViewController.h"

@interface MSYoutubeActivity ()

@property (strong, nonatomic) NSURL *url;
@property (nonatomic, strong) MSYoutubeViewController *youtubeViewController;

@end

@implementation MSYoutubeActivity

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
    if (self.icon != nil) {
        return self.icon;
    }
    return [UIImage imageNamed:@"AppIcon60x60"];
}

- (NSString *)activityTitle
{
    return @"YouTube";
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
        __weak MSYoutubeActivity *weakSelf = self;
        self.youtubeViewController.finishBlock = ^(BOOL completed) {
            [weakSelf.youtubeViewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf activityDidFinish:completed];
            }];
        };
    }
    return self.youtubeViewController.navigationController;
}


@end
