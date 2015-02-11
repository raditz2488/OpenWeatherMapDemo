//
//  CityData.h
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CityDataDelegate

@optional
-(void)fetchingDataForTheCityHasFinished:(id)cityData;

@end

@interface CityData : NSObject
{
    NSOperationQueue *operationQueue;
}

@property (copy, nonatomic) NSString *cityName;

//Array for holding forecast for the next 14 days
@property (strong, nonatomic) NSArray *cityWeatherDataFor14Days;

@property (weak, nonatomic) id<CityDataDelegate> delegate;

//Coordinates of the cityData
@property CLLocationCoordinate2D cityCoordinate;


//Initialize with a cityName
-(id)initWithCityName:(NSString*)cityN;

//Fetch weather data for the city using city name using API
-(void)fetchWeatherDataForTheCity;

//Fetch weather data for the city using coordinate using API
-(void)fetchWeatherDataForTheCityWithCoordinate;

//Get the date for the forecast
-(NSString*)dateForIndex:(NSInteger)index;


//Get the weather forecast for the particular row
-(NSString*)getWeatherForeCastForIndex:(NSInteger)index;

//Get the image name for the particular row
-(NSString*)getImageNameForIndex:(NSInteger)index;

@end
