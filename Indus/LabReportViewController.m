//
//  LabReportViewController.m
//  Indus
//
//  Created by think360 on 02/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "LabReportViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "UIFloatLabelTextField.h"
#import "DejalActivityView.h"
#import "NotificationViewController.h"

@interface LabReportViewController ()<ApiRequestdelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    UIFloatLabelTextField *txtBookingNo,*txtMobile;
    UILabel *linelabel2,*linelabel3;
    
    
    UIWebView *webview;
    
    UIView *popview5;
    UIView *footerview5;
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
}

@end

@implementation LabReportViewController

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
                [self responsewithToken5:responseJSON];
                
            }
            
        });
    }] resume];
}



-(void)responsewithToken5:(NSMutableDictionary *)responseToken
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
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-20, topView.frame.size.width-120, 40)];
    titlelab.text=@"Lab Report";
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
    
    
    
    webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-115)];
    webview.backgroundColor=[UIColor whiteColor];
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lab.indusafrica.org/"]]];
    [self.view addSubview:webview];
    
    
   
    
    UIButton *LoginButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-150, self.view.frame.size.height/2-10, 100, 20)];
    LoginButton.backgroundColor=[UIColor clearColor];
    [LoginButton setTitle:@"CLICK HERE" forState:UIControlStateNormal];
    LoginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    LoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [LoginButton setTitleColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    LoginButton.hidden=YES;
    [self.view addSubview:LoginButton];
    
    UILabel *LoginUnderlab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-145, LoginButton.frame.size.height+LoginButton.frame.origin.y, LoginButton.frame.size.width-5, 2)];
    LoginUnderlab.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    LoginUnderlab.hidden=YES;
    [self.view addSubview:LoginUnderlab];

    UILabel *Loginlab=[[UILabel alloc] initWithFrame:CGRectMake(LoginButton.frame.origin.x+LoginButton.frame.size.width+2, self.view.frame.size.height/2-10, 200, 20)];
    Loginlab.text=@"TO REACH INDUS DIRECTLY.";
    Loginlab.font=[UIFont systemFontOfSize:15];
    Loginlab.textAlignment=NSTextAlignmentCenter;
    Loginlab.numberOfLines=0;
    Loginlab.hidden=YES;
    Loginlab.textColor=[UIColor darkGrayColor];
    [self.view addSubview:Loginlab];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    categoryScrollView.backgroundColor=[UIColor whiteColor];
    categoryScrollView.hidden=YES;
    [self.view addSubview:categoryScrollView];
    
    
    UILabel *HeadLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, self.view.frame.size.width-20, 25)];
    HeadLab.text=@"Pathology Test Report";
    HeadLab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    HeadLab.font=[UIFont boldSystemFontOfSize:17];
    HeadLab.textAlignment=NSTextAlignmentCenter;
    [categoryScrollView addSubview:HeadLab];
    
    
    txtBookingNo=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, HeadLab.frame.size.height+HeadLab.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtBookingNo.placeholder=@"BOOKING NO";
    NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"BOOKING NO" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtBookingNo.attributedPlaceholder = str3;
    txtBookingNo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtBookingNo.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtBookingNo.font = [UIFont systemFontOfSize:17];
    txtBookingNo.backgroundColor=[UIColor clearColor];
    txtBookingNo.delegate=self;
    [txtBookingNo setKeyboardType:UIKeyboardTypeEmailAddress];
    txtBookingNo.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtBookingNo];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtBookingNo.frame.size.height+txtBookingNo.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    
    
    txtMobile=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtBookingNo.frame.size.height+txtBookingNo.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtMobile.placeholder=@"MOBILE NUMBER";
    NSAttributedString *str4= [[NSAttributedString alloc] initWithString:@"MOBILE NUMBER" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtMobile.attributedPlaceholder = str4;
    txtMobile.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtMobile.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtMobile.font = [UIFont systemFontOfSize:17];
    txtMobile.backgroundColor=[UIColor clearColor];
    txtMobile.delegate=self;
    [txtMobile setKeyboardType:UIKeyboardTypeEmailAddress];
    txtMobile.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtMobile];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtMobile.frame.size.height+txtMobile.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    
    
    UILabel *NoteLab=[[UILabel alloc]initWithFrame:CGRectMake(15, txtMobile.frame.size.height+txtMobile.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    NoteLab.numberOfLines=0;
    NoteLab.text=@"* The Lab Report Will be available for the tests conducted last 15 days";
    NoteLab.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    NoteLab.font=[UIFont boldSystemFontOfSize:15];
    NoteLab.textAlignment=NSTextAlignmentCenter;
    [categoryScrollView addSubview:NoteLab];
    
    
    UIButton *SubmitButton=[[UIButton alloc] initWithFrame:CGRectMake(15, NoteLab.frame.size.height+NoteLab.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    SubmitButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]   ;
    [SubmitButton setTitle:@"Next" forState:UIControlStateNormal];
    SubmitButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    SubmitButton.layer.cornerRadius = 4;
    SubmitButton.clipsToBounds = YES;
    SubmitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitButton addTarget:self action:@selector(SubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:SubmitButton];
    
    
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


// Delegate methods

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
   [DejalBezelActivityView removeView];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
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
}



#pragma mark - Reach us Clicked

-(IBAction)LoginButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://lab.indusafrica.org/"] options:@{} completionHandler:nil];

}

#pragma mark - Submit Button Clicked

-(IBAction)SubmitButtonClicked:(id)sender
{
    if (txtBookingNo.text.length==0)
    {
        [requested showMessage:@"Please Type Your Booking No" withTitle:@"Warning"];
    }
    else if (txtMobile.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Mobile Number" withTitle:@"Warning"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"HomeBook" forKey:@"HomeScreen"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"Index"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = tbc;
        tbc.selectedIndex=3;
        [self.window makeKeyAndVisible];
    }
}


#pragma mark - TextField Delegates


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == txtBookingNo)
    {
        if ([txtBookingNo.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField == txtMobile)
    {
        if ([txtMobile.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == txtBookingNo)
    {
        if ([txtBookingNo.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField == txtMobile)
    {
        if ([txtMobile.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
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
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lab.indusafrica.org/"]]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
        //[requested sendRequest2:post withUrl:strurl];
        
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
      //  NotificationButton.userInteractionEnabled=NO;
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]])
    {
        self.tabBarController.tabBar.userInteractionEnabled=YES;
        
        popview5.hidden=YES;
        [footerview5 removeFromSuperview];
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"firstlog"];
        [[NSUserDefaults standardUserDefaults]synchronize];
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
