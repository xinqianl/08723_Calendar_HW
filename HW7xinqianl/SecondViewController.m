
//
//  SecondViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/13/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "SecondViewController.h"
#import "CustomTweetTableViewCell.h"
#import "PhotoViewController.h"

@interface SecondViewController ()

@property NSMutableArray *objects;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myArr=[[NSMutableArray alloc]init];
    
    [self readTweet];
    
    [self.tableView registerClass:[CustomTweetTableViewCell class]forCellReuseIdentifier: @"Cell"];
    
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    
    return self.myArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //how to use media_url_https refers to http://stackoverflow.com/questions/13493137/ios-twitter-api-json-parsing
    CustomTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *tweet = [[self.myArr objectAtIndex:indexPath.row] valueForKey:(@"text")];
    
    NSDictionary *entity= [[self.myArr objectAtIndex:indexPath.row] valueForKey:(@"entities")];
    NSArray *media        = entity[@"media"];
    NSDictionary *media0  = media[0];
    NSString *image = media0[@"media_url_https"];
    
    
    
    cell.tweet = tweet;
    cell.image = image;
    UIButton *linkButton = cell.link;
    if(image==nil || image.length==0){
        [linkButton setHidden:YES];
    }else{
        [linkButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
    
}
- (void)buttonPressed:(UIButton*) sender {
    PhotoViewController *testController = [[PhotoViewController alloc] init];
    [self.navigationController pushViewController:testController animated:YES];
    testController.imageURL = sender.titleLabel.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        NSLog(@"showDetail");
        
        self.detailViewController = [segue destinationViewController];
        
        
    }
}
- (void)readTweet {
    
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 140);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request Access to the twitter account
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                 
                 [self generateAlert];
                 return;
             }
             ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
             NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
             twAccount = [accounts lastObject];
             NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/home_timeline.json?count=200"];
             SLRequest *requestUsersTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                requestMethod:SLRequestMethodGET
                                                                          URL:twitterURL
                                                                   parameters:nil];
             
             [requestUsersTweets setAccount:twAccount];
             [requestUsersTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2)
              {
                  NSLog(@"HTTP Response: %i", [urlResponse statusCode]);
                  if([urlResponse statusCode]!=200){
                      [self noResponseAlert];
                      return;
                  }
                  if([urlResponse statusCode]==200){
                      self.myArr=[[NSMutableArray alloc]init];
                      NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                      NSArray *timeline = (NSArray*)jsonResponse;
                      for (int i=0; i<[timeline count]; i++) {
                          NSString *text = [[timeline objectAtIndex:i] valueForKey:(@"text")];
                        if([text containsString:@"@MobileApp4"]){
                              [self.myArr addObject: [timeline objectAtIndex:i]];
                          }
                      }                      dispatch_async(dispatch_get_main_queue(), ^{
                          [self.tableView reloadData];
                      });
                  }
                  
              }
              ];
             
             twAccount = nil;
             accounts = nil;
             twitterURL = nil;
             requestUsersTweets = nil;
         }
         else
         {
             [self permissionAlert];
         }
     }];
    [spinner stopAnimating];
    twAccountType = nil;
    
}

-(void)generateAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Please make sure your device has an internet connection and you have at least one Twitter account setup. Or maybe you hit the rate limit."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;});
    
}
-(void) permissionAlert{
    NSLog(@"Permission Not Granted");
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Please make sure your device has an internet connection and you have at least one Twitter account setup"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"OK", nil];
        [alert show];
    });
    return;
}
-(void) noResponseAlert{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Please make sure your device has an internet connection and you have at least one Twitter account setup. Or maybe you hit the rate limit."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    });
}
@end
