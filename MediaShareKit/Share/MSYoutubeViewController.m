//
//  MSYoutubeViewController.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-8.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSYoutubeViewController.h"
#import "MSYouTubeHelper.h"
#import "SHKConfiguration.h"
#import "JGProgressHUDPieIndicatorView.h"
#import "JGProgressHUDFadeZoomAnimation.h"
#import "SCLAlertView.h"
#import <AFNetworking.h>

NSString *const UD_KEY_LAST_SELECT_PRIVACY = @"UD_KEY_LAST_SELECT_PRIVACY";

@interface MSYoutubeViewController ()<YouTubeHelperDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) MSYouTubeHelper *helper;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) JGProgressHUD *prototypeHUD;
@property (strong, nonatomic) NSString *identifier;

@end

static NSString *descriptionCellIdentifier = @"descriptionCell";

@implementation MSYoutubeViewController


#pragma mark ViewLiftCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _helper = [[MSYouTubeHelper alloc] initWithDelegate:self];
    
    [_titleTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self checkSendButton];
    
    
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleLight];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockNoTouches;
    
    
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    
    HUD.HUDView.layer.shadowColor = [UIColor blackColor].CGColor;
    HUD.HUDView.layer.shadowOffset = CGSizeZero;
    HUD.HUDView.layer.shadowOpacity = 0.4f;
    HUD.HUDView.layer.shadowRadius = 8.0f;
    
    HUD.delegate = self;
    self.prototypeHUD = HUD;
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

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
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    
    [self.helper cancelUpload];
    self.finishBlock(NO);
}

- (IBAction)send:(id)sender {
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [self resignFirstResponder];
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    self.titleTextField.enabled = NO;
    self.descriptionTextField.editable = NO;

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
        self.doneButton.enabled = NO;
        self.doneButton.tintColor = [UIColor lightGrayColor];
        
        JGProgressHUD *HUD = self.prototypeHUD;
        HUD.indicatorView = [[JGProgressHUDPieIndicatorView alloc] initWithHUDStyle:HUD.style];
        HUD.detailTextLabel.text = NSLocalizedString(@"0% Complete", nil);
        HUD.textLabel.text = NSLocalizedString(@"Uploading...",nil);
        [HUD showInView:self.navigationController.view];
        HUD.layoutChangeAnimationDuration = 0.0;
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

        [self.helper uploadPrivateVideoWithTitle:self.titleTextField.text description:self.descriptionTextField.text commaSeperatedTags:nil privacyStatus:privacyStatus andPath:self.url.path];
//        self.finishBlock(YES);
    } else {
        [self.helper authenticate];
    }
}

#pragma mark TableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.titleTextField resignFirstResponder];
    [self.descriptionTextField resignFirstResponder];
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        if (indexPath.section == 3 && indexPath.row == 0) {
            if (!self.helper.isAuthorized) {
                [self.helper authenticate];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Do you want to logout your YouTube account right now?",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No",nil) otherButtonTitles:NSLocalizedString(@"Logout",nil), nil];
                [alertView show];
            }
        }
    }
}

#pragma mark Text

- (void)checkSendButton {
    if (!self.helper.isAuthorized) {
        self.doneButton.enabled = NO;
        self.doneButton.tintColor = [UIColor lightGrayColor];
        
        return;
    }
    
    if (self.titleTextField.text.length > 0 &&
        self.descriptionTextField.text.length > 0) {
        self.doneButton.enabled = YES;
        self.doneButton.tintColor = self.navigationController.navigationBar.tintColor;
    } else {
        self.doneButton.enabled = NO;
        self.doneButton.tintColor = [UIColor lightGrayColor];
    }
}


-(void)textViewDidChange:(UITextView *)textView
{
    [self checkSendButton];
}

-(void)textFieldDidChange:(UITextField *)textView
{
    [self checkSendButton];
}

#pragma mark UIAlertView Delegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.title == nil){
        if (buttonIndex == 1) {
        [self.helper signOut];
        self.finishBlock(YES);
        }
    }
    else{
        self.finishBlock(YES);
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"http://www.youtube.com/watch?v=" stringByAppendingString:self.identifier]]];
        }
        self.identifier = nil;
    }
    
}

#pragma mark YouTubeHelper Delegate

- (NSString *)youtubeAPIClientID
{
    return SHKCONFIG(youtubeAPIClientID);
}

- (NSString *)youtubeAPIClientSecret
{
    return SHKCONFIG(youtubeAPIClientSecret);
}

- (void)showAuthenticationViewController:(UIViewController *)authView;
{
    [self presentViewController:authView animated:YES completion:nil];
}

- (void)authenticationFail:(NSError *)error;
{
//    NSLog(@"Error %@", error.description);
    self.finishBlock(NO);
}

- (void)authenticationSuccess {
    self.accountLabel.text = self.helper.userEmail;
}

- (void)uploadProgressPercentage:(int)percentage;
{
    NSLog(@"Data uploaded: %d", percentage);
    JGProgressHUD *HUD = self.prototypeHUD;
    [HUD setProgress:percentage/100.0f animated:NO];
    HUD.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%i%% Complete",nil), percentage];
}

- (void)uploadSuccess:(NSString *)identifier {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    JGProgressHUD *HUD = self.prototypeHUD;
    HUD.textLabel.text = @"Success";
    HUD.detailTextLabel.text = nil;
    HUD.indicatorView = nil;
    
    HUD.layoutChangeAnimationDuration = 0.3;
    self.identifier = identifier;
    
     NSLog(@"%@",identifier);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HUD dismiss];
        [self setToDoneButton];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Congratulations", nil) message:NSLocalizedString(@"You've uploaded your video to YouTube successfully, you can watch it right now or later", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Maybe Later", nil) otherButtonTitles:NSLocalizedString(@"Watch it now!", nil), nil];
            
            [alert show];

        });
    });
}

- (void)uploadFail:(NSError *)error {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        JGProgressHUD *HUD = self.prototypeHUD;
        HUD.textLabel.text = @"Failed";
        HUD.detailTextLabel.text = nil;
        HUD.indicatorView = nil;
        
        HUD.layoutChangeAnimationDuration = 0.3;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
            self.finishBlock(NO);
            [self setToDoneButton];
        });
        
    });

}

- (void)setToDoneButton{
    self.doneButton.enabled = YES;
    self.doneButton.title = NSLocalizedString(@"Done", nil);
    self.doneButton.tintColor = self.navigationController.navigationBar.tintColor;
}


@end
