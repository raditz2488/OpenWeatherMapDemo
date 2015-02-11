//
//  MapPoint.h
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapPoint : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate2D;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2D;

@end
