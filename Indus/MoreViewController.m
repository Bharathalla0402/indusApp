//
//  MoreViewController.m
//  Indus
//
//  Created by think360 on 13/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "MoreViewController.h"
#import "BookAppointmentViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "Customcell1.h"
#import "DoctorRegViewController.h"
#import "QueryViewController.h"
#import "ReferPatientViewController.h"
#import "DejalActivityView.h"
#import "AboutIndusViewController.h"
#import "PrivacyViewController.h"
#import "FilterReferPatientViewController.h"
#import "NotificationViewController.h"
#import "ContactUsViewController.h"
#import "SocialSupportViewController.h"
#import "UserInformation.h"

@interface MoreViewController ()<ApiRequestdelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    NSMutableArray *arrtitle,*arrimages;
    UITableView *tabl;
    Customcell1 *cell;
    
    NSString *strWebUrl;
    
    UIView *popview5;
    UIView *footerview5;
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
//    NSUserDefaults *prefs2 = [NSUserDefaults standardUserDefaults];
//    NSObject * object2 = [prefs2 objectForKey:@"DoctorId"];
//    if(object2 != nil)
//    {
//        arrtitle=[[NSMutableArray alloc]initWithObjects:@"Book an Appointment",@"Feedback/Query",@"Refered Patients",@"About Indus Healthcare",@"Privacy Policy",@"Share",@"Rate Our App",@"Logout", nil];
//        
//        arrimages=[[NSMutableArray alloc]initWithObjects:@"Book_appointment.png",@"feedback_query.png",@"Doc_registeration.png",@"About_indus.png",@"privacy_policy.png",@"share.png",@"rate_our_app.png",@"logout.png", nil];
//    }
//    else
//    {
//        arrtitle=[[NSMutableArray alloc]initWithObjects:@"Book an Appointment",@"Feedback/Query",@"Doctor Registration",@"About Indus Healthcare",@"Privacy Policy",@"Share",@"Rate Our App", nil];
//        
//        arrimages=[[NSMutableArray alloc]initWithObjects:@"Book_appointment.png",@"feedback_query.png",@"Doc_registeration.png",@"About_indus.png",@"privacy_policy.png",@"share.png",@"rate_our_app.png", nil];
//    }
    
    

//    
//    NSString *strDevicetoken=[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
//    
//    
//    NSArray *activityItems = @[strDevicetoken];
//    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
//    [activityViewControntroller setValue:@"Coupon Details of Promo_Analytics" forKey:@"subject"];
//    activityViewControntroller.excludedActivityTypes = @[];
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        activityViewControntroller.popoverPresentationController.sourceView = self.view;
//        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
//    }
//    [self presentViewController:activityViewControntroller animated:true completion:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    NSUserDefaults *prefs2 = [NSUserDefaults standardUserDefaults];
    NSObject * object2 = [prefs2 objectForKey:@"DoctorId"];
    if(object2 != nil)
    {
        arrtitle=[[NSMutableArray alloc]initWithObjects:@"Refer A Patient",@"About Indus Healthcare",@"Feedback/Query",@"Contact Us",@"Share",@"Rate Our App",@"Privacy Policy",@"Logout", nil];
        
        arrimages=[[NSMutableArray alloc]initWithObjects:@"Doc_registeration.png",@"About_indus.png",@"feedback_query.png",@"contact_us.png",@"share.png",@"rate_our_app.png",@"privacy_policy.png",@"logout.png", nil];
    }
    else
    {
        arrtitle=[[NSMutableArray alloc]initWithObjects:@"Doctor Registration",@"About Indus Healthcare",@"Feedback/Query",@"Contact Us",@"Share",@"Rate Our App",@"Privacy Policy", nil];
        
        arrimages=[[NSMutableArray alloc]initWithObjects:@"Doc_registeration.png",@"About_indus.png",@"feedback_query.png",@"contact_us.png",@"share.png",@"rate_our_app.png",@"privacy_policy.png", nil];
    }


   
    
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [self CustomView];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"HomeScreen"];
    if(object != nil)
    {
        BookAppointmentViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentViewController"];
        [self.navigationController pushViewController:book animated:YES];
    }
    else
    {
        
    }
    
  }

- (void) receiveTestNotification:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *myObject = [userInfo objectForKey:@"count"];
    NoticationLab.text=[NSString stringWithFormat:@"%@",myObject];
}



-(void)TipPopUp
{
   
    
    [DejalBezelActivityView activityViewForView:self.window withLabel:@"please wait..."];
    
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
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-15, topView.frame.size.width-120, 40)];
    titlelab.text=@"Menu";
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
    
    
    tabl=[[UITableView alloc] init];
    tabl.frame = CGRectMake(0,topView.frame.origin.y+topView.frame.size.height+20,self.view.frame.size.width,self.view.frame.size.height-150);
    tabl.delegate=self;
    tabl.dataSource=self;
    tabl.tag=3;
    tabl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tabl.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabl];
    

    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tabl.frame.size.width, 60)];
    view.backgroundColor=[UIColor whiteColor];
    tabl.tableFooterView = view;
    
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width/2-95, 10, 40, 40)];
    UIImage *btnImage = [UIImage imageNamed:@"facebook.png"];
    [button setImage:btnImage forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    button.layer.cornerRadius = 20;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(FacebookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    
    UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake(button.frame.origin.x+50, 10, 40, 40)];
    UIImage *btnImage3 = [UIImage imageNamed:@"twitter.png"];
    [button2 setImage:btnImage3 forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor clearColor];
    button2.layer.cornerRadius = 20;
    button2.clipsToBounds = YES;
    [button2 addTarget:self action:@selector(TwitterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button2];
    
    
    
    
    UIButton *button3=[[UIButton alloc] initWithFrame:CGRectMake(button2.frame.origin.x+50, 10, 40, 40)];
    UIImage *btnImage2 = [UIImage imageNamed:@"instagram.png"];
    [button3 setImage:btnImage2 forState:UIControlStateNormal];
    button3.backgroundColor=[UIColor clearColor];
    button3.layer.cornerRadius = 20;
    button3.clipsToBounds = YES;
    [button3 addTarget:self action:@selector(InstagramButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button3];
    
    
   
    
    
    UIButton *button4=[[UIButton alloc] initWithFrame:CGRectMake(button3.frame.origin.x+45, 0, 60, 60)];
    UIImage *btnImage4 = [UIImage imageNamed:@"youtube-2.png"];
    [button4 setImage:btnImage4 forState:UIControlStateNormal];
    button4.backgroundColor=[UIColor clearColor];
    button4.layer.cornerRadius = 20;
    button4.clipsToBounds = YES;
    [button4 addTarget:self action:@selector(YoutubeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button4];
    
    
    
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



-(IBAction)FacebookButtonClicked:(id)sender
{
    SocialSupportViewController *social=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialSupportViewController"];
    social.strWebUrl=@"https://www.facebook.com/Indushospitals/";
    social.strtitle=@"Facebook";
    [self.navigationController pushViewController:social animated:YES];
}

-(IBAction)InstagramButtonClicked:(id)sender
{
    SocialSupportViewController *social=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialSupportViewController"];
    social.strWebUrl=@"https://www.instagram.com/indushospital/";
    social.strtitle=@"Instagram";
    [self.navigationController pushViewController:social animated:YES];
}

-(IBAction)TwitterButtonClicked:(id)sender
{
    SocialSupportViewController *social=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialSupportViewController"];
    social.strWebUrl=@"https://twitter.com/IndusCareforYOU";
    social.strtitle=@"Twitter";
    [self.navigationController pushViewController:social animated:YES];
}

-(IBAction)YoutubeButtonClicked:(id)sender
{
    SocialSupportViewController *social=[self.storyboard instantiateViewControllerWithIdentifier:@"SocialSupportViewController"];
    social.strWebUrl=@"https://www.youtube.com/channel/UCWCX1mCMpU2uaD-wXqAB9Rg";
    social.strtitle=@"Youtube";
    [self.navigationController pushViewController:social animated:YES];
}




-(void)SocialSupport
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
    
    UILabel *titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-20, topView.frame.size.width-120, 40)];
    titlelab.text=@"Social Support";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    [topView addSubview:titlelab];
    
    
    UIImageView *topimage=[[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width-50, topView.frame.size.height/2-17, 40, 40)];
    topimage.image=[UIImage imageNamed:@"intro_logo.png"];
    topimage.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:topimage];
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    
    UIWebView *webview=[[UIWebView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-115)];
    webview.backgroundColor=[UIColor whiteColor];
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lab.indusafrica.org/"]]];
    [self.view addSubview:webview];
}


#pragma mark - Tableview delegate methodes

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrtitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellClassName = @"Customcell1";
    
    cell = (Customcell1 *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
    
    if (cell == nil)
    {
        cell = [[Customcell1 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Customcell1"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *lblName=(UILabel *)[cell viewWithTag:2];
    UIImageView *image=(UIImageView*)[cell viewWithTag:1];
    UILabel *linelabel=(UILabel *)[cell viewWithTag:5];
    lblName.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    lblName.text=[arrtitle objectAtIndex:indexPath.row];
    NSString *imageName=[arrimages objectAtIndex:indexPath.row];
    image.image=[UIImage imageNamed:imageName];
    
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1){
        linelabel.backgroundColor=[UIColor clearColor];
    }
    else
    {
         linelabel.backgroundColor=[UIColor lightGrayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSObject * object = [prefs objectForKey:@"DoctorId"];
        if(object != nil)
        {
            [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
            
//            NSData *Decode=[[NSUserDefaults standardUserDefaults] objectForKey:@"DocId"];
//            UserInformation *info = [NSKeyedUnarchiver unarchiveObjectWithData:Decode];
//            NSString *strDoctorId=[NSString stringWithFormat:@"%@",info.DoctorId];
            
            NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
            NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
            NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referralHistory];
            [requested sendRequest2:post withUrl:strurl];
            
        }
        else
        {
            DoctorRegViewController *reg=[self.storyboard instantiateViewControllerWithIdentifier:@"DoctorRegViewController"];
            [self.navigationController pushViewController:reg animated:YES];
        }
        
        
        
//        BookAppointmentViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentViewController"];
//        [self.navigationController pushViewController:book animated:YES];
    }
    else if (indexPath.row==1)
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,aboutIndusHealth];
        [requested SubCategoryRequest2:nil withUrl:strurl];
    }
    else if (indexPath.row==2)
    {
        QueryViewController *query=[self.storyboard instantiateViewControllerWithIdentifier:@"QueryViewController"];
        [self.navigationController pushViewController:query animated:YES];

    }
    else if (indexPath.row==3)
    {
        ContactUsViewController *query=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [self.navigationController pushViewController:query animated:YES];
    }
    else if (indexPath.row==4)
    {
        NSArray* sharedObjects=[NSArray arrayWithObjects:@"http://www.indushospital.in/",  nil];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:sharedObjects applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint,UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
        [self presentViewController:activityVC animated:TRUE completion:nil];
    }
    else if (indexPath.row==5)
    {
        [requested showMessage:@"link Will Update Soon" withTitle:@""];
        
        //        NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id1133221799?mt=8"; [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
    else if (indexPath.row==6)
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,privacyPolicy];
        [requested SubCategoryRequest3:nil withUrl:strurl];
    }
    else if (indexPath.row==7)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Indus" message:@"Are you sure want to Logout" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self yesClicked];
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
}


-(void)yesClicked
{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"DoctorId"];
    
    arrtitle=[[NSMutableArray alloc]initWithObjects:@"Doctor Registration",@"About Indus Healthcare",@"Feedback/Query",@"Contact Us",@"Share",@"Rate Our App",@"Privacy Policy", nil];
    
    arrimages=[[NSMutableArray alloc]initWithObjects:@"Doc_registeration.png",@"About_indus.png",@"feedback_query.png",@"contact_us.png",@"share.png",@"rate_our_app.png",@"privacy_policy.png", nil];
    
    [tabl reloadData];
    [self NotificationSettings];
    
    [requested showMessage:@"Logout Successfully" withTitle:@"Indus"];
}



-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        ReferPatientViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"ReferPatientViewController"];
        refer.arrChildCategory=[responseToken valueForKey:@"data"];
        refer.strpage=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"next"]];
        [self.navigationController pushViewController:refer animated:YES];
        
        
//        FilterReferPatientViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"FilterReferPatientViewController"];
//        refer.arrChildCategory=[responseToken valueForKey:@"data"];
//        [self.navigationController pushViewController:refer animated:YES];
    }
    else
    {
        ReferPatientViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"ReferPatientViewController"];
        [self.navigationController pushViewController:refer animated:YES];
    }
}

-(void)responseSubCategory2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        AboutIndusViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"AboutIndusViewController"];
        refer.arrChildCategory=[responseToken valueForKey:@"data"];
        [self.navigationController pushViewController:refer animated:YES];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}

-(void)responseSubCategory3:(NSMutableDictionary *)responseToken
{    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        PrivacyViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"PrivacyViewController"];
        refer.arrChildCategory=[responseToken valueForKey:@"data"];
        [self.navigationController pushViewController:refer animated:YES];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}



-(void)NotificationSettings
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
        // [requested sendRequest4:post withUrl:strurl];
        
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
                    
                } else
                {
                    NSError *err;
                    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                    [self responsewithToken4:responseJSON];
                    [DejalBezelActivityView removeView];
                }
                
            });
        }] resume];
        
    }
    else
    {
        NoticationLab.hidden=YES;
        NotificationButton.userInteractionEnabled=NO;
    }

}


#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];
    
    [super viewWillAppear:animated];
   //  self.tabBarController.tabBar.userInteractionEnabled=YES;
    self.navigationController.navigationBarHidden = YES;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
       // [requested sendRequest4:post withUrl:strurl];
        
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
                    [self responsewithToken4:responseJSON];
                    [DejalBezelActivityView removeView];
                }
                
            });
        }] resume];

    }
    else
    {
        NoticationLab.hidden=YES;
        //NotificationButton.userInteractionEnabled=NO;
    }
}


-(void)responsewithToken4:(NSMutableDictionary *)responseToken
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
     //   NotificationButton.userInteractionEnabled=NO;
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
    NSLog(@"%@",responseToken);
    
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
