//
//  AppDelegate.m
//  Indus
//
//  Created by think360 on 13/04/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
#import "TabBarController.h"
#import "ViewController.h"
#import "ApiRequest.h"
#import "DejalActivityView.h"
#import "Indus.pch"
#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()<ApiRequestdelegate,UNUserNotificationCenterDelegate>
{
    ApiRequest *requested;
    UIView *popview5;
    UIView *footerview5;
    
    NSArray *arrdata;
    UILabel *textLab;
    UILabel *textLab2;
    
    NSString *strCount;

}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
     [application setStatusBarHidden:YES];
    
     [GMSServices provideAPIKey:@"AIzaSyAFhk1Wyc6H_13J-e2JxhTH26vb9ivVj7U"];
    
     [self CurrentLocationIdentifier];
    
    requested=[[ApiRequest alloc]init];
    requested.delegate=self;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"first" forKey:@"firstlog"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSObject * object = [prefs objectForKey:@"DoctorId"];
//    if(object != nil)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"Index"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//        
//        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UITabBarController *tbc = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//        self.window.rootViewController = tbc;
//        tbc.selectedIndex=0;
//        [self.window makeKeyAndVisible];
//    }
//    else
//    {
//       
//    }
    
    application.applicationIconBadgeNumber = 0;
    if( SYSTEM_VERSION_LESS_THAN( @"10.0" ) )
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound |    UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    }
    else
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
         {
             if( !error )
             {
                 [[UIApplication sharedApplication] registerForRemoteNotifications];  // required to get the app to do anything at all about push notifications
                 NSLog( @"Push registration success." );
             }
             else
             {
                 NSLog( @"Push registration FAILED" );
                 NSLog( @"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription );
                 NSLog( @"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion );  
             }  
         }];  
    }
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (application.applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"App Notification" message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token as you need:
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"%@",token);
    
    [[NSUserDefaults standardUserDefaults]setObject:token forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}


- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification  withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog( @"for handling push in foreground" );
   
    NSLog(@"%@", notification.request.content.userInfo); //for getting response payload data
    
    NSDictionary *data=notification.request.content.userInfo;
    
    NSString *strId=[NSString stringWithFormat:@"%@",[[data valueForKey:@"aps"] valueForKey:@"doctor_id"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strId];
       // NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,Notification];
        NSString *strurl2=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
       // [requested sendRequest9:post withUrl:strurl];
        [requested sendRequest8:post withUrl:strurl2];
    }
    else
    {
        [requested showMessage:@"Please Login to check the Notification" withTitle:@"Indus"];
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response  withCompletionHandler:(void (^)())completionHandler
{
    NSLog( @"for handling push in background" );
   
    NSLog(@"%@", response.notification.request.content.userInfo); //for getting response payload data
    
    NSDictionary *data=response.notification.request.content.userInfo;
    
    NSString *strId=[NSString stringWithFormat:@"%@",[[data valueForKey:@"aps"] valueForKey:@"doctor_id"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSObject * object = [prefs objectForKey:@"DoctorId"];
    if(object != nil)
    {
        NSString *post = [NSString stringWithFormat:@"doctor_id=%@",strId];
        NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,Notification];
      //  NSString *strurl2=[NSString stringWithFormat:@"%@%@",BaseUrl,countNotification];
        [requested sendRequest9:post withUrl:strurl];
       // [requested sendRequest8:post withUrl:strurl2];
    }
    else
    {
        [requested showMessage:@"Please Login to check the Notification" withTitle:@"Indus"];
    }
}

-(void)responsewithToken8:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    if([strstatus isEqualToString:@"1"])
    {
        strCount=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"count"]];
        
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:strCount forKey:@"count"];
        [[NSNotificationCenter defaultCenter] postNotificationName:
         @"CounNotification" object:nil userInfo:userInfo];
    }
    else
    {
       
    }
}


-(void)responsewithToken9:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
//        UIStoryboard *storyboard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        NotificationViewController *notification=[storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
//        notification.arrChildCategory=[responseToken valueForKey:@"data"];
//        UINavigationController *nav = [[UINavigationController alloc]init];
//        [nav pushViewController:notification animated:YES];
        
        self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NotificationViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        viewController.arrChildCategory=[responseToken valueForKey:@"data"];
        viewController.strNot=@"1";
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
    else
    {
      //  [requested showMessage:[responseToken valueForKey:@"message"] withTitle:@""];
    }
}




-(void)CurrentLocationIdentifier
{
    //---- For getting current gps location
    locationManager = [CLLocationManager new];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    //------
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString *strcountrycode2=[NSString stringWithFormat:@"%@",placemark.ISOcountryCode];

             
             [[NSUserDefaults standardUserDefaults]setObject:placemark.subLocality forKey:@"locaion"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             [[NSUserDefaults standardUserDefaults]setObject:strcountrycode2 forKey:@"countryCode"];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
         }
         else
         {

         }
     }];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
   // popview5.hidden=YES;
   // [footerview5 removeFromSuperview];
    
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    application.applicationIconBadgeNumber = 0;
    
//    popview5 = [[UIView alloc]init];
//    popview5.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//   // popview.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_strip1.png"]];
//    popview5.backgroundColor = [UIColor colorWithRed:0.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:0.7];
//    [self.window addSubview:popview5];
//    
//    [DejalBezelActivityView activityViewForView:self.window withLabel:@"please wait..."];
//    
//    NSString *strurl=[NSString stringWithFormat:@"%@%@",BaseUrl,healthtips];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:strurl]];
//    [request setHTTPMethod:@"GET"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        dispatch_async (dispatch_get_main_queue(), ^{
//            
//            if (error)
//            {
//                popview5.hidden=YES;
//                
//                if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."])
//                {
//                    [DejalBezelActivityView removeView];
//                    [requested showMessage:@"Please check your mobile data/WiFi Connection" withTitle:@"NetWork Error!"];
//                    
//                }
//                if ([error.localizedDescription isEqualToString:@"The request timed out."])
//                {
//                    [DejalBezelActivityView removeView];
//                }
//                
//                
//            } else
//            {
//                NSError *err;
//                NSMutableDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
//                [self responsewithToken2:responseJSON];
//                
//            }
//            
//        });
//    }] resume];
    

}

-(void)responsewithToken2:(NSMutableDictionary *)responseToken
{
    NSString *strstatus=[NSString stringWithFormat:@"%@",[responseToken valueForKey:@"status"]];
    
    if([strstatus isEqualToString:@"1"])
    {
        
       
        arrdata=[responseToken valueForKey:@"data"];
        
         [self NotificationApi];
        
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


-(void)NotificationApi
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

    
    
    
   [self performSelector:@selector(AcceptedResponse7:) withObject:self afterDelay:5.0];
}

-(void)AcceptedResponse7:(id)sender
{
    popview5.hidden=YES;
    [footerview5 removeFromSuperview];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
   // popview5.hidden=YES;
   // [footerview5 removeFromSuperview];
}


@end
