//
//  AddCities.h
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCitiesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *cityTextField;
    __weak IBOutlet UITableView *tableView;
}

//Ran on + tap
-(IBAction)addCityButtonPress:(id)sender;

//ran on Done tap
-(IBAction)doneButtonPress:(id)sender;



@end
