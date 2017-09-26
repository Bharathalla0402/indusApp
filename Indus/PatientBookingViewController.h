//
//  PatientBookingViewController.h
//  Indus
//
//  Created by think360 on 21/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientBookingViewController : UIViewController

@property(nonatomic,retain) NSString *strDoctorname;
@property(nonatomic,retain) NSString *strDoctorAddress;
@property(nonatomic,retain) NSString *strDoctorImageUrl;
@property(nonatomic,retain) NSMutableArray *arrChildCategory;

@property(nonatomic,retain) NSString *strSelectedDate;

@property(nonatomic,retain) NSString *strDate;

@end
