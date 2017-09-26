//
//  MyAnnotation.h
//  MapView
//
//  Created by Nagendra on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"
@interface MyAnnotation : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    NSString *time;
    
}
@property (nonatomic, retain) NSString *mPinColor;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;
//@property(nonatomic,retain)NSString *title1;
//@property(nonatomic,retain)NSString *subtitle1;
-(id)initWithCoordinate:(CLLocationCoordinate2D)location title:(NSString*)strTitle subtitle:(NSString*)strSubTitle;
-(id)initWithCoordinate:(CLLocationCoordinate2D) c title:(NSString *)tit;
@end
