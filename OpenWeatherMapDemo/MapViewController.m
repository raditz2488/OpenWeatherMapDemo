//
//  MapViewController.m
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "MapViewController.h"
#import "CurrentCityWeatherVC.h"
#import "CityData.h"

@interface MapViewController ()

@end

@implementation MapViewController


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        //Set up the locationManager
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        //Ask the user for the location services
        [locationManager requestWhenInUseAuthorization];
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    //Start updating the user location
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
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


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //Get the latest location
    CLLocation *newLocation = [locations objectAtIndex:[locations count] - 1];
    
    //Check how many seconds ago was the location created
    NSTimeInterval t = [[newLocation timestamp] timeIntervalSinceNow];
    
    //If location was made 3 mins ago we need to ignore it
    if (t < -180)
    {
        return;
    }
    
    //stop updating the user location
    [locationManager stopUpdatingLocation];
    
    [self foundLocation:newLocation];
}


-(void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError *)error
{
    NSLog(@"Could not find location: %@",error);
}

-(void)foundLocation:(CLLocation*)newLocation
{
    
    //Add the annotation to the map for current location
    currentLocationPoint = [[MapPoint alloc] initWithCoordinate:[newLocation coordinate]];
    
    [mapView addAnnotation:currentLocationPoint];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = nil;
    if(annotation != mapView.userLocation)
    {
        static NSString *defaultPinID = @"pin";
        pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
        {
            pinView = [[MKPinAnnotationView alloc] init];
            
  
            
            [pinView setPinColor:MKPinAnnotationColorGreen];
            pinView.canShowCallout = YES;
            //pinView.animatesDrop = YES;
            
            
            
        }
        
        
        
    }
    
    return pinView;
}

-(IBAction)showWeatherDetails
{
    //If you have the current location then navigate else show alert
    if (currentLocationPoint)
    {
        [self performSegueWithIdentifier:@"mycity" sender:self];
    }
    else
    {
        UIAlertView *objUIAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please check if you have enabled location services for the app in settings" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [objUIAlertView show];
    }
    
    
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mycity"])
    {
        //Set the cityData of the destinationViewController
        CityData *cityData = [[CityData alloc] initWithCityName:@"My Location"];
        [cityData setCityCoordinate:[currentLocationPoint coordinate]];
        
        CurrentCityWeatherVC *objCurrentCityWeatherVC = [segue destinationViewController];
        
        [objCurrentCityWeatherVC setCityData:cityData];
    }
}




@end
