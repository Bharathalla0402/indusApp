//
//  PaymentStatusViewController.m
//  PaymentGateway
//
//  Created by Suraj on 30/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import "PaymentStatusViewController.h"
#import "MoreViewController.h"
#import "BookAppointmentViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "DejalActivityView.h"

@interface PaymentStatusViewController ()<ApiRequestdelegate>
{
    __weak IBOutlet UITextField *txtFieldProductInfo;
    __weak IBOutlet UITextField *txtFieldTransactionStatus;
    __weak IBOutlet UITextField *txtFieldTransactionID;
    __weak IBOutlet UITextField *txttransactionAmount;
    
     ApiRequest *requested;
}
@property (weak, nonatomic) IBOutlet UIButton *makeanother;

- (IBAction)popToPaymentPage:(id)sender;

@end

@implementation PaymentStatusViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self setTitle:@"Payment Status"];
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self setTitle:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"id=%@&transaction_id=%@&payment_method=%@",_strId,[_mutDictTransactionDetails valueForKey:@"Transaction_ID" ],@"PayUMoney"];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,RequestAppointment];
    [requested sendRequest2:post withUrl:strurl];
    
    [self setUserDataToUI];
}


-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserDataToUI {
    [txtFieldProductInfo setText:[self.mutDictTransactionDetails objectForKey:@"Payee_Name"]];
    [txtFieldTransactionStatus setText:[self.mutDictTransactionDetails objectForKey:@"Transaction_Status"]];
    [txtFieldTransactionID setText:[self.mutDictTransactionDetails objectForKey:@"Transaction_ID"]];
    
    txttransactionAmount.text=[NSString stringWithFormat:@"₹%@",[self.mutDictTransactionDetails objectForKey:@"Paid_Amount"]];
}
- (IBAction)AnotherBookingClick:(id)sender
{
//    BookAppointmentViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentViewController"];
//    [self.navigationController pushViewController:book animated:YES];
    
     [self.navigationController popToRootViewControllerAnimated:NO];
}
- (IBAction)gotoDashboardClick:(id)sender
{
   //   [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.window.rootViewController = tbc;
    tbc.selectedIndex=3;
    [self.window makeKeyAndVisible];
}

- (IBAction)popToPaymentPage:(id)sender {
   // [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
