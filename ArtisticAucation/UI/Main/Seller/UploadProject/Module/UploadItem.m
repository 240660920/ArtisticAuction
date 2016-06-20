//
//  UploadItem.m
//  ArtisticAucation
//
//  Created by xieran on 15/11/6.
//  Copyright © 2015年 xieran. All rights reserved.
//

#import "UploadItem.h"

@implementation UploadItem

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init])
    {
        self.name =[aDecoder decodeObjectForKey:@"name"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.property =[aDecoder decodeObjectForKey:@"property"];
        self.images =[aDecoder decodeObjectForKey:@"images"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.features = [aDecoder decodeObjectForKey:@"features"];
        self.timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    }
    return (self);
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_price forKey:@"price"];
    [aCoder encodeObject:_property forKey:@"property"];
    [aCoder encodeObject:_images forKey:@"images"];
    [aCoder encodeObject:_desc forKey:@"desc"];
    [aCoder encodeObject:_features forKey:@"features"];
    [aCoder encodeObject:_timestamp forKey:@"timestamp"];
}



@end
