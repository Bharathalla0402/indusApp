//
//  ContactUsViewController.m
//  Indus
//
//  Created by think360 on 02/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "ContactUsViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "DejalActivityView.h"
#import "UIFloatLabelTextField.h"
#import "TabBarController.h"
#import "NotificationViewController.h"
#import "DropDownListView.h"
#import "LocationCell.h"

@interface ContactUsViewController ()<ApiRequestdelegate,UITextFieldDelegate,UITextViewDelegate,UITabBarControllerDelegate,kDropDownListViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    DropDownListView * Dropobj;
    UIView *popview;

    
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UIScrollView *categoryScrollView2;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    UILabel *titlelab;
    
    UIView *segmentView;
    UIButton *Locationbutton,*ContactUsbutton;
    
    UILabel *locationTitle,*locationAddress;
    
    TabBarController *tabbar;
    
    UIFloatLabelTextField *txtName,*txtEmail,*txtPhone,*txtDescription,*txtHoapital;
    UILabel *linelabel2,*linelabel3,*linelabel4,*linelabel5,*linelabel22,*linelabel55;
    NSMutableArray *arrHospital;
    
    UITextView *txtadDesc;
    BOOL showPlaceHolder;
    
    NSMutableArray *arrlocations;
    
    NSString *strAddress,*strHospitalId;
    
    UIButton *button2;
    UILabel *Typelab;
    
    UITableView *tabl;
    LocationCell *cell;
}
@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"CounNotification"
                                               object:nil];

    
    arrlocations=[[NSMutableArray alloc]init];
     arrHospital=[[NSMutableArray alloc]init];
    
    [self GetLocation];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    latitude=locationManager.location.coordinate.latitude;
    longitude=locationManager.location.coordinate.longitude;
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [self CustomView];
    
    [self setupAlertCtrl2];
}

- (void) receiveTestNotification:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *myObject = [userInfo objectForKey:@"count"];
    NoticationLab.text=[NSString stringWithFormat:@"%@",myObject];
}


- (void)setupAlertCtrl2
{
    self.alertCtrl2 = [UIAlertController alertControllerWithTitle:@"Please install Google Maps - Navigation & Transport app from iTunes store before Navigation"
                                                          message:nil
                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    //Create an action
    UIAlertAction *Report = [UIAlertAction actionWithTitle:@"Install"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action)
                             {
                                 [self handleMaps];
                             }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [self dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [self.alertCtrl2 addAction:Report];
    [self.alertCtrl2 addAction:cancel];
}

- (void)handleMaps
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/in/app/google-maps-navigation-transport/id585027354?mt=8"] options:@{} completionHandler:nil];
}


#pragma mark - GetLocations

-(void)GetLocation
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,getLocations];
  
    
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
                if(data != nil) {
                    NSError *err;
                    NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:NSUTF8StringEncoding error:&err];
                    [self responseSubCategory2:responseJSON];
                    [DejalBezelActivityView removeView];
                }
            }
        });
    }] resume];
}

-(void)responseSubCategory2:(NSMutableDictionary *)responseToken
{
    NSLog(@"%@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrlocations=[responseToken valueForKey:@"data"];
        
        [tabl reloadData];
        
        [self locationView];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
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
    
    titlelab=[[UILabel alloc] initWithFrame:CGRectMake(60, topView.frame.size.height/2-15, topView.frame.size.width-120, 40)];
    titlelab.text=@"Contact Us";
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
   // NotificationButton.userInteractionEnabled=NO;
    [topView addSubview:NotificationButton];
    
    
    UILabel *linelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, topView.frame.size.height-2, self.view.frame.size.width, 2)];
    linelabel.backgroundColor=[UIColor lightGrayColor];
    [topView addSubview:linelabel];
    
    
    UIView *segview=[[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height+topView.frame.origin.y, self.view.frame.size.width, 90)];
    segview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:segview];
    
    
    segmentView=[[UIView alloc]initWithFrame:CGRectMake(10, 15, self.view.frame.size.width-20, 60)];
    segmentView.layer.borderColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0].CGColor;
    segmentView.layer.borderWidth = 2.0f;
    segmentView.layer.cornerRadius=4;
    segmentView.backgroundColor=[UIColor whiteColor];
    [segview addSubview:segmentView];
    
    
    
    
   
    ContactUsbutton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, segmentView.frame.size.width/2, 60)];
    [ContactUsbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ContactUsbutton setTitle:@"Contact Us" forState:UIControlStateNormal];
    ContactUsbutton.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    [ContactUsbutton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16.0]];
    UIImage *image2= [UIImage imageNamed:@"31.png"];
    [ContactUsbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [ContactUsbutton setImage:[self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    ContactUsbutton.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [ContactUsbutton setImageEdgeInsets:UIEdgeInsetsMake(2, 0.0, 0.0, -ContactUsbutton.titleLabel.bounds.size.width+95)];
    [ContactUsbutton addTarget:self action:@selector(ContactUsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    ContactUsbutton.layer.cornerRadius=4;
    [segmentView addSubview:ContactUsbutton];
    
    
    
    Locationbutton=[[UIButton alloc] initWithFrame:CGRectMake(segmentView.frame.size.width/2, 0, segmentView.frame.size.width/2, 60)];
    [Locationbutton setTitleColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    [Locationbutton setTitle:@"Locations" forState:UIControlStateNormal];
    Locationbutton.backgroundColor=[UIColor clearColor];
    [Locationbutton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:16.0]];
    UIImage *image1= [UIImage imageNamed:@"Doclocation.png"];
    [Locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [Locationbutton setImage:[self imageWithImage:image1 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    Locationbutton.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [Locationbutton setImageEdgeInsets:UIEdgeInsetsMake(2, 0.0, 0.0, -Locationbutton.titleLabel.bounds.size.width+74)];
    [Locationbutton addTarget:self action:@selector(LocationsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    Locationbutton.layer.cornerRadius=4;
    [segmentView addSubview:Locationbutton];
    
  
    
    
    
    categoryScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, segview.frame.size.height+segview.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-197)];
    categoryScrollView.backgroundColor=[UIColor whiteColor];
    categoryScrollView.hidden=YES;
    [self.view addSubview:categoryScrollView];
    
  //  [self locationView];
    
    
    categoryScrollView2=[[UIScrollView alloc]initWithFrame:CGRectMake(0, segview.frame.size.height+segview.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-197)];
    categoryScrollView2.backgroundColor=[UIColor whiteColor];
  //  categoryScrollView2.hidden=YES;
    [self.view addSubview:categoryScrollView2];
    
    
    tabl=[[UITableView alloc] init];
    tabl.frame = CGRectMake(0,segview.frame.origin.y+segview.frame.size.height,self.view.frame.size.width,self.view.frame.size.height-210);
    tabl.delegate=self;
    tabl.dataSource=self;
    tabl.tag=3;
    tabl.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tabl.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tabl];
    
    
    
    
    // [self ContactUsView];
    
}



#pragma mark - Tableview delegate methodes

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrlocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellClassName = @"LocationCell";
    
    cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier: CellClassName];
    
    if (cell == nil)
    {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellClassName];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationCell"
                                                     owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *lbltitle=(UILabel *)[cell viewWithTag:1];
    UILabel *lbladdress=(UILabel *)[cell viewWithTag:2];
    UILabel *lblContact=(UILabel *)[cell viewWithTag:3];
    
    lbltitle.text=[[arrlocations valueForKey:@"title"] objectAtIndex:indexPath.row];
    lbladdress.text=[[arrlocations valueForKey:@"address"] objectAtIndex:indexPath.row];
    lblContact.text=[[arrlocations valueForKey:@"contact_no"] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *phone=[[arrlocations valueForKey:@"contact_no"] objectAtIndex:indexPath.row];
    NSString *phone_number = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phone_number]] options:@{} completionHandler:nil];
}





- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Locations Clicked

-(IBAction)LocationsButtonClicked:(id)sender
{
    [Locationbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image1= [UIImage imageNamed:@"m1.png"];
    [Locationbutton setImage:[self imageWithImage:image1 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    Locationbutton.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    
    [ContactUsbutton setTitleColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    UIImage *image2= [UIImage imageNamed:@"32.png"];
    [ContactUsbutton setImage:[self imageWithImage:image2 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    ContactUsbutton.backgroundColor=[UIColor clearColor];
    
    
    
    titlelab.text=@"Locations";
    categoryScrollView.hidden=NO;
    categoryScrollView2.hidden=YES;
    tabl.hidden=YES;
    
}

-(IBAction)ContactUsButtonClicked:(id)sender
{
    [Locationbutton setTitleColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0] forState:UIControlStateNormal];
    UIImage *image1= [UIImage imageNamed:@"Doclocation.png"];
    [Locationbutton setImage:[self imageWithImage:image1 scaledToSize:CGSizeMake(25, 25)] forState:UIControlStateNormal];
    Locationbutton.backgroundColor=[UIColor clearColor];
    
    [ContactUsbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image2= [UIImage imageNamed:@"31.png"];
    [ContactUsbutton setImage:[self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)] forState:UIControlStateNormal];
    ContactUsbutton.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    
    
    titlelab.text=@"Contact Us";
    categoryScrollView.hidden=YES;
    categoryScrollView2.hidden=YES;
    tabl.hidden=NO;
}



#pragma mark - Locations View

-(void)locationView
{
    mapview=[[GMSMapView alloc] initWithFrame:CGRectMake(5, 2, self.view.frame.size.width-10, self.view.frame.size.height-260)];
    mapview.delegate=self;
   
    NSString *strlat2=[[arrlocations objectAtIndex:0] valueForKey:@"lat"];
    latitude1=[strlat2 floatValue];
    NSString *strlong2=[[arrlocations objectAtIndex:0] valueForKey:@"lang"];
    longitude1=[strlong2 floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude1
                                                            longitude:longitude1
                                                                 zoom:14];
    mapview.camera=camera;
    for (int i=0; i<arrlocations.count; i++)
    {
        marker = [[GMSMarker alloc] init];
        NSString *strlat=[[arrlocations objectAtIndex:i] valueForKey:@"lat"];
        latitude1=[strlat floatValue];
        NSString *strlong=[[arrlocations objectAtIndex:i] valueForKey:@"lang"];
        longitude1=[strlong floatValue];
        marker.position = CLLocationCoordinate2DMake(latitude1, longitude1);
        marker.title=[[arrlocations objectAtIndex:i] valueForKey:@"address"];
        marker.icon=[UIImage imageNamed:@"Doclocation.png"];
        marker.icon = [self image:marker.icon scaledToSize:CGSizeMake(30.0f, 30.0f)];
        marker.userData=[arrlocations objectAtIndex:i];
        marker.map = mapview;
    }
    [categoryScrollView addSubview:mapview];
    
    strAddress=[[arrlocations objectAtIndex:0] valueForKey:@"address"];
    NSString *strlat=[[arrlocations objectAtIndex:0] valueForKey:@"lat"];
    Directionlatitude=[strlat floatValue];
    NSString *strlong=[[arrlocations objectAtIndex:0] valueForKey:@"lang"];
    Directionlongitude=[strlong floatValue];
    
    
    locationTitle=[[UILabel alloc]initWithFrame:CGRectMake(10, mapview.frame.size.height+mapview.frame.origin.y+10, self.view.frame.size.width-60, 40)];
    locationTitle.numberOfLines=0;
    locationTitle.backgroundColor=[UIColor clearColor];
    locationTitle.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    locationTitle.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    locationTitle.textAlignment=NSTextAlignmentLeft;
    locationTitle.text=[[arrlocations objectAtIndex:0] valueForKey:@"title"];
    [categoryScrollView addSubview:locationTitle];
    
    
    button2=[[UIButton alloc] initWithFrame:CGRectMake(categoryScrollView.frame.size.width-50, mapview.frame.size.height+mapview.frame.origin.y+10, 40, 40)];
    UIImage *btnImage2 = [UIImage imageNamed:@"cancel-2.png"];
    [button2 setImage:btnImage2 forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor clearColor];
    button2.layer.cornerRadius = 20;
    button2.clipsToBounds = YES;
    button2.hidden=YES;
    [button2 addTarget:self action:@selector(InstagramButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:button2];
    
    
    locationAddress=[[UILabel alloc]initWithFrame:CGRectMake(10, locationTitle.frame.size.height+locationTitle.frame.origin.y+5, self.view.frame.size.width-20, 40)];
    locationAddress.numberOfLines=0;
    locationAddress.backgroundColor=[UIColor clearColor];
    locationAddress.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    locationAddress.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    locationAddress.textAlignment=NSTextAlignmentLeft;
    locationAddress.text=[[arrlocations objectAtIndex:0] valueForKey:@"address"];
    [categoryScrollView addSubview:locationAddress];
    
    
    
    UIButton *GetDirectionsButton=[[UIButton alloc] initWithFrame:CGRectMake(15, locationAddress.frame.size.height+locationAddress.frame.origin.y+30, self.view.frame.size.width-30, 50)];
    GetDirectionsButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0]   ;
    [GetDirectionsButton setTitle:@"Get Directions" forState:UIControlStateNormal];
    GetDirectionsButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    GetDirectionsButton.layer.cornerRadius = 4;
    GetDirectionsButton.clipsToBounds = YES;
    GetDirectionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [GetDirectionsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [GetDirectionsButton addTarget:self action:@selector(GetDirectionsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView addSubview:GetDirectionsButton];
    
    categoryScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 140+60+self.view.frame.size.height-260);
}

-(IBAction)InstagramButtonClicked:(id)sender
{
    button2.hidden=YES;
    CGPoint bottomOffset = CGPointMake(0, categoryScrollView.frame.origin.x);
    [categoryScrollView setContentOffset:bottomOffset animated:YES];
}


- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marke
{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    arr=marke.userData;
    
     locationTitle.text=[arr valueForKey:@"title"];
     locationAddress.text=[arr valueForKey:@"address"];
}

-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marke
{
    
    button2.hidden=NO;
    
    CGPoint bottomOffset = CGPointMake(0, categoryScrollView.contentSize.height - categoryScrollView.bounds.size.height);
    [categoryScrollView setContentOffset:bottomOffset animated:YES];
    
   
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    arr=marke.userData;
    
    locationTitle.text=[arr valueForKey:@"title"];
    locationAddress.text=[arr valueForKey:@"address"];
    strAddress=[arr valueForKey:@"address"];
    
    NSString *strlat=[arr valueForKey:@"lat"];
    Directionlatitude=[strlat floatValue];
    NSString *strlong=[arr valueForKey:@"lang"];
    Directionlongitude=[strlong floatValue];
    
    return YES;
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

#pragma mark - GetDirections Clicked

-(IBAction)GetDirectionsButtonClicked:(id)sender
{
    NSString *googleMapUrlString = [NSString stringWithFormat:@"comgooglemaps://?.saddr=%@&daddr=%@&directionsmode=driving",@"",locationTitle.text];
    NSString *trimmedString = [googleMapUrlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trimmedString] options:@{} completionHandler:nil];
    }
    else
    {
        self.alertCtrl2.popoverPresentationController.sourceView = self.view;
        [self presentViewController:self.alertCtrl2 animated:YES completion:^{}];
    }
}


-(void)ContactUsView
{
    txtHoapital=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 50)];
    txtHoapital.placeholder = @"Select Hospital";
    NSAttributedString *str11 = [[NSAttributedString alloc] initWithString:@"Select Hospital" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtHoapital.attributedPlaceholder = str11;
    txtHoapital.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtHoapital.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtHoapital.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtHoapital.backgroundColor=[UIColor clearColor];
    txtHoapital.delegate=self;
    [categoryScrollView2 addSubview:txtHoapital];
    
    UIImageView * myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-35, 35, 20, 20)];
    myImageView.image = [UIImage imageNamed:@"down_grey_arrow.png"];
    [categoryScrollView2 addSubview:myImageView];
    
    linelabel22=[[UILabel alloc]initWithFrame:CGRectMake(15, txtHoapital.frame.size.height+txtHoapital.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel22.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView2 addSubview:linelabel22];
    
    
    UIButton *CityButton=[[UIButton alloc] initWithFrame:CGRectMake(15, 20, self.view.frame.size.width-30, 50)];
    [CityButton addTarget:self action:@selector(HospitalButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    CityButton.backgroundColor=[UIColor clearColor];
    [categoryScrollView2 addSubview:CityButton];
    
    
    
    
    txtName=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtHoapital.frame.size.height+txtHoapital.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtName.placeholder=@"Name";
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtName.attributedPlaceholder = str1;
    txtName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtName.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtName.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtName.backgroundColor=[UIColor clearColor];
    txtName.delegate=self;
    txtName.returnKeyType = UIReturnKeyNext;
    [categoryScrollView2 addSubview:txtName];
    
    linelabel2=[[UILabel alloc]initWithFrame:CGRectMake(15, txtName.frame.size.height+txtName.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView2 addSubview:linelabel2];
    
    
    
    txtEmail=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtName.frame.size.height+txtName.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtEmail.placeholder=@"Email";
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtEmail.attributedPlaceholder = str2;
    txtEmail.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtEmail.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtEmail.font = [UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtEmail.backgroundColor=[UIColor clearColor];
    txtEmail.delegate=self;
    txtEmail.returnKeyType = UIReturnKeyNext;
    [categoryScrollView2 addSubview:txtEmail];
    
    linelabel3=[[UILabel alloc]initWithFrame:CGRectMake(15, txtEmail.frame.size.height+txtEmail.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel3.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView2 addSubview:linelabel3];
    
    
    
    txtPhone=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtEmail.frame.size.height+txtEmail.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtPhone.placeholder=@"Mobile Number";
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"Mobile Number" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtPhone.attributedPlaceholder = str3;
    txtPhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtPhone.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtPhone.font =[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtPhone.backgroundColor=[UIColor clearColor];
    txtPhone.delegate=self;
    txtPhone.returnKeyType = UIReturnKeyNext;
    [txtPhone setKeyboardType:UIKeyboardTypeNumberPad];
    [categoryScrollView2 addSubview:txtPhone];
    
    linelabel4=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel4.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView2 addSubview:linelabel4];
    
    
    
    txtDescription=[[UIFloatLabelTextField alloc]initWithFrame:CGRectMake(10, txtPhone.frame.size.height+txtPhone.frame.origin.y+20, self.view.frame.size.width-30, 50)];
    txtDescription.placeholder=@"Description";
    NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
    txtDescription.attributedPlaceholder = str4;
    txtDescription.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    txtDescription.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtDescription.font =[UIFont fontWithName:@"OpenSans-Regular" size:17.0];
    txtDescription.backgroundColor=[UIColor clearColor];
    txtDescription.delegate=self;
    txtDescription.returnKeyType = UIReturnKeyDone;
    [categoryScrollView2 addSubview:txtDescription];
    
    linelabel55=[[UILabel alloc]initWithFrame:CGRectMake(15, txtDescription.frame.size.height+txtDescription.frame.origin.y, self.view.frame.size.width-30, 2)];
    linelabel55.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    [categoryScrollView2 addSubview:linelabel55];
    
    
    Typelab=[[UILabel alloc]initWithFrame:CGRectMake(15, txtPhone.frame.size.height+txtPhone.frame.origin.y+30, 120, 30)];
    Typelab.text=@"Description";
    Typelab.font=[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    Typelab.textColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    Typelab.hidden=YES;
    [categoryScrollView2 addSubview:Typelab];
    
    
    txtadDesc=[[UITextView alloc]initWithFrame:CGRectMake(10, Typelab.frame.size.height+Typelab.frame.origin.y+5, self.view.frame.size.width-20, 50)];
    txtadDesc.textAlignment=NSTextAlignmentNatural;
    [self setPlaceholder];
    txtadDesc.layer.borderColor=[[UIColor clearColor]CGColor];
    txtadDesc.layer.borderWidth=1.0;
    txtadDesc.textColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    txtadDesc.font =[UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    txtadDesc.backgroundColor=[UIColor clearColor];
    txtadDesc.delegate=self;
    txtadDesc.hidden=YES;
    [categoryScrollView2 addSubview:txtadDesc];
    
    linelabel5=[[UILabel alloc] initWithFrame:CGRectMake(15, txtadDesc.frame.size.height+txtadDesc.frame.origin.y+2, self.view.frame.size.width-30, 2)];
    linelabel5.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
    linelabel5.hidden=YES;
    [categoryScrollView2 addSubview:linelabel5];
    
    
    UIButton *SubmitButton=[[UIButton alloc] initWithFrame:CGRectMake(15, linelabel55.frame.size.height+linelabel55.frame.origin.y+50, self.view.frame.size.width-30, 50)];
    SubmitButton.backgroundColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    [SubmitButton setTitle:@"Submit" forState:UIControlStateNormal];
    SubmitButton.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
    SubmitButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [SubmitButton addTarget:self action:@selector(ContactUsSubmitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [categoryScrollView2 addSubview:SubmitButton];

    
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
    
    
    categoryScrollView2.contentSize = CGSizeMake(self.view.frame.size.width, 500);
        
}

- (void)setPlaceholder
{
    txtadDesc.text = NSLocalizedString(@"Type Here...", @"placeholder");
    txtadDesc.textColor = [UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    showPlaceHolder = YES;
}

-(void)doneWithNumberPad
{
    [txtPhone resignFirstResponder];
}

#pragma mark - CityButton Clicked

-(IBAction)HospitalButtonClicked:(id)sender
{
    [Dropobj fadeOut];
    
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"please wait..."];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,allHospital];
    [requested SubCategoryRequest:nil withUrl:strurl];
}


-(void)responseSubCategory:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrHospital=[responseToken valueForKey:@"data"];
        
        [self showPopUpWithTitle:@"Select Hospital" withOption:arrHospital xy:CGPointMake(self.view.frame.size.width/2-155, self.view.frame.size.height/2-155) size:CGSizeMake(310, 310) isMultiple:NO];
    }
    else
    {
        [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}





#pragma mark - ContactForm Submit Clicked

-(IBAction)ContactUsSubmitButtonClicked:(id)sender
{
    if (txtHoapital.text.length==0)
    {
        [requested showMessage:@"Please Select the Hospital" withTitle:@"Warning"];
    }
    else if (txtName.text.length==0)
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
    else if (txtadDesc.text.length==0)
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
        NSString *post = [NSString stringWithFormat:@"name=%@&email=%@&phone=%@&description=%@&hospital_id=%@",encodetitle,txtEmail.text,txtPhone.text,encodeDescription,strHospitalId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,Contact];
        [requested sendRequest:post withUrl:strurl];
    }
}


-(void)responsewithToken:(NSMutableDictionary *)responseToken
{
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
      
//        txtName.text=@"";
//        txtEmail.text=@"";
//        txtPhone.text=@"";
//        txtadDesc.text=@"";
//        txtName.placeholder=@"Name";
//        txtEmail.placeholder=@"Email";
//        txtPhone.placeholder=@"Mobile Number";
//         [self setPlaceholder];
//        
//        [[NSUserDefaults standardUserDefaults]setObject:@"3" forKey:@"Index"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        tabbar = [[TabBarController alloc] init];
//        tabbar.selectedIndex=3;
        
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [requested showMessage:@"Thank you for Contact us. We will contact you soon." withTitle:@"Contact Us"];
        
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
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Contact Number" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            
            NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
       
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField==txtName)
    {
        if ([txtName.text isEqual:@""])
        {
            linelabel2.backgroundColor=[UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0];
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            
            NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"Contact Number" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
            
            NSAttributedString *str4 = [[NSAttributedString alloc] initWithString:@"Type Here" attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:148.0/255.0f green:148.0/255.0f blue:148.0/255.0f alpha:1.0] }];
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
                    [self responsewithToken5:responseJSON];
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


-(void)responsewithToken5:(NSMutableDictionary *)responseToken
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


#pragma mark - DropDown Options

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    popview = [[ UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:popview animated:YES];
    /*----------------Set DropDown backGroundColor-----------------*/
    [Dropobj SetBackGroundDropDown_R:93.0 G:181.0 B:80.0 alpha:0.9];
    
}
- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex
{
    popview.hidden = YES;
    
    txtHoapital.text=[[arrHospital valueForKey:@"name"]objectAtIndex:anIndex];
    strHospitalId=[[arrHospital valueForKey:@"id"]objectAtIndex:anIndex];
    linelabel22.backgroundColor=[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0];
    
    NSLog(@"%@",strHospitalId);
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)ArryData
{
    if (ArryData.count>0)
    {
        
    }
    else
    {
        
    }
}

- (void)DropDownListViewDidCancel
{
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]])
    {
        popview.hidden = YES;
        [Dropobj fadeOut];
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
