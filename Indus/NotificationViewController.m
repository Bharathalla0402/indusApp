//
//  NotificationViewController.m
//  Indus
//
//  Created by think360 on 09/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "NotificationViewController.h"
#import "Indus.pch"
#import "ApiRequest.h"
#import "UIFloatLabelTextField.h"
#import "DejalActivityView.h"

@interface NotificationViewController ()<ApiRequestdelegate,UITableViewDelegate,UITableViewDataSource>
{
    ApiRequest *requested;
    UIScrollView *categoryScrollView;
    UILabel *NoticationLab;
    UIButton *NotificationButton;
    
    IBOutlet UITableView *tablDta;
    UITableViewCell *cell;
    
    NSMutableArray *arrlist;
    NSArray *arrlistDetails;
    

    UIView *footerview2;
    UILabel *loadLbl,*locationNamelabel;
    UIActivityIndicatorView * actInd;
    int scrool;
    int count,lastCount;
     UIView *footerview,*popview;
}
@property(nonatomic,strong)NSMutableArray *arryDatalistids;
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scrool=1;
    count=1;
    lastCount=1;
    
    arrlist=[[NSMutableArray alloc]init];
    arrlist=_arrChildCategory;
    
    _arryDatalistids=[[NSMutableArray alloc]init];
    
    
    
    self.view.backgroundColor=[UIColor whiteColor];
    
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
    titlelab.text=@"Notifications";
    titlelab.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    //titlelab.font=[UIFont boldSystemFontOfSize:17];
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
    
    
    tablDta=[[UITableView alloc] init];
    tablDta.frame = CGRectMake(0,linelabel.frame.size.height+linelabel.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-120);
    tablDta.delegate=self;
    tablDta.dataSource=self;
    tablDta.tag=4;
    tablDta.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    tablDta.backgroundColor=[UIColor clearColor];
    [tablDta setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tablDta];

    
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
        testView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        testView.layer.borderWidth = 1.0f;
        testView.layer.cornerRadius=4.0;
        testView.backgroundColor=[UIColor whiteColor];
        
        
        NSInteger aRedValue = arc4random()%255;
        NSInteger aGreenValue = arc4random()%255;
        NSInteger aBlueValue = arc4random()%255;
        
        UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        toimage.text=[[arrlist valueForKey:@"sn"] objectAtIndex:indexPath.row];
        toimage.layer.cornerRadius=25.0;
        toimage.clipsToBounds=YES;
        toimage.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        toimage.textAlignment=NSTextAlignmentCenter;
        toimage.textColor=[UIColor whiteColor];
        toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        [testView addSubview:toimage];
        
        
        
        
        UILabel *Namelabel=[[UILabel alloc] init];
        Namelabel.numberOfLines=0;
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"patient_name"]];
        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:16.0]}
                                                       context:nil];
        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size.height)];
        Namelabel.frame = CGRectMake(70,10, descriptionSize.width+30, descriptionSize.height);
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:16.0];
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        
        
        
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"appointment_request"]];
        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                              context:nil];
        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size2.height)];
        ClinicNamelabel.frame = CGRectMake(70,Namelabel.frame.size.height+Namelabel.frame.origin.y+10, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor darkGrayColor];
        
        
        
        UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(70, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, 20, 20)];
        referimage.image=[UIImage imageNamed:@"clock.png"];
        referimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:referimage];
        
        UILabel *referlabel=[[UILabel alloc] init];
        referlabel.numberOfLines=0;
        referlabel.text=[NSString stringWithFormat:@"%@ | %@",[[arrlist valueForKey:@"apointment_date"] objectAtIndex:indexPath.row],[[arrlist valueForKey:@"apointment_time"] objectAtIndex:indexPath.row]];
        CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                         context:nil];
        CGSize size3 = textRect3.size;
        CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size3.height)];
        referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, descriptionSize3.width, descriptionSize3.height);
        referlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        referlabel.textAlignment=NSTextAlignmentLeft;
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+45);

        
        
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
        testView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        testView.layer.borderWidth = 1.0f;
        testView.layer.cornerRadius=4.0;
       
        NSString *strId=[NSString stringWithFormat:@"%@",[[arrlist valueForKey:@"read_unread"] objectAtIndex:indexPath.row]];
        
        
        if ([strId isEqualToString:@"1"])
        {
            
            if([self.arryDatalistids containsObject:indexPath])
            {
                 testView.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0];
            }
            else
            {
                testView.backgroundColor = [UIColor whiteColor];
            }
        }
        else
        {
             testView.backgroundColor=[UIColor colorWithRed:236.0/255.0f green:236.0/255.0f blue:236.0/255.0f alpha:1.0];
        }
        
        
        
        NSInteger aRedValue = arc4random()%255;
        NSInteger aGreenValue = arc4random()%255;
        NSInteger aBlueValue = arc4random()%255;
        
        UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        toimage.text=[[arrlist valueForKey:@"sn"] objectAtIndex:indexPath.row];
        toimage.layer.cornerRadius=25.0;
        toimage.clipsToBounds=YES;
        toimage.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
        toimage.textAlignment=NSTextAlignmentCenter;
        toimage.textColor=[UIColor whiteColor];
        toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
        [testView addSubview:toimage];
        
        
        
        
        UILabel *Namelabel=[[UILabel alloc] init];
        Namelabel.numberOfLines=0;
        Namelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"patient_name"]];
        CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:20.0]}
                                                               context:nil];
        CGSize size = textRect.size;
        CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size.height)];
        Namelabel.frame = CGRectMake(70,10, descriptionSize.width+30, descriptionSize.height);
        Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:16.0];
        Namelabel.textAlignment=NSTextAlignmentLeft;
        Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
        
        
    
        UILabel *ClinicNamelabel=[[UILabel alloc] init];
        ClinicNamelabel.numberOfLines=0;
        ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"appointment_request"]];
        CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                                      context:nil];
        CGSize size2 = textRect2.size;
        CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size2.height)];
        ClinicNamelabel.frame = CGRectMake(70,Namelabel.frame.size.height+Namelabel.frame.origin.y+10, descriptionSize2.width, descriptionSize2.height);
        ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
        ClinicNamelabel.textColor=[UIColor darkGrayColor];
        
        
        
        UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(70, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, 20, 20)];
        referimage.image=[UIImage imageNamed:@"clock.png"];
        referimage.contentMode = UIViewContentModeScaleAspectFit;
        [testView addSubview:referimage];
        
        UILabel *referlabel=[[UILabel alloc] init];
        referlabel.numberOfLines=0;
        referlabel.text=[NSString stringWithFormat:@"%@ | %@",[[arrlist valueForKey:@"apointment_date"] objectAtIndex:indexPath.row],[[arrlist valueForKey:@"apointment_time"] objectAtIndex:indexPath.row]];
        CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                                 context:nil];
        CGSize size3 = textRect3.size;
        CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-100,size3.height)];
        referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+10, descriptionSize3.width, descriptionSize3.height);
        referlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
        referlabel.textAlignment=NSTextAlignmentLeft;
        
        
        
        testView.frame=CGRectMake(10,10, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+45);
        
        [cell addSubview:testView];
        [testView addSubview:Namelabel];
        [testView addSubview:ClinicNamelabel];
        [testView addSubview:referlabel];
       
        
        return cell;
        
    }
    else
    {
        static NSString *CellIdentifier1 = @"Cell1";
        UITableViewCell *cell2;
        
        cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell2 == nil)
        {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
        }
        
        if (tablDta.tag==3)
        {
            
            
        }
        else
        {
            
        }
        
        return cell2;
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
        arrlistDetails=[arrlist objectAtIndex:indexPath.row];
        
        NSString *strId=[NSString stringWithFormat:@"%@",[[arrlist valueForKey:@"read_unread"] objectAtIndex:indexPath.row]];
        
        
        if ([strId isEqualToString:@"1"])
        {
            
            if([self.arryDatalistids containsObject:indexPath])
            {
                 [self DataListDetails];
            }
            else
            {
                [self.arryDatalistids addObject:indexPath];
                 [tablDta reloadData];
                
                NSString *strid=[NSString stringWithFormat:@"%@",[[arrlist objectAtIndex:indexPath.row]valueForKey:@"id"]];
                NSString *post = [NSString stringWithFormat:@"id=%@",strid];
                NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,readMessage];
                [requested sendRequest:post withUrl:strurl];
            }
        }
        else
        {
             [self DataListDetails];
        }

    
      
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)responsewithToken:(NSMutableDictionary *)responseDict
{
   
    [self DataListDetails];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==4)
    {
        NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
        NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
        
        if ((indexPath.section == lastSectionIndex) && (indexPath.row == lastRowIndex))
        {
            
            if ([_strpage isEqualToString:@"0"])
            {
                loadLbl.text=@"No More List";
                [actInd stopAnimating];
            }
            else
            {
                
                //  NSString *strurl=[NSString stringWithFormat:@"%@%@?problem=%@&latitude=%f&longitude=%f&page=%@",BaseUrl,getDoctor,_strDoctId,core_latitude,core_longitude,_strpage];
                //   [requested SubCategoryRequest3:nil withUrl:strurl];
                //   [self initFooterView];
                //   loadLbl.text=@"loading...";
            }
        }
        
    }
    else
    {
        
    }
}

-(void)responseSubCategory3:(NSMutableDictionary *)responseDict
{
    NSMutableDictionary *responseDictionary=[[NSMutableDictionary alloc]init];
    responseDictionary=responseDict;
    NSLog(@"Dict Response: %@",responseDictionary);
    
    if (count==1)
    {
        count=2;
        if ([_strpage isEqualToString:@"2"])
        {
            NSArray *arr=[responseDictionary valueForKey:@"data"];
            
            arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [tablDta reloadData];
        }
        else
        {
            
        }
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
    }
    else
    {
        
        _strpage=[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:@"nextPage"]];
        
        if ([_strpage isEqualToString:@"0"])
        {
            if (lastCount==1)
            {
                NSArray *arr=[responseDictionary valueForKey:@"data"];
                
                arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
                
                [tablDta reloadData];
                lastCount=2;
            }
        }
        else
        {
            NSArray *arr=[responseDictionary valueForKey:@"data"];
            
            arrlist=[[arrlist arrayByAddingObjectsFromArray:arr] mutableCopy];
            
            [tablDta reloadData];
        }
    }
    
}




#pragma mark - Data list Clicked

-(void)DataListDetails
{
    self.tabBarController.tabBar.userInteractionEnabled=NO;
    
    popview = [[UIView alloc]init];
    popview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
    [self.view addSubview:popview];
    
    footerview=[[UIView alloc] init];
    footerview.backgroundColor = [UIColor whiteColor];
    
    
    NSInteger aRedValue = arc4random()%255;
    NSInteger aGreenValue = arc4random()%255;
    NSInteger aBlueValue = arc4random()%255;
    
    UILabel *toimage=[[UILabel alloc] initWithFrame:CGRectMake(10, 50, 50, 50)];
    toimage.text=[arrlistDetails valueForKey:@"sn"];
    toimage.layer.cornerRadius=25.0;
    toimage.clipsToBounds=YES;
    toimage.font=[UIFont fontWithName:@"OpenSans-Bold" size:17.0];
    toimage.textAlignment=NSTextAlignmentCenter;
    toimage.textColor=[UIColor whiteColor];
    toimage.backgroundColor=[UIColor colorWithRed:aRedValue/255.0f green:aGreenValue/255.0f blue:aBlueValue/255.0f alpha:1.0f];
    [footerview addSubview:toimage];
    
    
    
    
    UILabel *Namelabel=[[UILabel alloc] init];
    Namelabel.numberOfLines=0;
    Namelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"patient_name"]];
    CGRect textRect = [Namelabel.text boundingRectWithSize:Namelabel.frame.size
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:14.0]}
                                                   context:nil];
    CGSize size = textRect.size;
    CGSize descriptionSize = [Namelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-200,size.height)];
    Namelabel.frame = CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+10,50, descriptionSize.width+30, descriptionSize.height);
    Namelabel.font=[UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    Namelabel.textAlignment=NSTextAlignmentLeft;
    Namelabel.textColor=[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0];
    
    
    
    
    UIImageView *genderimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, Namelabel.frame.size.height+Namelabel.frame.origin.y+15, 20, 20)];
    genderimage.image=[UIImage imageNamed:@"pro4.png"];
    genderimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:genderimage];
    
    
    UILabel *genderNamelabel=[[UILabel alloc] init];
    genderNamelabel.numberOfLines=0;
    NSString *strgender = [NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"gender"]];
    NSString *strge = [NSString stringWithFormat:@"%@%@",[[strgender substringToIndex:1] uppercaseString],[strgender substringFromIndex:1] ];
    genderNamelabel.text=[NSString stringWithFormat:@"%@, Age:- %@",strge,[arrlistDetails valueForKey:@"age"]];
    CGRect textRect12 = [genderNamelabel.text boundingRectWithSize:genderNamelabel.frame.size
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                           context:nil];
    CGSize size12 = textRect12.size;
    CGSize descriptionSize12 = [genderNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size12.height)];
    genderNamelabel.frame = CGRectMake(genderimage.frame.size.width+genderimage.frame.origin.x+5,genderimage.frame.origin.y-3, descriptionSize12.width, descriptionSize12.height);
    genderNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    genderNamelabel.textAlignment=NSTextAlignmentLeft;
    genderNamelabel.textColor=[UIColor darkGrayColor];
    
    
    
    
    
    
    UIImageView *locationimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, genderNamelabel.frame.size.height+genderNamelabel.frame.origin.y+15, 20, 20)];
    locationimage.image=[UIImage imageNamed:@"Doclocation.png"];
    locationimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:locationimage];
    
    UILabel *ClinicNamelabel=[[UILabel alloc] init];
    ClinicNamelabel.numberOfLines=0;
    ClinicNamelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"address"]];
    CGRect textRect2 = [ClinicNamelabel.text boundingRectWithSize:ClinicNamelabel.frame.size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                          context:nil];
    CGSize size2 = textRect2.size;
    CGSize descriptionSize2 = [ClinicNamelabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size2.height)];
    ClinicNamelabel.frame = CGRectMake(locationimage.frame.size.width+locationimage.frame.origin.x+5,locationimage.frame.origin.y-3, descriptionSize2.width, descriptionSize2.height);
    ClinicNamelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    ClinicNamelabel.textAlignment=NSTextAlignmentLeft;
    ClinicNamelabel.textColor=[UIColor darkGrayColor];
    
    
    
    
    
    
    
    UIImageView *referimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, ClinicNamelabel.frame.size.height+ClinicNamelabel.frame.origin.y+15, 20, 20)];
    referimage.image=[UIImage imageNamed:@"Docrefer_doctor.png"];
    referimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:referimage];
    
    UILabel *referlabel=[[UILabel alloc] init];
    referlabel.numberOfLines=0;
    UIColor *highlightColor = [UIColor colorWithRed:29.0/255.0f green:29.0/255.0f blue:38.0/255.0f alpha:1.0];
    UIColor *normalColor = [UIColor colorWithRed:51.0/255.0f green:51.0/255.0f blue:51.0/255.0f alpha:1.0];
    UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    UIFont *font2 = [UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    NSDictionary *highlightAttributes = @{NSFontAttributeName:font, NSForegroundColorAttributeName:highlightColor};
    NSDictionary *normalAttributes = @{NSFontAttributeName:font2, NSForegroundColorAttributeName:normalColor};
    NSAttributedString *highlightedText = [[NSAttributedString alloc] initWithString:@"Refered Doctor:- " attributes:highlightAttributes];
    NSAttributedString *normalText = [[NSAttributedString alloc] initWithString:[arrlistDetails valueForKey:@"doctor_name"] attributes:normalAttributes];
    NSMutableAttributedString *finalAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:highlightedText];
    [finalAttributedString appendAttributedString:normalText];
    referlabel.attributedText = finalAttributedString;
    CGRect textRect3 = [referlabel.text boundingRectWithSize:referlabel.frame.size
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:15.0]}
                                                     context:nil];
    CGSize size3 = textRect3.size;
    CGSize descriptionSize3 = [referlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size3.height)];
    referlabel.frame = CGRectMake(referimage.frame.size.width+referimage.frame.origin.x+5,referimage.frame.origin.y-3, descriptionSize3.width, descriptionSize3.height);
    referlabel.textAlignment=NSTextAlignmentLeft;
    
    
    
    
    UIImageView *Commentimage=[[UIImageView alloc] initWithFrame:CGRectMake(toimage.frame.size.width+toimage.frame.origin.x+3, referlabel.frame.size.height+referlabel.frame.origin.y+15, 20, 20)];
    Commentimage.image=[UIImage imageNamed:@"pro2.png"];
    Commentimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:Commentimage];
    
    
    UILabel *commentlabel=[[UILabel alloc] init];
    commentlabel.numberOfLines=0;
    commentlabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"comments"]];
    CGRect textRect22 = [commentlabel.text boundingRectWithSize:commentlabel.frame.size
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}
                                                        context:nil];
    CGSize size22 = textRect22.size;
    CGSize descriptionSize22 = [commentlabel sizeThatFits:CGSizeMake(self.view.frame.size.width-120,size22.height)];
    commentlabel.frame = CGRectMake(Commentimage.frame.size.width+Commentimage.frame.origin.x+5,Commentimage.frame.origin.y-3, descriptionSize22.width, descriptionSize22.height);
    commentlabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:14.0];
    commentlabel.textAlignment=NSTextAlignmentLeft;
    commentlabel.textColor=[UIColor darkGrayColor];
    
    
    
    footerview.frame=CGRectMake(10,(self.view.frame.size.height/2)-(descriptionSize.height+descriptionSize2.height+descriptionSize3.height+80+descriptionSize12.height+descriptionSize22.height)/2, self.view.frame.size.width-20, descriptionSize.height+descriptionSize2.height+descriptionSize3.height+80+descriptionSize12.height+descriptionSize22.height+70);
    
    [popview addSubview:footerview];
    [footerview addSubview:Namelabel];
    [footerview addSubview:ClinicNamelabel];
    [footerview addSubview:referlabel];
    [footerview addSubview:genderNamelabel];
    [footerview addSubview:commentlabel];
    
    UIButton *button2=[[UIButton alloc] initWithFrame:CGRectMake(footerview.frame.size.width-50, 10, 30, 30)];
    UIImage *btnImage2 = [UIImage imageNamed:@"cancel-2.png"];
    [button2 setImage:btnImage2 forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor clearColor];
    button2.layer.cornerRadius = 15;
    button2.clipsToBounds = YES;
    [button2 addTarget:self action:@selector(CrossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:button2];
    
    
    UIButton *button3=[[UIButton alloc] initWithFrame:CGRectMake(footerview.frame.size.width-50, 0, 50, 50)];
    [button3 addTarget:self action:@selector(CrossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerview addSubview:button3];

    
    UILabel *Datelabel=[[UILabel alloc] initWithFrame:CGRectMake(footerview.frame.size.width-80, 50, 70, 20)];
    Datelabel.text=[NSString stringWithFormat:@"%@",[arrlistDetails valueForKey:@"apointment_date"]];
    Datelabel.font=[UIFont fontWithName:@"OpenSans-Regular" size:12.0];
    Datelabel.textAlignment=NSTextAlignmentCenter;
    Datelabel.textColor=[UIColor lightGrayColor];
    [footerview addSubview:Datelabel];
    
    UIImageView *Dateimage=[[UIImageView alloc] initWithFrame:CGRectMake(footerview.frame.size.width-105, 50, 20, 20)];
    Dateimage.image=[UIImage imageNamed:@"docdatePicker.png"];
    Dateimage.contentMode = UIViewContentModeScaleAspectFit;
    [footerview addSubview:Dateimage];

}


-(IBAction)CrossButtonClicked:(id)sender
{
    popview.hidden = YES;
    [footerview removeFromSuperview];
    
   // [tablDta reloadData];
    
    //[self ReloadData];
    
}

-(void)ReloadData
{
    NSString *strDoctorId=[[NSUserDefaults standardUserDefaults]objectForKey:@"DoctorId"];
    NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strDoctorId];
    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,Notification];
    [requested sendRequest3:post withUrl:strurl];
}

-(void)responsewithToken3:(NSMutableDictionary *)responseToken
{
    NSLog(@"%@",responseToken);
    
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        arrlist =[responseToken valueForKey:@"data"];
        
        [tablDta reloadData];
        
        popview.hidden = YES;
        [footerview removeFromSuperview];
    }
    else
    {
        popview.hidden = YES;
        [footerview removeFromSuperview];
    }
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]])
    {
//        [footerview removeFromSuperview];
//        popview.hidden = YES;
    }
}






#pragma mark - Back Clicked

-(IBAction)BackButtonClicked:(id)sender
{
    if ([_strNot isEqualToString:@"1"])
    {
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        self.window.rootViewController = tbc;
        tbc.selectedIndex=3;
        [self.window makeKeyAndVisible];
    }
    else
    {
      [self.navigationController popViewControllerAnimated:YES];
    }
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
                    [self responsewithToken8:responseJSON];
                    [DejalBezelActivityView removeView];
                }
                
            });
        }] resume];
        
    }
  
}


-(void)responsewithToken8:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        NSString *strCount=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"count"]];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:strCount forKey:@"count"];
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"CounNotification" object:nil userInfo:userInfo];
    }
    else
    {
        NoticationLab.hidden=YES;
      
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
