//
//  NotificationViewController.h
//  Indus
//
//  Created by think360 on 09/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) NSString *strNot;
@property(nonatomic,retain) NSString *strpage;
@property(nonatomic,retain) NSMutableArray *arrChildCategory;

@end
