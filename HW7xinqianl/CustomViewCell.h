//
//  CustomViewCell.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomViewCell : UITableViewCell
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) UILabel *summaryLabel;
@property (copy, nonatomic) UILabel *detailTextView;
@end
