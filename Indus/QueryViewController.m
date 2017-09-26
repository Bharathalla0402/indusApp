//
//  QueryViewController.m
//  Indus
//
//  Created by think360 on 14/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "QueryViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "ACFloatingTextField.h"
#import "BookAppointmentViewController.h"
#import "UIFloatLabelTextField.h"
#import "DejalActivityView.h"
#import "NotificationViewController.h"

@interface QueryViewController ()<ApiRequestdelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL showPlaceHolder;
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
     UIButton *NotificationButton;
    
    UIFloatLabelTextField *txtName,*txtEmail,*txtPhone,*txtDescription;
    
    UIImageView *feedImage,*enquiryImage,*complaintImage;
    
    UITextView *txtadDesc;
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5,*linelabel55;
    NSString *strfeedbacktype;
}

@end

@implementation QueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    strfeedbacktype=@"0";
    
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
    titlelab.text=@"Feedback/Query";
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
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 67, self.view.frame.size.width, self.view.frame.size.height-120)];
    [self.view addSubview:categoryScrollView];
    
    
    UILabel *textlab=[[UILabel alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-30, 30)];
    textlab.text=@"TYPE OF QUERY *";
    textlab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    textlab.textAlignment=NSTextAlignmentLeft;
    textlab.numberOfLines=0;
    textlab.textColor=[UIColor blackColor];
    [categoryScrollView addSubview:textlab];

    
    feedImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, textlab.frame.size.height+textlab.frame.origin.y+15, 30, 30)];
    feedImage.image=[UIImage imageNamed:@"selected-radio.png"];
    feedImage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:feedImage];
    
    UILabel *feedbacklab=[[UILabel alloc]initWithFrame:CGRectMake(feedImage.frame.size.width+feedImage.frame.origin.x, textlab.frame.size.height+textlab.frame.origin.y+15, 70, 30)];
    feedbacklab.text=@"Feedback";
    feedbacklab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:feedbacklab];
    
    UIButton *feedbackbutt=[[UIButton alloc] initWithFrame:CGRectMake(10 , textlab.frame.size.height+textlab.frame.origin.y+15, 90, 30)];
    [feedbackbutt addTarget:self action:@selector(FeedbackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    feedbackbutt.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:feedbackbutt];
    
    
    enquiryImage=[[UIImageView alloc]initWithFrame:CGRectMake(feedbacklab.frame.size.width+feedbacklab.frame.origin.x+5, textlab.frame.size.height+textlab.frame.origin.y+15, 30, 30)];
    enquiryImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    enquiryImage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:enquiryImage];
    
    UILabel *Enquirylab=[[UILabel alloc]initWithFrame:CGRectMake(enquiryImage.frame.size.width+enquiryImage.frame.origin.x, textlab.frame.size.height+textlab.frame.origin.y+15, 60, 30)];
    Enquirylab.text=@"Enquiry";
    Enquirylab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:Enquirylab];
    
    UIButton *Enquirybutt=[[UIButton alloc] initWithFrame:CGRectMake(feedbacklab.frame.size.width+feedbacklab.frame.origin.x+5, textlab.frame.size.height+textlab.frame.origin.y+15, 85, 30)];
    [Enquirybutt addTarget:self action:@selector(EnquiryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    Enquirybutt.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:Enquirybutt];
    
    
    
    complaintImage=[[UIImageView alloc]initWithFrame:CGRectMake(Enquirylab.frame.size.width+Enquirylab.frame.origin.x+5, textlab.frame.size.height+textlab.frame.origin.y+15, 30, 30)];
    complaintImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    complaintImage.contentMode = UIViewContentModeScaleAspectFit;
    [categoryScrollView addSubview:complaintImage];
    
    UILabel *Complaintlab=[[UILabel alloc]initWithFrame:CGRectMake(complaintImage.frame.size.width+complaintImage.frame.origin.x, textlab.frame.size.height+textlab.frame.origin.y+15, 80, 30)];
    Complaintlab.text=@"Complaint";
    Complaintlab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    [categoryScrollView addSubview:Complaintlab];
    
    UIButton *Complaintbutt=[[UIButton alloc] initWithFrame:CGRectMake(Enquirylab.frame.size.width+Enquirylab.frame.origin.x+5, textlab.frame.size.height+textlab.frame.origin.y+15, 105, 30)];
    [Complaintbutt addTarget:self action:@selector(ComplaintButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    Complaintbutt.backgroundColor=[UIColor clearColor];
    [categoryScrollView addSubview:Complaintbutt];
    
    
    
    txtName=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, Enquirylab.frame.size.height+Enquirylab.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtName.placeholder=@"Name *";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtName.attributedPlaceholder = str1;
    txtName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtName.font =[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtName.backgroundColor=[UIColor clearColor];
    txtName.delegate=self;
    txtName.returnKeyType = UIReturnKeyNext;
    [categoryScrollView addSubview:txtName];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtName.frame.size.height+txtName.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel2];
    
    
    txtEmail=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtName.frame.size.height+txtName.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtEmail.placeholder=@"Email *";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel3];
    
    
    
    txtPhone=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtEmail.frame.size.height+txtEmail.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    txtPhone.placeholder=@"Contact Number *";
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtPhone.attributedPlaceholder = str3;
    txtPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtPhone.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtPhone.backgroundColor=[UIColor clearColor];
    txtPhone.delegate=self;
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    txtPhone.returnKeyType = UIReturnKeyDone;
    [categoryScrollView addSubview:txtPhone];
    
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel4];
    
    
    txtDescription=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtPhone.frame.size.height+txtPhone.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtDescription.placeholder=@"Description *";
    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDescription.attributedPlaceholder = str4;
    txtDescription.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDescription.font =[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDescription.backgroundColor=[UIColor clearColor];
    txtDescription.delegate=self;
    txtDescription.returnKeyType = UIReturnKeyDone;
    [categoryScrollView addSubview:txtDescription];
    
    linelabel55=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDescription.frame.size.height+txtDescription.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel55.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView addSubview:linelabel55];


    
    UILabel *Typelab=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y+30, 120, 30)];
    Typelab.text=@"Description";
    Typelab.font=[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    Typelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    Typelab.hidden=YES;
    [categoryScrollView addSubview:Typelab];
    
    
    txtadDesc=[[UITextView alloc]initWithFrame:CGRectMake(10, Typelab.frame.size.height+Typelab.frame.origin.y+5, self.view.frame.size.width-20, 150)];
    txtadDesc.textAlignment=NSTextAlignmentNatural;
    [self setPlaceholder];
    txtadDesc.layer.borderColor=[[UIColor clearColor]CGColor];
    txtadDesc.layer.borderWidth=1.0;
    txtadDesc.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtadDesc.font = [UIFont systemFontOfSize:15];
    txtadDesc.backgroundColor=[UIColor clearColor];
    txtadDesc.delegate=self;
    txtadDesc.hidden=YES;
    [categoryScrollView addSubview:txtadDesc];
    
    linelabel5=[[UILabel alloc] initWithFrame:CGRectMake(15, txtadDesc.frame.size.height+txtadDesc.frame.origin.y+2, self.view.frame.size.width-30, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    linelabel5.hidden=YES;
    [categoryScrollView addSubview:linelabel5];
    
    
    UIButton *SubmitButton=[[UIButton alloc] initWithFrame:CGRectMake(15, linelabel55.frame.size.height+linelabel55.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    SubmitButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [SubmitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    SubmitButton.titleLabel.font =[UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    SubmitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitButton addTarget:self action:@selector(SubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:SubmitButton];
    
    
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

    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 550);
}

- (void)setPlaceholder
{
    txtadDesc.text = NSLocalizedString(@"Tap to start typing...", @"placeholder");
    txtadDesc.textColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    showPlaceHolder = YES;
}

-(void)doneWithNumberPad
{
    [txtPhone resignFirstResponder];
}


#pragma mark - RadioButtons Clicked

-(IBAction)FeedbackButtonClicked:(id)sender
{
    strfeedbacktype=@"0";
    feedImage.image=[UIImage imageNamed:@"selected-radio.png"];
    enquiryImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    complaintImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
}


-(IBAction)EnquiryButtonClicked:(id)sender
{
     strfeedbacktype=@"1";
    feedImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    enquiryImage.image=[UIImage imageNamed:@"selected-radio.png"];
    complaintImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
}

-(IBAction)ComplaintButtonClicked:(id)sender
{
     strfeedbacktype=@"2";
    feedImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    enquiryImage.image=[UIImage imageNamed:@"unselected-radio.png.png"];
    complaintImage.image=[UIImage imageNamed:@"selected-radio.png"];
}



#pragma mark - Submit button Clicked

-(IBAction)SubmitButtonClicked:(id)sender
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
    else if (txtDescription.text.length==0)
    {
        [requested showMessage:@"Please Enter Your Description" withTitle:@"Warning"];
    }
    else
    {
        NSString *string = txtEmail.text;
        string = [string stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceCharacterSet]];
        
        txtEmail.text=string;
        
        NSString *strtit=[NSString stringWithFormat:@"%@",txtName.text];
        NSString *strdes=[NSString stringWithFormat:@"%@",txtDescription.text];
        
        NSString *encodetitle=[strtit stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        NSString *encodeDescription=[strdes stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
        
        encodetitle=[strtit stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        encodeDescription=[strdes stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
        
        [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
        NSString *post = [NSString stringWithFormat:@"name=%@&email=%@&phone=%@&comments=%@&type=%@",encodetitle,txtEmail.text,txtPhone.text,encodeDescription,strfeedbacktype];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,feedback];
        [requested sendRequest:post withUrl:strurl];
    }
}

-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@"Indus"];
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





#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TextView Delegate Methods

- (void)textViewDidBeginEditing:(UITextView *)txtView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    if (showPlaceHolder == YES)
    {
        txtadDesc.textColor = [UIColor blueColor];
        txtadDesc.text = @"";
        showPlaceHolder = NO;
    }
    
    if (txtadDesc.text.length == 0)
    {
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else
    {
        linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (txtadDesc.text.length == 0)
    {
        [self setPlaceholder];
        linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    }
    else
    {
       linelabel5.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


- (void)resignKeyboard
{
    [txtadDesc resignFirstResponder];
    if (txtadDesc.text.length == 0)
    {
        [self setPlaceholder];
    }
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
    
    txtDescription.delegate=self;
    txtDescription.tag=4;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str1;
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
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str1;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtDescription)
    {
        if ([txtDescription.text isEqual:@""])
        {
            linelabel55.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtDescription.attributedPlaceholder = str4;
            txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel55.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
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
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Email *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtEmail.attributedPlaceholder = str1;
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
            linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Contact Number *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtPhone.attributedPlaceholder = str1;
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel4.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
    }
    else if (textField==txtDescription)
    {
        if ([txtDescription.text isEqual:@""])
        {
            linelabel55.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here *" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
            txtDescription.attributedPlaceholder = str4;
            txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        }
        else
        {
            linelabel55.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
            txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
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
