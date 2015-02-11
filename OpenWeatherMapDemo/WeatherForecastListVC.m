//
//  WeatherForecastListVC.m
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "WeatherForecastListVC.h"
#import "CityData.h"
#import "CityList.h"

#define baseURL @"http://openweathermap.org/img/w/%@.png"

@interface WeatherForecastListVC ()

@end

@implementation WeatherForecastListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Let the cities in the list start fetching for their forecast data of 14 days
    [[CityList sharedCityList] startFetchingForeCastDataForCityListWithDelegate:self];
    
    //Initialize the image cache
    imageDictionary = [[NSMutableDictionary alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We need sections equal to the citylist
    NSLog(@"Cities:%d",[[[CityList sharedCityList] allCityData] count]);
    return [[[CityList sharedCityList] allCityData] count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Each city is going to have 14 days of forecast days
    CityData *cityData = [[[CityList sharedCityList] allCityData] objectAtIndex:section];
    
    return [[cityData cityWeatherDataFor14Days] count];
}

-(UITableViewCell*)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tblView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    //Set up the rows with forecast data and images
    CityData *cityData = [[[CityList sharedCityList] allCityData] objectAtIndex:indexPath.section];

    [[cell textLabel] setText:[cityData getWeatherForeCastForIndex:indexPath.row]];
    
    [[cell detailTextLabel] setText:[cityData dateForIndex:indexPath.row]];
    
    
    [[cell imageView] setImage:nil];
    
    
    
    
    
    

//    
// ======================================================================================================
    [[cell imageView] setImage:nil];
    
    //Try searching image in imageDictionary cache
    UIImage *weatherImage = [imageDictionary objectForKey:[cityData getImageNameForIndex:indexPath.row]];
    
    //If image not found in cache try searching in doc dir
    if (!weatherImage)
    {
        //If image exists at doc dir then load image and store in imageDictionary
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self docDirPathForImage:[cityData getImageNameForIndex:indexPath.row]]])
        {
            weatherImage = [UIImage imageWithContentsOfFile:[self docDirPathForImage:[cityData getImageNameForIndex:indexPath.row]]];
            
            [imageDictionary setObject:weatherImage forKey:[cityData getImageNameForIndex:indexPath.row]];
        }
        //Image not found in doc dir so Download image from server and store in cache and add to doc dir
        else
        {
            //Prepare a url for fetching the image
            NSString *stringURL = [NSString stringWithFormat:baseURL, [cityData getImageNameForIndex:indexPath.row]];
            
            NSURL *url = [NSURL URLWithString:stringURL];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            //Fetch image from the url asynchronously
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"Error: %@",[connectionError localizedDescription]);
                 }
                 else
                 {
                     UIImage *image = [UIImage imageWithData:data];
                     
                     //Add the fetched image to image cache
                     [imageDictionary setObject:image forKey:[cityData getImageNameForIndex:indexPath.row]];
                     
                     //Update the ui with the image
                     [self performSelectorOnMainThread:@selector(imageFetchedFromAPIForIndexPath:) withObject:indexPath waitUntilDone:NO];
                     
                     
                     //Write the image to the doc dir
                     [data writeToFile:[self docDirPathForImage:[self docDirPathForImage:[cityData getImageNameForIndex:indexPath.row]]] atomically:NO];
                 }
                 
                 
                 
             }];
        }
        
        
    }
    
    [[cell imageView] setImage:weatherImage];
    
    return cell;
}





-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CityData *cityData = [[[CityList sharedCityList] allCityData] objectAtIndex:section];
    
    return [NSString stringWithFormat:@"%@ forecast: %d days",[cityData cityName], [[cityData cityWeatherDataFor14Days] count]];
}


-(void)tableView:(UITableView *)tblView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}





-(void)fetchingDataForTheCityHasFinished:(id)cityData
{
    //Now that fetching data for a city is finished we need to update the section for the city
    NSInteger section = [[[CityList sharedCityList] allCityData] indexOfObject:cityData];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
    
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

-(IBAction)backButtonPress:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}



-(void)imageFetchedFromServerWithName:(NSString*)imageName
{
    //image for the imagename has been fetched so update the rows
    for (CityData *cityData in [[CityList sharedCityList] allCityData])
    {
        NSArray *filteredArray = [[cityData cityWeatherDataFor14Days] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"icon == %@",imageName]];
        
        NSInteger section = [[[CityList sharedCityList] allCityData] indexOfObject:cityData];
        NSMutableArray *indexPathArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in filteredArray)
        {
            NSInteger row = [[cityData cityWeatherDataFor14Days] indexOfObject:dictionary];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [indexPathArray addObject:indexPath];
            
            
        }
        
        [tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


-(NSString*)docDirPathForImage:(NSString*)imageName
{
    //Get list of doc directories
    NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    //Get the only doc dir
    NSString *docDirPath = [docDirectories objectAtIndex:0];
    
    return [docDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    
    
}

-(void)imageFetchedFromAPIForIndexPath:(NSIndexPath*)indexPath
{
    //Image has  been fetched from the api
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:
     UITableViewRowAnimationAutomatic];
}



@end
