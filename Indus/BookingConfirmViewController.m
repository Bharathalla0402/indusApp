//
//  BookingConfirmViewController.m
//  Indus
//
//  Created by think360 on 06/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "BookingConfirmViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "PayuMoneyViewController.h"
#import "DejalActivityView.h"
#import "MoreViewController.h"
#import "NotificationViewController.h"
#import "CashCounterViewController.h"

@interface BookingConfirmViewController ()<ApiRequestdelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
}
@end

@implementation BookingConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
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
    titlelab.text=@"Confirm Appointment";
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
    [self.view addSubview:categoryScrollView];
    
    
    
    UILabel *orLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-15, categoryScrollView.frame.size.height/2-35, 30, 30)];
    orLab.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    orLab.textColor=[UIColor whiteColor];
    orLab.text=@"OR";
    orLab.textAlignment=NSTextAlignmentCenter;
    orLab.layer.masksToBounds = YES;
    orLab.layer.cornerRadius = 15.0;
    [categoryScrollView addSubview:orLab];
    
    UILabel *lineLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-120, categoryScrollView.frame.size.height/2-21, 100, 2)];
    lineLab.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:lineLab];
    
    UILabel *lineLab2=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2+20, categoryScrollView.frame.size.height/2-21, 100, 2)];
    lineLab2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:lineLab2];
    
    
    
    UIView *payumoneyView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-120, categoryScrollView.frame.size.height/2-180, 240, 130)];
    payumoneyView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    payumoneyView.layer.cornerRadius= 4.0;
    [categoryScrollView addSubview:payumoneyView];
    
    UIImageView *payuimage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140, categoryScrollView.frame.size.height/2-135, 40, 40)];
    payuimage.image=[UIImage imageNamed:@"booking_pay.png"];
    payuimage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:payuimage];
    
    UILabel *payulab=[[UILabel alloc]initWithFrame:CGRectMake(25, 20, payumoneyView.frame.size.width-50, payumoneyView.frame.size.height-40)];
    payulab.text=@"Pay & Confirm Appointment";
    payulab.numberOfLines=0;
    payulab.font=[UIFont fontWithName:@"OpenSans-Bold" size:20.0];
    payulab.textColor=[UIColor whiteColor];
    payulab.textAlignment=NSTextAlignmentCenter;
    [payumoneyView addSubview:payulab];
    
    
    UIButton *payuMoneyButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, payumoneyView.frame.size.width, payumoneyView.frame.size.height)];
    [payuMoneyButton addTarget:self action:@selector(PayuMoneyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    payuMoneyButton.backgroundColor=[UIColor clearColor];
    [payumoneyView addSubview:payuMoneyButton];
    
    
    
    
    UIView *RequestView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-120, categoryScrollView.frame.size.height/2+10, 240, 130)];
    RequestView.backgroundColor=[UIColor colorWithRed:83.0/255.0f green:84.0/255.0f blue:85.0/255.0f alpha:1.0];
    RequestView.layer.cornerRadius= 4.0;
    [categoryScrollView addSubview:RequestView];
    
    
    UIImageView *Requestimage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-140, categoryScrollView.frame.size.height/2+55, 40, 40)];
    Requestimage.image=[UIImage imageNamed:@"booking_request.png"];
    Requestimage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:Requestimage];
    
    UILabel *requestlab=[[UILabel alloc]initWithFrame:CGRectMake(25, 20, RequestView.frame.size.width-50, RequestView.frame.size.height-40)];
    requestlab.text=@"Request Appointment";
    requestlab.numberOfLines=0;
    requestlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:20.0];
    requestlab.textColor=[UIColor whiteColor];
    requestlab.textAlignment=NSTextAlignmentCenter;
    [RequestView addSubview:requestlab];
    
    UIButton *RequestButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, RequestView.frame.size.width, RequestView.frame.size.height)];
    [RequestButton addTarget:self action:@selector(RequestButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    RequestButton.backgroundColor=[UIColor clearColor];
    [RequestView addSubview:RequestButton];
    
    
    
    
    
    
    
    UILabel *NoteLab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-120, RequestView.frame.size.height+RequestView.frame.origin.y+15, 240, 50)];
    NoteLab.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    NoteLab.text=@"If you are paying then your appointment will be confirmed";
    NoteLab.textAlignment=NSTextAlignmentCenter;
    NoteLab.numberOfLines=0;
    NoteLab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:NoteLab];
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 460);
}




#pragma mark - PayuMoneyButton Clicked

-(IBAction)PayuMoneyButtonClicked:(id)sender
{
    PayuMoneyViewController *pay=[self.storyboard instantiateViewControllerWithIdentifier:@"PayuMoneyViewController"];
    pay.strName=_strName;
    pay.strEmailId=_strEmailId;
    pay.strPhone=_strPhone;
    pay.strId=_strId;
    [self.navigationController pushViewController:pay animated:YES];
}


#pragma mark - RequestButton Clicked

-(IBAction)RequestButtonClicked:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"id=%@&payment_method=%@",_strId,@"Cash"];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,RequestAppointment];
    [requested sendRequest2:post withUrl:strurl];
}



-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        CashCounterViewController *cash=[self.storyboard instantiateViewControllerWithIdentifier:@"CashCounterViewController"];
        [self.navigationController pushViewController:cash animated:YES];
        
        //[self.navigationController popToRootViewControllerAnimated:NO];
       // [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
        
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
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
     //   [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
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
