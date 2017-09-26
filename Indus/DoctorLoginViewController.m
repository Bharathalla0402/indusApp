//
//  DoctorLoginViewController.m
//  Indus
//
//  Created by think360 on 14/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "DoctorLoginViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "VerifyOtpViewController.h"
#import "DejalActivityView.h"

@interface DoctorLoginViewController ()<ApiRequestdelegate,UITextFieldDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    
    ACFloatingTextField *txtPhone;
}

@end

@implementation DoctorLoginViewController

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
    titlelab.text=@"Doctor Login";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.textColor=[UIColor colorWithRed:241.0/255.0f green:110.0/255.0f blue:69.0/255.0f alpha:1.0];
    [topView addSubview:titlelab];
    
    
    UIImageView *topimage=[[UIImageView alloc] initWithFrame:CGRectMake(topView.frame.size.width-50, topView.frame.size.height/2-12, 40, 40)];
    topimage.image=[UIImage imageNamed:@"intro_logo.png"];
    topimage.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:topimage];
    

    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    [self.view addSubview:categoryScrollView];
    
    
    UILabel *textlab=[[UILabel alloc] initWithFrame:CGRectMake(15, 30, self.view.frame.size.width-30, 50)];
    textlab.text=@"Enter your Registered Mobile Number";
    textlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    textlab.textAlignment=NSTextAlignmentCenter;
    textlab.numberOfLines=0;
    textlab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:textlab];
    
    
    
    txtPhone=[[ACFloatingTextField alloc]initWithFrame:CGRectMake(15, textlab.frame.size.height+textlab.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Mobile" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
    txtPhone.attributedPlaceholder = str3;
    txtPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtPhone.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtPhone.backgroundColor=[UIColor clearColor];
    txtPhone.delegate=self;
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    txtPhone.returnKeyType = UIReturnKeyDone;
    [categoryScrollView addSubview:txtPhone];
    
    
    UIButton *LoginButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y+70, self.view.frame.size.width-30, 50)];
    LoginButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [LoginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    LoginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    LoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [LoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:LoginButton];
    
    
    UILabel *Loginlab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-125, LoginButton.frame.size.height+LoginButton.frame.origin.y+20, 176, 20)];
    Loginlab.text=@"Don't have an Account?";
    Loginlab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    Loginlab.textAlignment=NSTextAlignmentCenter;
    Loginlab.numberOfLines=0;
    Loginlab.textColor=[UIColor darkGrayColor];
    [categoryScrollView addSubview:Loginlab];
    
    UIButton *RegisterButton=[[UIButton alloc] initWithFrame:CGRectMake(Loginlab.frame.size.width+Loginlab.frame.origin.x, LoginButton.frame.size.height+LoginButton.frame.origin.y+20, 60, 20)];
    RegisterButton.backgroundColor=[UIColor clearColor];
    [RegisterButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    RegisterButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    RegisterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [RegisterButton setTitleColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [RegisterButton addTarget:self action:@selector(RegisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:RegisterButton];
    
    UILabel *LoginUnderlab=[[UILabel alloc] initWithFrame:CGRectMake(Loginlab.frame.size.width+Loginlab.frame.origin.x, RegisterButton.frame.size.height+RegisterButton.frame.origin.y, RegisterButton.frame.size.width, 2)];
    LoginUnderlab.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:LoginUnderlab];
    
    
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarButtonItemStyleDone;
    numberToolbar.tintColor=[UIColor whiteColor];
    numberToolbar.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:0.5];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    txtPhone.inputAccessoryView=numberToolbar;
    [self setupOutlets1];
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 470);
}


-(void)doneWithNumberPad
{
    [txtPhone resignFirstResponder];
}


#pragma mark - Register Button Clicked

-(IBAction)RegisterButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Login Button Clicked

-(IBAction)LoginButtonClicked:(id)sender
{
    if (txtPhone.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Mobile Number" withTitle:@"Warning"];
    }
    else if (![self myMobileNumberValidate:txtPhone.text])
    {
        [requested showMessage:@"Please Enter 10 Digit Mobile Number" withTitle:@"Warning"];
    }
    else
    {
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *strDevicetoken=[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        NSString *post = [NSString stringWithFormat:@"mobile=%@&device_type=%@&deviceId=%@",txtPhone.text,@"ios",strDevicetoken];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,userLogin];
        [requested sendRequest:post withUrl:strurl];
    }
}

-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        VerifyOtpViewController *otp=[self.storyboard instantiateViewControllerWithIdentifier:@"VerifyOtpViewController"];
        otp.strDoctorId=[NSString stringWithFormat:@"%@",[[responseToken valueForKey:@"data"] valueForKey:@"doctor_id"]];
        [self.navigationController pushViewController:otp animated:YES];
    }
    else
    {
         NSString *strMessage=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"message"]];
        
        if ([strMessage isEqualToString:@"User Not Exists"])
        {
            [requested showMessage:@"User Does Not Exists" withTitle:@"Indus"];
        }
        else
        {
           [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@"Indus"];
        }
    }
}



- (BOOL)myMobileNumberValidate:(NSString*)number
{
    NSString *numberRegEx = @"[0-9]{10}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegEx];
    if ([numberTest evaluateWithObject:number] == YES)
        return TRUE;
    else
        return FALSE;
}

#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextField Delegates

- (void)setupOutlets1
{
    txtPhone.delegate=self;
    txtPhone.tag=1;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [(ACFloatingTextField *)textField textFieldDidBeginEditing];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [(ACFloatingTextField *)textField textFieldDidEndEditing];
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
