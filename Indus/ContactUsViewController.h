//
//  ContactUsViewController.h
//  Indus
//
//  Created by think360 on 02/06/17.
//  Copyright © 2017 bharat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;

@interface ContactUsViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    GMSMapView *mapview;
    float			latitude;
    float			longitude;
    
    float			latitude1;
    float			longitude1;
    
    
    float			Directionlatitude;
    float			Directionlongitude;
    GMSMarker *marker;
    
    
    CLLocationManager *locationManager;
    CLGeocoder *ceo;
    CLPlacemark *currentLocPlacemark;
    CLLocation *currentLocation;
}
@property (strong, nonatomic) UIAlertController *alertCtrl2;
@property (strong, nonatomic) UIWindow *window;
@end
