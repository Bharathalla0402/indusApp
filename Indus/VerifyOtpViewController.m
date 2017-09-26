//
//  VerifyOtpViewController.m
//  Indus
//
//  Created by think360 on 14/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "VerifyOtpViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "DejalActivityView.h"
#import "ReferPatientViewController.h"
#import "UserInformation.h"

@interface VerifyOtpViewController ()<ApiRequestdelegate,UITextFieldDelegate>
{
     UserInformation *userInfo;
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    
    ACFloatingTextField *txt1,*txt2,*txt3,*txt4;
    NSString *strcode;
}
@end

@implementation VerifyOtpViewController

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
    titlelab.text=@"Verification";
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
    
    
    UIImageView *topLogoimage=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 15, 80, 80)];
    topLogoimage.image=[UIImage imageNamed:@"verification_otp.png"];
    topLogoimage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:topLogoimage];
    
    UILabel *labeltext2=[[UILabel alloc] initWithFrame:CGRectMake(15, topLogoimage.frame.size.height+topLogoimage.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    labeltext2.text=@"Check your message and enter OTP below";
    labeltext2.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    labeltext2.textAlignment=NSTextAlignmentCenter;
    labeltext2.numberOfLines=0;
    labeltext2.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:labeltext2];
    
    
    txt1=[[ACFloatingTextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-139.5, labeltext2.frame.size.height+labeltext2.frame.origin.y+25, 60, 40)];
    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    [txt1 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
    [txt1 addTarget:self action:@selector(productNameTFChange2:) forControlEvents:UIControlEventEditingDidBegin];
    txt1.attributedPlaceholder = str4;
    txt1.textAlignment = NSTextAlignmentCenter;
    txt1.textColor=[UIColor blueColor];
    txt1.font = [UIFont systemFontOfSize:17];
    txt1.backgroundColor=[UIColor clearColor];
    txt1.secureTextEntry=YES;
    txt1.delegate=self;
    [txt1 setKeyboardType:UIKeyboardTypeNumberPad];
    txt1.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txt1];
    
    
    txt2=[[ACFloatingTextField alloc]initWithFrame:CGRectMake(txt1.frame.size.width+txt1.frame.origin.x+10, labeltext2.frame.size.height+labeltext2.frame.origin.y+25, 60, 40)];
    NSAttributedString *str5 = [[NSAttributedString alloc] initWithString:@"" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    [txt2 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
     [txt2 addTarget:self action:@selector(productNameTFChange2:) forControlEvents:UIControlEventEditingDidBegin];
    txt2.attributedPlaceholder = str5;
    txt2.textAlignment = NSTextAlignmentCenter;
    txt2.textColor=[UIColor blueColor];
    txt2.font = [UIFont systemFontOfSize:17];
    txt2.backgroundColor=[UIColor clearColor];
    txt2.secureTextEntry=YES;
    txt2.delegate=self;
    [txt2 setKeyboardType:UIKeyboardTypeNumberPad];
    txt2.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txt2];
    
    txt3=[[ACFloatingTextField alloc]initWithFrame:CGRectMake(txt2.frame.size.width+txt2.frame.origin.x+10, labeltext2.frame.size.height+labeltext2.frame.origin.y+25, 60, 40)];
    NSAttributedString *str6 = [[NSAttributedString alloc] initWithString:@"" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    [txt3 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
     [txt3 addTarget:self action:@selector(productNameTFChange2:) forControlEvents:UIControlEventEditingDidBegin];
    txt3.attributedPlaceholder = str6;
    txt3.textAlignment = NSTextAlignmentCenter;
    txt3.textColor=[UIColor blueColor];
    txt3.font = [UIFont systemFontOfSize:17];
    txt3.backgroundColor=[UIColor clearColor];
    txt3.secureTextEntry=YES;
    txt3.delegate=self;
    [txt3 setKeyboardType:UIKeyboardTypeNumberPad];
    txt3.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txt3];
    
    
    txt4=[[ACFloatingTextField alloc]initWithFrame:CGRectMake(txt3.frame.size.width+txt3.frame.origin.x+10, labeltext2.frame.size.height+labeltext2.frame.origin.y+25, 60, 40)];
    NSAttributedString *str7 = [[NSAttributedString alloc] initWithString:@"" attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
    [txt4 addTarget:self action:@selector(productNameTFChange:) forControlEvents:UIControlEventEditingChanged];
     [txt4 addTarget:self action:@selector(productNameTFChange2:) forControlEvents:UIControlEventEditingDidBegin];
    txt4.attributedPlaceholder = str7;
    txt4.textAlignment = NSTextAlignmentCenter;
    txt4.textColor=[UIColor blueColor];
    txt4.font = [UIFont systemFontOfSize:17];
    txt4.backgroundColor=[UIColor clearColor];
    txt4.secureTextEntry=YES;
    txt4.delegate=self;
    [txt4 setKeyboardType:UIKeyboardTypeNumberPad];
    txt4.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txt4];
    
  
    
    
    UIButton *VerifyButton=[[UIButton alloc] initWithFrame:CGRectMake(15, txt4.frame.size.height+txt4.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    VerifyButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [VerifyButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    VerifyButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    VerifyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [VerifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [VerifyButton addTarget:self action:@selector(VerifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:VerifyButton];
    
    
    
    UIButton *ResendButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60, VerifyButton.frame.size.height+VerifyButton.frame.origin.y+15, 120, 20)];
    ResendButton.backgroundColor=[UIColor clearColor];
    [ResendButton setTitle:@"Send OTP again" forState:UIControlStateNormal];
    ResendButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    ResendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [ResendButton setTitleColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [ResendButton addTarget:self action:@selector(ResendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:ResendButton];
    
    UILabel *LoginUnderlab=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-58, ResendButton.frame.size.height+ResendButton.frame.origin.y, 116, 2)];
    LoginUnderlab.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:LoginUnderlab];
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.tintColor=[UIColor whiteColor];
    numberToolbar.backgroundColor=[UIColor colorWithRed:90.0/255.0f green:143.0/255.0f blue:63.0/255.0f alpha:1.0];
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];
    
    txt1.inputAccessoryView = numberToolbar;
    txt2.inputAccessoryView=numberToolbar;
    txt3.inputAccessoryView=numberToolbar;
    txt4.inputAccessoryView=numberToolbar;
    
    [self setupOutlets1];
    [txt1 becomeFirstResponder];
    txt2.userInteractionEnabled=NO;
    txt3.userInteractionEnabled=NO;
    txt4.userInteractionEnabled=NO;
    
}

-(void)doneWithNumberPad
{
    [txt1 resignFirstResponder];
    [txt2 resignFirstResponder];
    [txt3 resignFirstResponder];
    [txt4 resignFirstResponder];
}


#pragma mark - Submit Clicked

-(IBAction)VerifyButtonClicked:(id)sender
{
    if (txt1.text.length==0)
    {
        [requested showMessage:@"Please Enter Valid OTP" withTitle:@"Warning"];
    }
    else if(txt2.text.length==0)
    {
        [requested showMessage:@"Please Enter Valid OTP" withTitle:@"Warning"];
    }
    else if(txt3.text.length==0)
    {
        [requested showMessage:@"Please Enter Valid OTP" withTitle:@"Warning"];
    }
    else if(txt4.text.length==0)
    {
        [requested showMessage:@"Please Enter Valid OTP" withTitle:@"Warning"];
    }
    else
    {
        NSString *strOtp=[NSString stringWithFormat:@"%@%@%@%@",txt1.text,txt2.text,txt3.text,txt4.text];
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@&otp=%@",_strDoctorId,strOtp];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,verifyOtp];
        [requested sendRequest:post withUrl:strurl];
    }
        
}

-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    NSLog(@"%@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        
        [[UserInformation sharedController] updateuserinfo:responseToken];
        
        NSData *encode = [NSKeyedArchiver archivedDataWithRootObject:[UserInformation sharedController]];
        [[NSUserDefaults standardUserDefaults] setObject:encode forKey:@"DocId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        [[NSUserDefaults standardUserDefaults]setObject:_strDoctorId forKey:@"DoctorId"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",_strDoctorId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,referralHistory];
        [requested sendRequest2:post withUrl:strurl];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}


-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSLog(@"Response: %@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        ReferPatientViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"ReferPatientViewController"];
        refer.arrChildCategory=[responseToken valueForKey:@"data"];
        refer.strpage=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"next"]];
        [self.navigationController pushViewController:refer animated:YES];
    }
    else
    {
        ReferPatientViewController *refer=[self.storyboard instantiateViewControllerWithIdentifier:@"ReferPatientViewController"];
        [self.navigationController pushViewController:refer animated:YES];
    }
}



#pragma mark - Resend Clicked

-(IBAction)ResendButtonClicked:(id)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *post = [NSString stringWithFormat:@"doctor_id=%@",_strDoctorId];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,resendOtp];
    [requested sendRequest1:post withUrl:strurl];
}

-(void)responsewithToken1:(NSMutableDictionary *)responseToken
{
    NSLog(@"Resend Response: %@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        
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



#pragma mark - TextField Delegates

- (void)setupOutlets1
{
    txt1.delegate=self;
    txt1.tag=1;
    
    txt2.delegate=self;
    txt2.tag=2;
    
    txt3.delegate=self;
    txt3.tag=3;
    
    txt4.delegate=self;
    txt4.tag=4;
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

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -100;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if ((textField.text.length >= 1) && (string.length > 0))
//    {
//        NSInteger nextTag = textField.tag + 1;
//        // Try to find next responder
//        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//        if (! nextResponder)
//            nextResponder = [textField.superview viewWithTag:1];
//        
//        if (nextResponder)
//            // Found next responder, so set it.
//            [nextResponder becomeFirstResponder];
//        
//        return NO;
//    }
//    return YES;
//}


//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSString *passcode = [textField text];
//    passcode = [passcode stringByReplacingCharactersInRange:range withString:string];
//    
//    switch ([passcode length]) {
//        case 0:
//            txt1.text = nil;
//            txt2.text = nil;
//            txt3.text = nil;
//            txt4.text = nil;
//            break;
//        case 1:
//            txt1.text = @"*";
//            txt2.text = nil;
//            txt3.text = nil;
//            txt4.text = nil;
//            break;
//        case 2:
//            txt1.text = @"*";
//            txt2.text = @"*";
//            txt3.text = nil;
//            txt4.text = nil;
//            break;
//        case 3:
//            txt1.text = @"*";
//            txt2.text = @"*";
//            txt3.text = @"*";
//            txt4.text = nil;
//            break;
//        case 4:
//            txt1.text = @"*";
//            txt2.text = @"*";
//            txt3.text = @"*";
//            txt4.text = @"*";
//            
//            // Notify delegate a little later so we have a chance to show the 4th bullet
//        
//            
//            return NO;
//            
//            break;
//        default:
//            break;
//    }
//    
//    return YES;
//}





-(void)productNameTFChange:(UITextField *)sender
{
    if (sender==txt1)
    {
        
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
             txt2.userInteractionEnabled=YES;
            [txt2 becomeFirstResponder];
           
        }
    }
    else if (sender==txt2)
    {
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
             txt3.userInteractionEnabled=YES;
            [txt3 becomeFirstResponder];
        }
    }
    else if (sender==txt3)
    {
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
             txt4.userInteractionEnabled=YES;
            [txt4 becomeFirstResponder];
        }
    }
    else if (sender==txt4)
    {
        if (sender.text.length>0 && ![sender.text isEqualToString:@" "])
        {
            [txt4 resignFirstResponder];
            strcode=[NSString stringWithFormat:@"%@%@%@%@",txt1.text,txt2.text,txt3.text,txt4.text];
            // [self verifyOTPmethod];
        }
    }
}

-(void)productNameTFChange2:(UITextField *)sender
{
    
}



#pragma mark - Warnings



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
