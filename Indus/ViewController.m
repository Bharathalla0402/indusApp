//
//  ViewController.m
//  Indus
//
//  Created by think360 on 13/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "ViewController.h"
#import "LCBannerView.h"
#import "TabBarController.h"
#import "ApiRequest.h"
#import "DejalActivityView.h"
#import "Indus.pch"

@interface ViewController ()<LCBannerViewDelegate,ApiRequestdelegate>
{
     ApiRequest *requested;
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
    
    UIView *popview5;
    UIView *footerview5;
    UIImageView *imagebig;
    UIScrollView *scrollView;
}
@property (nonatomic, weak) LCBannerView *bannerView1;
@property (nonatomic, weak) LCBannerView *bannerView2;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"HomeScreen"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
  //  [self.view setBackgroundColor:[UIColor clearColor]];
    [self CustomView];
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    
}


- (void)applicationIsActive:(NSNotification *)notification
{
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
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


-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrdata=[responseToken valueForKey:@"data"];
        
        
        textLab.text=[[responseToken valueForKey:@"data"] valueForKey:@"title"];
        textLab.numberOfLines=0;
        textLab.textColor=[UIColor whiteColor];
        textLab.font=[UIFont fontWithName:@"OpenSans-Bold" size:22.0];
        textLab.textAlignment=NSTextAlignmentCenter;
        CGRect textRect22 = [textLab.text boundingRectWithSize:textLab.frame.size
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:22.0]}
                                                                context:nil];
        CGSize size22 = textRect22.size;
        CGSize descriptionSize22 = [textLab sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size22.height)];
        textLab.frame = CGRectMake(10,imagebig.frame.size.height+imagebig.frame.origin.y+10, self.view.frame.size.width-20, descriptionSize22.height);
        textLab.textAlignment=NSTextAlignmentCenter;
        [scrollView addSubview:textLab];
       
       
        
        
        textLab2.text=[[responseToken valueForKey:@"data"] valueForKey:@"description"];
        textLab2.numberOfLines=0;
        textLab2.textColor=[UIColor whiteColor];
        textLab2.font=[UIFont fontWithName:@"OpenSans-Regular" size:18.0];
        textLab2.textAlignment=NSTextAlignmentCenter;
        CGRect textRect23 = [textLab2.text boundingRectWithSize:textLab2.frame.size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Regular" size:18.0]}
                                                       context:nil];
        CGSize size23 = textRect23.size;
        CGSize descriptionSize23 = [textLab2 sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size23.height)];
        textLab2.frame = CGRectMake(10,textLab.frame.size.height+textLab.frame.origin.y+10, self.view.frame.size.width-20, descriptionSize23.height);
        textLab2.textAlignment=NSTextAlignmentCenter;
        [scrollView addSubview:textLab2];
    }
    else
    {
      
        // [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}



#pragma mark - CustomView

-(void)CustomView
{
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        scrollView.contentSize = CGSizeMake(0, self.view.frame.size.height-50);
        [self.view addSubview:scrollView];
        
        
        [scrollView addSubview:({
            
            LCBannerView *bannerView = [[LCBannerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50)
                                                                  delegate:nil
                                                                 imageName:@"banner"
                                                                     count:2
                                                              timeInterval:3.0f
                                             currentPageIndicatorTintColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]
                                                    pageIndicatorTintColor:[UIColor whiteColor]];
            
            self.bannerView1 = bannerView;
        })];
    
    
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
        
        }
        else
        {
    
        }
    
    
        imagebig=[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-55, self.view.frame.size.height/2-150, 110, 110)];
        imagebig.image=[UIImage imageNamed:@"intro_logo.png"];
        imagebig.contentMode = UIViewContentModeScaleAspectFill;
        [scrollView addSubview:imagebig];
    
    
        textLab=[[UILabel alloc] init];
        textLab.text=@"";
        textLab.numberOfLines=0;
        textLab.textColor=[UIColor whiteColor];
        textLab.font=[UIFont fontWithName:@"OpenSans-Bold" size:22.0];
        textLab.textAlignment=NSTextAlignmentCenter;
        CGRect textRect22 = [textLab.text boundingRectWithSize:textLab.frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:22.0]}
                                                   context:nil];
        CGSize size22 = textRect22.size;
        CGSize descriptionSize22 = [textLab sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size22.height)];
        textLab.frame = CGRectMake(10,imagebig.frame.size.height+imagebig.frame.origin.y+10, self.view.frame.size.width-20, descriptionSize22.height);
        textLab.textAlignment=NSTextAlignmentCenter;
        [scrollView addSubview:textLab];
    
    
    
        textLab2=[[UILabel alloc] init];
        textLab2.text=@"";
        textLab2.numberOfLines=0;
        textLab2.textColor=[UIColor whiteColor];
        textLab2.font=[UIFont fontWithName:@"OpenSans-Regular" size:18.0];
        textLab2.textAlignment=NSTextAlignmentCenter;
        CGRect textRect23 = [textLab2.text boundingRectWithSize:textLab2.frame.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Regular" size:18.0]}
                                                    context:nil];
        CGSize size23 = textRect23.size;
        CGSize descriptionSize23 = [textLab2 sizeThatFits:CGSizeMake(self.view.frame.size.width-20,size23.height)];
        textLab2.frame = CGRectMake(10,textLab.frame.size.height+textLab.frame.origin.y+10, self.view.frame.size.width-20, descriptionSize23.height);
        textLab2.textAlignment=NSTextAlignmentCenter;
        [scrollView addSubview:textLab2];

    
    
        UIButton *BookButton=[[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-130, textLab2.frame.size.height+textLab2.frame.origin.y+5, 260, 50)];
        BookButton.backgroundColor=[UIColor colorWithRed:86.0/255.0f green:152.0/255.0f blue:113.0/255.0f alpha:0.7];
        [BookButton setTitle:@"BOOK YOUR APPOINTMENT" forState:UIControlStateNormal];
        BookButton.titleLabel.font =[UIFont fontWithName:@"OpenSans-Bold" size:16.0];
        [[BookButton layer] setBorderWidth:1.0f];
        [[BookButton layer] setBorderColor:[UIColor whiteColor].CGColor];
        BookButton.layer.cornerRadius = 4;
        BookButton.clipsToBounds = YES;
        BookButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [BookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [BookButton addTarget:self action:@selector(BookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        BookButton.hidden=YES;
        [scrollView addSubview:BookButton];
        
        
        UIView *bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
        bottomView.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
        [self.view addSubview:bottomView];
        
        UIView *view1=[[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width/4, 50)];
        view1.backgroundColor=[UIColor clearColor];
        [bottomView addSubview:view1];
        
        UIImageView *image1=[[UIImageView alloc] initWithFrame:CGRectMake(view1.frame.size.width/2-15, 2, 30, 30)];
        image1.image=[UIImage imageNamed:@"booking-white.png"];
        image1.contentMode = UIViewContentModeScaleAspectFill;
        [view1 addSubview:image1];
        
        UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(0, 33, view1.frame.size.width+7, 15)];
        label1.text=@"Appointments";
        label1.textColor=[UIColor whiteColor];
        label1.textAlignment=NSTextAlignmentCenter;
        label1.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        [view1 addSubview:label1];
        
        UIButton *Button1=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, view1.frame.size.width, view1.frame.size.height)];
        Button1.backgroundColor=[UIColor clearColor];
        [Button1 addTarget:self action:@selector(Button1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view1 addSubview:Button1];
        
        
        
        UIView *view2=[[UIView alloc] initWithFrame:CGRectMake(view1.frame.size.width+view1.frame.origin.x, 0, bottomView.frame.size.width/4, 50)];
        view2.backgroundColor=[UIColor clearColor];
        [bottomView addSubview:view2];
        
        UIImageView *image2=[[UIImageView alloc] initWithFrame:CGRectMake(view2.frame.size.width/2-15, 2, 30, 30)];
        image2.image=[UIImage imageNamed:@"package.png"];
        image2.contentMode = UIViewContentModeScaleAspectFill;
        [view2 addSubview:image2];
        
        UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(3, 33, view2.frame.size.width-6, 15)];
        label2.text=@"Packages";
        label2.textColor=[UIColor whiteColor];
        label2.textAlignment=NSTextAlignmentCenter;
        label2.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        [view2 addSubview:label2];
        
        UIButton *Button2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, view2.frame.size.width, view2.frame.size.height)];
        Button2.backgroundColor=[UIColor clearColor];
        [Button2 addTarget:self action:@selector(Button2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:Button2];
        
        
        UIView *view3=[[UIView alloc] initWithFrame:CGRectMake(view2.frame.size.width+view2.frame.origin.x, 0, bottomView.frame.size.width/4, 50)];
        view3.backgroundColor=[UIColor clearColor];
        [bottomView addSubview:view3];
        
        UIImageView *image3=[[UIImageView alloc] initWithFrame:CGRectMake(view3.frame.size.width/2-15, 2, 30, 30)];
        image3.image=[UIImage imageNamed:@"report.png"];
        image3.contentMode = UIViewContentModeScaleAspectFill;
        [view3 addSubview:image3];
        
        UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(3, 33, view3.frame.size.width-6, 15)];
        label3.text=@"Lab Reports";
        label3.textColor=[UIColor whiteColor];
        label3.textAlignment=NSTextAlignmentCenter;
        label3.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        [view3 addSubview:label3];
        
        UIButton *Button3=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, view3.frame.size.width, view3.frame.size.height)];
        Button3.backgroundColor=[UIColor clearColor];
        [Button3 addTarget:self action:@selector(Button3Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view3 addSubview:Button3];
        
        
        UIView *view4=[[UIView alloc] initWithFrame:CGRectMake(view3.frame.size.width+view3.frame.origin.x, 0, bottomView.frame.size.width/4, 50)];
        view4.backgroundColor=[UIColor clearColor];
        [bottomView addSubview:view4];
        
        UIImageView *image4=[[UIImageView alloc] initWithFrame:CGRectMake(view4.frame.size.width/2-15, 2, 30, 30)];
        image4.image=[UIImage imageNamed:@"more.png"];
        image4.contentMode = UIViewContentModeScaleAspectFill;
        [view4 addSubview:image4];
        
        UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake(3, 33, view4.frame.size.width-6, 15)];
        label4.text=@"More";
        label4.textColor=[UIColor whiteColor];
        label4.textAlignment=NSTextAlignmentCenter;
        label4.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
        [view4 addSubview:label4];
        
        UIButton *Button4=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, view4.frame.size.width, view4.frame.size.height)];
        Button4.backgroundColor=[UIColor clearColor];
        [Button4 addTarget:self action:@selector(Button4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [view4 addSubview:Button4];
        
}

-(void)NotificationApi
{
    
}




#pragma mark - Button1 Clicked
    
-(IBAction)Button1Clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    tbc.selectedIndex=0;
    [self.navigationController pushViewController:tbc animated:YES];
    
    
}
    
#pragma mark - Button2 Clicked
    
-(IBAction)Button2Clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
        
    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    tbc.selectedIndex=1;
    [self.navigationController pushViewController:tbc animated:YES];
    
    
}
    
#pragma mark - Button3 Clicked
    
-(IBAction)Button3Clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"2" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
        
    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    tbc.selectedIndex=2;
    [self.navigationController pushViewController:tbc animated:YES];
    
   
}
    
#pragma mark - Button4 Clicked
    
-(IBAction)Button4Clicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
        
    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    tbc.selectedIndex=3;
    [self.navigationController pushViewController:tbc animated:YES];
    
    
}


-(void)TipPopUp
{

    popview5.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);
    // popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    popview5.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.7];
    [self.window addSubview:popview5];
    
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
    
    
    footerview5=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    footerview5.backgroundColor = [UIColor clearColor];
    [popview5 addSubview:footerview5];
    
    
    UIImageView *imagebig=[[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-40, 80, 80, 80)];
    imagebig.image=[UIImage imageNamed:@"intro_logo.png"];
    imagebig.contentMode = UIViewContentModeScaleAspectFill;
    [footerview5 addSubview:imagebig];
    
    textLab=[[UILabel alloc] initWithFrame:CGRectMake(10, [UIScreen mainScreen].bounds.size.height/2-90, [UIScreen mainScreen].bounds.size.width-20, 60)];
    textLab.text=[arrdata valueForKey:@"title"];
    textLab.textColor=[UIColor whiteColor];
    textLab.numberOfLines=0;
    textLab.textAlignment=NSTextAlignmentCenter;
    textLab.font=[UIFont fontWithName:@"OpenSans-Bold" size:22.0];
    [footerview5 addSubview:textLab];
    
    textLab2=[[UILabel alloc] initWithFrame:CGRectMake(10, textLab.frame.size.height+textLab.frame.origin.y+10, [UIScreen mainScreen].bounds.size.width-20, 150)];
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
    popview5.hidden=YES;
    [footerview5 removeFromSuperview];
}

    
    

    
#pragma mark - Book your appointment Clicked
    
-(IBAction)BookButtonClicked:(id)sender
{
//    [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"Index"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//
//    [[NSUserDefaults standardUserDefaults]setObject:@"HomeBook" forKey:@"HomeScreen"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//    
//    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//    tbc.selectedIndex=3;
//    [self.navigationController pushViewController:tbc animated:YES];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"Index"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    TabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    tbc.selectedIndex=0;
    [self.navigationController pushViewController:tbc animated:YES];
}
    
    
#pragma mark - Warnings


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
