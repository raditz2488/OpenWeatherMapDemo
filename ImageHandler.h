//
//  ImageHandler.h
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 31/01/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol ImageHandlerDelegate <NSObject>

@optional
-(void)imageFetchedFromServerWithName:(NSString*)imageName;

@end

@interface ImageHandler : NSObject
{
    NSMutableDictionary *imageDictionary;
    
//    NSData *tempImageData;
//    NSString *tempImageName;
}

@property (weak, nonatomic) id<ImageHandlerDelegate> delegate;

-(UIImage*)getImageWithName:(NSString*)imageName;

-(void)getImageAsynchronously:(NSString*)imageName;

@end
