//
//  CityData.m
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "CityData.h"

//URL for fetching data for 14 days using cityname
#define baseURL @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&cnt=14"

//URL for fetching data for 14 days using coordinates
#define baseURL2 @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=14&mode=json"

@implementation CityData

@synthesize cityName;
@synthesize cityWeatherDataFor14Days;
@synthesize delegate;
@synthesize cityCoordinate;


-(id)initWithCityName:(NSString*)cityN
{
    //Custom initialization
    self = [super init];
    
    if (self)
    {
        cityName = cityN;
        
        cityWeatherDataFor14Days = [[NSArray alloc] init];
    }
    
    return self;
}


-(id)init
{
    //Default initialization
    return [self initWithCityName:@"Mumbai"];
}

-(NSString*)dateForIndex:(NSInteger)index
{
    //Get dateInterval
    NSString *dateInterval = [[[self cityWeatherDataFor14Days] objectAtIndex:index] objectForKey:@"dt"];
    
    
    NSTimeInterval timeInterval = [dateInterval doubleValue];
    

    //Get date since the time interval
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    //Return the date in string format
    return [dateFormatter stringFromDate:date];
}


-(NSString*)getWeatherForeCastForIndex:(NSInteger)index
{
    //Get the forecast for the particular row i.e day
    NSArray *weatherArray = [[[self cityWeatherDataFor14Days] objectAtIndex:index] objectForKey:@"weather"];
    
    NSDictionary *weatherDictionary = [weatherArray objectAtIndex:0];
    
    return weatherDictionary[@"description"];
}

-(NSString*)getImageNameForIndex:(NSInteger)index
{
    //Get image name for the forecast type on a row i.e day
    NSArray *weatherArray = [[[self cityWeatherDataFor14Days] objectAtIndex:index] objectForKey:@"weather"];
    
    NSDictionary *weatherDictionary = [weatherArray objectAtIndex:0];
    
    return weatherDictionary[@"icon"];
}


-(void)fetchWeatherDataForTheCity
{
    //Get the weather forecast using cityName
    NSString *stringURL = [NSString stringWithFormat:baseURL,cityName];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        if (connectionError)
        {
            NSLog(@"Error: %@",[connectionError localizedDescription]);
        }
        else
        {
            NSError *error = nil;
            NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            
            
            if (!jsonDictionary)
            {
                [NSException raise:@"No Data Received" format:@"Reason: %@",[error localizedDescription]];
            }
            else
            {
                NSLog(@"%@",jsonDictionary);
                cityWeatherDataFor14Days = jsonDictionary[@"list"];
                
                [self performSelectorOnMainThread:@selector(sendFetchRequestFisnishToDelegate) withObject:self waitUntilDone:NO];
                
            }
        }
        
        
        
    }];
}

-(void)fetchWeatherDataForTheCityWithCoordinate
{

    //Get the weather forecast using cooridnate
    NSString *stringURL = [NSString stringWithFormat:baseURL2,[self cityCoordinate].latitude,[self cityCoordinate].longitude];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    operationQueue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (connectionError)
         {
             NSLog(@"Error: %@",[connectionError localizedDescription]);
         }
         else
         {
             NSError *error = nil;
             NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             
         
             
             if (!jsonDictionary)
             {
                 [NSException raise:@"No Data Received" format:@"Reason: %@",[error localizedDescription]];
             }
             else
             {
                 NSLog(@"%@",jsonDictionary);
                 cityWeatherDataFor14Days = jsonDictionary[@"list"];
                 
                 [self performSelectorOnMainThread:@selector(sendFetchRequestFisnishToDelegate) withObject:self waitUntilDone:NO];
                 
             }
         }
         
         
         
     }];
}

-(void)sendFetchRequestFisnishToDelegate
{
    [[self delegate] fetchingDataForTheCityHasFinished:self];
}

@end
