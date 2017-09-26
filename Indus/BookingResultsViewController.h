//
//  BookingResultsViewController.h
//  Indus
//
//  Created by think360 on 17/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookingResultsViewController : UIViewController

@property BOOL isInternetConnectionAvailable;

@property(nonatomic,strong)NSMutableArray *arryData;
@property(nonatomic,strong)NSMutableArray *arryData2;

@property(nonatomic,retain) NSString *strpage;
@property(nonatomic,retain) NSString *strtitl;
@property(nonatomic,retain) NSString *strlocation;
@property(nonatomic,retain) NSString *strlattitude;
@property(nonatomic,retain) NSString *strlongitude;
@property(nonatomic,retain) NSString *strDoctors;
@property(nonatomic,retain) NSString *strDoctId;
@property(nonatomic,retain) NSString *strModule;
@property(nonatomic,retain) NSMutableArray *arrChildCategory;



@property(nonatomic,retain) NSString *strCityId;
@property(nonatomic,retain) NSString *strSpecialityId;
@property(nonatomic,retain) NSString *strHospitalId;
@property(nonatomic,retain) NSString *strDoctorsId;

@property(nonatomic,retain) NSString *SelectedCity;
@property(nonatomic,retain) NSString *SelectedSpeciality;
@property(nonatomic,retain) NSString *SelectedHospital;
@property(nonatomic,retain) NSString *SelectedDoctor;

@end
