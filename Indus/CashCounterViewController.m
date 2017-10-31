//
//  CashCounterViewController.m
//  Indus
//
//  Created by think360 on 09/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "CashCounterViewController.h"
#import "MoreViewController.h"
#import "BookAppointmentViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "DejalActivityView.h"

@interface CashCounterViewController ()<ApiRequestdelegate>
{
    ApiRequest *requested;
}
@end

@implementation CashCounterViewController


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self setTitle:@"Booking Status"];
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = YES;
    [self setTitle:@""];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    
    NSString *post = [NSString stringWithFormat:@"id=%@&payment_method=%@",_strId,@"Cash"];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,RequestAppointment];
    [requested sendRequest4:post withUrl:strurl];
    
    
    [[[self navigationController] navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
}

-(void)responsewithToken4:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        
    }
    else
    {
      //  [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


- (IBAction)AnotherBookingClick:(id)sender
{
//    BookAppointmentViewController *book=[self.storyboard instantiateViewControllerWithIdentifier:@"BookAppointmentViewController"];
//    [self.navigationController pushViewController:book animated:YES];
    
      [self.navigationController popToRootViewControllerAnimated:NO];
}
- (IBAction)gotoDashboardClick:(id)sender
{
  //  [self.navigationController popToRootViewControllerAnimated:NO];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"4" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    self.window.rootViewController = tbc;
    tbc.selectedIndex=3;
    [self.window makeKeyAndVisible];
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
