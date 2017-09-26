//
//  BookingResultsViewController.m
//  Indus
//
//  Created by think360 on 17/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "BookingResultsViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ResultsCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DejalActivityView.h"
#import "PatientBookingViewController.h"
#import "UIFloatLabelTextField.h"
#import "DropDownListView.h"
#import "NotificationViewController.h"


@interface BookingResultsViewController ()<ApiRequestdelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,kDropDownListViewDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab,*Datelabel,*ResultsLabel;
    UIButton *NotificationButton;
    
    UIView *weekViewSelectionView;
    
    UICollectionView *_collectionView;
    ResultsCollectionViewCell *listViewCell;
    ResultsCollectionViewCell *listViewCell2;
    
    NSString *strdayid,*str2moroid;
    NSIndexPath *index;
    
    int set;
    NSIndexPath *index2;
    
    NSMutableArray *testarrDates,*testarrMonths,*testarrWeeks,*testarrMonthsName;
    
    NSMutableArray *arrDates,*arrMonths,*arrWeeks,*arrMonthsName;
    
    IBOutlet UITableView *tablDta;
    UITableViewCell *cell;
    
    UIView *footerview2;
    UILabel *loadLbl,*locationNamelabel,*NodataLab;
    UIActivityIndicatorView * actInd;
    int scrool;
    int count,lastCount;
    
    NSMutableArray *arrlist;
    UIView *footerview,*popview,*popview2;
    
    NSString *StrId,*strSelectedDate;
    DropDownListView * Dropobj;
    
    
    UIFloatLabelTextField *txtCity,*txtSpeciality,*txtHospital,*txtDoctors;
    NSMutableArray *arrCitys,*arrSpeciality,*arrHospital,*arrDoctors;
   
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5;
    
    NSString *strAppointmentDate,*strarrMonthDate,*strCurrentYear;
    
    NSString *strWeekDaySlot;
    
   
}
@end

@implementation BookingResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    
    NSInteger weekday = [[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                       fromDate:[NSDate date]];
    
    NSLog(@"%ld",(long)weekday);
    
    if(weekday == 1)
    {
        strWeekDaySlot = @"6";
    }
    else if (weekday == 2)
    {
        strWeekDaySlot = @"0";
    }
    else if (weekday == 3)
    {
        strWeekDaySlot = @"1";
    }
    else if (weekday == 4)
    {
        strWeekDaySlot = @"2";
    }
    else if (weekday == 5)
    {
        strWeekDaySlot = @"3";
    }
    else if (weekday == 6)
    {
        strWeekDaySlot = @"4";
    }
    else if (weekday == 7)
    {
        strWeekDaySlot = @"5";
    }

     NSLog(@"%@",strWeekDaySlot);
    
    
    
    NSDate *today = [NSDate dateWithTimeInterval:(24*0*0) sinceDate:[NSDate date]];
    NSString *dateSt = [NSString stringWithFormat:@"%@",today];
    NSArray *components = [dateSt componentsSeparatedByString:@" "];
    NSString *dat = components[0];
    NSArray *todate=[dat componentsSeparatedByString:@"-"];
    strCurrentYear = [NSString stringWithFormat:@"%@", todate[0]];

    
    arrCitys=[[NSMutableArray alloc]init];
    arrSpeciality=[[NSMutableArray alloc]init];
    arrHospital=[[NSMutableArray alloc]init];
    arrDoctors=[[NSMutableArray alloc]init];
    
    scrool=1;
    count=1;
    lastCount=1;
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    set=1;
    
    arrlist=[[NSMutableArray alloc]init];
    arrlist=_arrChildCategory;
    
    self.arryData=[[NSMutableArray alloc]init];
    self.arryData2=[[NSMutableArray alloc]init];
    
    
    testarrDates=[[NSMutableArray alloc]init];
    testarrMonths=[[NSMutableArray alloc]init];
    testarrMonthsName=[[NSMutableArray alloc]init];
    arrWeeks=[[NSMutableArray alloc]init];
    
    arrDates=[[NSMutableArray alloc]init];
    arrMonths=[[NSMutableArray alloc]init];
    arrMonthsName=[[NSMutableArray alloc]init];
    testarrWeeks=[[NSMutableArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    
    [self CalenderView];
    
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
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-15, topView.frame.size.width-120, 25)];
    titlelab.text=@"Search Results";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    [topView addSubview:titlelab];
    
    Datelabel=[[UILabel alloc] initWithFrame:CGRectMake(60, titlelab.frame.size.height+titlelab.frame.origin.y, topView.frame.size.width-120, 15)];
    Datelabel.text=@"Today";
    Datelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    Datelabel.textAlignment=NSTextAlignmentCenter;
    Datelabel.textColor=[UIColor blackColor];
    [topView addSubview:Datelabel];
    
    
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
    
    
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y, self.view.frame.size.width, 65) collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView registerClass:[ResultsCollectionViewCell class] forCellWithReuseIdentifier:@"ResultsCollectionViewCell"];
    [_collectionView setBackgroundColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0]];
    [_collectionView setCollectionViewLayout:layout];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    layout.minimumLineSpacing=0.0;
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [self.view addSubview:_collectionView];
    
   
    UIView *filterView=[[UIView alloc] initWithFrame:CGRectMake(0, _collectionView.frame.size.height+_collectionView.frame.origin.y, self.view.frame.size.width, 50)];
    filterView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:filterView];
    
    ResultsLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, filterView.frame.size.width-150, 40)];
    ResultsLabel.text=[NSString stringWithFormat:@"%lu result(s) found",(unsigned long)_arrChildCategory.count];
    ResultsLabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    ResultsLabel.textAlignment=NSTextAlignmentLeft;
    ResultsLabel.textColor=[UIColor blackColor];
    [filterView addSubview:ResultsLabel];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(filterView.frame.size.width-95, 10, 80, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Filter" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16.0]];
    UIImage *image1= [UIImage imageNamed:@"filter.png"];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [button setImage:[self imageWithImage:image1 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    button.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [button setImageEdgeInsets:UIEdgeInsetsMake(2, 0.0, 0.0, -button.titleLabel.bounds.size.width+42)];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:button];
    
    
    UILabel *linelab2=[[UILabel alloc]initWithFrame:CGRectMake(0, filterView.frame.size.height+filterView.frame.origin.y+8, self.view.frame.size.width, 2)];
    linelab2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:linelab2];
    
    
    tablDta=[[UITableView alloc] init];
    tablDta.frame = CGRectMake(0,linelab2.frame.size.height+linelab2.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-247);
    tablDta.delegate=self;
    tablDta.dataSource=self;
    tablDta.tag=4;
    tablDta.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tablDta.backgroundColor=[UIColor clearColor];
    [tablDta setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tablDta];
    
    
    NodataLab=[[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-10, self.view.frame.size.width-40, 20)];
    NodataLab.text=@"No Doctor Available";
    NodataLab.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    NodataLab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    NodataLab.textAlignment=NSTextAlignmentCenter;
    NodataLab.hidden=YES;
    [self.view addSubview:NodataLab];
    
//    NSString *StrDay=[NSString stringWithFormat:@"%@",[arrWeeks objectAtIndex:0]];
//    
//    if ([StrDay isEqualToString:@"Sun"])
//    {
//        tablDta.hidden=YES;
//        NodataLab.hidden=NO;
//        ResultsLabel.text=[NSString stringWithFormat:@"0 result(s) found"];
//    }
//    else
//    {
//        tablDta.hidden=NO;
//        NodataLab.hidden=YES;
//        ResultsLabel.text=[NSString stringWithFormat:@"%lu result(s) found",(unsigned long)arrlist.count];
//    }
    
    
    
    
    NSString *strarrmonths=[NSString stringWithFormat:@"%@",[arrMonthsName objectAtIndex:0]];
    if ([strarrmonths isEqualToString:@"Jan"])
    {
        strarrMonthDate=@"01";
    }
    else if ([strarrmonths isEqualToString:@"Feb"])
    {
        strarrMonthDate=@"02";
    }
    else if ([strarrmonths isEqualToString:@"Mar"])
    {
        strarrMonthDate=@"03";
    }
    else if ([strarrmonths isEqualToString:@"Apr"])
    {
        strarrMonthDate=@"04";
    }
    else if ([strarrmonths isEqualToString:@"May"])
    {
        strarrMonthDate=@"05";
    }
    else if ([strarrmonths isEqualToString:@"Jun"])
    {
        strarrMonthDate=@"06";
    }
    else if ([strarrmonths isEqualToString:@"Jul"])
    {
        strarrMonthDate=@"07";
    }
    else if ([strarrmonths isEqualToString:@"Aug"])
    {
        strarrMonthDate=@"08";
    }
    else if ([strarrmonths isEqualToString:@"Sep"])
    {
        strarrMonthDate=@"09";
    }
    else if ([strarrmonths isEqualToString:@"Oct"])
    {
        strarrMonthDate=@"10";
    }
    else if ([strarrmonths isEqualToString:@"Nov"])
    {
        strarrMonthDate=@"11";
    }
    else if ([strarrmonths isEqualToString:@"Dec"])
    {
        strarrMonthDate=@"12";
    }
    
    strAppointmentDate=[NSString stringWithFormat:@"%@-%@-%@",[arrDates objectAtIndex:0],strarrMonthDate,strCurrentYear];
    
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Table View Delegates



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==4)
    {
        return arrlist.count;
    }
    else
    {
        return arrlist.count;
    }
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==4)
    {
        return 315;
    }
    else
    {
        return 55;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==4)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        static NSString *cellIdetifier = @"Cell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *testView=[[UIView alloc] initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-20, 300)];
        testView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        testView.layer.borderWidth = 0.0f;
        testView.layer.cornerRadius = 4.0;
        testView.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0];
        [cell addSubview:testView];
        
        
        UIImageView *toimage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        NSString *imageName=[[arrlist objectAtIndex:indexPath.row]valueForKey:@"pic"];
        //NSString *imageName=@"";
        [toimage sd_setImageWithURL:[NSURL URLWithString:imageName]
                   placeholderImage:[UIImage imageNamed:@"intro_logo.png"]];
        toimage.layer.cornerRadius = toimage.frame.size.height /2;
        toimage.layer.masksToBounds = YES;
        toimage.contentMode = UIViewContentModeScaleAspectFill;
        [testView addSubview:toimage];
        
        
        UILabel *CityNamelabel=[[UILabel alloc] initWithFrame:CGRectMake(testView.frame.size.width-95, 10, 85, 35)];
        CityNamelabel.text=[NSString stringWithFormat:@"City: %@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"city"]];
        CityNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        CityNamelabel.numberOfLines=2;
        CityNamelabel.textAlignment=NSTextAlignmentCenter;
        CityNamelabel.textColor=[UIColor lightGrayColor];
        [testView addSubview:CityNamelabel];
        
        
        UILabel *Namelabel=[[UILabel alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+5, 8, testView.frame.size.width-200, 37)];
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"name"]];
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:13.0];
        Namelabel.numberOfLines=2;
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        [testView addSubview:Namelabel];
        
        
        UIImageView *Specialityimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+5, Namelabel.frame.size.height+Namelabel.frame.origin.y+7, 20, 20)];
        Specialityimage.image=[UIImage imageNamed:@"Orthopedics.png"];
        Specialityimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:Specialityimage];
        
        UILabel *ClinicNamelabel=[[UILabel alloc] initWithFrame:CGRectMake(Specialityimage.frame.size.width+Specialityimage.frame.origin.x+5, Namelabel.frame.size.height+Namelabel.frame.origin.y+2, testView.frame.size.width-135, 30)];
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"specility"]];
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:11.0];
        ClinicNamelabel.numberOfLines=2;
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor darkGrayColor];
        [testView addSubview:ClinicNamelabel];
        
        
        UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+5, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+7, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"location.png"];
        locationimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:locationimage];
        
        UILabel *locationlabel=[[UILabel alloc] initWithFrame:CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+2, testView.frame.size.width-135, 30)];
        locationlabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"hospital"]];
        locationlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:11.0];
        locationlabel.numberOfLines=2;
        locationlabel.textAlignment=NSTextAlignmentLeft;
        locationlabel.textColor=[UIColor darkGrayColor];
        [testView addSubview:locationlabel];
        
        NSArray *arrAvailability=[[arrlist valueForKey:@"available"] objectAtIndex:indexPath.row];
        
        UILabel *Avallabel=[[UILabel alloc] initWithFrame:CGRectMake(10, toimage.frame.size.height+toimage.frame.origin.y+12, 105, 30)];
        Avallabel.text=@"Availability";
        Avallabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14.0];
        Avallabel.numberOfLines=2;
        Avallabel.textAlignment=NSTextAlignmentLeft;
        Avallabel.textColor=[UIColor blackColor];
        [testView addSubview:Avallabel];

        UILabel *weekLab1=[[UILabel alloc] initWithFrame:CGRectMake(10, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab1.text=@"S";
        weekLab1.layer.cornerRadius=15.0;
        weekLab1.layer.borderWidth = 1.0;
        weekLab1.clipsToBounds=YES;
        weekLab1.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab1.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"6"])
        {
            weekLab1.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab1.textColor=[UIColor whiteColor];
            weekLab1.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab1.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab1.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab1.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab1];
        
        UILabel *weekLab2=[[UILabel alloc] initWithFrame:CGRectMake(weekLab1.frame.size.width+weekLab1.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab2.text=@"M";
        weekLab2.layer.cornerRadius=15.0;
        weekLab2.layer.borderWidth = 1.0;
        weekLab2.clipsToBounds=YES;
        weekLab2.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab2.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"0"])
        {
            weekLab2.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab2.textColor=[UIColor whiteColor];
            weekLab2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab2.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab2.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab2.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab2];
        
        UILabel *weekLab3=[[UILabel alloc] initWithFrame:CGRectMake(weekLab2.frame.size.width+weekLab2.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab3.text=@"T";
        weekLab3.layer.cornerRadius=15.0;
        weekLab3.layer.borderWidth = 1.0;
        weekLab3.clipsToBounds=YES;
        weekLab3.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab3.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"1"])
        {
            weekLab3.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab3.textColor=[UIColor whiteColor];
            weekLab3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab3.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab3.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab3.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab3];
        
        UILabel *weekLab4=[[UILabel alloc] initWithFrame:CGRectMake(weekLab3.frame.size.width+weekLab3.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab4.text=@"W";
        weekLab4.layer.cornerRadius=15.0;
        weekLab4.layer.borderWidth = 1.0;
        weekLab4.clipsToBounds=YES;
        weekLab4.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab4.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"2"])
        {
            weekLab4.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab4.textColor=[UIColor whiteColor];
            weekLab4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab4.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab4.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab4.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab4];
        
        UILabel *weekLab5=[[UILabel alloc] initWithFrame:CGRectMake(weekLab4.frame.size.width+weekLab4.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab5.text=@"T";
        weekLab5.layer.cornerRadius=15.0;
        weekLab5.layer.borderWidth = 1.0;
        weekLab5.clipsToBounds=YES;
        weekLab5.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab5.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"3"])
        {
            weekLab5.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab5.textColor=[UIColor whiteColor];
            weekLab5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab5.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab5.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab5.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab5];
        
        UILabel *weekLab6=[[UILabel alloc] initWithFrame:CGRectMake(weekLab5.frame.size.width+weekLab5.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab6.text=@"F";
        weekLab6.layer.cornerRadius=15.0;
        weekLab6.layer.borderWidth = 1.0;
        weekLab6.clipsToBounds=YES;
        weekLab6.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab6.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"4"])
        {
            weekLab6.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab6.textColor=[UIColor whiteColor];
            weekLab6.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab6.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab6.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab6.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab6];
        
        UILabel *weekLab7=[[UILabel alloc] initWithFrame:CGRectMake(weekLab6.frame.size.width+weekLab6.frame.origin.x+7, Avallabel.frame.size.height+Avallabel.frame.origin.y+2, 30, 30)];
        weekLab7.text=@"S";
        weekLab7.layer.cornerRadius=15.0;
        weekLab7.layer.borderWidth = 1.0;
        weekLab7.clipsToBounds=YES;
        weekLab7.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        weekLab7.textAlignment=NSTextAlignmentCenter;
        if ([arrAvailability containsObject:@"5"])
        {
            weekLab7.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
            weekLab7.textColor=[UIColor whiteColor];
            weekLab7.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            weekLab7.layer.borderColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0].CGColor;
            weekLab7.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            weekLab7.backgroundColor=[UIColor clearColor];
        }
        [testView addSubview:weekLab7];
        
        
        
        UIImageView *TimeImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, weekLab1.frame.size.height+weekLab1.frame.origin.y+10, 20, 20)];
        TimeImage.image=[UIImage imageNamed:@"clock.png"];
        TimeImage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:TimeImage];
        
        UILabel *timelabel=[[UILabel alloc] initWithFrame:CGRectMake(35, weekLab1.frame.size.height+weekLab1.frame.origin.y+10, 90, 20)];
        timelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"degree"]];
        timelabel.text=@"Morning";
        timelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        timelabel.textAlignment=NSTextAlignmentLeft;
        timelabel.textColor=[UIColor darkGrayColor];
        [testView addSubview:timelabel];
        
        UILabel *timelabel2=[[UILabel alloc] initWithFrame:CGRectMake(testView.frame.size.width-150, weekLab1.frame.size.height+weekLab1.frame.origin.y+10, 140, 20)];
        NSString *strMor=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"mrning_time"]];
        if (strMor == (id)[NSNull null] || strMor.length == 0 )
        {
            timelabel2.text=@"NA";
        }
        else
        {
            timelabel2.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"mrning_time"]];
        }
        timelabel2.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        timelabel2.textAlignment=NSTextAlignmentRight;
        timelabel2.textColor=[UIColor darkGrayColor];
        [testView addSubview:timelabel2];
        
        
        
        UIImageView *TimeImage2=[[UIImageView alloc] initWithFrame:CGRectMake(10, TimeImage.frame.size.height+TimeImage.frame.origin.y+10, 20, 20)];
        TimeImage2.image=[UIImage imageNamed:@"clock.png"];
        TimeImage2.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:TimeImage2];
        
        UILabel *timelabel3=[[UILabel alloc] initWithFrame:CGRectMake(35, TimeImage.frame.size.height+TimeImage.frame.origin.y+10, 90, 20)];
        timelabel3.text=@"Evening";
        timelabel3.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        timelabel3.textAlignment=NSTextAlignmentLeft;
        timelabel3.textColor=[UIColor darkGrayColor];
        [testView addSubview:timelabel3];
        
        UILabel *timelabel4=[[UILabel alloc] initWithFrame:CGRectMake(testView.frame.size.width-150, TimeImage.frame.size.height+TimeImage.frame.origin.y+10, 140, 20)];
        NSString *strEve=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"evening_time"]];
        if (strEve == (id)[NSNull null] || strEve.length == 0 )
        {
           timelabel4.text=@"NA";
        }
        else
        {
         timelabel4.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"evening_time"]];
        }
        timelabel4.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        timelabel4.textAlignment=NSTextAlignmentRight;
        timelabel4.textColor=[UIColor darkGrayColor];
        [testView addSubview:timelabel4];
        
        
        
        UIButton *BookButton=[[UIButton alloc] initWithFrame:CGRectMake(30, TimeImage2.frame.size.height+TimeImage2.frame.origin.y+15, testView.frame.size.width-60, 50)];
        BookButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        [BookButton setTitle:@"Book Appointment" forState:UIControlStateNormal];
        BookButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];;
        BookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [BookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        BookButton.tag=indexPath.row;
        [BookButton addTarget:self action:@selector(BookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [testView addSubview:BookButton];


        
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier1 = @"Cell1";
        UITableViewCell *cell2;
        
        cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell2 == nil)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        
        if (tablDta.tag==3)
        {
          
            
        }
        else
        {
            
        }
        
        return cell2;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==4)
    {
      //  NSString *strid=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
     //   [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
      //  NSString *strurl=[NSString stringWithFormat:@"%@%@?doctor_id=%@",BaseUrl,doctorDetail,strid];
      //  [requested SubCategoryRequest:nil withUrl:strurl];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)responseSubCategory:(NSMutableDictionary *)responseDict
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"status"]];
    
    if ([strstatus isEqualToString:@"1"])
    {
        
    }
    else
    {
        [requested showMessage:[responseDict valueForKey:@"message"] withTitle:@""];
    }
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==4)
    {
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
        {
            
            if ([_strpage isEqualToString:@"0"])
            {
                loadLbl.text=@"No More List";
                [actInd stopAnimating];
            }
            else
            {
                
              //  NSString *strurl=[NSString stringWithFormat:@"%@%@?problem=%@&latitude=%f&longitude=%f&page=%@",BaseUrl,getDoctor,_strDoctId,core_latitude,core_longitude,_strpage];
             //   [requested SubCategoryRequest3:nil withUrl:strurl];
             //   [self initFooterView];
             //   loadLbl.text=@"loading...";
            }
        }
        
    }
    else
    {
        
    }
}

-(void)responseSubCategory3:(NSMutableDictionary *)responseDict
{
    NSMutableDictionary *responseDictionary=[[NSMutableDictionary alloc]init];
    responseDictionary=responseDict;
    
    if (count==1)
    {
        count=2;
        if ([_strpage isEqualToString:@"2"])
        {
            NSArray *arr=[responseDictionary valueForKey:@"data"];
            
            arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [tablDta reloadData];
        }
        else
        {
            
        }
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
    }
    else
    {
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
        
        if ([_strpage isEqualToString:@"0"])
        {
            if (lastCount==1)
            {
                NSArray *arr=[responseDictionary valueForKey:@"data"];
                
                arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
                
                [tablDta reloadData];
                lastCount=2;
            }
        }
        else
        {
            NSArray *arr=[responseDictionary valueForKey:@"data"];
            
            arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [tablDta reloadData];
        }
    }
    
}



-(void)BookButtonClicked:(UIButton *)sender
{
//    CGPoint buttonPosition = [sender convertPoint:CGPointZero
//                                               toView:tablDta];
//    NSIndexPath *tappedIP = [tablDta indexPathForRowAtPoint:buttonPosition];
    
    PatientBookingViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"PatientBookingViewController"];
    book.arrChildCategory=[arrlist objectAtIndex:(long)sender.tag];
    book.strSelectedDate=strAppointmentDate;
    [self.navigationController pushViewController:book animated:YES];
}



#pragma mark  ActivityIndicator At Bottom:

-(void)initFooterView
{
    footerview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 50.0)];
    actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actInd.tag = 10;
    actInd.frame = CGRectMake(self.view.frame.size.width/2-10, 5.0, 20.0, 20.0);
    actInd.hidden=YES;
    [actInd performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:30.0];
    [footerview2 addSubview:actInd];
    loadLbl=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 25, 200, 20)];
    loadLbl.textAlignment=NSTextAlignmentCenter;
    loadLbl.textColor=[UIColor lightGrayColor];
    // [loadLbl setFont:[UIFont fontWithName:@"System" size:2]];
    [loadLbl setFont:[UIFont systemFontOfSize:12]];
    [footerview2 addSubview:loadLbl];
    actInd = nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrool==1)
    {
        BOOL endOfTable = (scrollView.contentOffset.y >= 0);
        if ( endOfTable && !scrollView.dragging && !scrollView.decelerating)
        {
            if ([_strpage isEqualToString:@"0"])
            {
                tablDta.tableFooterView = footerview2;
                [(UIActivityIndicatorView *)[footerview2 viewWithTag:10] stopAnimating];
                loadLbl.text=@"No More List";
                [actInd stopAnimating];
            }
            else
            {
                tablDta.tableFooterView = footerview2;
                [(UIActivityIndicatorView *)[footerview2 viewWithTag:10] startAnimating];
            }
        }
        
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrool==1)
    {
        footerview2.hidden=YES;
        loadLbl.hidden=YES;
    }
}




#pragma mark - Collection View Delegates


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrDates.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ResultsCollectionViewCell";
    
    listViewCell = [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
   
    listViewCell.cellBgrndView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, listViewCell.frame.size.width, 65)];
    if([self.arryData containsObject:indexPath])
    {
        listViewCell.cellBgrndView.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    }
    else
    {
        listViewCell.cellBgrndView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    }
    [listViewCell addSubview:listViewCell.cellBgrndView];
        
        
    listViewCell.Monthlabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 5, listViewCell.cellBgrndView.frame.size.width-4, 15)];
    listViewCell.Monthlabel.text=[arrMonthsName objectAtIndex:indexPath.row];
    listViewCell.Monthlabel.font=[UIFont systemFontOfSize:14];
    listViewCell.Monthlabel.numberOfLines=2;
    listViewCell.Monthlabel.textAlignment=NSTextAlignmentCenter;
    listViewCell.Monthlabel.textColor=[UIColor whiteColor];
    [listViewCell.cellBgrndView addSubview:listViewCell.Monthlabel];
    
    listViewCell.Weeklabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 25, listViewCell.cellBgrndView.frame.size.width-4, 15)];
    listViewCell.Weeklabel.text=[arrWeeks objectAtIndex:indexPath.row];
    listViewCell.Weeklabel.font=[UIFont systemFontOfSize:14];
    listViewCell.Weeklabel.numberOfLines=2;
    listViewCell.Weeklabel.textAlignment=NSTextAlignmentCenter;
    listViewCell.Weeklabel.textColor=[UIColor whiteColor];
    [listViewCell.cellBgrndView addSubview:listViewCell.Weeklabel];
        
    listViewCell.Datelabel=[[UILabel alloc] initWithFrame:CGRectMake(2, 45, listViewCell.cellBgrndView.frame.size.width-4, 15)];
    listViewCell.Datelabel.text=[arrDates objectAtIndex:indexPath.row];
    listViewCell.Datelabel.font=[UIFont systemFontOfSize:14];
    listViewCell.Datelabel.numberOfLines=2;
    listViewCell.Datelabel.textAlignment=NSTextAlignmentCenter;
    listViewCell.Datelabel.textColor=[UIColor whiteColor];
    [listViewCell.cellBgrndView addSubview:listViewCell.Datelabel];
    
    [listViewCell setNeedsDisplay];
    
    return listViewCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showWeekViewSelectionViewTo:collectionView cellAtIndexPath:indexPath];
        
    NSString *strdate=[NSString stringWithFormat:@"%@",[arrDates objectAtIndex:indexPath.row]];
        
    if ([strdate isEqualToString:strdayid])
    {
        Datelabel.text=@"Today";
    }
    else if ([strdate isEqualToString:str2moroid])
    {
        Datelabel.text=@"Tomorrow";
    }
    else
    {
        Datelabel.text=[NSString stringWithFormat:@"%@ | %@ %@",[arrWeeks objectAtIndex:indexPath.row], strdate,[arrMonthsName objectAtIndex:indexPath.row]];
    }
    
//    NSString *StrDay=[NSString stringWithFormat:@"%@",[arrWeeks objectAtIndex:indexPath.row]];
//    
//    if ([StrDay isEqualToString:@"Sun"])
//    {
//        tablDta.hidden=YES;
//        NodataLab.hidden=NO;
//        ResultsLabel.text=[NSString stringWithFormat:@"0 result(s) found"];
//    }
//    else
//    {
//        tablDta.hidden=NO;
//        NodataLab.hidden=YES;
//        ResultsLabel.text=[NSString stringWithFormat:@"%lu result(s) found",(unsigned long)arrlist.count];
//    }
    
    NSString *strarrmonths=[NSString stringWithFormat:@"%@",[arrMonthsName objectAtIndex:indexPath.row]];
    if ([strarrmonths isEqualToString:@"Jan"])
    {
        strarrMonthDate=@"01";
    }
    else if ([strarrmonths isEqualToString:@"Feb"])
    {
        strarrMonthDate=@"02";
    }
    else if ([strarrmonths isEqualToString:@"Mar"])
    {
        strarrMonthDate=@"03";
    }
    else if ([strarrmonths isEqualToString:@"Apr"])
    {
        strarrMonthDate=@"04";
    }
    else if ([strarrmonths isEqualToString:@"May"])
    {
        strarrMonthDate=@"05";
    }
    else if ([strarrmonths isEqualToString:@"Jun"])
    {
        strarrMonthDate=@"06";
    }
    else if ([strarrmonths isEqualToString:@"Jul"])
    {
        strarrMonthDate=@"07";
    }
    else if ([strarrmonths isEqualToString:@"Aug"])
    {
        strarrMonthDate=@"08";
    }
    else if ([strarrmonths isEqualToString:@"Sep"])
    {
        strarrMonthDate=@"09";
    }
    else if ([strarrmonths isEqualToString:@"Oct"])
    {
        strarrMonthDate=@"10";
    }
    else if ([strarrmonths isEqualToString:@"Nov"])
    {
        strarrMonthDate=@"11";
    }
    else if ([strarrmonths isEqualToString:@"Dec"])
    {
        strarrMonthDate=@"12";
    }

    strAppointmentDate=[NSString stringWithFormat:@"%@-%@-%@",[arrDates objectAtIndex:indexPath.row],strarrMonthDate,strCurrentYear];
    

    
    NSString *strWeekDay=[NSString stringWithFormat:@"%@",[arrWeeks objectAtIndex:indexPath.row]];
    
    if ([strWeekDay isEqualToString:@"Sun"])
    {
        strWeekDaySlot =@"6";
    }
    else if ([strWeekDay isEqualToString:@"Mon"])
    {
       strWeekDaySlot =@"0";
    }
    else if ([strWeekDay isEqualToString:@"Tue"])
    {
        strWeekDaySlot =@"1";
    }
    else if ([strWeekDay isEqualToString:@"Wed"])
    {
        strWeekDaySlot =@"2";
    }
    else if ([strWeekDay isEqualToString:@"Thu"])
    {
        strWeekDaySlot =@"3";
    }
    else if ([strWeekDay isEqualToString:@"Fri"])
    {
        strWeekDaySlot =@"4";
    }
    else if ([strWeekDay isEqualToString:@"Sat"])
    {
        strWeekDaySlot =@"5";
    }
    
    NSLog(@"%@",strWeekDaySlot);
    
    NSString *strCityid1=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CityId"]];
    NSString *strSpecialityid1=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"SpecialityId"]];
    NSString *strHospitalid1=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"HospitalId"]];
    NSString *strDoctorid1=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctId"]];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@&hospital_id=%@&doctor_id=%@&week_day=%@",strCityid1,strSpecialityid1,strHospitalid1,strDoctorid1,strWeekDaySlot];
    NSLog(@"%@",post);
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDoctorAll];
    [requested sendRequest7:post withUrl:strurl];
    

}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   [self deselectCollectionView:collectionView cellAtIndexPath:indexPath];
}


-(void)showWeekViewSelectionViewTo:(UICollectionView *)collectionView cellAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsCollectionViewCell *selectedCell = (ResultsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.cellBgrndView.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    
    
    if([self.arryData containsObject:indexPath]){
        
    } else {
        [self.arryData addObject:indexPath];
    }
    
   // NSLog(@"%@",self.arryData);
    
    if (set==1)
    {
        set=2;
        ResultsCollectionViewCell *selectedCell = (ResultsCollectionViewCell *)[collectionView cellForItemAtIndexPath:index2];
        selectedCell.cellBgrndView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        [self.arryData removeObject:index2];
    }
}


-(void)deselectCollectionView:(UICollectionView *)collectionView cellAtIndexPath:(NSIndexPath *)indexPath
{
    ResultsCollectionViewCell *selectedCell = (ResultsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.cellBgrndView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    
    
    if([self.arryData containsObject:indexPath])
    {
        [self.arryData removeObject:indexPath];
    }
    else {
        
    }
    [_collectionView reloadData];
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/7, 65);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}




#pragma mark - FilterButton Clicked

-(IBAction)filterButtonClicked:(id)sender
{
     self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] init];
    footerview.backgroundColor = [UIColor whiteColor];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120)];
    [footerview addSubview:categoryScrollView];
    
    
    UIImageView *CroosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, 5, 30, 30)];
    CroosImageView.image = [UIImage imageNamed:@"cancel.png"];
    CroosImageView.contentMode=UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:CroosImageView];
    
    UIButton *CroosButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-65, 0, 65, 35)];
    [CroosButton addTarget:self action:@selector(CrossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CroosButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:CroosButton];
    
    
    UILabel *textlab=[[UILabel alloc] initWithFrame:CGRectMake(15, 35, self.view.frame.size.width-50, 40)];
    textlab.text=@"Select the fields below to schedule your Doctor Appointment";
    textlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:13.0];
    textlab.textAlignment=NSTextAlignmentCenter;
    textlab.numberOfLines=0;
    textlab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:textlab];
    
    
    txtCity=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, textlab.frame.size.height+textlab.frame.origin.y+20, self.view.frame.size.width-50, 50)];
    txtCity.placeholder = @"Select City";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Select City" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtCity.attributedPlaceholder = str1;
    txtCity.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtCity.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtCity.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtCity.backgroundColor=[UIColor clearColor];
    txtCity.delegate=self;
    if (_SelectedCity == (id)[NSNull null] || _SelectedCity.length == 0 )
    {
        
    }
    else
    {
        txtCity.text = _SelectedCity;
    }
    [categoryScrollView addSubview:txtCity];
    
    UIImageView * myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, textlab.frame.size.height+textlab.frame.origin.y+35, 20, 20)];
    myImageView.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y, self.view.frame.size.width-50, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    
    UIButton *CityButton=[[UIButton alloc] initWithFrame:CGRectMake(15, textlab.frame.size.height+textlab.frame.origin.y+20, self.view.frame.size.width-50, 50)];
    [CityButton addTarget:self action:@selector(CityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CityButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:CityButton];
    
    
    
    
    
    
    
    
    
    txtHospital=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtHospital.placeholder = @"Select Hospital";
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Select Hospital" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtHospital.attributedPlaceholder = str3;
    txtHospital.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtHospital.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtHospital.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtHospital.backgroundColor=[UIColor clearColor];
    txtHospital.delegate=self;
    if (_SelectedHospital == (id)[NSNull null] || _SelectedHospital.length == 0 )
    {
        
    }
    else
    {
        txtHospital.text = _SelectedHospital;
    }
    [categoryScrollView addSubview:txtHospital];
    
    UIImageView * myImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, txtCity.frame.size.height+txtCity.frame.origin.y+35, 20, 20)];
    myImageView3.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView3];
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y, self.view.frame.size.width-50, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    UIButton *HospitalButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtCity.frame.size.height+txtCity.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [HospitalButton addTarget:self action:@selector(HospitalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    HospitalButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:HospitalButton];
    
    
    
    
    
    
    txtSpeciality=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtSpeciality.placeholder = @"Select Speciality";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Select Speciality" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtSpeciality.attributedPlaceholder = str2;
    txtSpeciality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtSpeciality.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtSpeciality.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtSpeciality.backgroundColor=[UIColor clearColor];
    txtSpeciality.delegate=self;
    if (_SelectedSpeciality == (id)[NSNull null] || _SelectedSpeciality.length == 0 )
    {
        
    }
    else
    {
        txtSpeciality.text = _SelectedSpeciality;
    }
    [categoryScrollView addSubview:txtSpeciality];
    
    UIImageView * myImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, txtHospital.frame.size.height+txtHospital.frame.origin.y+35, 20, 20)];
    myImageView2.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView2];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y, self.view.frame.size.width-50, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    UIButton *SpecialityButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtHospital.frame.size.height+txtHospital.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    [SpecialityButton addTarget:self action:@selector(SpecialityButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    SpecialityButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:SpecialityButton];
    
    
    
    

    txtDoctors=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+20, self.view.frame.size.width-50, 50)];
    txtDoctors.placeholder = @"Select Doctor";
    NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"Select Doctor" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDoctors.attributedPlaceholder = str4;
    txtDoctors.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDoctors.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDoctors.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDoctors.backgroundColor=[UIColor clearColor];
    txtDoctors.delegate=self;
    if (_SelectedDoctor == (id)[NSNull null] || _SelectedDoctor.length == 0 )
    {
        
    }
    else
    {
        txtDoctors.text = _SelectedDoctor;
    }
    [categoryScrollView addSubview:txtDoctors];
    
    UIImageView * myImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-55, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+35, 20, 20)];
    myImageView4.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView addSubview:myImageView4];
    
    linelabel5=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDoctors.frame.size.height+txtDoctors.frame.origin.y, self.view.frame.size.width-50, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel5];
    
    
    UIButton *DoctorsButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtSpeciality.frame.size.height+txtSpeciality.frame.origin.y+20, self.view.frame.size.width-50, 50)];
    [DoctorsButton addTarget:self action:@selector(DoctorsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    DoctorsButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:DoctorsButton];
    
    
    UIButton *ContinueButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtDoctors.frame.size.height+txtDoctors.frame.origin.y+30, self.view.frame.size.width-50, 40)];
    ContinueButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [ContinueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
    ContinueButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    ContinueButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ContinueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ContinueButton addTarget:self action:@selector(ContinueButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:ContinueButton];
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    
    footerview.frame=CGRectMake(10,(self.view.frame.size.height/2)-230, self.view.frame.size.width-20, 460);
    
    [popview addSubview:footerview];
}

#pragma mark - CityButton Clicked

-(IBAction)CrossButtonClicked:(id)sender
{
     self.tabBarController.tabBar.userInteractionEnabled=YES;
    [footerview removeFromSuperview];
    popview.hidden=YES;
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
    NSString *post = [NSString stringWithFormat:@"city_id=%@",_strCityId];
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
    NSString *post = [NSString stringWithFormat:@"city_id=%@&hospital_id=%@",_strCityId,_strHospitalId];
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
    NSString *post = [NSString stringWithFormat:@"city_id=%@&speciality_id=%@&hospital_id=%@",_strCityId,_strSpecialityId,_strHospitalId];
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
    NSString *post = [NSString stringWithFormat:@"city_id=%@&specility_id=%@&hospital_id=%@&doctor_id=%@&week_day=%@",_strCityId,_strSpecialityId,_strHospitalId,_strDoctorsId,strWeekDaySlot];
    NSLog(@"%@",post);
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchDoctorAll];
    [requested sendRequest7:post withUrl:strurl];
}



-(void)responsewithToken7:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        [footerview removeFromSuperview];
        popview.hidden=YES;
        
        [arrlist removeAllObjects];
        
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
                
                arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
                
            }
        }

       // arrlist=[responseToken valueForKey:@"data"];
        ResultsLabel.text=[NSString stringWithFormat:@"%lu result(s) found",(unsigned long)arrlist.count];
        [tablDta reloadData];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:_strCityId forKey:@"CityId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:_strSpecialityId forKey:@"SpecialityId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:_strHospitalId forKey:@"HospitalId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:_strDoctorsId forKey:@"DoctId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
//        NSString *StrDay=[NSString stringWithFormat:@"%@",[arrWeeks objectAtIndex:0]];
//        
//        if ([StrDay isEqualToString:@"Sun"])
//        {
//            tablDta.hidden=YES;
//            NodataLab.hidden=NO;
//            ResultsLabel.text=[NSString stringWithFormat:@"0 result(s) found"];
//        }
//        else
//        {
//            tablDta.hidden=NO;
//            NodataLab.hidden=YES;
//            ResultsLabel.text=[NSString stringWithFormat:@"%lu result(s) found",(unsigned long)arrlist.count];
//        }

    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
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
    
    popview2 = [[ UIView alloc]init];
    popview2.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview2.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview2];
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:popview2 animated:YES];
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:93.0 G:181.0 B:80.0 alpha:0.9];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    popview2.hidden = YES;
    
    if ([StrId isEqualToString:@"1"])
    {
        txtCity.text=[[arrCitys valueForKey:@"name"]objectAtIndex:anIndex];
        _SelectedCity=[[arrCitys valueForKey:@"name"]objectAtIndex:anIndex];
        _strCityId=[[arrCitys valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        
        _strHospitalId=@"";
        txtHospital.text=@"";
        _strSpecialityId=@"";
        txtSpeciality.text=@"";
        _strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        
    }
    else if([StrId isEqualToString:@"2"])
    {
        txtHospital.text=[[arrHospital valueForKey:@"name"]objectAtIndex:anIndex];
         _SelectedHospital=[[arrHospital valueForKey:@"name"]objectAtIndex:anIndex];
        _strHospitalId=[[arrHospital valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        _strSpecialityId=@"";
        txtSpeciality.text=@"";
        _strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else if([StrId isEqualToString:@"3"])
    {
        txtSpeciality.text=[[arrSpeciality valueForKey:@"name"]objectAtIndex:anIndex];
        _SelectedSpeciality=[[arrSpeciality valueForKey:@"name"]objectAtIndex:anIndex];
        _strSpecialityId=[[arrSpeciality valueForKey:@"id"]objectAtIndex:anIndex];
        linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        _strDoctorsId=@"";
        txtDoctors.text=@"";
        
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else if([StrId isEqualToString:@"4"])
    {
        txtDoctors.text=[[arrDoctors valueForKey:@"name"]objectAtIndex:anIndex];
        _SelectedDoctor=[[arrDoctors valueForKey:@"name"]objectAtIndex:anIndex];
        _strDoctorsId=[[arrDoctors valueForKey:@"id"]objectAtIndex:anIndex];
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
       // popview.hidden = YES;
        popview2.hidden = YES;
        [Dropobj fadeOut];
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
       // NotificationButton.userInteractionEnabled=NO;
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
        //[requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
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




#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - CalenderView

-(void)CalenderView
{
    NSDate *today = [NSDate dateWithTimeInterval:(24*0*0) sinceDate:[NSDate date]];
    NSString *dateSt = [NSString stringWithFormat:@"%@",today];
    NSArray *components = [dateSt componentsSeparatedByString:@" "];
    NSString *dat = components[0];
    NSArray *todate=[dat componentsSeparatedByString:@"-"];
    strdayid = [NSString stringWithFormat:@"%@", [todate objectAtIndex:2]];

    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSString *dateString = [NSString stringWithFormat:@"%@",tomorrow];
    NSArray *components2 = [dateString componentsSeparatedByString:@" "];
    NSString *date2 = components2[0];
    NSArray *todaydate=[date2 componentsSeparatedByString:@"-"];
    str2moroid = [NSString stringWithFormat:@"%@", [todaydate objectAtIndex:2]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSArray * allDatesOfThisWeek = [self daysThisWeek];
    NSArray * allDatesOfNextWeek = [self daysNextWeek];
    NSArray * allDatesOfNextToNextWeek = [self daysInWeek:2 fromDate:[NSDate date]];
    NSArray * allDatesOfNextToNextWeek2 = [self daysInWeek:3 fromDate:[NSDate date]];
   
    
    
    
    for (int i=0; i<allDatesOfThisWeek.count; i++)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[allDatesOfThisWeek objectAtIndex:i]];
        NSArray *components = [dateString componentsSeparatedByString:@" "];
        NSString *date = components[0];
        NSArray *todaydate=[date componentsSeparatedByString:@"-"];
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:[todaydate objectAtIndex:1]];
        testarrMonths=[[testarrMonths arrayByAddingObjectsFromArray:arr] mutableCopy];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        [arr2 addObject:[todaydate objectAtIndex:2]];
        testarrDates=[[testarrDates arrayByAddingObjectsFromArray:arr2] mutableCopy];
    }
    
    for (int i=0; i<allDatesOfNextWeek.count; i++)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[allDatesOfNextWeek objectAtIndex:i]];
        NSArray *components = [dateString componentsSeparatedByString:@" "];
        NSString *date = components[0];
        NSArray *todaydate=[date componentsSeparatedByString:@"-"];
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:[todaydate objectAtIndex:1]];
        testarrMonths=[[testarrMonths arrayByAddingObjectsFromArray:arr] mutableCopy];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        [arr2 addObject:[todaydate objectAtIndex:2]];
        testarrDates=[[testarrDates arrayByAddingObjectsFromArray:arr2] mutableCopy];
    }
    
    for (int i=0; i<allDatesOfNextToNextWeek.count; i++)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[allDatesOfNextToNextWeek objectAtIndex:i]];
        NSArray *components = [dateString componentsSeparatedByString:@" "];
        NSString *date = components[0];
        NSArray *todaydate=[date componentsSeparatedByString:@"-"];
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:[todaydate objectAtIndex:1]];
        testarrMonths=[[testarrMonths arrayByAddingObjectsFromArray:arr] mutableCopy];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        [arr2 addObject:[todaydate objectAtIndex:2]];
        testarrDates=[[testarrDates arrayByAddingObjectsFromArray:arr2] mutableCopy];
    }
    for (int i=0; i<allDatesOfNextToNextWeek2.count; i++)
    {
        NSString *dateString = [NSString stringWithFormat:@"%@",[allDatesOfNextToNextWeek2 objectAtIndex:i]];
        NSArray *components = [dateString componentsSeparatedByString:@" "];
        NSString *date = components[0];
        NSArray *todaydate=[date componentsSeparatedByString:@"-"];
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:[todaydate objectAtIndex:1]];
        testarrMonths=[[testarrMonths arrayByAddingObjectsFromArray:arr] mutableCopy];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        [arr2 addObject:[todaydate objectAtIndex:2]];
        testarrDates=[[testarrDates arrayByAddingObjectsFromArray:arr2] mutableCopy];
    }
    
    
    
    
    
    for (int i=0; i<testarrMonths.count; i++)
    {
        NSString *strid=[NSString stringWithFormat:@"%@",[testarrMonths objectAtIndex:i]];
        
        if ([strid isEqualToString:@"01"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Jan", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"02"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Feb", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"03"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Mar", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"04"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Apr", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"05"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"May", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"06"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Jun", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"07"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Jul", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"08"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Aug", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"09"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Sep", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"10"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Oct", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"11"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Nov", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
        else if ([strid isEqualToString:@"12"])
        {
            NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:@"Dec", nil];
            testarrMonthsName=[[testarrMonthsName arrayByAddingObjectsFromArray:arr2] mutableCopy];
        }
    }
    
    int indexValue = (int)[testarrDates indexOfObject:strdayid];
    
    for (int k=indexValue; k<indexValue+21; k++)
    {
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        [arr addObject:[testarrDates objectAtIndex:k]];
        arrDates=[[arrDates arrayByAddingObjectsFromArray:arr] mutableCopy];
        
        NSMutableArray *arr2=[[NSMutableArray alloc]init];
        [arr2 addObject:[testarrMonths objectAtIndex:k]];
        arrMonths=[[arrMonths arrayByAddingObjectsFromArray:arr2] mutableCopy];
        
        NSMutableArray *arr3=[[NSMutableArray alloc]init];
        [arr3 addObject:[testarrMonthsName objectAtIndex:k]];
        arrMonthsName=[[arrMonthsName arrayByAddingObjectsFromArray:arr3] mutableCopy];
        
        NSMutableArray *arr4=[[NSMutableArray alloc]init];
        [arr4 addObject:[testarrWeeks objectAtIndex:k]];
        arrWeeks=[[arrWeeks arrayByAddingObjectsFromArray:arr4] mutableCopy];
        
    }
    
    
    int indexValue2 = (int)[arrDates indexOfObject:strdayid];
    
    index2 = [NSIndexPath indexPathForRow:indexValue2 inSection:0];
    [self.arryData addObject:index2];
    
    for (int j=0; j<indexValue; j++)
    {
        index = [NSIndexPath indexPathForRow:j inSection:0];
        NSMutableArray *arr2=[[NSMutableArray alloc]initWithObjects:index, nil];
        self.arryData2=[[self.arryData2 arrayByAddingObjectsFromArray:arr2] mutableCopy];
    }
    
}


-(NSArray*)daysThisWeek
{
    return  [self daysInWeek:0 fromDate:[NSDate date]];
}

-(NSArray*)daysNextWeek
{
    return  [self daysInWeek:1 fromDate:[NSDate date]];
}
-(NSArray*)daysInWeek:(int)weekOffset fromDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //ask for current week
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps=[calendar components:NSWeekCalendarUnit|NSCalendarUnitYear fromDate:date];
    //create date on week start
    NSDate* weekstart=[calendar dateFromComponents:comps];
    
    NSDateComponents* moveWeeks=[[NSDateComponents alloc] init];
    moveWeeks.weekOfYear=weekOffset;
    weekstart=[calendar dateByAddingComponents:moveWeeks toDate:weekstart options:0];
    
    
    //add 7 days
    NSMutableArray* week=[NSMutableArray arrayWithCapacity:7];
    for (int i=1; i<=7; i++) {
        NSDateComponents *compsToAdd = [[NSDateComponents alloc] init];
        compsToAdd.day=i;
        NSDate *nextDate = [calendar dateByAddingComponents:compsToAdd toDate:weekstart options:0];
        [week addObject:nextDate];
        
    }
    return [NSArray arrayWithArray:week];
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
