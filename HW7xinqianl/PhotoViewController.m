//
//  PhotoViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/13/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(self.imageURL);
    NSData * originalImageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.imageURL]];
//    UIImageView *imView = [[UIImageView alloc] initWithImage:[UIImage imageWithData: originalImageData]];
//    NSData *imageData = UIImageJPEGRepresentation(imView.image, 0.4);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData: originalImageData]];
    [imageView setFrame:[[UIScreen mainScreen] bounds]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
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

