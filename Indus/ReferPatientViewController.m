//
//  ReferPatientViewController.m
//  Indus
//
//  Created by think360 on 19/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "ReferPatientViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DejalActivityView.h"
#import "MoreViewController.h"
#import "UIImageView+WebCache.h"
#import "ReferPatientBookViewController.h"
#import "NotificationViewController.h"
#import "CallenderView.h"
#import "FilterReferPatientViewController.h"

@interface ReferPatientViewController ()<ApiRequestdelegate,UITableViewDelegate,UITableViewDataSource,CKCalendarDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab,*NodataLab;
    UIButton *NotificationButton;
    
    IBOutlet UITableView *tablDta;
    UITableViewCell *cell;
    
    UIView *footerview2;
    UILabel *loadLbl,*locationNamelabel;
    UIActivityIndicatorView * actInd;
    int scrool;
    int count,lastCount;
    
    NSMutableArray *arrlist;
    NSArray *arrlistDetails;
    UIView *footerview,*popview;
    
     UIView *popView2,*popView,*footerView;
      UILabel *RightDatelabel,*fromDatelabel;
     NSString *strStartDate,*strEndDate;
     int DateClick;
     UILabel *ResultsLabel;
}
@property(nonatomic, weak) CallenderView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation ReferPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    NSDate *today = [NSDate dateWithTimeInterval:(24*0*0) sinceDate:[NSDate date]];
    NSString *dateSt = [NSString stringWithFormat:@"%@",today];
    NSArray *components = [dateSt componentsSeparatedByString:@" "];
    NSString *dat = components[0];
    NSArray *todate=[dat componentsSeparatedByString:@"-"];
    strStartDate = [NSString stringWithFormat:@"%@-%@-%@", todate[0],todate[1],todate[2]];
    
    strEndDate = [NSString stringWithFormat:@"%@-%@-%@", todate[0],todate[1],todate[2]];

    
    scrool=1;
    count=1;
    lastCount=1;
     DateClick=1;
    
    arrlist=[[NSMutableArray alloc]init];
    arrlist=_arrChildCategory;

    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
  
   [self CustomView];
    
   // [self refreshData];
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
    titlelab.text=@"Referred Patients";
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
    

   
    
    UIView *filterView=[[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y+2, self.view.frame.size.width, 50)];
    filterView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:filterView];
    
    
    ResultsLabel=[[UILabel alloc] initWithFrame:CGRectMake(8, 10, 85, 40)];
    if (arrlist.count==0)
    {
        ResultsLabel.text=@"0 Patients";
    }
    else
    {
      ResultsLabel.text=[NSString stringWithFormat:@"%lu Patients",(unsigned long)arrlist.count];
    }
    ResultsLabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    ResultsLabel.textAlignment=NSTextAlignmentLeft;
    ResultsLabel.textColor=[UIColor blackColor];
    [filterView addSubview:ResultsLabel];
    
    
    UIButton *butt=[[UIButton alloc] initWithFrame:CGRectMake(filterView.frame.size.width-220, 10, 80, 40)];
    [butt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butt setTitle:@"Filter" forState:UIControlStateNormal];
    butt.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [butt.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16.0]];
    UIImage *image1= [UIImage imageNamed:@"filter.png"];
    [butt setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [butt setImage:[self imageWithImage:image1 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    butt.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [butt setImageEdgeInsets:UIEdgeInsetsMake(2, 0.0, 0.0, -butt.titleLabel.bounds.size.width+42)];
    butt.layer.cornerRadius = 4;
    butt.clipsToBounds = YES;
    [butt addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:butt];

    
    
    
    
//    UILabel *ReferedLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, ReferedView.frame.size.width-150, 40)];
//    ReferedLabel.text=@"Refered Patients";
//    ReferedLabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:16.0];
//    ReferedLabel.textAlignment=NSTextAlignmentLeft;
//    ReferedLabel.textColor=[UIColor blackColor];
//    [ReferedView addSubview:ReferedLabel];
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(filterView.frame.size.width-130, 10, 120, 40)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"REFER A PATIENT" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [button.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:14.0]];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(ReferPatientButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [filterView addSubview:button];
    
    
    UILabel *linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, filterView.frame.size.height+filterView.frame.origin.y+8, self.view.frame.size.width, 2)];
    linelabel2.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:linelabel2];
    
    tablDta=[[UITableView alloc] init];
    tablDta.frame = CGRectMake(0,linelabel2.frame.size.height+linelabel2.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-182);
    tablDta.delegate=self;
    tablDta.dataSource=self;
    tablDta.tag=4;
    tablDta.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tablDta.backgroundColor=[UIColor clearColor];
    [tablDta setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tablDta];
    
    
    if (_arrChildCategory == (id)[NSNull null] || [_arrChildCategory count] == 0)
    {
        tablDta.hidden=YES;
        
        NodataLab=[[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-10, self.view.frame.size.width-40, 20)];
        NodataLab.text=@"No Refered Patients Found";
        NodataLab.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        NodataLab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
        NodataLab.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:NodataLab];
    }
    else
    {
        tablDta.hidden=NO;
        NodataLab.hidden=YES;
    }

}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - FilterButton Clicked

-(IBAction)filterButtonClicked:(id)sender
{
    FilterReferPatientViewController *filter=[self.storyboard instantiateViewControllerWithIdentifier:@"FilterReferPatientViewController"];
    [self.navigationController pushViewController:filter animated:YES];
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
        UIView *testView=[[UIView alloc] init];
        testView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        testView.layer.borderWidth = 1.0f;
        testView.backgroundColor=[UIColor whiteColor];
        
        
        NSInteger aRedValue = arc4random()%255;
        NSInteger aGreenValue = arc4random()%255;
        NSInteger aBlueValue = arc4random()%255;
        
        UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        toimage.text=[[arrlist valueForKey:@"sn"] objectAtIndex:indexPath.row];
        toimage.layer.cornerRadius=25.0;
        toimage.clipsToBounds=YES;
        toimage.font=[UIFont boldSystemFontOfSize:17];
        toimage.textAlignment=NSTextAlignmentCenter;
        toimage.textColor=[UIColor whiteColor];
        toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        [testView addSubview:toimage];
        
        
        
        
        UILabel *Namelabel=[[UILabel alloc] init];
        Namelabel.numberOfLines=0;
          Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14.0];
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"patient_name"]];
//        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
//                                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                       context:nil];
//        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-200+20,45)];
        Namelabel.frame = CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+10,10, descriptionSize.width, descriptionSize.height);
      
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        
        
        
        UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, Namelabel.frame.size.height+Namelabel.frame.origin.y+10, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"Doclocation.png"];
        locationimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:locationimage];
        
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"hospital"]];
//        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
//                                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                              context:nil];
//        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-150,45)];
        ClinicNamelabel.frame = CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5,Namelabel.frame.size.height+Namelabel.frame.origin.y+7, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont systemFontOfSize:13];
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor darkGrayColor];
        
        
        
        UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, 20, 20)];
        referimage.image=[UIImage imageNamed:@"Docrefer_doctor.png"];
        referimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:referimage];
        
        UILabel *referlabel=[[UILabel alloc] init];
        referlabel.numberOfLines=0;
        UIColor *highlightColor = [UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:38.0/255.0f alpha:1.0];
        UIColor *normalColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
        UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
        UIFont *font2 = [UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        NSDictionary *highlightAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:highlightColor};
        NSDictionary *normalAttributes = @{NSFontAttributeName:font2, NSForegroundColorAttributeName:normalColor};
        NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"Refered Doctor:- " attributes:highlightAttributes];
        NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:[[arrlist objectAtIndex:indexPath.row]valueForKey:@"doctor_name"] attributes:normalAttributes];
        NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:highlightedText];
        [finalAttributedString appendAttributedString:normalText];
        referlabel.attributedText = finalAttributedString;
//        CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
//                                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                         context:nil];
//        CGSize size3 = textRect3.size;
        CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-180,45)];
        referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, descriptionSize3.width, descriptionSize3.height);
        referlabel.textAlignment=NSTextAlignmentLeft;
        
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+45);
        [testView addSubview:Namelabel];
        [testView addSubview:ClinicNamelabel];
        [testView addSubview:referlabel];
        
        
         return testView.frame.size.height+10;
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
        
        UIView *testView=[[UIView alloc] init];
        testView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        testView.layer.borderWidth = 1.0f;
        testView.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0];
      
        
        NSInteger aRedValue = arc4random()%255;
        NSInteger aGreenValue = arc4random()%255;
        NSInteger aBlueValue = arc4random()%255;
        
        UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        toimage.text=[[arrlist valueForKey:@"sn"] objectAtIndex:indexPath.row];
        toimage.layer.cornerRadius=25.0;
        toimage.clipsToBounds=YES;
        toimage.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        toimage.textAlignment=NSTextAlignmentCenter;
        toimage.textColor=[UIColor whiteColor];
        toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        [testView addSubview:toimage];
        
        
        
        
        UILabel *Namelabel=[[UILabel alloc] init];
         Namelabel.numberOfLines=0;
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14.0];
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"patient_name"]];
//        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
//                                                       options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                       context:nil];
//        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-200+20,45)];
        Namelabel.frame = CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+10,10, descriptionSize.width, descriptionSize.height);
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        
        
        
        UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, Namelabel.frame.size.height+Namelabel.frame.origin.y+10, 20, 20)];
        locationimage.image=[UIImage imageNamed:@"Doclocation.png"];
        locationimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:locationimage];
        
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"hospital"]];
//        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
//                                                              options:NSStringDrawingUsesLineFragmentOrigin
//                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                              context:nil];
//        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-150,45)];
        ClinicNamelabel.frame = CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5,Namelabel.frame.size.height+Namelabel.frame.origin.y+7, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor darkGrayColor];
        
        
        
        UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, 20, 20)];
        referimage.image=[UIImage imageNamed:@"Docrefer_doctor.png"];
        referimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:referimage];
        
        UILabel *referlabel=[[UILabel alloc] init];
        referlabel.numberOfLines=0;
        UIColor *highlightColor = [UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:38.0/255.0f alpha:1.0];
        UIColor *normalColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
        UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
        UIFont *font2 = [UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        NSDictionary *highlightAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:highlightColor};
        NSDictionary *normalAttributes = @{NSFontAttributeName:font2, NSForegroundColorAttributeName:normalColor};
        NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"Refered Doctor:- " attributes:highlightAttributes];
        NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:[[arrlist objectAtIndex:indexPath.row]valueForKey:@"doctor_name"] attributes:normalAttributes];
        NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:highlightedText];
        [finalAttributedString appendAttributedString:normalText];
        referlabel.attributedText = finalAttributedString;
//        CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
//                                                         options:NSStringDrawingUsesLineFragmentOrigin
//                                                      attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
//                                                         context:nil];
//        CGSize size3 = textRect3.size;
        CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-180,45)];
        referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, descriptionSize3.width, descriptionSize3.height);
        referlabel.textAlignment=NSTextAlignmentLeft;
       
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+45);
        
        [cell addSubview:testView];
        [testView addSubview:Namelabel];
        [testView addSubview:ClinicNamelabel];
        [testView addSubview:referlabel];
        
        UILabel *Datelabel=[[UILabel alloc] initWithFrame:CGRectMake(testView.frame.size.width-80, 10, 70, 20)];
        Datelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"created_on"]];
        Datelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:11.0];
        Datelabel.textAlignment=NSTextAlignmentCenter;
        Datelabel.textColor=[UIColor lightGrayColor];
        [testView addSubview:Datelabel];
        
        UIImageView *Dateimage=[[UIImageView alloc] initWithFrame:CGRectMake(testView.frame.size.width-105, 10, 20, 20)];
        Dateimage.image=[UIImage imageNamed:@"docdatePicker.png"];
        Dateimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:Dateimage];

    
        UILabel *BookButton=[[UILabel alloc] initWithFrame:CGRectMake(testView.frame.size.width-70, testView.frame.size.height-42, 60, 30)];
        BookButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        BookButton.text=@"More";
        BookButton.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        BookButton.textAlignment = NSTextAlignmentCenter;
        BookButton.textColor=[UIColor whiteColor];
        BookButton.layer.cornerRadius=4.0;
        BookButton.clipsToBounds=YES;
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
        arrlistDetails=[arrlist objectAtIndex:indexPath.row];
        [self DataListDetails];
        
        //  NSString *strid=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"id"]];
        
        //   [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        //  NSString *strurl=[NSString stringWithFormat:@"%@%@?doctor_id=%@",BaseUrl,doctorDetail,strid];
        //  [requested SubCategoryRequest2:nil withUrl:strurl];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)responseSubCategory2:(NSMutableDictionary *)responseDict
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
                
                NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
                NSString *post = [NSString stringWithFormat:@"doctor_id=%@&page=%@",strLoginid,_strpage];
                NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referralHistory];
                [requested sendRequest6:post withUrl:strurl];
                
//                NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
//                NSString *post = [NSString stringWithFormat:@"start_date=%@&end_date=%@&login_id=%@&page=%@",strStartDate,strEndDate,strLoginid,_strpage];
//                NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchReferalHistory];
//                [requested sendRequest6:post withUrl:strurl];
            }
        }
        
    }
    else
    {
        
    }
}

-(void)responsewithToken6:(NSMutableDictionary *)responseDict
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
            
            ResultsLabel.text=[NSString stringWithFormat:@"%lu Patients",(unsigned long)arrlist.count];
            
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
                
                ResultsLabel.text=[NSString stringWithFormat:@"%lu Patients",(unsigned long)arrlist.count];
                
                [tablDta reloadData];
                lastCount=2;
            }
        }
        else
        {
            NSArray *arr=[responseDictionary valueForKey:@"data"];
            
            arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            ResultsLabel.text=[NSString stringWithFormat:@"%lu Patients",(unsigned long)arrlist.count];
            
            [tablDta reloadData];
        }
    }
    
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






#pragma mark - Data list Clicked

-(void)DataListDetails
{
    self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] init];
    footerview.backgroundColor = [UIColor whiteColor];
    
    

    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 50, 50)];
    toimage.text=[arrlistDetails valueForKey:@"sn"];
    toimage.layer.cornerRadius=25.0;
    toimage.clipsToBounds=YES;
    toimage.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    toimage.textAlignment=NSTextAlignmentCenter;
    toimage.textColor=[UIColor whiteColor];
    toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    [footerview addSubview:toimage];
    
    
    
    
    UILabel *Namelabel=[[UILabel alloc] init];
    Namelabel.numberOfLines=0;
    Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    Namelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"patient_name"]];
    CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:15.0]}
                                                   context:nil];
    CGSize size = textRect.size;
    CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-200+10,size.height)];
    Namelabel.frame = CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+10,50, descriptionSize.width, descriptionSize.height);
    Namelabel.textAlignment=NSTextAlignmentLeft;
    Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    
    
    
    
    UIImageView *genderimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, Namelabel.frame.size.height+Namelabel.frame.origin.y+15, 20, 20)];
    genderimage.image=[UIImage imageNamed:@"pro4.png"];
    genderimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:genderimage];
    
    
    UILabel *genderNamelabel=[[UILabel alloc] init];
    genderNamelabel.numberOfLines=0;
    NSString *strgender = [NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"gender"]];
    NSString *strge = [NSString stringWithFormat:@"%@%@",[[strgender substringToIndex:1] uppercaseString],[strgender substringFromIndex:1] ];
    genderNamelabel.text=[NSString stringWithFormat:@"%@, Age:- %@",strge,[arrlistDetails valueForKey:@"age"]];
    CGRect textRect12 = [genderNamelabel.text boundingRectWithSize:genderNamelabel.frame.size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                           context:nil];
    CGSize size12 = textRect12.size;
    CGSize descriptionSize12 = [genderNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size12.height)];
    genderNamelabel.frame = CGRectMake(genderimage.frame.size.width+genderimage.frame.origin.x+5,genderimage.frame.origin.y-3, descriptionSize12.width, descriptionSize12.height);
    genderNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:13.0];
    genderNamelabel.textAlignment=NSTextAlignmentLeft;
    genderNamelabel.textColor=[UIColor darkGrayColor];
    
    
    
    
    
    
    UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, genderNamelabel.frame.size.height+genderNamelabel.frame.origin.y+15, 20, 20)];
    locationimage.image=[UIImage imageNamed:@"Doclocation.png"];
    locationimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:locationimage];
    
    UILabel *ClinicNamelabel=[[UILabel alloc] init];
    ClinicNamelabel.numberOfLines=0;
    ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"hospital"]];
    CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                          context:nil];
    CGSize size2 = textRect2.size;
    CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size2.height)];
    ClinicNamelabel.frame = CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5,locationimage.frame.origin.y-3, descriptionSize2.width, descriptionSize2.height);
    ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:13.0];
    ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
    ClinicNamelabel.textColor=[UIColor darkGrayColor];
    
    
    
   
    
    
    
    UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+15, 20, 20)];
    referimage.image=[UIImage imageNamed:@"Docrefer_doctor.png"];
    referimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:referimage];
    
    UILabel *referlabel=[[UILabel alloc] init];
    referlabel.numberOfLines=0;
    UIColor *highlightColor = [UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:38.0/255.0f alpha:1.0];
    UIColor *normalColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:13.0];
    UIFont *font2 = [UIFont fontWithName:@"OpenSans-Regular" size:13.0];
    NSDictionary *highlightAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:highlightColor};
    NSDictionary *normalAttributes = @{NSFontAttributeName:font2, NSForegroundColorAttributeName:normalColor};
    NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"Refered Doctor:- " attributes:highlightAttributes];
    NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:[arrlistDetails valueForKey:@"doctor_name"] attributes:normalAttributes];
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:highlightedText];
    [finalAttributedString appendAttributedString:normalText];
    referlabel.attributedText = finalAttributedString;
    CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                     context:nil];
    CGSize size3 = textRect3.size;
    CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size3.height)];
    referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,referimage.frame.origin.y-3, descriptionSize3.width, descriptionSize3.height);
    referlabel.textAlignment=NSTextAlignmentLeft;
    
    
    
    
    UIImageView *Commentimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, referlabel.frame.size.height+referlabel.frame.origin.y+15, 20, 20)];
    Commentimage.image=[UIImage imageNamed:@"pro2.png"];
    Commentimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:Commentimage];
    
    
    UILabel *commentlabel=[[UILabel alloc] init];
    commentlabel.numberOfLines=0;
    commentlabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"comments"]];
    CGRect textRect22 = [commentlabel.text boundingRectWithSize:commentlabel.frame.size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                           context:nil];
    CGSize size22 = textRect22.size;
    CGSize descriptionSize22 = [commentlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size22.height)];
    commentlabel.frame = CGRectMake(Commentimage.frame.size.width+Commentimage.frame.origin.x+5,Commentimage.frame.origin.y-3, descriptionSize22.width, descriptionSize22.height);
    commentlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:13.0];
    commentlabel.textAlignment=NSTextAlignmentLeft;
    commentlabel.textColor=[UIColor darkGrayColor];
    
    
    
    footerview.frame=CGRectMake(10,(self.view.frame.size.height/2)-(descriptionSize.height+descriptionSize2.height+descriptionSize3.height+80+descriptionSize12.height+descriptionSize22.height)/2, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+80+descriptionSize12.height+descriptionSize22.height+70);
    
    [popview addSubview:footerview];
    [footerview addSubview:Namelabel];
    [footerview addSubview:ClinicNamelabel];
    [footerview addSubview:referlabel];
    [footerview addSubview:genderNamelabel];
    [footerview addSubview:commentlabel];
    
    UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake(footerview.frame.size.width-50, 10, 30, 30)];
    UIImage *btnImage2 = [UIImage imageNamed:@"cancel-2.png"];
    [button2 setImage:btnImage2 forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor clearColor];
    button2.layer.cornerRadius = 15;
    button2.clipsToBounds = YES;
    [button2 addTarget:self action:@selector(CrossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:button2];
    
    UIButton *button3=[[UIButton alloc] initWithFrame:CGRectMake(footerview.frame.size.width-50, 0, 50, 50)];
    [button3 addTarget:self action:@selector(CrossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:button3];
    
    UILabel *Datelabel=[[UILabel alloc] initWithFrame:CGRectMake(footerview.frame.size.width-80, 50, 70, 20)];
    Datelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"created_on"]];
    Datelabel.font=[UIFont systemFontOfSize:12];
    Datelabel.textAlignment=NSTextAlignmentCenter;
    Datelabel.textColor=[UIColor lightGrayColor];
    [footerview addSubview:Datelabel];
    
    UIImageView *Dateimage=[[UIImageView alloc] initWithFrame:CGRectMake(footerview.frame.size.width-105, 50, 20, 20)];
    Dateimage.image=[UIImage imageNamed:@"docdatePicker.png"];
    Dateimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:Dateimage];
}

-(IBAction)CrossButtonClicked:(id)sender
{
     self.tabBarController.tabBar.userInteractionEnabled=YES;
    [footerview removeFromSuperview];
    popview.hidden = YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]])
    {
//        [footerview removeFromSuperview];
//        popview.hidden = YES;
    }
}



#pragma mark - Refer Clicked

-(IBAction)ReferPatientButtonClicked:(id)sender
{
    ReferPatientBookViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"ReferPatientBookViewController"];
    [self.navigationController pushViewController:book animated:YES];
}





#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];
    
    
//    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
//    NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
//    NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
//    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referralHistory];
//    [requested sendRequest2:post withUrl:strurl];
    
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



-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrlist=[responseToken valueForKey:@"data"];
        [tablDta reloadData];
    }
    else
    {
        
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
    MoreViewController *more=[self.storyboard instantiateViewControllerWithIdentifier:@"MoreViewController"];
    [self.navigationController pushViewController:more animated:YES];
}


#pragma mark - leftDate Clicked

-(IBAction)leftDateButtonClicked:(id)sender
{
    DateClick=1;
    
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
    label.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
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
    
    
    
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(15, 60, 270, 270);
    calendar.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [footerview addSubview:calendar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    
}


#pragma mark - RightDate Clicked

-(IBAction)RightDateButtonClicked:(id)sender
{
    DateClick=2;
    
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
    label.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
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
    
    calendar.onlyShowCurrentMonth = NO;
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

- (void)calendar:(CallenderView *)calendar didSelectDate:(NSDate *)date
{
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    self.dateLabel.text = [self.dateLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    if (DateClick==1)
    {
        NSString *strdate= [self.dateFormatter stringFromDate:date];
        strdate=[strdate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        
        NSString *strdate2= [self.dateFormatter stringFromDate:date];
        NSArray *arrdate=[strdate2 componentsSeparatedByString:@"/"];
        strStartDate=[NSString stringWithFormat:@"%@-%@-%@",arrdate[2],arrdate[1],arrdate[0]];
        fromDatelabel.text = strStartDate;
        
        [self refreshData];
    }
    else
    {
        NSString *strdate= [self.dateFormatter stringFromDate:date];
        strdate=[strdate stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        
        
        NSString *strdate2= [self.dateFormatter stringFromDate:date];
        NSArray *arrdate=[strdate2 componentsSeparatedByString:@"/"];
        strEndDate=[NSString stringWithFormat:@"%@-%@-%@",arrdate[2],arrdate[1],arrdate[0]];
        RightDatelabel.text = strEndDate;
        
        [self refreshData];
    }
    
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
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


-(IBAction)DateBackButtonClicked:(id)sender
{
    [footerview removeFromSuperview];
    popView.hidden = YES;
}


#pragma mark - Back Clicked

-(void)refreshData
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *strLoginid=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
    NSString *post = [NSString stringWithFormat:@"start_date=%@&end_date=%@&login_id=%@",strStartDate,strEndDate,strLoginid];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,searchReferalHistory];
    [requested sendRequest:post withUrl:strurl];
}


-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrlist=[responseToken valueForKey:@"data"];
        _strpage=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"next"]];
        ResultsLabel.text=[NSString stringWithFormat:@"%lu Patients",(unsigned long)arrlist.count];
        
        if (arrlist == (id)[NSNull null] || [arrlist count] == 0)
        {
            tablDta.hidden=YES;
            NodataLab.hidden=NO;
        }
        else
        {
            tablDta.hidden=NO;
            NodataLab.hidden=YES;
        }
        
        [tablDta reloadData];
    }
    else
    {
        arrlist=nil;
        _strpage=@"0";
        ResultsLabel.text=@"0 Patients";
        if (arrlist == (id)[NSNull null] || [arrlist count] == 0)
        {
            tablDta.hidden=YES;
            NodataLab.hidden=NO;
        }
        else
        {
            tablDta.hidden=NO;
            NodataLab.hidden=YES;
        }
        
        [tablDta reloadData];
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
