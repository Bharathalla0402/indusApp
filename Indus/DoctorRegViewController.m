//
//  DoctorRegViewController.m
//  Indus
//
//  Created by think360 on 14/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "DoctorRegViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DoctorLoginViewController.h"
#import "VerifyOtpViewController.h"
#import "DejalActivityView.h"
#import "UIFloatLabelTextField.h"

@interface DoctorRegViewController ()<ApiRequestdelegate,UITextFieldDelegate>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    
   // ACFloatingTextField *txtName,*txtEmail,*txtPhone;
    
    UIFloatLabelTextField *txtName,*txtEmail,*txtPhone;
    
    UILabel *linelabel2,*linelabel3,*linelabel4;
}
@end

@implementation DoctorRegViewController

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
    titlelab.text=@"Doctor Register";
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
    
    
    UILabel *textlab=[[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.view.frame.size.width-30, 50)];
    textlab.text=@"Enter your Registration Information";
    textlab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    textlab.textAlignment=NSTextAlignmentCenter;
    textlab.numberOfLines=0;
    textlab.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:textlab];
    
    
    txtName=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, textlab.frame.size.height+textlab.frame.origin.y+30, self.view.frame.size.width-20, 50)];
    txtName.placeholder = @"Name";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
    txtName.attributedPlaceholder = str1;
    txtName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtName.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtName.backgroundColor=[UIColor clearColor];
    txtName.delegate=self;
    txtName.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtName];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtName.frame.size.height+txtName.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    
    txtEmail=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtName.frame.size.height+txtName.frame.origin.y+30, self.view.frame.size.width-20, 50)];
     txtEmail.placeholder = @"Email";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
    txtEmail.attributedPlaceholder = str2;
    txtEmail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtEmail.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtEmail.backgroundColor=[UIColor clearColor];
    txtEmail.delegate=self;
    [txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    txtEmail.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtEmail];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtEmail.frame.size.height+txtEmail.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    
    
    txtPhone=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtEmail.frame.size.height+txtEmail.frame.origin.y+30, self.view.frame.size.width-20, 50)];
    txtPhone.placeholder = @"Mobile";
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Mobile" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
    txtPhone.attributedPlaceholder = str3;
    txtPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtPhone.font = [UIFont systemFontOfSize:17];
    txtPhone.backgroundColor=[UIColor clearColor];
    txtPhone.delegate=self;
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    txtPhone.returnKeyType = UIReturnKeyDone;
    [categoryScrollView addSubview:txtPhone];
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    
    UIButton *RegisterButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    RegisterButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [RegisterButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    RegisterButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    RegisterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [RegisterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RegisterButton addTarget:self action:@selector(RegisterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:RegisterButton];
    
    
    UILabel *Loginlab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-137, RegisterButton.frame.size.height+RegisterButton.frame.origin.y+20, 204, 20)];
    Loginlab.text=@"Already have an Account?";
    Loginlab.font=[UIFont fontWithName:@"OpenSans-Regular" size:16.0];
    Loginlab.textAlignment=NSTextAlignmentCenter;
    Loginlab.numberOfLines=0;
    Loginlab.textColor=[UIColor darkGrayColor];
    [categoryScrollView addSubview:Loginlab];
    
    UIButton *LoginButton=[[UIButton alloc] initWithFrame:CGRectMake(Loginlab.frame.size.width+Loginlab.frame.origin.x, RegisterButton.frame.size.height+RegisterButton.frame.origin.y+20, 54, 20)];
    LoginButton.backgroundColor=[UIColor clearColor];
    [LoginButton setTitle:@"Sign in" forState:UIControlStateNormal];
    LoginButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    LoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [LoginButton setTitleColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [LoginButton addTarget:self action:@selector(LoginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:LoginButton];
    
    UILabel *LoginUnderlab=[[UILabel alloc] initWithFrame:CGRectMake(Loginlab.frame.size.width+Loginlab.frame.origin.x, LoginButton.frame.size.height+LoginButton.frame.origin.y, LoginButton.frame.size.width, 2)];
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
    if (txtName.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Name" withTitle:@"Warning"];
    }
    else if (txtEmail.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Email Id" withTitle:@"Warning"];
    }
    else if (![self NSStringIsValidEmail:txtEmail.text])
    {
        [requested showMessage:@"Please Enter Valid Email Id" withTitle:@"Warning"];
    }
    else if (txtPhone.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Mobile Number" withTitle:@"Warning"];
    }
    else if (![self myMobileNumberValidate:txtPhone.text])
    {
        [requested showMessage:@"Please Enter 10 Digit Mobile Number" withTitle:@"Warning"];
    }
    else
    {
        NSString *string = txtEmail.text;
        string = [string stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
        
        txtEmail.text=string;
        
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *strDevicetoken=[[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceToken"];
        NSString *post = [NSString stringWithFormat:@"name=%@&email=%@&mobile=%@&device_type=%@&deviceId=%@",txtName.text,txtEmail.text,txtPhone.text,@"ios",strDevicetoken];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,userRegister];
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
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}



#pragma mark - Validation

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    NSString *trimmedString = [checkString stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    return [emailTest evaluateWithObject:trimmedString];
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



#pragma mark - Login Button Clicked

-(IBAction)LoginButtonClicked:(id)sender
{
    DoctorLoginViewController *logi=[self.storyboard instantiateViewControllerWithIdentifier:@"DoctorLoginViewController"];
    [self.navigationController pushViewController:logi animated:YES];
}





#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextField Delegates

- (void)setupOutlets1
{
    txtName.delegate=self;
    txtName.tag=1;
    
    txtEmail.delegate=self;
    txtEmail.tag=2;
    
    txtPhone.delegate=self;
    txtPhone.tag=3;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
           NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str2;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Mobile" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]  }];
            txtPhone.attributedPlaceholder = str3;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
           linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else
    {
       [(ACFloatingTextField *)textField textFieldDidBeginEditing];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] }];
            txtName.attributedPlaceholder = str1;
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtEmail)
    {
        if ([txtEmail.text isEqual:@""])
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
            NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]  }];
            txtEmail.attributedPlaceholder = str2;
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel3.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtPhone)
    {
        if ([txtPhone.text isEqual:@""])
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
            
            NSAttributedString *str3= [[NSAttributedString alloc] initWithString:@"Mobile" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]  }];
            txtPhone.attributedPlaceholder = str3;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else
    {
        [(ACFloatingTextField *)textField textFieldDidBeginEditing];
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
