//
//  EventDetailViewController.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/11/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLCalendar.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface EventDetailViewController : UIViewController <UISplitViewControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) GTLCalendarEvent *event;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (strong, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (readonly) CLLocationCoordinate2D selectedCoordinate;
@property (nonatomic, strong) MKPlacemark *placemark;
@property (nonatomic, strong) MKPlacemark *result;
@property (nonatomic, strong) NSArray *searchPlacemarksCache;
@property (nonatomic, strong) NSArray *mapItemList;
@property NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) NSString *coordString;
@property (assign, nonatomic) MKCoordinateRegion *region;

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *startLabel;
@property (strong, nonatomic) UILabel *endLabel;
@property (strong, nonatomic) UILabel *placeLabel;
@property (strong, nonatomic) NSString *startString;
@property (strong, nonatomic) NSString *endString;
@end