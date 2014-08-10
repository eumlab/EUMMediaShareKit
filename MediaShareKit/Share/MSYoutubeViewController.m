//
//  MSYoutubeViewController.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-8.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSYoutubeViewController.h"
#import "MSYouTubeHelper.h"

NSString *const UD_KEY_LAST_SELECT_PRIVACY = @"UD_KEY_LAST_SELECT_PRIVACY";

@interface MSYoutubeViewController ()<YouTubeHelperDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MSYouTubeHelper *helper;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@end

static NSString *descriptionCellIdentifier = @"descriptionCell";

@implementation MSYoutubeViewController

#pragma mark ViewLiftCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper = [[MSYouTubeHelper alloc] initWithDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.helper.isAuthorized) {
        self.accountLabel.text = self.helper.userEmail;
    }
    
    NSInteger lastSelectPrivacyIndex = [[NSUserDefaults standardUserDefaults] integerForKey:UD_KEY_LAST_SELECT_PRIVACY];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:lastSelectPrivacyIndex inSection:2] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.helper.isAuthorized) {
        [self.helper authenticate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setInteger:[self selectedPrivacyIndex] forKey:UD_KEY_LAST_SELECT_PRIVACY];
}

#pragma mark Data

- (NSInteger)selectedPrivacyIndex {
    for (NSInteger i = 0; i<3; i++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
        if (cell.isSelected) {
            return i;
        }
    }
    return 0;
}

#pragma mark Action

- (IBAction)cancel:(id)sender {
    self.finishBlock(NO);
}

- (IBAction)send:(id)sender {
    if (self.helper.isAuthorized) {
        NSString *privacyStatus;
        switch ([self selectedPrivacyIndex]) {
            case 0:
                privacyStatus = GTLYouTubeVideoStatusPublic;
                break;
            case 1:
                privacyStatus = GTLYouTubeVideoStatusPrivate;
                break;
            case 2:
                privacyStatus = GTLYouTubeVideoStatusUnlisted;
                break;
                
            default:
                break;
        }
        [self.helper uploadPrivateVideoWithTitle:self.titleTextField.text description:self.descriptionTextField.text commaSeperatedTags:nil privacyStatus:privacyStatus andPath:self.url.path];

    } else {
        [self.helper authenticate];
    }
}

#pragma mark TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Logout?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

#pragma mark UIAlertView Delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.helper signOut];
        self.finishBlock(NO);
    }
}

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
    [self presentViewController:authView animated:YES completion:nil];
}

- (void)authenticationFail:(NSError *)error;
{
    NSLog(@"Error %@", error.description);
    self.finishBlock(NO);
}

- (void)authenticationSuccess {
    self.accountLabel.text = self.helper.userEmail;
}

- (void)uploadProgressPercentage:(int)percentage;
{
    NSLog(@"Data uploaded: %d", percentage);
}

- (void)uploadSuccess {
    self.finishBlock(YES);
}

- (void)uploadFail:(NSError *)error {
    self.finishBlock(NO);
}

@end