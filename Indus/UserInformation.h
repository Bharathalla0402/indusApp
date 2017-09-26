//
//  UserInformation.h
//  Jaguar Enterprises
//
//  Created by Mac on 10/02/16.
//  Copyright (c) 2016 bharat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject<NSCoding>

@property(nonatomic,retain) NSString *DoctorId;


+ (UserInformation *)sharedController;

-(void)updateuserinfo:(NSMutableDictionary *)Array;

@end
