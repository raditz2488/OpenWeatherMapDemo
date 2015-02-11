//
//  CurrentCityWeatherVC.h
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 05/02/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityData.h"

@interface CurrentCityWeatherVC : UITableViewController<CityDataDelegate>
{
    //Image cache dictionary
    NSMutableDictionary *imageDictionary;
}
@property (strong, nonatomic) CityData *cityData;

@end
