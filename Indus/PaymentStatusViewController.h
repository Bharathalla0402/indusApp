//
//  PaymentStatusViewController.h
//  PaymentGateway
//
//  Created by Suraj on 30/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentStatusViewController : UIViewController {
    
}
@property(nonatomic,retain) NSString *strId;
@property (nonatomic, strong) NSMutableDictionary *mutDictTransactionDetails;
@property (strong, nonatomic) UIWindow *window;
@end
