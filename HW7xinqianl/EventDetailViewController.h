//
//  EventDetailViewController.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLCalendar.h"
@interface EventDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLavel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;


@property (strong, nonatomic) GTLCalendarEvent *event;


@end