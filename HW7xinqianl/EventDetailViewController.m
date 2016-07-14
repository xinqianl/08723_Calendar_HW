//
//  EventDetailViewController.m
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventAnnotation.h"
#import <sys/sysctl.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface EventDetailViewController ()

@end

@implementation EventDetailViewController
+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    NSLog(@"%@",self.result.name);
//    [self startButtonPress];
    // Do any additional setup after loading the view.
}
-(void) initialize{
    self.view.backgroundColor = [UIColor whiteColor];
     self.titleLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake (10.0f, 60.0f, 300.0f, 60.0f)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@", @"Event title: ", self.event.summary];
    self.titleLabel.numberOfLines = 2;
    [self.view addSubview:self.titleLabel];
    
    GTLDateTime *start = self.event.start.dateTime ?: self.event.start.date;
     self.startLabel = [[UILabel alloc]initWithFrame:CGRectMake (10.0f, 130.0f, 300.0f, 20.0f)];
    self.startLabel.textColor = [UIColor blackColor];
    self.startString = [NSDateFormatter localizedStringFromDate:[start date] dateStyle:NSDateFormatterShortStyle
                                                     timeStyle:NSDateFormatterShortStyle];
    self.startLabel.text = [NSString stringWithFormat:@"%@%@", @"Event start: ", [NSDateFormatter localizedStringFromDate:[start date] dateStyle:NSDateFormatterShortStyle
                                                                                                           timeStyle:NSDateFormatterShortStyle]];
    [self.view addSubview:self.startLabel];
    
    GTLDateTime *end = self.event.end.dateTime ?: self.event.end.date;
    self.endLabel = [[UILabel alloc]initWithFrame:CGRectMake (10.0f, 150.0f, 300.0f, 20.0f)];
    self.endLabel.textColor = [UIColor blackColor];
    self.endLabel.text =[NSString stringWithFormat:@"%@%@", @"Event end: ", [NSDateFormatter localizedStringFromDate:[end date]
                                                                                                      dateStyle:NSDateFormatterShortStyle
                                                                                                      timeStyle:NSDateFormatterShortStyle]];
    self.endString =[NSDateFormatter localizedStringFromDate:[end date]
                                                                       dateStyle:NSDateFormatterShortStyle
                                                                       timeStyle:NSDateFormatterShortStyle];
    [self.view addSubview:self.endLabel];
    
    self.placeLabel = [[UILabel alloc]initWithFrame:CGRectMake (10.0f, 170.0f, 300.0f, 80.0f)];
    self.placeLabel.textColor = [UIColor blackColor];
    self.placeLabel.numberOfLines = 2;
    self.placeLabel.text = [NSString stringWithFormat:@"%@%@", @"Event place: ",self.event.location];
    [self.view addSubview:self.placeLabel];
    
    UIButton *tweetButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    tweetButton.frame = CGRectMake(100, 250, 150, 44);
    
    [tweetButton addTarget:self
                    action:@selector (tweetButtonPressed)
          forControlEvents: UIControlEventTouchUpInside];
    [tweetButton setTitle:@"Tweet Event" forState:UIControlStateNormal];
    [tweetButton setBackgroundColor: [UIColor grayColor]];
    [self.view addSubview: tweetButton];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake (10.0f, 300.0f, 350.0f, 350.0f)];
    [self.view addSubview:self.mapView];
    
    
    self.results = [[NSMutableArray alloc]init];
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.event.location;

    request.region = _mapView.region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            
            for (MKMapItem *item in response.mapItems)
            {
                [self.results addObject:item.placemark];
                
            }
        self.result = self.results.lastObject;
        NSLog(@"%@",self.result.name);
        [self startButtonPress];
       
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Location Disabled"
                                                                       message:@"Please enable location services in the Settings app."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleDefault
                                                handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}
- (IBAction)myLocation:(UIBarButtonItem *)sender {
    float spanX = 0.00725;
    float spanY = 0.00725;
    self.location = self.locationManager.location;
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span = MKCoordinateSpanMake(spanX, spanY);
    [self.mapView setRegion:region animated:YES];
}

-(void)generatePlaces:(NSString *)location{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    if (location.length!=0) {
        [geocoder geocodeAddressString:location
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         float spanX = 0.00725;
                         float spanY = 0.00725;
                         MKCoordinateRegion region;
                         region.center.latitude = self.result.location.coordinate.latitude;
                         region.center.longitude = self.result.location.coordinate.longitude;
                         region.span = MKCoordinateSpanMake(spanX, spanY);
                         [self.mapView setRegion:region animated:YES];
                         NSArray *add = [self.result.addressDictionary objectForKey:@"FormattedAddressLines"];
                         NSMutableString *address = [[NSMutableString alloc]init];
                         for (id myArrayElement in add) {
                             [address appendString:myArrayElement];
                             [address appendString:@","];
                         }
                         NSLog(@"%@", address);
                         EventAnnotation *annotation = [[EventAnnotation alloc] init];
                         annotation.coordinate = self.result.coordinate;
                         annotation.title = self.result.name;
                         annotation.subtitle = address;
                         [self.mapView addAnnotation:annotation];
                     }
         ];
        
        
    }
}
- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[EventAnnotation class]])
    {
        annotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"Pin"];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
            annotationView.canShowCallout = YES;
            annotationView.animatesDrop = YES;
            annotationView.pinColor = MKPinAnnotationColorPurple;
            
            return annotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}


- (void)startButtonPress {
    [self.mapView removeAnnotations:self.mapView.annotations];
     NSLog(@"%@",self.result.name);
    [self generatePlaces:self.result.name];
    
}
- (void)tweetButtonPressed{
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [self check];
    [twitter requestAccessToAccountsWithType:twAccountType options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
                 NSLog(@"SLComposeViewController is not available for service type twitter");
                 [self generateAlert];
             }
             else
             {
                 SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                 [tweetSheet setInitialText: [NSString stringWithFormat:@"@MobileApp4 Title:%@ Start:%@ End:%@ Place:%@", self.event.summary, self.startString, self.endString, self.event.location]];
                 
                 [self presentViewController:tweetSheet animated:YES completion:nil];
             }
             
         }
         else
         {
             [self permissionAlert];
         }
     }];
    
}
-(void)check{
    ACAccountStore *twitter = [[ACAccountStore alloc] init];
    ACAccountType *twAccountType = [twitter accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccount *twAccount = [[ACAccount alloc] initWithAccountType:twAccountType];
    NSArray *accounts = [twitter accountsWithAccountType:twAccountType];
    twAccount = [accounts lastObject];
    NSURL *twitterURL = [[NSURL alloc] initWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"];
    SLRequest *requestUsersTweets = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                       requestMethod:SLRequestMethodGET
                                                                 URL:twitterURL
                                                          parameters:nil];
    
    [requestUsersTweets performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error2)
     {
         // The output of the request is placed in the log.
         NSLog(@"HTTP Response: %i", [urlResponse statusCode]);
         if([urlResponse statusCode]==0){
             NSLog(@"status code is 0");
             dispatch_async(dispatch_get_main_queue(), ^{
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Sorry"
                                           message:@"Please make sure your device has an internet connection and you have at least one Twitter account setup"
                                           delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
                 return;
             });
         }
     }];
    
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
        // code here
    });
    return;
}
-(void) generateAlert{
    {dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Please make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    });
        return;
    }
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
