//
//  CurrentCityWeatherVC.m
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "CurrentCityWeatherVC.h"

#define baseURL @"http://openweathermap.org/img/w/%@.png"


@interface CurrentCityWeatherVC ()

@end

@implementation CurrentCityWeatherVC

@synthesize cityData;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initialize the image cache
    imageDictionary = [[NSMutableDictionary alloc] init];
    
    [cityData setDelegate:self];
    
    //Start fetching the weather forecast data
    [cityData fetchWeatherDataForTheCityWithCoordinate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    //We need 1 section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // We need 14 for 14 days
    return [[cityData cityWeatherDataFor14Days] count];
}


- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tblView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    }
    
    
    
    //Setup the forecast data for a single day
    [[cell textLabel] setText:[cityData getWeatherForeCastForIndex:indexPath.row]];
    
    [[cell detailTextLabel] setText:[cityData dateForIndex:indexPath.row]];
    
    
    [[cell imageView] setImage:nil];
    

    
    //Try searching image in imageDictionary cache
    UIImage *weatherImage = [imageDictionary objectForKey:[cityData getImageNameForIndex:indexPath.row]];
    
    //If image not found try searching in doc dir
    if (!weatherImage)
    {
        //If image exists at doc dir then load image and store in imageDictionary
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self docDirPathForImage:[cityData getImageNameForIndex:indexPath.row]]])
        {
            weatherImage = [UIImage imageWithContentsOfFile:[self docDirPathForImage:[cityData getImageNameForIndex:indexPath.row]]];
            
            [imageDictionary setObject:weatherImage forKey:[cityData getImageNameForIndex:indexPath.row]];
        }
        //Download image from server
        else
        {
            NSString *stringURL = [NSString stringWithFormat:baseURL, [cityData getImageNameForIndex:indexPath.row]];
            
            NSURL *url = [NSURL URLWithString:stringURL];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            //    tempImageName = imageName;
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
             {
                 if (connectionError)
                 {
                     NSLog(@"Error: %@",[connectionError localizedDescription]);
                 }
                 else
                 {
                     UIImage *image = [UIImage imageWithData:data];
                     
                     
                     [imageDictionary setObject:image forKey:[cityData getImageNameForIndex:indexPath.row]];
                     
                     
                     [self performSelectorOnMainThread:@selector(imageFetchedFromAPIForIndexPath:) withObject:indexPath waitUntilDone:NO];
                     
                     
                     
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
    return [NSString stringWithFormat:@"%@ forecast: %d days",[cityData cityName], [[cityData cityWeatherDataFor14Days] count]];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)fetchingDataForTheCityHasFinished:(id)cityData
{
    [[self tableView] reloadData];
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
    //Image has been fetched using the API
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:
     UITableViewRowAnimationAutomatic];
}


@end
