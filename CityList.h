//
//  CityList.h
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CityData;

@interface CityList : NSObject
{
    //Stores the cityData for each city added
    NSMutableArray *allCityData;
}

//Returns the singleton for the class
+(id)sharedCityList;

//Return the array of cityData
-(NSArray*)allCityData;


//Adds a city
-(void)addCity:(NSString*)city;

//Clears the allCityData array
-(void)clearCityList;

//Starts fetching data for the cities in allCityData
-(void)startFetchingForeCastDataForCityListWithDelegate:(id)delegate;

//Deletes a cityData
-(void)deleteCityData:(CityData*)cityData;



@end
