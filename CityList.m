//
//  CityList.m
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "CityList.h"
#import "CityData.h"

@implementation CityList


+(id)sharedCityList
{
    //Create a static reference of the class
    static CityList *sharedCityList = nil;
    
    //If not created create one
    if (!sharedCityList)
    {
        sharedCityList = [[super allocWithZone:nil] init];
    }
    
    //return the same static shared object
    return sharedCityList;
}


-(id)init
{
    //PErform custom initializations
    self = [super init];
    
    if (self)
    {
        allCityData = [[NSMutableArray alloc] init];
    }
    
    return self;
}



-(NSArray*)allCityData
{
    return allCityData;
}



-(void)addCity:(NSString*)city
{
    //Add a cityData to the allCityData
    CityData *cityData = [[CityData alloc] initWithCityName:city];
    [allCityData addObject:cityData];
}

-(void)clearCityList
{
    //Delete all objects in allCityData
    [allCityData removeAllObjects];
}

-(void)startFetchingForeCastDataForCityListWithDelegate:(id)delegate;
{
    //Start fetching the forecast data for allCityData
    for (CityData *cityData in allCityData)
    {
        [cityData setDelegate:delegate];
        [cityData fetchWeatherDataForTheCity];
    }
}

-(void)deleteCityData:(CityData*)cityData
{
    //Delete a particular cityData
    [allCityData removeObject:cityData];
}


@end
