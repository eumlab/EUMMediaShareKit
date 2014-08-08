//
//  YouTubeHelper.h
//  YouTube_iOS_API_Sample
//
//  Created by Nirbhay Agarwal on 17/04/14.
//  Copyright (c) 2014 Nirbhay Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLYouTube.h"
#import "GTMOAuth2ViewControllerTouch.h"

/*---------------- YoutubeHelper Delegate ----------------*/

@protocol YouTubeHelperDelegate <NSObject>

@required

- (NSString *)youtubeAPIClientID;
- (NSString *)youtubeAPIClientSecret;
- (void)showAuthenticationViewController:(UIViewController *)authView;
- (void)authenticationFail:(NSError *)error;
- (void)authenticationSuccess;

@optional

- (void)uploadProgressPercentage:(int)percentage;
- (void)uploadSuccess;
- (void)uploadFail:(NSError *)error;

@end

/*---------------- YoutubeHelper ----------------*/

@interface YouTubeHelper : NSObject

@property (weak) id <YouTubeHelperDelegate> delegate;
@property (readonly, nonatomic) BOOL isAuthorized;

//Initialization function
- (id)initWithDelegate:(id <YouTubeHelperDelegate>)delegate;

//User authentication
- (void)authenticate;

//Delete stored auth object from keychain
- (void)signOut;

//Upload a video
- (void)uploadPrivateVideoWithTitle:(NSString *)title
                        description:(NSString *)description
                 commaSeperatedTags:(NSString *)tags
                            andPath:(NSString *)path;

@end
