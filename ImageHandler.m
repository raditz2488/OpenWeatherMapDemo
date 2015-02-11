//
//  ImageHandler.m
//  OpenWeatherMapDemo
//
//  Created by Rohan Bhale on 31/01/15.
//  Copyright (c) 2015 Rohan. All rights reserved.
//

#import "ImageHandler.h"


#define baseURL @"http://openweathermap.org/img/w/%@.png"

@implementation ImageHandler

@synthesize delegate;

-(id)init
{
    self = [super init];

    if (self)
    {
        imageDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(UIImage*)getImageWithName:(NSString*)imageName
{
    UIImage *imageToBeReturned;
    
    //Look if image is in imageDictionary
    if ([imageDictionary objectForKey:imageName])
    {
        return [imageDictionary objectForKey:imageName];
    }
    
    
    
    //Else check in doc dir if found load it in dictionary and return
    else if ([[NSFileManager defaultManager] fileExistsAtPath:[self docDirPathForImage:imageName]])
    {
        imageToBeReturned = [[UIImage alloc] initWithContentsOfFile:[self docDirPathForImage:imageName]];
        
        [imageDictionary setObject:imageToBeReturned forKey:imageName];
        
        return imageToBeReturned;
        
    }
    
    return imageToBeReturned;
    
    
   
    
}

-(void)getImageAsynchronously:(NSString*)imageName
{
    NSString *stringURL = [NSString stringWithFormat:baseURL, imageName];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
//    tempImageName = imageName;
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        UIImage *image = [UIImage imageWithData:data];
        
        
        [imageDictionary setObject:image forKey:imageName];
        
        
        [self performSelectorOnMainThread:@selector(imageTobeReturnedAsync:) withObject:imageName waitUntilDone:NO];
        
       
        
        [data writeToFile:[self docDirPathForImage:imageName] atomically:NO];

    }];
    
}

-(void)imageTobeReturnedAsync:(NSString*)imageName
{
    
    if ([[self delegate] respondsToSelector:@selector(imageFetchedFromServerWithName:)])
    {
        [[self delegate] imageFetchedFromServerWithName:imageName];
    }
    
}

-(NSString*)docDirPathForImage:(NSString*)imageName
{
    //Get list of doc directories
    NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *docDirPath = [docDirectories objectAtIndex:0];
    
    return [docDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",imageName]];
    
    
}



@end
