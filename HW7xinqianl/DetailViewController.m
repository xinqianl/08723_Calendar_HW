//
//  DetailViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/13/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//
#import "DetailViewController.h"
#import "PhotoViewController.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UITextView *label3 = [[UITextView alloc]
                          initWithFrame:CGRectMake (10.0f, 300.0f, 500.0f, 100.0f)];
    label3.text = self.tweet;
    [label3 setEditable:NO];
    [self.view addSubview: label3];
    NSLog(@"%@",self.tweet);
    
    UIButton *sampleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sampleButton setTitle:self.imageURL forState:UIControlStateNormal];
    sampleButton.frame = CGRectMake(10, 400, 150, 44);
    [sampleButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sampleButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [sampleButton sizeToFit];
    
    [sampleButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
    [sampleButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.view addSubview:sampleButton];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)buttonPressed{
    PhotoViewController *testController = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:testController animated:YES];
    testController.imageURL = self.imageURL;
    
    
    
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
