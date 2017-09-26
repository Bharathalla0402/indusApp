//
//  UserInformation.m
//  Jaguar Enterprises
//
//  Created by Mac on 10/02/16.
//  Copyright (c) 2016 bharat. All rights reserved.
//

#import "UserInformation.h"

static UserInformation *sharedController;

@implementation UserInformation
@synthesize DoctorId;

+ (UserInformation *)sharedController
{
    if (sharedController == nil)
    {
        sharedController = [[self alloc] init];
    }
    return sharedController;
}
- (id)init
{
    if ((self = [super init]))
    {
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:DoctorId forKey:@"DoctorId"];
   
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    DoctorId = [aDecoder decodeObjectForKey:@"DoctorId"];
       
    return self;
    
}
-(void)updateuserinfo:(NSMutableDictionary *)Array
{
    DoctorId=[[Array objectForKey:@"data"] valueForKey:@"doctor_id"];
   
}

@end
