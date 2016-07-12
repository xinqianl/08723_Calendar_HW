//
//  EventDetailViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GTLDateTime *start = self.event.start.dateTime ?: self.event.start.date;
    GTLDateTime *end = self.event.end.dateTime ?: self.event.end.date;
    self.startLabel.text = [NSDateFormatter localizedStringFromDate:[start date]
                                                           dateStyle:NSDateFormatterShortStyle
                                                           timeStyle:NSDateFormatterShortStyle];
    self.endLabel.text =[NSDateFormatter localizedStringFromDate:[end date]
                                                        dateStyle:NSDateFormatterShortStyle
                                                        timeStyle:NSDateFormatterShortStyle];
    self.placeLavel.text = self.event.location;
    self.titleLabel.text = self.event.summary;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
