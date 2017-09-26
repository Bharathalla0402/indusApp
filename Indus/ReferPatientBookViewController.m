//
//  ReferPatientBookViewController.m
//  Indus
//
//  Created by think360 on 21/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "ReferPatientBookViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DejalActivityView.h"
#import "DropDownListView.h"
#import "UIFloatLabelTextField.h"
#import "FilterReferPatientViewController.h"
#import "NotificationViewController.h"

@interface ReferPatientBookViewController ()<ApiRequestdelegate,UITextFieldDelegate,kDropDownListViewDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    NSArray *arryList,*arryList2;
    
    DropDownListView * Dropobj;
    NSString *StrId;
    UIView *popview;
    
    UIFloatLabelTextField *txtHospital,*txtDoctors;
    
    UIFloatLabelTextField *txtName,*txtage,*txtEmail,*txtPhone,*txtAddress,*txtComments;
    NSMutableArray *arrHospital,*arrDoctors;
    NSString *strHospitalId,*strDoctorsId,*strgender;
    UIImageView *maleb,*femaleb;
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5,*linelabel6,*linelabel7,*linelabel8,*linelabel9;
}
@end

@implementation ReferPatientBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    self.view.backgroundColor=[UIColor whiteColor];
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    arrHospital=[[NSMutableArray alloc]init];
    arrDoctors=[[NSMutableArray alloc]init];
    
    arryList=@[@"Ivy",@"Indus",@"Malinani",@"Think360",@"HIG",@"ESI",@"Appolo",@"Themo",@"Care",@"Mangal"];
    arryList2=@[@"Dr.Bharath",@"Dr.Hitesh",@"Dr.Nitish",@"Dr.Swamy",@"Dr.Prince",@"Dr.Rajinder",@"Dr.Shama",@"Dr.Sathi",@"Dr.Ram",@"Dr.Siddhu"];
    
    [self CustomView];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *myObject = [userInfo objectForKey:@"count"];
    NoticationLab.text=[NSString stringWithFormat:@"%@",myObject];
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
    [topView addSubview:backimage];
    
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 10, 70, 50)];
    [backButton addTarget:self action:@selector(BackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor=[UIColor clearColor];
    [topView addSubview:backButton];
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-15, topView.frame.size.width-120, 40)];
    titlelab.text=@"REFER A PATIENT";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
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
  //  NotificationButton.userInteractionEnabled=NO;
    [topView addSubview:NotificationButton];
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    categoryScrollView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:categoryScrollView];
    
    
    
    txtHospital=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-30, 50)];
    txtHospital.placeholder = @"Select Hospital *";
    NSAttributedString *str33 = [[NSAttributedString alloc] initWithString:@"Select Hospital *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtHospital.attributedPlaceholder = str33;
    txtHospital.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtHospital.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtHospital.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtHospital.backgroundColor=[UIColor clearColor];
    txtHospital.delegate=self;
    [categoryScrollView addSubview:txtHospital];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    UIImageView *myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, 35, 20, 20)];
    myImageView.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView];
    
    UIButton *HospitalButton=[[UIButton alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-30, 50)];
    [HospitalButton addTarget:self action:@selector(HospitalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    HospitalButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:HospitalButton];
    
    
    
    txtDoctors=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtHospital.frame.size.height+txtHospital.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    NSAttributedString *str44= [[NSAttributedString alloc] initWithString:@"Select Doctor *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDoctors.attributedPlaceholder = str44;
    txtDoctors.placeholder = @"Select Doctor *";
    txtDoctors.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDoctors.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDoctors.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDoctors.backgroundColor=[UIColor clearColor];
    txtDoctors.delegate=self;
    [categoryScrollView addSubview:txtDoctors];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDoctors.frame.size.height+txtDoctors.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    UIImageView * myImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, txtHospital.frame.size.height+txtHospital.frame.origin.y+35, 20, 20)];
    myImageView4.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView4];
    
    UIButton *DoctorsButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    [DoctorsButton addTarget:self action:@selector(DoctorsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    DoctorsButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:DoctorsButton];
    
    
    txtName=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtDoctors.frame.size.height+txtDoctors.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtName.placeholder=@"Refer Patient Name *";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Refer Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtName.attributedPlaceholder = str1;
    txtName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtName.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.btmLineColor =[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtName.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtName.backgroundColor=[UIColor clearColor];
    txtName.delegate=self;
    txtName.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtName];
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtName.frame.size.height+txtName.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    txtage=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtName.frame.size.height+txtName.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtage.placeholder=@"Age *";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Age *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtage.attributedPlaceholder = str2;
    txtage.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtage.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtage.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtage.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtage.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtage.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtage.backgroundColor=[UIColor clearColor];
    txtage.delegate=self;
    [txtage setKeyboardType:UIKeyboardTypeNumberPad];
    txtage.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtage];
    
    linelabel5=[[UILabel alloc]initWithFrame:CGRectMake(15, txtage.frame.size.height+txtage.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel5];
    
    
    UILabel *genderLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, txtage.frame.size.height+txtage.frame.origin.y+30, 80, 30)];
    genderLabel.text=@"Gender *";
    genderLabel.numberOfLines=2;
    genderLabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    genderLabel.textAlignment=NSTextAlignmentLeft;
    genderLabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:genderLabel];
    
    
    maleb=[[UIImageView alloc]initWithFrame:CGRectMake(genderLabel.frame.size.width+genderLabel.frame.origin.x+20, txtage.frame.size.height+txtage.frame.origin.y+30, 30, 30)];
    maleb.image=[UIImage imageNamed:@"unselected-radio.png"];
    maleb.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:maleb];
    
    UILabel *malelab=[[UILabel alloc] initWithFrame:CGRectMake(maleb.frame.size.width+maleb.frame.origin.x, txtage.frame.size.height+txtage.frame.origin.y+30, 50, 30)];
    malelab.text=@"Male";
    malelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    malelab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:malelab];

    
    UIButton *malebutt=[[UIButton alloc] initWithFrame:CGRectMake(genderLabel.frame.size.width+genderLabel.frame.origin.x+20, txtage.frame.size.height+txtage.frame.origin.y+30, 80, 30)];
    [malebutt addTarget:self action:@selector(MaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    malebutt.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:malebutt];
    
    
    femaleb=[[UIImageView alloc]initWithFrame:CGRectMake(malelab.frame.size.width+malelab.frame.origin.x+20, txtage.frame.size.height+txtage.frame.origin.y+30, 30, 30)];
    femaleb.image=[UIImage imageNamed:@"unselected-radio.png"];
    femaleb.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:femaleb];
    
    UILabel *femalelab=[[UILabel alloc] initWithFrame:CGRectMake(femaleb.frame.size.width+femaleb.frame.origin.x, txtage.frame.size.height+txtage.frame.origin.y+30, 70, 30)];
    femalelab.text=@"Female";
    femalelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    femalelab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:femalelab];
    
    UIButton *femalebutt=[[UIButton alloc] initWithFrame:CGRectMake(malelab.frame.size.width+malelab.frame.origin.x+20, txtage.frame.size.height+txtage.frame.origin.y+30, 80, 30)];
    [femalebutt addTarget:self action:@selector(FemaleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    femalebutt.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:femalebutt];
    
    
    txtEmail=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, genderLabel.frame.size.height+genderLabel.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtEmail.placeholder=@"Email";
    NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtEmail.attributedPlaceholder = str3;
    txtEmail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtEmail.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtEmail.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtEmail.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtEmail.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtEmail.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtEmail.backgroundColor=[UIColor clearColor];
    txtEmail.delegate=self;
    [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    txtEmail.autocorrectionType = NO;
    txtEmail.autocapitalizationType = NO;
    txtEmail.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtEmail];
    
    linelabel6=[[UILabel alloc]initWithFrame:CGRectMake(15, txtEmail.frame.size.height+txtEmail.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel6];
    
    txtPhone=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtEmail.frame.size.height+txtEmail.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtPhone.placeholder=@"Contact Number *";
    NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtPhone.attributedPlaceholder = str4;
    txtPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtPhone.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtPhone.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtPhone.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtPhone.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtPhone.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtPhone.backgroundColor=[UIColor clearColor];
    txtPhone.delegate=self;
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    txtPhone.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtPhone];
    
    linelabel7=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel7];
    
    txtAddress=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtPhone.frame.size.height+txtPhone.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtAddress.placeholder=@"Address";
    NSAttributedString *str7= [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtAddress.attributedPlaceholder = str7;
    txtAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtAddress.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtAddress.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtAddress.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtAddress.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtAddress.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtAddress.backgroundColor=[UIColor clearColor];
    txtAddress.delegate=self;
    txtAddress.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtAddress];
    
    linelabel8=[[UILabel alloc]initWithFrame:CGRectMake(15, txtAddress.frame.size.height+txtAddress.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel8];
    
    txtComments=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtAddress.frame.size.height+txtAddress.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtComments.placeholder=@"Additional Comments";
    NSAttributedString *str8= [[NSAttributedString alloc] initWithString:@"Additional Comments" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtComments.attributedPlaceholder = str8;
    txtComments.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtComments.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtComments.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtComments.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtComments.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtComments.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtComments.backgroundColor=[UIColor clearColor];
    txtComments.delegate=self;
    txtComments.returnKeyType = UIReturnKeyDone;
    [categoryScrollView addSubview:txtComments];
    
    linelabel9=[[UILabel alloc]initWithFrame:CGRectMake(15, txtComments.frame.size.height+txtComments.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel9.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel9];
    
    
    UIButton *SubmitButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtComments.frame.size.height+txtComments.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    SubmitButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]   ;
    [SubmitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    SubmitButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    SubmitButton.layer.cornerRadius = 4;
    SubmitButton.clipsToBounds = YES;
    SubmitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitButton addTarget:self action:@selector(SubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:SubmitButton];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor=[UIColor whiteColor];
    numberToolbar.backgroundColor=[UIColor colorWithRed:90.0/255.0f green:143.0/255.0f blue:63.0/255.0f alpha:1.0];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    txtage.inputAccessoryView = numberToolbar;
    txtPhone.inputAccessoryView=numberToolbar;
    
    
    
    [self setupOutlets1];
    
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 760);

}

-(void)doneWithNumberPad
{
    [txtage resignFirstResponder];
    [txtPhone resignFirstResponder];
}


#pragma mark - Submit Button Clicked

-(IBAction)SubmitButtonClicked:(id)sender
{
    if (txtHospital.text.length==0)
    {
        [requested showMessage:@"Please Select the Hospital" withTitle:@"Warning"];
    }
    else if (txtDoctors.text.length==0)
    {
        [requested showMessage:@"Please Select the Doctor" withTitle:@"Warning"];
    }
    else if (txtName.text.length==0)
    {
        [requested showMessage:@"Please Enter Refer Patient Name" withTitle:@"Warning"];
    }
    else if (txtage.text.length==0)
    {
        [requested showMessage:@"Please Enter  Age" withTitle:@"Warning"];
    }
    else if (txtage.text.length>4)
    {
        [requested showMessage:@"Please Enter Proper Age" withTitle:@"Warning"];
    }
    else if (txtPhone.text.length==0)
    {
        [requested showMessage:@"Please Enter Mobile Number" withTitle:@"Warning"];
    }
    else if (![self myMobileNumberValidate:txtPhone.text])
    {
        [requested showMessage:@"Please Enter 10 Digit Mobile Number" withTitle:@"Warning"];
    }
    else
    {
        if (!(txtEmail.text.length==0))
        {
            if (![self NSStringIsValidEmail:txtEmail.text])
            {
                [requested showMessage:@"Please Enter Valid Email Id" withTitle:@"Warning"];
            }
            else
            {
                NSString *string = txtEmail.text;
                string = [string stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceCharacterSet]];
                
                txtEmail.text=string;
                
                NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
                [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
                NSString *post = [NSString stringWithFormat:@"login_id=%@&doctor_id=%@&hospital_id=%@&patient_name=%@&age=%@&gender=%@&email=%@&contact=%@&address=%@&comments=%@",strLoginid,strDoctorsId,strHospitalId,txtName.text,txtage.text,strgender,txtEmail.text,txtPhone.text,txtAddress.text,txtComments.text];
                NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referal];
                [requested sendRequest2:post withUrl:strurl];
            }
        }
        else
        {
            
            NSString *string = txtEmail.text;
            string = [string stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
            
            txtEmail.text=string;
            
            NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
            NSString *post = [NSString stringWithFormat:@"login_id=%@&doctor_id=%@&hospital_id=%@&patient_name=%@&age=%@&gender=%@&email=%@&contact=%@&address=%@&comments=%@",strLoginid,strDoctorsId,strHospitalId,txtName.text,txtage.text,strgender,txtEmail.text,txtPhone.text,txtAddress.text,txtComments.text];
            NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referal];
            [requested sendRequest2:post withUrl:strurl];
            
        }
    }
}


-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        //[self.navigationController popViewControllerAnimated:YES];

        txtName.text=@"";
        txtage.text=@"";
        txtEmail.text=@"";
        txtPhone.text=@"";
        txtAddress.text=@"";
        txtComments.text=@"";
        
        FilterReferPatientViewController *filter=[self.storyboard instantiateViewControllerWithIdentifier:@"FilterReferPatientViewController"];
        [self.navigationController pushViewController:filter animated:YES];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}



#pragma mark - Validation

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString *trimmedString = [checkString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return [emailTest evaluateWithObject:trimmedString];
}

- (BOOL)myMobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}


#pragma mark - MaleButton Clicked

-(IBAction)MaleButtonClicked:(id)sender
{
    maleb.image=[UIImage imageNamed:@"selected-radio.png"];
    femaleb.image=[UIImage imageNamed:@"unselected-radio.png"];
    strgender=@"male";
}


#pragma mark - FemaleButton Clicked

-(IBAction)FemaleButtonClicked:(id)sender
{
    maleb.image=[UIImage imageNamed:@"unselected-radio.png"];
    femaleb.image=[UIImage imageNamed:@"selected-radio.png"];
    strgender=@"female";
}



#pragma mark - HospitalButton Clicked

-(IBAction)HospitalButtonClicked:(id)sender
{
    
    strDoctorsId=@"";
    txtDoctors.text=@"";
    [txtDoctors resignFirstResponder];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    
    StrId=@"1";
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,allHospital];
    [requested SubCategoryRequest:nil withUrl:strurl];
}


-(void)responseSubCategory:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrHospital=[responseToken valueForKey:@"data"];
        
        [self showPopUpWithTitle:@"Select Hospital" withOption:arrHospital xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}





#pragma mark - DoctorsButton Clicked

-(IBAction)DoctorsButtonClicked:(id)sender
{
    if (strHospitalId == (id)[NSNull null] || strHospitalId.length == 0 )
    {
        [requested showMessage:@"Please Select the Hospital First" withTitle:@""];
        
    }
    else
    {
     StrId=@"2";
    
     [self showPopUpWithTitle:@"Select Doctor" withOption:arrDoctors xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
}







#pragma mark - TextField Delegates

- (void)setupOutlets1
{
    txtName.delegate=self;
    txtName.tag=1;
    
    txtage.delegate=self;
    txtage.tag=2;
    
    txtEmail.delegate=self;
    txtEmail.tag=3;
    
    txtPhone.delegate=self;
    txtPhone.tag=4;
    
    txtAddress.delegate=self;
    txtAddress.tag=5;
    
    txtComments.delegate=self;
    txtComments.tag=6;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtDoctors)
    {
        
    }
    else if (textField == txtHospital)
    {
    
    }
    else if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Refer Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtage)
    {
        if ([txtage.text isEqual:@""])
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Age *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtage.attributedPlaceholder = str2;
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str3;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
             txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str4;
             txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
             txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtAddress)
    {
        if ([txtAddress.text isEqual:@""])
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str7= [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtAddress.attributedPlaceholder = str7;
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtComments)
    {
        if ([txtComments.text isEqual:@""])
        {
            linelabel9.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str8= [[NSAttributedString alloc] initWithString:@"Additional Comments" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtComments.attributedPlaceholder = str8;
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];

        }
        else
        {
            linelabel9.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else
    {
        [(ACFloatingTextField *)textField textFieldDidBeginEditing];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtDoctors)
    {
        
    }
    else if (textField == txtHospital)
    {
        
    }
    else if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Refer Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtage)
    {
        if ([txtage.text isEqual:@""])
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Age *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtage.attributedPlaceholder = str2;
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str3;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str4;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtAddress)
    {
        if ([txtAddress.text isEqual:@""])
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str7= [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtAddress.attributedPlaceholder = str7;
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtComments)
    {
        if ([txtComments.text isEqual:@""])
        {
            linelabel9.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str8= [[NSAttributedString alloc] initWithString:@"Additional Comments" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtComments.attributedPlaceholder = str8;
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            
        }
        else
        {
            linelabel9.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else
    {
          [(ACFloatingTextField *)textField textFieldDidEndEditing];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    [self jumpToNextTextField:textField withTag:nextTag];
    return NO;
}

- (void)jumpToNextTextField:(UITextField *)textField withTag:(NSInteger)tag
{
    UIResponder *nextResponder = [self.view viewWithTag:tag];
    
    if ([nextResponder isKindOfClass:[UITextField class]])
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
}






#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
       // [requested sendRequest5:post withUrl:strurl];
        
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
                    [self responsewithToken5:responseJSON];
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


-(void)responsewithToken5:(NSMutableDictionary *)responseToken
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
       // NotificationButton.userInteractionEnabled=NO;
      //  [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
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
        [requested sendRequest3:post withUrl:strurl];
    }
    else
    {
        [requested showMessage:@"Please Login to check the Notification" withTitle:@"Indus"];
    }
}

-(void)responsewithToken3:(NSMutableDictionary *)responseToken
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

#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
        txtHospital.text=[[arrHospital valueForKey:@"name"]objectAtIndex:anIndex];
        strHospitalId=[[arrHospital valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
    
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *post = [NSString stringWithFormat:@"hospital_id=%@",strHospitalId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,allDoctor];
        [requested sendRequest:post withUrl:strurl];
        
    }
    else if([StrId isEqualToString:@"2"])
    {
        txtDoctors.text=[[arrDoctors valueForKey:@"name"]objectAtIndex:anIndex];
        strDoctorsId=[[arrDoctors valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
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
    }
}

-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrDoctors=[responseToken valueForKey:@"data"];
        
       
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}

#pragma mark - Warnings

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
