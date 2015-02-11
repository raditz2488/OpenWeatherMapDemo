//
//  AddCities.m
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "AddCitiesViewController.h"
#import "CityData.h"
#import "CityList.h"


@interface AddCitiesViewController ()

@end

@implementation AddCitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
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

-(IBAction)addCityButtonPress:(id)sender
{
    //cityTextField contains text then add the city
    if ([[cityTextField text] length] == 0)
    {
        return;
    }
    
    NSString *cityString = [cityTextField.text copy];
    
    [cityTextField setText:@""];
    
    //Add the city to city list and show it in the tableview
    [[CityList sharedCityList] addCity:cityString];
    
    
    NSInteger cityCount = [[[CityList sharedCityList] allCityData] count] - 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cityCount inSection:0];
    
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}


-(IBAction)doneButtonPress:(id)sender
{
    //Check if any city is added to the list or else show alert
    if ([[[CityList sharedCityList] allCityData] count] > 0)
    {
        [self performSegueWithIdentifier:@"forecasts" sender:self];
    }
    else
    {
        UIAlertView *objUIAlertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please add a city to view forecast." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [objUIAlertView show];
    }
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //We need only one section
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Should be equal to the citylist
    return [[[CityList sharedCityList] allCityData] count];
}

-(UITableViewCell*)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    cell = [tblView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    CityData *cityData = [[[CityList sharedCityList] allCityData] objectAtIndex:indexPath.row];
    
    
    //Add the city name to the cell for the row
    [[cell textLabel] setText:[cityData cityName]];
    
    
    return cell;
}


-(IBAction)editToggle:(id)sender
{
    //Edit toggle mode
    if ([tableView isEditing])
    {
        [tableView setEditing:NO animated:YES];
        [sender setTitle:@"Edit"];
    }
    else
    {
        [tableView setEditing:YES animated:YES];
        [sender setTitle:@"Done"];
    }
}

-(void)tableView:(UITableView *)tblView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        //Delete the selected city from the city list and also the particular row
        [[CityList sharedCityList] deleteCityData:[[[CityList sharedCityList] allCityData] objectAtIndex:indexPath.row]];
        
        [tblView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //Hide the keyboard
    [textField resignFirstResponder];
    
    return YES;
}

@end
