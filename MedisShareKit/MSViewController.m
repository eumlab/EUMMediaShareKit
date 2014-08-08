//
//  MSViewController.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-8.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSViewController.h"
#import "EUMYoutubeActivity.h"

@interface MSViewController ()

@end

@implementation MSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)shareVideo:(id)sender {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"RARBG.com" withExtension:@"mp4"];
    
    UIActivityViewController *controller =
    [[UIActivityViewController alloc] initWithActivityItems:@[url]
                                      applicationActivities:@[[EUMYoutubeActivity new]]];
    controller.completionHandler = ^(NSString *activityType, BOOL completed){
        NSLog(@"%@", activityType);
        NSLog(@"%i", completed);
    };
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

@end
