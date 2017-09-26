//
//  MyAnnotation.m
//  MapView
//
//  Created by Nagendra on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize coordinate,title,subtitle;

-(id)initWithCoordinate:(CLLocationCoordinate2D)location title:(NSString*)strTitle subtitle:(NSString*)strSubTitle
{
    self.coordinate=location;
 //   self.title=strTitle;
 //   self.subtitle=strSubTitle;
    return self;
}
-(id)initWithCoordinate:(CLLocationCoordinate2D)c title:(NSString *)tit
{
    self.coordinate=c;
   // self.title=tit;
    
    return self;
}


@end
