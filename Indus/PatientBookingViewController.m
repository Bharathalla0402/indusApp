//
//  PatientBookingViewController.m
//  Indus
//
//  Created by think360 on 21/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "PatientBookingViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DejalActivityView.h"
#import "UIImageView+WebCache.h"
#import "CallenderView.h"
#import "UIFloatLabelTextField.h"
#import "BookingConfirmViewController.h"
#import "NotificationViewController.h"


@interface PatientBookingViewController ()<ApiRequestdelegate,UITextFieldDelegate,CKCalendarDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    UIFloatLabelTextField *txtDate,*txtage,*txtEmail,*txtPhone,*txtAddress,*txtComments;
    NSString *strgender;
    UIImageView *maleb,*femaleb;
    
    UIFloatLabelTextField *txtName;
    
    UIView *popView,*footerview,*popView2,*footerview2;
    
    UIImageView *imageSlot1,*imageSlot2,*imageSlot3,*imageSlot4,*imageSlot5,*imageSlot6;
    
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5,*linelabel6,*linelabel7,*linelabel8;
    NSString *strSlot,*strTimeSlot;
    int a;
}
@property(nonatomic, weak) CallenderView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@end

@implementation PatientBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];


    strSlot=@"10 - 11";
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;

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
    titlelab.text=@"Patient Form";
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
   // NotificationButton.userInteractionEnabled=NO;
    [topView addSubview:NotificationButton];
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    [self.view addSubview:categoryScrollView];
    
    
    UIView *DoctorDetailView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    DoctorDetailView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:DoctorDetailView];
    
    UIImageView *toimage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    NSString *imageName=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"pic"]];
    [toimage sd_setImageWithURL:[NSURL URLWithString:imageName]
               placeholderImage:[UIImage imageNamed:@"intro_logo.png"]];
    toimage.layer.cornerRadius = toimage.frame.size.height /2;
    toimage.layer.masksToBounds = YES;
    toimage.contentMode = UIViewContentModeScaleAspectFill;
    [DoctorDetailView addSubview:toimage];
    
    UILabel *Namelabel=[[UILabel alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+11, 8, DoctorDetailView.frame.size.width-110, 37)];
    Namelabel.text=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"name"]];
    Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:13.0];
    Namelabel.numberOfLines=2;
    Namelabel.textAlignment=NSTextAlignmentLeft;
    Namelabel.textColor=[UIColor whiteColor];
    [DoctorDetailView addSubview:Namelabel];
    
    UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+5, Namelabel.frame.size.height+Namelabel.frame.origin.y+10, 20, 20)];
    locationimage.image=[UIImage imageNamed:@"placeholder-2.png"];
    locationimage.contentMode = UIViewContentModeScaleAspectFit;
    [DoctorDetailView addSubview:locationimage];
    
    UILabel *locationlabel=[[UILabel alloc] initWithFrame:CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5, Namelabel.frame.size.height+Namelabel.frame.origin.y+2, DoctorDetailView.frame.size.width-135, 36)];
    locationlabel.text=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"hospital"]];
    locationlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];;
    locationlabel.numberOfLines=2;
    locationlabel.textAlignment=NSTextAlignmentLeft;
    locationlabel.textColor=[UIColor whiteColor];
    [DoctorDetailView addSubview:locationlabel];
    
    
    txtDate=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, DoctorDetailView.frame.size.height+DoctorDetailView.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtDate.placeholder=@"Appointment Date";
    NSAttributedString *str6= [[NSAttributedString alloc] initWithString:@"Appointment Date" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDate.attributedPlaceholder = str6;
    txtDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDate.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtDate.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtDate.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtDate.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtDate.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDate.text=_strSelectedDate;
    txtDate.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDate.backgroundColor=[UIColor clearColor];
    txtDate.delegate=self;
   // txtDate.userInteractionEnabled = NO;
    txtDate.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtDate];
    
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDate.frame.size.height+txtDate.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    UIImageView *dateimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, DoctorDetailView.frame.size.height+DoctorDetailView.frame.origin.y+33, 25, 25)];
    dateimage.image=[UIImage imageNamed:@"calender.png"];
    dateimage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:dateimage];
    
    UIButton *txtDateButt=[[UIButton alloc]initWithFrame:CGRectMake(15, DoctorDetailView.frame.size.height+DoctorDetailView.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtDateButt.backgroundColor=[UIColor clearColor];
    [txtDateButt addTarget:self action:@selector(txtDateButtClicked:) forControlEvents:UIControlEventTouchUpInside];
    txtDateButt.backgroundColor=[UIColor clearColor];
   // txtDateButt.userInteractionEnabled = NO;
    [categoryScrollView addSubview:txtDateButt];
    
    
    UILabel *chooseSlotlabel=[[UILabel alloc] initWithFrame:CGRectMake(15, txtDate.frame.size.height+txtDate.frame.origin.y+20, DoctorDetailView.frame.size.width-135, 20)];
    chooseSlotlabel.text=@"Choose Slot";
    chooseSlotlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    chooseSlotlabel.numberOfLines=2;
    chooseSlotlabel.textAlignment=NSTextAlignmentLeft;
    chooseSlotlabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:chooseSlotlabel];
    
    
    
    NSString *strmorning=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"mrning_time"]];
    
    if (strmorning == (id)[NSNull null] || strmorning.length == 0 )
    {
        imageSlot1=[[UIImageView alloc]initWithFrame:CGRectMake(15, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 30, 30)];
        imageSlot1.image=[UIImage imageNamed:@"selected-radio.png"];
        imageSlot1.contentMode = UIViewContentModeScaleAspectFit;
        [categoryScrollView addSubview:imageSlot1];
        
        
        UILabel *MorningSlotlabel=[[UILabel alloc] initWithFrame:CGRectMake(50, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 100, 30)];
        MorningSlotlabel.text=@"Evening";
        strTimeSlot=@"Evening";
        MorningSlotlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
        MorningSlotlabel.numberOfLines=2;
        MorningSlotlabel.textAlignment=NSTextAlignmentLeft;
        MorningSlotlabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        [categoryScrollView addSubview:MorningSlotlabel];
        
        
        UILabel *slot1lab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 150, 30)];
        slot1lab.text=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"evening_time"]];
        strSlot=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"evening_time"]];
        slot1lab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        slot1lab.font=[UIFont systemFontOfSize:15];
        slot1lab.textAlignment=NSTextAlignmentRight;
        [categoryScrollView addSubview:slot1lab];
        
        UIButton *imag1butt=[[UIButton alloc] initWithFrame:CGRectMake(15, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, categoryScrollView.frame.size.width-30, 30)];
        [imag1butt addTarget:self action:@selector(Imag2ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        imag1butt.backgroundColor=[UIColor clearColor];
        [categoryScrollView addSubview:imag1butt];
        
        a=65;

    }
    else
    {
        imageSlot1=[[UIImageView alloc]initWithFrame:CGRectMake(15, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 30, 30)];
        imageSlot1.image=[UIImage imageNamed:@"selected-radio.png"];
        imageSlot1.contentMode = UIViewContentModeScaleAspectFit;
        [categoryScrollView addSubview:imageSlot1];
        
        
        UILabel *MorningSlotlabel=[[UILabel alloc] initWithFrame:CGRectMake(50, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 100, 30)];
        MorningSlotlabel.text=@"Morning";
        strTimeSlot=@"Morning";
        MorningSlotlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
        MorningSlotlabel.numberOfLines=2;
        MorningSlotlabel.textAlignment=NSTextAlignmentLeft;
        MorningSlotlabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        [categoryScrollView addSubview:MorningSlotlabel];
        
        
        UILabel *slot1lab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, 150, 30)];
        slot1lab.text=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"mrning_time"]];
        strSlot=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"mrning_time"]];
        slot1lab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        slot1lab.font=[UIFont systemFontOfSize:15];
        slot1lab.textAlignment=NSTextAlignmentRight;
        [categoryScrollView addSubview:slot1lab];
        
        UIButton *imag1butt=[[UIButton alloc] initWithFrame:CGRectMake(15, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+15, categoryScrollView.frame.size.width-30, 30)];
        [imag1butt addTarget:self action:@selector(Imag1ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        imag1butt.backgroundColor=[UIColor clearColor];
        [categoryScrollView addSubview:imag1butt];
        
        a=65;
        
         NSString *streve=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"evening_time"]];
        
        if (streve == (id)[NSNull null] || streve.length == 0 )
        {
            
        }
        else
        {
            
            imageSlot2=[[UIImageView alloc]initWithFrame:CGRectMake(15, imageSlot1.frame.size.height+imageSlot1.frame.origin.y+10, 30, 30)];
            imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
            imageSlot2.contentMode = UIViewContentModeScaleAspectFit;
            [categoryScrollView addSubview:imageSlot2];
            
            
            UILabel *EveningSlotlabel=[[UILabel alloc] initWithFrame:CGRectMake(50, imageSlot1.frame.size.height+imageSlot1.frame.origin.y+10, 100, 30)];
            EveningSlotlabel.text=@"Evening";
            EveningSlotlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
            EveningSlotlabel.numberOfLines=2;
            EveningSlotlabel.textAlignment=NSTextAlignmentLeft;
            EveningSlotlabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            [categoryScrollView addSubview:EveningSlotlabel];
            
            
            UILabel *slot2lab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-160, imageSlot1.frame.size.height+imageSlot1.frame.origin.y+10, 150, 30)];
            slot2lab.text=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"evening_time"]];
            slot2lab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            slot2lab.font=[UIFont systemFontOfSize:15];
            slot2lab.textAlignment=NSTextAlignmentRight;
            [categoryScrollView addSubview:slot2lab];
            
            UIButton *imag2butt=[[UIButton alloc] initWithFrame:CGRectMake(15, imageSlot1.frame.size.height+imageSlot1.frame.origin.y+10, categoryScrollView.frame.size.width-30, 30)];
            [imag2butt addTarget:self action:@selector(Imag2ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            imag2butt.backgroundColor=[UIColor clearColor];
            [categoryScrollView addSubview:imag2butt];
            
            a=105;
        }

    }

    
    
    
    
    
    
    
    
    
    txtName=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, chooseSlotlabel.frame.size.height+chooseSlotlabel.frame.origin.y+a, self.view.frame.size.width-30, 50)];
    txtName.placeholder=@"Patient Name *";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtName.attributedPlaceholder = str1;
    txtName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
//    txtName.placeHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.selectedPlaceHolderTextColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.btmLineColor = [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
//    txtName.btmLineSelectionColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtName.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtName.backgroundColor=[UIColor clearColor];
    txtName.delegate=self;
    txtName.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtName];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtName.frame.size.height+txtName.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    
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
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtage.frame.size.height+txtage.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    
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
    
    linelabel5=[[UILabel alloc]initWithFrame:CGRectMake(15, txtEmail.frame.size.height+txtEmail.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel5];

    
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
    
    
    linelabel6=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel6];
    
    
    
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
    
    
    linelabel7=[[UILabel alloc]initWithFrame:CGRectMake(15, txtAddress.frame.size.height+txtAddress.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel7];
    
    
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
    
    linelabel8=[[UILabel alloc]initWithFrame:CGRectMake(15, txtComments.frame.size.height+txtComments.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel8];
    
    
    
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
    
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 795+a);
}


-(void)doneWithNumberPad
{
    [txtage resignFirstResponder];
    [txtPhone resignFirstResponder];
}



#pragma mark - Submit Button Clicked

-(IBAction)SubmitButtonClicked:(id)sender
{
    if (txtName.text.length==0)
    {
        [requested showMessage:@"Please Enter Patient Name" withTitle:@""];
    }
    else if (txtage.text.length==0)
    {
         [requested showMessage:@"Please Enter Age" withTitle:@""];
    }
    else if (txtage.text.length>=4)
    {
        [requested showMessage:@"Please Enter Proper Age" withTitle:@""];
    }
    else if (strgender.length==0)
    {
        [requested showMessage:@"Please Select Gender" withTitle:@""];
    }
    else if (txtPhone.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Mobile Number" withTitle:@"Warning"];
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
                
                // NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
                
                NSString *strHospid=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"hospital_id"]];
                NSString *strDoctid=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"id"]];
                [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
                NSString *post = [NSString stringWithFormat:@"doctor_id=%@&hospital_id=%@&appointment_date=%@&choose_slot=%@&patient_name=%@&age=%@&gender=%@&email=%@&contact=%@&address=%@&comments=%@&Time_slot=%@",strDoctid,strHospid,_strSelectedDate,strSlot,txtName.text,txtage.text,strgender,txtEmail.text,txtPhone.text,txtAddress.text,txtComments.text,strTimeSlot];
                NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,PatientDetail];
                [requested sendRequest2:post withUrl:strurl];

            }
        }
        else
        {
            NSString *string = txtEmail.text;
            string = [string stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
            
            txtEmail.text=string;
            
            // NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
            
            NSString *strHospid=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"hospital_id"]];
            NSString *strDoctid=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"id"]];
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
            NSString *post = [NSString stringWithFormat:@"doctor_id=%@&hospital_id=%@&appointment_date=%@&choose_slot=%@&patient_name=%@&age=%@&gender=%@&email=%@&contact=%@&address=%@&comments=%@&Time_slot=%@",strDoctid,strHospid,_strSelectedDate,strSlot,txtName.text,txtage.text,strgender,txtEmail.text,txtPhone.text,txtAddress.text,txtComments.text,strTimeSlot];
            NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,PatientDetail];
            [requested sendRequest2:post withUrl:strurl];

        }
    }
}



-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        txtName.text=@"";
        txtage.text=@"";
        txtEmail.text=@"";
        txtPhone.text=@"";
        txtAddress.text=@"";
        txtComments.text=@"";
        
        BookingConfirmViewController *confirm=[self.storyboard instantiateViewControllerWithIdentifier:@"BookingConfirmViewController"];
        confirm.strId=[[responseToken valueForKey:@"data"] valueForKey:@"id"];
        confirm.strName=txtName.text;
        confirm.strEmailId=txtEmail.text;
        confirm.strPhone=txtPhone.text;
        [self.navigationController pushViewController:confirm animated:YES];
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



#pragma mark - Morning/Evening Slots Clicked

-(IBAction)Imag1ButtonClicked:(id)sender
{
    strSlot=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"mrning_time"]];
    imageSlot1.image=[UIImage imageNamed:@"selected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
    strTimeSlot=@"Morning";
   
}

-(IBAction)Imag2ButtonClicked:(id)sender
{
    strSlot=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"evening_time"]];
    imageSlot1.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"selected-radio.png"];
    strTimeSlot=@"Evening";
}

-(IBAction)Imag3ButtonClicked:(id)sender
{
    strSlot=@"12 - 01";
    imageSlot1.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot3.image=[UIImage imageNamed:@"selected-radio.png"];
    imageSlot4.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot5.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot6.image=[UIImage imageNamed:@"unselected-radio.png"];
}

-(IBAction)Imag4ButtonClicked:(id)sender
{
    strSlot=@"02 - 03";
    imageSlot1.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot3.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot4.image=[UIImage imageNamed:@"selected-radio.png"];
    imageSlot5.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot6.image=[UIImage imageNamed:@"unselected-radio.png"];
}

-(IBAction)Imag5ButtonClicked:(id)sender
{
    strSlot=@"03 - 04";
    imageSlot1.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot3.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot4.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot5.image=[UIImage imageNamed:@"selected-radio.png"];
    imageSlot6.image=[UIImage imageNamed:@"unselected-radio.png"];
}

-(IBAction)Imag6ButtonClicked:(id)sender
{
    strSlot=@"04 - 05";
    imageSlot1.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot2.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot3.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot4.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot5.image=[UIImage imageNamed:@"unselected-radio.png"];
    imageSlot6.image=[UIImage imageNamed:@"selected-radio.png"];
}


#pragma mark - Appointment Date Clicked

-(IBAction)txtDateButtClicked:(id)sender
{
    [self.view endEditing:YES];
    popView = [[ UIView alloc]init];
    popView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popView];
    
    footerview=[[UIView alloc] initWithFrame:CGRectMake(popView.frame.size.width/2-150, popView.frame.size.height/2-195, 300, 380)];
    footerview.backgroundColor = [UIColor whiteColor];
    [popView addSubview:footerview];
    
    UIView *topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, footerview.frame.size.width, 40)];
    topView.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [footerview addSubview:topView];
    

    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, footerview.frame.size.width-40, 20)];
    label.text=@"Choose Appointment Date";
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont boldSystemFontOfSize:15];
    label.textColor=[UIColor whiteColor];
    [topView addSubview:label];
    
    UIImageView *topimage=[[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width-40, topView.frame.size.height/2-15, 30, 30)];
    topimage.image=[UIImage imageNamed:@"error.png"];
    topimage.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:topimage];
    
    UIButton *backButton=[[UIButton alloc] initWithFrame:CGRectMake(topView.frame.size.width-50, 0, 50, 40)];
    [backButton addTarget:self action:@selector(DateBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.backgroundColor=[UIColor clearColor];
    [topView addSubview:backButton];
    
    
    
    CallenderView *calendar = [[CallenderView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    if (month==1)
    {
        NSString *str=[NSString stringWithFormat:@"%ld/%d/%ld",(long)day,12,(long)year];
        self.minimumDate = [self.dateFormatter dateFromString:str];
    }
    else
    {
        NSString *str=[NSString stringWithFormat:@"%ld/%d/%ld",(long)day,month-1,(long)year];
        self.minimumDate = [self.dateFormatter dateFromString:str];
    }
    
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (int i=1; i<day; i++)
    {
        NSString *stingdate=[NSString stringWithFormat:@"%d/%ld/%ld",i,(long)month,(long)year];
        NSDate *date= [self.dateFormatter dateFromString:stingdate];
        NSArray *ar=[[NSArray alloc] initWithObjects:date, nil];
        arr=[[arr arrayByAddingObjectsFromArray:ar] mutableCopy];
        
        self.disabledDates = arr;
    }
    
    
    calendar.onlyShowCurrentMonth = YES;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(15, 60, 270, 270);
    calendar.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [footerview addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}




#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CallenderView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor darkGrayColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CallenderView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CallenderView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    self.dateLabel.text = [self.dateLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    txtDate.text=[self.dateFormatter stringFromDate:date];
    linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    
    NSString *strdate2= [self.dateFormatter stringFromDate:date];
    NSArray *arrdate=[strdate2 componentsSeparatedByString:@"/"];
    _strSelectedDate=[NSString stringWithFormat:@"%@-%@-%@",arrdate[0],arrdate[1],arrdate[2]];
    txtDate.text=_strSelectedDate;
    
    [footerview removeFromSuperview];
    popView.hidden = YES;
}

- (BOOL)calendar:(CallenderView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        return NO;
    }
}

- (void)calendar:(CallenderView *)calendar didLayoutInRect:(CGRect)frame
{
    //NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


-(IBAction)DateBackButtonClicked:(id)sender
{
    [footerview removeFromSuperview];
    popView.hidden = YES;
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
       // NotificationButton.userInteractionEnabled=NO;
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
      //  NotificationButton.userInteractionEnabled=NO;
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
   
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
             linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtDate)
    {
        if ([txtDate.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str6= [[NSAttributedString alloc] initWithString:@"Appointment Date" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtDate.attributedPlaceholder = str6;
            txtDate.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtDate.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtage)
    {
        if ([txtage.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Age *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtage.attributedPlaceholder = str2;
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str3;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str4;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtAddress)
    {
        if ([txtAddress.text isEqual:@""])
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str7= [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtAddress.attributedPlaceholder = str7;
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtComments)
    {
        if ([txtComments.text isEqual:@""])
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str8= [[NSAttributedString alloc] initWithString:@"Additional Comments" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtComments.attributedPlaceholder = str8;
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
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
   
    // [self animateTextField:textField up:NO];
    
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Patient Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtDate)
    {
        if ([txtDate.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str6= [[NSAttributedString alloc] initWithString:@"Appointment Date" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtDate.attributedPlaceholder = str6;
            txtDate.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtDate.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtage)
    {
        if ([txtage.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Age *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtage.attributedPlaceholder = str2;
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtage.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str3;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str4;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel6.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtAddress)
    {
        if ([txtAddress.text isEqual:@""])
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str7= [[NSAttributedString alloc] initWithString:@"Address" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtAddress.attributedPlaceholder = str7;
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel7.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtAddress.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtComments)
    {
        if ([txtComments.text isEqual:@""])
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str8= [[NSAttributedString alloc] initWithString:@"Additional Comments" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtComments.attributedPlaceholder = str8;
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel8.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtComments.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else
    {
        [(ACFloatingTextField *)textField textFieldDidBeginEditing];
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
