//
//  MSYoutubeTableViewCell.m
//  MedisShareKit
//
//  Created by caiguo on 14-8-10.
//  Copyright (c) 2014年 EUMLab. All rights reserved.
//

#import "MSYoutubeTableViewCell.h"

@implementation MSYoutubeTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor blueColor];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.textLabel.textColor = [UIColor darkTextColor];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
