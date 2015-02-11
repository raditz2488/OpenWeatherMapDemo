//
//  MapPoint.m
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "MapPoint.h"


@implementation MapPoint

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate2DD
{
    self = [super init];
    
    if (self)
    {
        coordinate2D = coordinate2DD;
    }
    
    return self;
}

-(id)init
{
    return [self initWithCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
}

-(CLLocationCoordinate2D)coordinate
{
    return coordinate2D;
}

-(NSString*)title
{
    return @"You are here";
}

@end
