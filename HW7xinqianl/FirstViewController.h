//
//  FirstViewController.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventDetailViewController.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"
@interface FirstViewController : UITableViewController
@property (nonatomic, strong) GTLServiceCalendar *service;
@property (nonatomic, strong) UITextView *output;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) EventDetailViewController *detailViewController;
@end
