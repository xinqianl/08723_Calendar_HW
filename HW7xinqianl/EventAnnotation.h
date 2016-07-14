//
//  EventAnnotation.h
//  HW7xinqianl
//
//  Created by Xinqian Li on 7/12/16.
//  Copyright © 2016 Xinqian Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface EventAnnotation : NSObject<MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *detailAddr;


@end

