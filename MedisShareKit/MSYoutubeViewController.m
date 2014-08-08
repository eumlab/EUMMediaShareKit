//
//  MSYoutubeViewController.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-8.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSYoutubeViewController.h"
#import "YouTubeHelper.h"

@interface MSYoutubeViewController ()<YouTubeHelperDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) YouTubeHelper *helper;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;

@end

static NSString *descriptionCellIdentifier = @"descriptionCell";

@implementation MSYoutubeViewController

- (IBAction)cancel:(id)sender {
}

- (IBAction)send:(id)sender {
    _helper = [[YouTubeHelper alloc] initWithDelegate:self];
    
    if (_helper.isAuthorized) {
        [self authenticationSuccess];
    } else {
        [_helper authenticate];
    }
}

#pragma mark TableView


#pragma mark YouTubeHelper Delegate

- (NSString *)youtubeAPIClientID
{
    return @"869308807579-t0mu79sql6leag79fabttvitb5f7s1j6.apps.googleusercontent.com";
}

- (NSString *)youtubeAPIClientSecret
{
    return @"sVnS8r7tpa2tSmPnl3b9f6Ct";
}

- (void)showAuthenticationViewController:(UIViewController *)authView;
{
    [self presentViewController:authView animated:YES completion:^{
        NSLog(@"presented");
    }];
}

- (void)authenticationFail:(NSError *)error;
{
    NSLog(@"Error %@", error.description);
//    [self activityDidFinish:NO];
}

- (void)authenticationSuccess {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"RARBG.com" withExtension:@"mp4"];
    [_helper uploadPrivateVideoWithTitle:@"4 Video Title"
                             description:@"4 Video Description"
                      commaSeperatedTags:@"4 VideoTag1, 4 VideoTag2"
                                 andPath:url.path];
    
}

- (void)uploadProgressPercentage:(int)percentage;
{
    NSLog(@"Data uploaded: %d", percentage);
}

- (void)uploadSuccess {
//    [self activityDidFinish:YES];
}

- (void)uploadFail:(NSError *)error {
//    [self activityDidFinish:NO];
}

@end
