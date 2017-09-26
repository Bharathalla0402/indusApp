//
//  UITabBarController+BIZSelectedBackgroundForTabBarItem.h
//  Example
//
//  Created by bharath on 04/13/17.
//  Copyright © 2017 bharath All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UITabBarController (BIZSelectedBackgroundForTabBarItem)
- (void)selectBackgroundForItemAtIndex:(NSUInteger)index backgroundColor:(UIColor *)backgroundColor withEarlySelect:(BOOL)earlySelect animated:(BOOL)animated;
@end
