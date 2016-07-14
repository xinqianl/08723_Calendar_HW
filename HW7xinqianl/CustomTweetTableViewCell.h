//
//  CustomTweetTableViewCell.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/13/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface CustomTweetTableViewCell : UITableViewCell
@property (copy, nonatomic) NSString *tweet;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) UITextView *tweetLabel;
@property (copy, nonatomic) UIButton *link;
@end

