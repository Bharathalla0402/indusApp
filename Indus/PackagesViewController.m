//
//  PackagesViewController.m
//  Indus
//
//  Created by think360 on 02/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "PackagesViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "DejalActivityView.h"
#import "PackageDetailsViewController.h"
#import "NotificationViewController.h"

@interface PackagesViewController ()<ApiRequestdelegate,UITableViewDelegate,UITableViewDataSource>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    IBOutlet UITableView *tablDta;
    UITableViewCell *cell;
    
    UILabel *Popuplab;
    
    NSMutableArray *arrlist;
    
    UIView *popview5;
    UIView *footerview5;
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
}
@end

@implementation PackagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    arrlist=[[NSMutableArray alloc]init];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [self CustomView];
    
    
    Popuplab=[[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height/2-10, self.view.frame.size.width-40, 20)];
    Popuplab.text=@"No Packages Available";
    Popuplab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    Popuplab.textAlignment=NSTextAlignmentCenter;
    Popuplab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    Popuplab.hidden=YES;
    [self.view addSubview:Popuplab];
    
    
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
    //NotificationButton.userInteractionEnabled=NO;
    [topView addSubview:NotificationButton];
    
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    tablDta=[[UITableView alloc] init];
    tablDta.frame = CGRectMake(0,topView.frame.size.height+topView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-117);
    tablDta.delegate=self;
    tablDta.dataSource=self;
    tablDta.tag=4;
    tablDta.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tablDta.backgroundColor=[UIColor clearColor];
    [tablDta setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tablDta];
    
    
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
     
        UILabel *Namelabel=[[UILabel alloc] init];
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"title"]];
        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                       context:nil];
        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(testView.frame.size.width-50,size.height)];
        Namelabel.frame = CGRectMake(10,10, descriptionSize.width, descriptionSize.height);
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        Namelabel.numberOfLines=0;
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor whiteColor];
        [testView addSubview:Namelabel];
        
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"price"]];
        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                              context:nil];
        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(testView.frame.size.width-50,size2.height)];
        ClinicNamelabel.frame = CGRectMake(10,Namelabel.frame.size.height+Namelabel.frame.origin.y+10, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor whiteColor];
        [testView addSubview:ClinicNamelabel];
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+30);
        
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
        testView.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
        testView.layer.borderWidth = 1.0f;
        testView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        
        
        
        UILabel *Namelabel=[[UILabel alloc] init];
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"title"]];
        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                       context:nil];
        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(testView.frame.size.width-50,size.height)];
        Namelabel.frame = CGRectMake(10,10, descriptionSize.width, descriptionSize.height);
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        Namelabel.numberOfLines=0;
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor whiteColor];
        [testView addSubview:Namelabel];
        
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"price"]];
        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                              context:nil];
        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(testView.frame.size.width-50,size2.height)];
        ClinicNamelabel.frame = CGRectMake(10,Namelabel.frame.size.height+Namelabel.frame.origin.y+10, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor whiteColor];
        [testView addSubview:ClinicNamelabel];
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+30);
        [cell addSubview:testView];
        
        
        UIImageView *Dateimage=[[UIImageView alloc] initWithFrame:CGRectMake(testView.frame.size.width-34, testView.frame.size.height/2-13, 26, 26)];
        Dateimage.image=[UIImage imageNamed:@"right-arrow-2.png"];
        Dateimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:Dateimage];
        
        return cell;
        
    }
    else
    {
       
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
        PackageDetailsViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"PackageDetailsViewController"];
        refer.arrChildCategory=[arrlist objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:refer animated:YES];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}



#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,allPackage];
    [requested SubCategoryRequest:nil withUrl:strurl];
    
   
}


-(void)responseSubCategory:(NSMutableDictionary *)responseDict
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseDict valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrlist=[responseDict valueForKey:@"data"];
        [tablDta reloadData];
        Popuplab.hidden=YES;
        
        
        
        
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
    else
    {
        Popuplab.hidden=NO;
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
