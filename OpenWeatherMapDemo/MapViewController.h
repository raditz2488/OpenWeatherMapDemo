//
//  MapViewController.h
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapPoint.h"

@interface MapViewController : UIViewController<CLLocationManagerDelegate>
{
    //Location manager to fetch the location
    CLLocationManager *locationManager;
    
    //Map view to show current user location
    __weak IBOutlet MKMapView *mapView;
    
    //The current user location
    MapPoint *currentLocationPoint;
    
    //pointer to weatherdetails button
    __weak IBOutlet UIButton *weatherDetailsButton;
}
@end
