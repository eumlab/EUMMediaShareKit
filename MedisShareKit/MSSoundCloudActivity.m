//
//  MSSoundCloudActivity.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-10.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSSoundCloudActivity.h"
#import <SCSoundCloud.h>
#import <SCUI.h>

@interface MSSoundCloudActivity ()

@property (strong, nonatomic) NSURL *url;
@property (nonatomic, strong) SCShareViewController *shareViewController;

@end

@implementation MSSoundCloudActivity

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
            [SCSoundCloud setClientID:@"9e73d8a3534e898c8239a68c06e58824"
                               secret:@"0a49e887340068b3173c94fdaa35be76"
                          redirectURL:[NSURL URLWithString:@"uke101://oauth"]];
            _url = activityItem;
        }
    }
}

- (UIViewController *)activityViewController {
    if (!self.shareViewController) {
        self.shareViewController = [SCShareViewController shareViewControllerWithFileURL:self.url
                                                                       completionHandler: ^(NSDictionary *trackInfo, NSError *error) {
                                                                           if (SC_CANCELED(error)) {
                                                                               [self activityDidFinish:NO];
                                                                           }
                                                                           else if (error) {
                                                                               [self activityDidFinish:NO];
                                                                           }
                                                                           else {
                                                                               [self activityDidFinish:YES];
                                                                           }
                                                                       }];
        [self.shareViewController setTitle:@""];
        [self.shareViewController setPrivate:NO];
        
    }
    return self.shareViewController;
}

@end
