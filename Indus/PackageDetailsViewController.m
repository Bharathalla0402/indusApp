//
//  PackageDetailsViewController.m
//  Indus
//
//  Created by think360 on 02/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "PackageDetailsViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "DejalActivityView.h"
#import "NotificationViewController.h"

@interface PackageDetailsViewController ()<ApiRequestdelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
     UIWebView *webview;
}
@end

@implementation PackageDetailsViewController

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
    titlelab.text=@"Packages";
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
    
    
    UIView *HeadView=[[UIView alloc]initWithFrame:CGRectMake(0, linelabel.frame.size.height+linelabel.frame.origin.y, self.view.frame.size.width, 55)];
    HeadView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [self.view addSubview:HeadView];
    
    UILabel *Headlab=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width-80, 30)];
    Headlab.text=[_arrChildCategory valueForKey:@"title"];
    Headlab.textColor=[UIColor whiteColor];
    Headlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    Headlab.textAlignment=NSTextAlignmentLeft;
    [HeadView addSubview:Headlab];
    
    UILabel *Pricelab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-70, 10, 65, 30)];
    Pricelab.text=[_arrChildCategory valueForKey:@"price"];
    Pricelab.textColor=[UIColor whiteColor];
    Pricelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    Pricelab.textAlignment=NSTextAlignmentRight;
    [HeadView addSubview:Pricelab];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, linelabel.frame.size.height+linelabel.frame.origin.y+55, self.view.frame.size.width, self.view.frame.size.height-177)];
    webview.backgroundColor=[UIColor clearColor];
    NSString *html = [_arrChildCategory valueForKey:@"description"];
    NSString *htmlString = [NSString stringWithFormat:@"<font face='OpenSans-Regular' size='3'>%@", html];
    [webview loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:webview];
    
    
    UIImageView *Callimage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-65, linelabel.frame.size.height+linelabel.frame.origin.y+65, 60, 60)];
    //Callimage.image=[UIImage imageNamed:@"call.png"];
    Callimage.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"circle_1.gif"],
                                 [UIImage imageNamed:@"circle_2.gif"],
                                 [UIImage imageNamed:@"circle_3.gif"],
                                 [UIImage imageNamed:@"circle_4.gif"],
                                 [UIImage imageNamed:@"circle_5.gif"],
                                 [UIImage imageNamed:@"circle_6.gif"],
                                 [UIImage imageNamed:@"circle_7.gif"],
                                          nil];
    Callimage.animationDuration = 4.0f;
    //Callimage.animationRepeatCount = 0;
    [Callimage startAnimating];
    Callimage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:Callimage];
    
    UILabel *Calllab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-80, Callimage.frame.size.height+Callimage.frame.origin.y, 80, 30)];
    Calllab.text=@"Call Now";
    Calllab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    Calllab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    Calllab.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:Calllab];

    
    UIButton *callButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-85, linelabel.frame.size.height+linelabel.frame.origin.y+75, 70, 70)];
    [callButton addTarget:self action:@selector(CallButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    callButton.backgroundColor=[UIColor clearColor];
    [self.view addSubview:callButton];
    
    
    
  
}




#pragma mark - Call Clicked

-(IBAction)CallButtonClicked:(id)sender
{
    NSString *phone=[NSString stringWithFormat:@"%@",[_arrChildCategory valueForKey:@"mobile"]];
   // NSString *phone=@"8143547797";
    NSString *phone_number = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];

     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone_number]] options:@{} completionHandler:nil];
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
       // [requested sendRequest2:post withUrl:strurl];
        
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
                    [self responsewithToken2:responseJSON];
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


-(void)responsewithToken2:(NSMutableDictionary *)responseToken
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
