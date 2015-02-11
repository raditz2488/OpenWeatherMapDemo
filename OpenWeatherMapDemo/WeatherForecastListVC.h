//
//  WeatherForecastListVC.h
//  OpenWeatherMapDemo
//
//  Created by $#r! on 1/30/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityData.h"
#import "ImageHandler.h"

@interface WeatherForecastListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CityDataDelegate>
{
    //The only tableview containing forecast data
    __weak IBOutlet UITableView *tableView;
    

    //This dictionary acts an image cache
    NSMutableDictionary *imageDictionary;
}



@end
