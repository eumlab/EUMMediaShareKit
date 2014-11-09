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
#import "SHKConfiguration.h"

NSString *const SoundCloudAudioUpdateResultNotification = @"SoundCloudAudioUpdateResultNotification";

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
    return @"SoundCloud";
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
            [SCSoundCloud setClientID:SHKCONFIG(soundCloudAPIClientID)
                               secret:SHKCONFIG(soundCloudAPIClientSecret)
                          redirectURL:[NSURL URLWithString:SHKCONFIG(soundCloudAPIRedirectURL)]];
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
                                                                               NSURL *url = [NSURL URLWithString:trackInfo[@"permalink_url"]];
                                                                               NSLog(@"%@", url.relativePath);
                                                                               [[NSNotificationCenter defaultCenter] postNotificationName:SoundCloudAudioUpdateResultNotification object:@{@"platform_reference":url.relativePath, @"url": self.url.path}];
                                                                               [self activityDidFinish:YES];
                                                                           }
                                                                       }];
        [self.shareViewController setTitle:@""];
        [self.shareViewController setPrivate:NO];
        
    }
    return self.shareViewController;
}

@end
