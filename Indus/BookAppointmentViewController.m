//
//  BookAppointmentViewController.m
//  Indus
//
//  Created by think360 on 13/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "BookAppointmentViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DropDownListView.h"
#import "BookingResultsViewController.h"
#import "DejalActivityView.h"
#import "UIFloatLabelTextField.h"
#import "NotificationViewController.h"
#import "PatientBookingViewController.h"

@interface BookAppointmentViewController ()<ApiRequestdelegate,UITextFieldDelegate,kDropDownListViewDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    NSArray *arryList,*arryList2,*arryList3,*arryList4;
    DropDownListView * Dropobj;
    UIView *popview;
    
    NSString *StrId;
    
    UIFloatLabelTextField *txtCity,*txtSpeciality,*txtHospital,*txtDoctors;
    NSMutableArray *arrCitys,*arrSpeciality,*arrHospital,*arrDoctors;
    NSString *strCityId,*strSpecialityId,*strHospitalId,*strDoctorsId;
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5;
    
    
   
    NSMutableArray *arrDatalist;
    NSString *StrweekDay;
    
    
    UIView *popview5;
    UIView *footerview5;
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
    
}
@end

@implementation BookAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    strCityId=@"";
    strSpecialityId=@"";
    strHospitalId=@"";
    strDoctorsId=@"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"HomeScreen"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    
    NSLog(@"%ld",(long)weekday);
    
    if(weekday == 1)
    {
     StrweekDay = @"6";
    }
    else if (weekday == 2)
    {
    StrweekDay = @"0";
    }
    else if (weekday == 3)
    {
        StrweekDay = @"1";
    }
    else if (weekday == 4)
    {
        StrweekDay = @"2";
    }
    else if (weekday == 5)
    {
        StrweekDay = @"3";
    }
    else if (weekday == 6)
    {
        StrweekDay = @"4";
    }
    else if (weekday == 7)
    {
        StrweekDay = @"5";
    }
        
     NSLog(@"%@",StrweekDay);
   
    arrDatalist=[[NSMutableArray alloc] init];
    
    arrCitys=[[NSMutableArray alloc]init];
    arrSpeciality=[[NSMutableArray alloc]init];
    arrHospital=[[NSMutableArray alloc]init];
    arrDoctors=[[NSMutableArray alloc]init];
    
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [self CustomView];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"%@",userInfo);
    NSString *myObject = [userInfo objectForKey:@"count"];
    NoticationLab.text=[NSString stringWithFormat:@"%@",myObject];
}


-(void)TipPopUp
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,healthtips];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:strurl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async (dispatch_get_main_queue(), ^{
            
            if (error)
            {
                popview5.hidden=YES;
                
                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                {
                    [DejalBezelActivityView removeView];
                    [requested showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
                    
                }
                if ([error.localizedDescription isEqualToString:@"The request timed out."])
                {
                    [DejalBezelActivityView removeView];
                }
                
                
            } else
            {
                NSError *err;
                NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                [self responsewithToken51:responseJSON];
                
            }
            
        });
    }] resume];
    
}



-(void)responsewithToken51:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        
        
        arrdata=[responseToken valueForKey:@"data"];
        
        [self NotificationApimeth];
        
        [DejalBezelActivityView removeView];
        
        
        //        textLab.text=[[responseToken valueForKey:@"data"] valueForKey:@"title"];
        //        textLab2.text=[[responseToken valueForKey:@"data"] valueForKey:@"description"];
    }
    else
    {
        popview5.hidden=YES;
        
        // [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


-(void)NotificationApimeth
{
   // self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstlog"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    popview5 = [[UIView alloc]init];
    popview5.frame = CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.height);
    // popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    popview5.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.7];
    [self.view addSubview:popview5];
    
    footerview5=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height)];
    footerview5.backgroundColor = [UIColor clearColor];
    [popview5 addSubview:footerview5];
    
    
    UIImageView *imagebig=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 80, 80, 80)];
    imagebig.image=[UIImage imageNamed:@"intro_logo.png"];
    imagebig.contentMode = UIViewContentModeScaleAspectFill;
    [footerview5 addSubview:imagebig];
    
    textLab=[[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2-90, self.view.frame.size.width-20, 60)];
    textLab.text=[arrdata valueForKey:@"title"];
    textLab.textColor=[UIColor whiteColor];
    textLab.numberOfLines=0;
    textLab.textAlignment=NSTextAlignmentCenter;
    textLab.font=[UIFont fontWithName:@"OpenSans-Bold" size:22.0];
    [footerview5 addSubview:textLab];
    
    textLab2=[[UILabel alloc] initWithFrame:CGRectMake(10, textLab.frame.size.height+textLab.frame.origin.y+10, self.view.frame.size.width-20, 150)];
    textLab2.text=[arrdata valueForKey:@"description"];
    textLab2.textColor=[UIColor whiteColor];
    textLab2.numberOfLines=0;
    textLab2.textAlignment=NSTextAlignmentCenter;
    textLab2.font=[UIFont fontWithName:@"OpenSans-Regular" size:18.0];
    [footerview5 addSubview:textLab2];
    
    
    
    
    [self performSelector:@selector(AcceptedResponse7:) withObject:self afterDelay:3.0];
}

-(void)AcceptedResponse7:(id)sender
{
    self.tabBarController.tabBar.userInteractionEnabled=YES;
    
    popview5.hidden=YES;
    [footerview5 removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstlog"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}






#pragma mark - CustomView

-(void)CustomView
{
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 67)];
    topView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *backimage=[[UIImageView alloc] initWithFrame:CGRectMake(5, 25, 30, 30)];
    backimage.image=[UIImage imageNamed:@"arrow_left.png"];
    backimage.contentMode = UIViewContentModeScaleAspectFit;
    backimage.hidden=YES;
    [topView addSubview:backimage];
    
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 10, 70, 50)];
    [backButton addTarget:self action:@selector(BackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor=[UIColor clearColor];
    backButton.hidden=YES;
    [topView addSubview:backButton];
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-15, topView.frame.size.width-120, 40)];
    titlelab.text=@"Book Your Appointment";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    [topView addSubview:titlelab];
    
    
    UIImageView *topimage=[[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width-50, topView.frame.size.height/2-17, 40, 40)];
    topimage.image=[UIImage imageNamed:@"intro_logo.png"];
    topimage.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:topimage];
    
    NoticationLab=[[UILabel alloc]initWithFrame:CGRectMake(topView.frame.size.width-30, topView.frame.size.height/2-19, 20, 20)];
    NoticationLab.backgroundColor=[UIColor colorWithRed:255.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0];
    NoticationLab.layer.masksToBounds = YES;
    NoticationLab.layer.cornerRadius = 10.0;
    NoticationLab.textColor=[UIColor whiteColor];
    NoticationLab.font=[UIFont systemFontOfSize:12];
    NoticationLab.textAlignment=NSTextAlignmentCenter;
    NoticationLab.hidden=YES;
    [topView addSubview:NoticationLab];
    
    NotificationButton=[[UIButton alloc] initWithFrame:CGRectMake(topView.frame.size.width-60, 0, 60, 60)];
    [NotificationButton addTarget:self action:@selector(NotificationButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NotificationButton.backgroundColor=[UIColor clearColor];
   // NotificationButton.userInteractionEnabled=NO;
    [topView addSubview:NotificationButton];
    
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    [self.view addSubview:categoryScrollView];
    
    
    UILabel *textlab=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 50)];
    textlab.text=@"Select the fields below to schedule your Doctor Appointment";
    textlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    textlab.textAlignment=NSTextAlignmentCenter;
    textlab.numberOfLines=0;
    textlab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:textlab];
    
    
    txtCity=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, textlab.frame.size.height+textlab.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtCity.placeholder = @"City";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Select City" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtCity.attributedPlaceholder = str1;
    txtCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtCity.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtCity.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtCity.backgroundColor=[UIColor clearColor];
    txtCity.delegate=self;
    [categoryScrollView addSubview:txtCity];
    
    UIImageView * myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, textlab.frame.size.height+textlab.frame.origin.y+45, 20, 20)];
    myImageView.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];

    
    UIButton *CityButton=[[UIButton alloc] initWithFrame:CGRectMake(15, textlab.frame.size.height+textlab.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [CityButton addTarget:self action:@selector(CityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CityButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:CityButton];
    
    
    
    
   
    
    
    txtHospital=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtHospital.placeholder = @"Hospital";
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Select Hospital" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtHospital.attributedPlaceholder = str3;
    txtHospital.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtHospital.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtHospital.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtHospital.backgroundColor=[UIColor clearColor];
    txtHospital.delegate=self;
    [categoryScrollView addSubview:txtHospital];
    
    UIImageView * myImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, txtCity.frame.size.height+txtCity.frame.origin.y+50, 20, 20)];
    myImageView3.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView3];
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    UIButton *HospitalButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [HospitalButton addTarget:self action:@selector(HospitalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    HospitalButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:HospitalButton];
    
    
    
    
    
    
    txtSpeciality=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtSpeciality.placeholder = @"Speciality";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Select Speciality" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtSpeciality.attributedPlaceholder = str2;
    txtSpeciality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtSpeciality.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtSpeciality.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtSpeciality.backgroundColor=[UIColor clearColor];
    txtSpeciality.delegate=self;
    [categoryScrollView addSubview:txtSpeciality];
    
    UIImageView * myImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, txtHospital.frame.size.height+txtHospital.frame.origin.y+45, 20, 20)];
    myImageView2.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView2];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    UIButton *SpecialityButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [SpecialityButton addTarget:self action:@selector(SpecialityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    SpecialityButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:SpecialityButton];
    
    
    
    
    
    
    
    
    
    txtDoctors=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtDoctors.placeholder = @"Doctor";
    NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Select Doctor" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDoctors.attributedPlaceholder = str4;
    txtDoctors.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDoctors.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDoctors.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDoctors.backgroundColor=[UIColor clearColor];
    txtDoctors.delegate=self;
    [categoryScrollView addSubview:txtDoctors];
    
    UIImageView * myImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+50, 20, 20)];
    myImageView4.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView4];
    
    linelabel5=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDoctors.frame.size.height+txtDoctors.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel5];

    
    UIButton *DoctorsButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [DoctorsButton addTarget:self action:@selector(DoctorsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    DoctorsButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:DoctorsButton];
    
    
    UIButton *ContinueButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtDoctors.frame.size.height+txtDoctors.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    ContinueButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [ContinueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    ContinueButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    ContinueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ContinueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ContinueButton addTarget:self action:@selector(ContinueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:ContinueButton];
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"firstlog"];
    if(object != nil)
    {
        
        [self TipPopUp];
    }
    else
    {
        
    }

}




#pragma mark - CityButton Clicked

-(IBAction)CityButtonClicked:(id)sender
{
    StrId=@"1";
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"city_id=%@",@""];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDrop];
    [requested sendRequest3:post withUrl:strurl];
}


-(void)responsewithToken3:(NSMutableDictionary *)responseToken
{
   // NSLog(@"%@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrCitys=[responseToken valueForKey:@"city"];
        
         [self showPopUpWithTitle:@"Select City" withOption:arrCitys xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


#pragma mark - HospitalButton Clicked

-(IBAction)HospitalButtonClicked:(id)sender
{
    //    if (strCityId == (id)[NSNull null] || strCityId.length == 0 )
    //    {
    //        [requested showMessage:@"Please Select City" withTitle:@""];
    //    }
    //    else if (strSpecialityId == (id)[NSNull null] || strSpecialityId.length == 0 )
    //    {
    //        [requested showMessage:@"Please Select Speciality" withTitle:@""];
    //    }
    //    else
    //    {
    //        StrId=@"3";
    //        [Dropobj fadeOut];
    //
    //
    //        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    //        NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@",strCityId,strSpecialityId];
    //        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,selectHospital];
    //        [requested sendRequest2:post withUrl:strurl];
    //    }
    //
    //
    //    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    //    NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@&hospital_id=%@&doctor_id=%@",strCityId,strSpecialityId,strHospitalId,strDoctorsId];
    //    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDrop];
    //    [requested sendRequest2:post withUrl:strurl];
    
    StrId=@"2";
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"city_id=%@",strCityId];
    NSLog(@"%@",post);
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDrop];
    [requested sendRequest5:post withUrl:strurl];
    
}


-(void)responsewithToken5:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrHospital=[responseToken valueForKey:@"hospital"];
        
        [self showPopUpWithTitle:@"Select Hospital" withOption:arrHospital xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}






#pragma mark - SpecialityButton Clicked

-(IBAction)SpecialityButtonClicked:(id)sender
{
//    if (strCityId == (id)[NSNull null] || strCityId.length == 0 )
//    {
//        [requested showMessage:@"Please Select City" withTitle:@""];
//    }
//    else
//    {
//     StrId=@"2";
//     [Dropobj fadeOut];
//    
//    
//     [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
//     NSString *post = [NSString stringWithFormat:@"city_id=%@",strCityId];
//     NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,selectSpeciality];
//     [requested sendRequest:post withUrl:strurl];
//    }
    
    StrId=@"3";
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"city_id=%@&hospital_id=%@",strCityId,strHospitalId];
     NSLog(@"%@",post);
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDrop];
    [requested sendRequest4:post withUrl:strurl];
}


-(void)responsewithToken4:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrSpeciality=[responseToken valueForKey:@"speciality"];
        
        [self showPopUpWithTitle:@"Select Speciality" withOption:arrSpeciality xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}







#pragma mark - DoctorsButton Clicked

-(IBAction)DoctorsButtonClicked:(id)sender
{
//    
//    if (strCityId == (id)[NSNull null] || strCityId.length == 0 )
//    {
//        [requested showMessage:@"Please Select City" withTitle:@""];
//    }
//    else if (strSpecialityId == (id)[NSNull null] || strSpecialityId.length == 0 )
//    {
//        [requested showMessage:@"Please Select Speciality" withTitle:@""];
//    }
//    else if (strHospitalId == (id)[NSNull null] || strHospitalId.length == 0 )
//    {
//        [requested showMessage:@"Please Select Hospital" withTitle:@""];
//    }
//    else
//    {
//        StrId=@"4";
//        [Dropobj fadeOut];
//        
//        
//        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
//        NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@&hospital_id=%@",strCityId,strSpecialityId,strHospitalId];
//        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,selectDoctor];
//        [requested sendRequest3:post withUrl:strurl];
//    }
//
    
    StrId=@"4";
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"city_id=%@&speciality_id=%@&hospital_id=%@",strCityId,strSpecialityId,strHospitalId];
     NSLog(@"%@",post);
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDrop];
    [requested sendRequest6:post withUrl:strurl];
}


-(void)responsewithToken6:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrDoctors=[responseToken valueForKey:@"doctor"];
        
        [self showPopUpWithTitle:@"Select Doctor" withOption:arrDoctors xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}



#pragma mark - Continue Clicked

-(IBAction)ContinueButtonClicked:(id)sender
{
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@&hospital_id=%@&doctor_id=%@&week_day=%@",strCityId,strSpecialityId,strHospitalId,strDoctorsId,StrweekDay];
    NSLog(@"%@",post);
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDoctorAll];
        [requested sendRequest7:post withUrl:strurl];
}



-(void)responsewithToken7:(NSMutableDictionary *)responseToken
{
    NSLog(@"%@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        [arrDatalist removeAllObjects];
        
        NSArray *arrData=[responseToken valueForKey:@"data"];
        
        for (int i=0; i<arrData.count; i++)
        {
        
            
            NSArray *arrHos=[[arrData objectAtIndex:i] valueForKey:@"hospital"];
            
            for (int j=0; j<arrHos.count; j++)
            {
                NSMutableDictionary *arrDic=[[NSMutableDictionary alloc]init];
                NSString *strCity=[NSString stringWithFormat:@"%@",[[arrData valueForKey:@"city"] objectAtIndex:i]];
                [arrDic setObject:strCity forKey:@"city"];
                NSString *strid=[NSString stringWithFormat:@"%@",[[arrData valueForKey:@"id"]objectAtIndex:i]];
                [arrDic setObject:strid forKey:@"id"];
                NSString *strname=[NSString stringWithFormat:@"%@",[[arrData valueForKey:@"name"]objectAtIndex:i]];
                [arrDic setObject:strname forKey:@"name"];
                NSString *strSpeciality=[NSString stringWithFormat:@"%@",[[arrData valueForKey:@"specility"]objectAtIndex:i]];
                [arrDic setObject:strSpeciality forKey:@"specility"];
                NSString *strPic=[NSString stringWithFormat:@"%@",[[arrData valueForKey:@"pic"]objectAtIndex:i]];
                [arrDic setObject:strPic forKey:@"pic"];
                
                 NSString *streveningtime=[NSString stringWithFormat:@"%@",[[arrHos valueForKey:@"evening_time"]objectAtIndex:j]];
                [arrDic setObject:streveningtime forKey:@"evening_time"];
                NSString *strhospital=[NSString stringWithFormat:@"%@",[[arrHos valueForKey:@"hospital"]objectAtIndex:j]];
                [arrDic setObject:strhospital forKey:@"hospital"];
                NSString *strhospitalid=[NSString stringWithFormat:@"%@",[[arrHos valueForKey:@"hospital_id"]objectAtIndex:j]];
                [arrDic setObject:strhospitalid forKey:@"hospital_id"];
                NSString *strmorningtime=[NSString stringWithFormat:@"%@",[[arrHos valueForKey:@"mrning_time"]objectAtIndex:j]];
                [arrDic setObject:strmorningtime forKey:@"mrning_time"];
                
                NSArray *stravailable=[[arrHos valueForKey:@"available"]objectAtIndex:j];
                [arrDic setObject:stravailable forKey:@"available"];
                
                NSMutableArray *arr=[[NSMutableArray alloc] initWithObjects:arrDic, nil];
                
                arrDatalist=[[arrDatalist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
               // NSLog(@"%@",arrDatalist);
            }
        }
        
        
        [[NSUserDefaults standardUserDefaults]setObject:strCityId forKey:@"CityId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:strSpecialityId forKey:@"SpecialityId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:strHospitalId forKey:@"HospitalId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:strDoctorsId forKey:@"DoctId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
        BookingResultsViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"BookingResultsViewController"];
        book.arrChildCategory=arrDatalist;
        book.strCityId=strCityId;
        book.strSpecialityId=strSpecialityId;
        book.strHospitalId=strHospitalId;
        book.strDoctorsId=strDoctorsId;
        book.SelectedCity=txtCity.text;
        book.SelectedSpeciality=txtSpeciality.text;
        book.SelectedHospital=txtHospital.text;
        book.SelectedDoctor=txtDoctors.text;
        [self.navigationController pushViewController:book animated:YES];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}





#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
   [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - TextField Delegates


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [(ACFloatingTextField *)textField textFieldDidBeginEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   // [(ACFloatingTextField *)textField textFieldDidEndEditing];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - DropDown Options

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    popview = [[ UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:popview animated:YES];
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:93.0 G:181.0 B:80.0 alpha:0.9];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    popview.hidden = YES;
    
    if ([StrId isEqualToString:@"1"])
    {
        txtCity.text=[[arrCitys valueForKey:@"name"]objectAtIndex:anIndex];
        strCityId=[[arrCitys valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        
        strHospitalId=@"";
        txtHospital.text=@"";
        strSpecialityId=@"";
        txtSpeciality.text=@"";
        strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
       
    }
    else if([StrId isEqualToString:@"2"])
    {
        txtHospital.text=[[arrHospital valueForKey:@"name"]objectAtIndex:anIndex];
        strHospitalId=[[arrHospital valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        strSpecialityId=@"";
        txtSpeciality.text=@"";
        strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else if([StrId isEqualToString:@"3"])
    {
        txtSpeciality.text=[[arrSpeciality valueForKey:@"name"]objectAtIndex:anIndex];
        strSpecialityId=[[arrSpeciality valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else if([StrId isEqualToString:@"4"])
    {
        txtDoctors.text=[[arrDoctors valueForKey:@"name"]objectAtIndex:anIndex];
        strDoctorsId=[[arrDoctors valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    }
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData
{
    if (ArryData.count>0)
    {
       
    }
    else
    {
       
    }
}

- (void)DropDownListViewDidCancel
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]])
    {
        popview.hidden = YES;
        [Dropobj fadeOut];
        
        
        self.tabBarController.tabBar.userInteractionEnabled=YES;
        
        popview5.hidden=YES;
        [footerview5 removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstlog"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}



#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
        //[requested sendRequest5:post withUrl:strurl];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:strurl]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:postData];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async (dispatch_get_main_queue(), ^{
                
                if (error)
                {
                    if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
                    {
                        [DejalBezelActivityView removeView];
                        [requested showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
                        
                    }
                    if ([error.localizedDescription isEqualToString:@"The request timed out."])
                    {
                        [DejalBezelActivityView removeView];
                    }
                } else
                {
                    NSError *err;
                    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    [self responsewithToken8:responseJSON];
                    [DejalBezelActivityView removeView];
                }
                
            });
        }] resume];

    }
    else
    {
        NoticationLab.hidden=YES;
      //  NotificationButton.userInteractionEnabled=NO;
    }
}


-(void)responsewithToken8:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        NoticationLab.hidden=NO;
        NotificationButton.userInteractionEnabled=YES;
        
        NoticationLab.text=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"count"]];
    }
    else
    {
        NoticationLab.hidden=YES;
      //  NotificationButton.userInteractionEnabled=NO;
       // [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


#pragma mark - NotificationButton Clicked

-(IBAction)NotificationButtonClicked:(id)sender
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,Notification];
        [requested sendRequest9:post withUrl:strurl];
    }
    else
    {
        [requested showMessage:@"Please Login to check the Notification" withTitle:@"Indus"];
    }
}


-(void)responsewithToken9:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        NotificationViewController *notification=[self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        notification.arrChildCategory=[responseToken valueForKey:@"data"];
        [self.navigationController pushViewController:notification animated:YES];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}





#pragma mark - Warrings

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
