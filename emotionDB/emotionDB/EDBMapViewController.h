//
//  EDBMapViewController.h
//  emotionDB
//
//  Created by Bonggeun Kim on 2016. 1. 9..
//  Copyright © 2016년 NEXT Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface EDBMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
