//
//  PayuMoneyViewController.m
//  Indus
//
//  Created by think360 on 06/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "PayuMoneyViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import <PayUmoney_SDK/PayUmoney_SDK.h>
#import <CommonCrypto/CommonDigest.h>
#import "PaymentPageViewController.h"
#import "NotificationViewController.h"
#import "DejalActivityView.h"


@interface PayuMoneyViewController ()<ApiRequestdelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
}
@property (nonatomic, strong) PUMRequestParams *params;
@end

@implementation PayuMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [self CustomView];
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
    titlelab.text=@"Payment";
    titlelab.font=[UIFont boldSystemFontOfSize:17];
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    [topView addSubview:titlelab];
    
    
    UIImageView *topimage=[[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width-50, topView.frame.size.height/2-12, 40, 40)];
    topimage.image=[UIImage imageNamed:@"intro_logo.png"];
    topimage.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:topimage];
    
    NoticationLab=[[UILabel alloc]initWithFrame:CGRectMake(topView.frame.size.width-30, topView.frame.size.height/2-14, 20, 20)];
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
    
    
    
    UIImageView *payuimage=[[UIImageView alloc] initWithFrame:CGRectMake(10, topView.frame.size.height+topView.frame.origin.y+38, 80, 80)];
    payuimage.image=[UIImage imageNamed:@"pay_u.png"];
    payuimage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:payuimage];
    
    UILabel *payulabel=[[UILabel alloc]initWithFrame:CGRectMake(100, topView.frame.size.height+topView.frame.origin.y+60, 120, 35)];
    payulabel.text=@"PayUMoney";
    payulabel.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    payulabel.font=[UIFont boldSystemFontOfSize:16];
    payulabel.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:payulabel];

    UIImageView *arrowimage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-45, topView.frame.size.height+topView.frame.origin.y+62, 30, 30)];
    arrowimage.image=[UIImage imageNamed:@"lis-arrow.png"];
    arrowimage.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:arrowimage];
    
    
    UIButton *PayUButton=[[UIButton alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y+38, self.view.frame.size.width, 90)];
    [PayUButton addTarget:self action:@selector(PayUButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    PayUButton.backgroundColor=[UIColor clearColor];
    [self.view addSubview:PayUButton];
    
}


#pragma mark - PayUButton Clicked

-(IBAction)PayUButtonClicked:(id)sender
{
    PaymentPageViewController *page=[self.storyboard instantiateViewControllerWithIdentifier:@"PaymentPageScreenID"];
    page.strName=_strName;
    page.strEmailId=_strEmailId;
    page.strPhone=_strPhone;
    page.strId=_strId;
   [self.navigationController pushViewController:page animated:YES];
    
    
  //  [self setPaymentParameters];
    
    //Start the payment flow
//    PUMMainVController *paymentVC = [[PUMMainVController alloc] init];
//    UINavigationController *paymentNavController = [[UINavigationController alloc] initWithRootViewController:paymentVC];
    
 //   [self presentViewController:paymentNavController
 //                      animated:YES
  //                   completion:nil];
}


- (void)setPaymentParameters {
    self.params = [PUMRequestParams sharedParams];
    self.params.environment = PUMEnvironmentProduction;
    self.params.amount = @"100";
    self.params.key = @"mdyCKV";
    self.params.merchantid = @"5817636";
    self.params.txnid = [self  getRandomString:2];
    self.params.surl = @"https://www.payumoney.com/mobileapp/payumoney/success.php";
    self.params.furl = @"https://www.payumoney.com/mobileapp/payumoney/failure.php";
    self.params.delegate = self;
    self.params.firstname = @"Bharath";
    self.params.productinfo = @"Bookng Payment";
    self.params.email = @"Bharath.alla23@gmail.com";
    self.params.phone = @"";
    
    //Below parameters are optional. It is to store any information you would like to save in PayU Database regarding trasnsaction. If you do not intend to store any additional info, set below params as empty strings.
    
    self.params.udf1 = @"";
    self.params.udf2 = @"";
    self.params.udf3 = @"";
    self.params.udf4 = @"";
    self.params.udf5 = @"";
    self.params.udf6 = @"";
    self.params.udf7 = @"";
    self.params.udf8 = @"";
    self.params.udf9 = @"";
    self.params.udf10 = @"";
    
    self.params.hashValue = [self getHash];
    
}

- (NSString *)getRandomString:(NSInteger)length {
    NSMutableString *returnString = [NSMutableString stringWithCapacity:length];
    NSString *numbers = @"0123456789";
    
    // First number cannot be 0
    [returnString appendFormat:@"%C", [numbers characterAtIndex:(arc4random() % ([numbers length]-1))+1]];
    
    for (int i = 1; i < length; i++) {
        [returnString appendFormat:@"%C", [numbers characterAtIndex:arc4random() % [numbers length]]];
    }
    return returnString;
}


#pragma mark - Never Generate hash from app
/*!
 Keeping salt in the app is a big security vulnerability. Never do this. Following function is just for demonstratin purpose
 In code below, salt Je7q3652 is mentioned. Never do this in prod app. You should get the hash from your server.
 */

- (NSString*)getHash {
    NSString *hashSequence = [NSString stringWithFormat:@"mdyCKV|%@|%@|%@|%@|%@|||||||||||Je7q3652",self.params.txnid, self.params.amount, self.params.productinfo,self.params.firstname, self.params.email];
    
    NSString *rawHash = [[self createSHA512:hashSequence] description];
    NSString *hash = [[[rawHash stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return hash;
}

- (NSData *) createSHA512:(NSString *)source {
    
    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
    CC_SHA512(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    NSLog(@"out --------- %@",output);
    return output;
}



#pragma mark - Completeion callbacks

-(void)transactionCompletedWithResponse:(NSDictionary*)response
                       errorDescription:(NSError* )error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"congrats! Payment is Successful"];
}

/*!
 * Transaction failure occured. Check Payment details in response. error shows any error
 if api failed.
 */
-(void)transactinFailedWithResponse:(NSDictionary* )response
                   errorDescription:(NSError* )error {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Oops!!! Payment Failed"];
}

-(void)transactinExpiredWithResponse: (NSString *)msg {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Trasaction expired!"];
}

/*!
 * Transaction cancelled by user.
 */
-(void)transactinCanceledByUser {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showAlertViewWithTitle:@"Message" message:@"Payment Cancelled!"];
}

#pragma mark - Helper methods

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}




#pragma mark - ViewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
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
