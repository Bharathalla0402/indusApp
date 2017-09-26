//
//  TabBarController.m
//  Example
//
//  Created by bharath on 04/13/17.
//  Copyright © 2017 bharath All rights reserved.
//


#import "TabBarController.h"
#import "UITabBarController+BIZSelectedBackgroundForTabBarItem.h"


@interface TabBarController () <UITabBarControllerDelegate>
@end


@implementation TabBarController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImage *image1= [UIImage imageNamed:@"report.png"];
//    UIImage *image2= [UIImage imageNamed:@"package.png"];
//    UIImage *image3= [UIImage imageNamed:@"contact.png"];
//    UIImage *image4= [UIImage imageNamed:@"more.png"];
    
    UIImage *image1= [UIImage imageNamed:@"booking-white.png"];
    UIImage *image2= [UIImage imageNamed:@"package.png"];
    UIImage *image3= [UIImage imageNamed:@"report.png"];
    UIImage *image4= [UIImage imageNamed:@"more.png"];
    
    
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *tabBarItem1 = [tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem2 = [tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem3 = [tabBar.items objectAtIndex:2];
    UITabBarItem *tabBarItem4 = [tabBar.items objectAtIndex:3];
    
    tabBarItem1.image=[self imageWithImage:image1 scaledToSize:CGSizeMake(30, 30)];
    tabBarItem2.image=[self imageWithImage:image2 scaledToSize:CGSizeMake(30, 30)];
    tabBarItem3.image=[self imageWithImage:image3 scaledToSize:CGSizeMake(30, 30)];
    tabBarItem4.image=[self imageWithImage:image4 scaledToSize:CGSizeMake(30, 30)];
    

   
    self.tabBar.unselectedItemTintColor=[UIColor whiteColor];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Regular" size:13.0] } forState:UIControlStateNormal];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:49.0/255.0f green:89.0/255.0f blue:168.0/255.0f alpha:1.0]];
    
    
    self.delegate = self;
   
    NSString *strvalue=[[NSUserDefaults standardUserDefaults]objectForKey:@"Index"];
    int v=[strvalue intValue];
    
    if (v==4)
    {
       [self selectBackgroundForItemAtIndex:3 backgroundColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] withEarlySelect:YES animated:NO];
    }
    else
    {
        [self selectBackgroundForItemAtIndex:v backgroundColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] withEarlySelect:YES animated:NO];
    }
}


#pragma mark - UITabBarControllerDelegate


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSUInteger index = [self.tabBar.items indexOfObject:item];
    [self selectBackgroundForItemAtIndex:index backgroundColor:[UIColor colorWithRed:93.0/255.0f green:181.0/255.0f blue:80.0/255.0f alpha:1.0] withEarlySelect:NO animated:YES];
}


#pragma mark - Image Reduce

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
