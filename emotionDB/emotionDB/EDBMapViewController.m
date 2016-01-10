//
//  EDBMapViewController.m
//  emotionDB
//
//  Created by Bonggeun Kim on 2016. 1. 9..
//  Copyright © 2016년 NEXT Institute. All rights reserved.
//

#import "EDBMapViewController.h"

@implementation EDBMapViewController

- (void) viewDidLoad {
	[super viewDidLoad];

	_locationManager = [[CLLocationManager alloc] init];
	[_locationManager requestWhenInUseAuthorization];
	_locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locationManager.delegate = self;
	[_locationManager startMonitoringSignificantLocationChanges];
	[_locationManager startUpdatingLocation];
	
	self.mapView.delegate = self;
	
	_mapView.showsUserLocation=YES;
	
	[self loadJSON];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
	[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}



- (void) loadJSON
{
	NSURL* url = [NSURL URLWithString:@"http://localhost:5001/loadData"];
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"GET"];
	[request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
	
	NSError* error;
	NSURLResponse* response;
	NSData* responseData = [NSURLConnection sendSynchronousRequest:request
												 returningResponse:&response
															 error:&error];
	
	NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
														 options:NSJSONReadingMutableContainers
														   error:&error];
	NSDictionary* jsonItem = [json objectForKey:@"results"];
	
	NSLog(@"json Item = %@", jsonItem);
	
	NSArray* latArr = [jsonItem valueForKey:@"lat"];
	NSArray* lonArr = [jsonItem valueForKey:@"lon"];
	NSArray* emotionArr = [jsonItem valueForKey:@"emotion"];
	NSArray* dailyTime = [jsonItem valueForKey:@"dailyTime"];
	
	for (int i = 0; i < [latArr count]; i++) {

		// Add an annotation
		MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
		point.coordinate = CLLocationCoordinate2DMake([latArr[i] doubleValue], [lonArr[i] doubleValue]);
		
		NSMutableString* title = [NSMutableString stringWithFormat:@""];
		if ([emotionArr[i] intValue] == 1) {
			[title appendString:@"좋아요"];
		} else if ([emotionArr[i] intValue] == 2) {
			[title appendString:@"귀찮아요"];
		} else if ([emotionArr[i] intValue] == 3) {
			[title appendString:@"재밌어요"];
		} else if ([emotionArr[i] intValue] == 4) {
			[title appendString:@"화나요"];
		} else if ([emotionArr[i] intValue] == 5) {
			[title appendString:@"놀라워요"];
		} else if ([emotionArr[i] intValue] == 6) {
			[title appendString:@"무서워요"];
		} else if ([emotionArr[i] intValue] == 7) {
			[title appendString:@"슬퍼요"];
		} else {
			[title appendString:@"흥분돼요"];
		}
		point.title = title;
		
		NSMutableString* subtitle = [NSMutableString stringWithFormat:@""];
		if ([dailyTime[i] intValue] == 1) {
			[subtitle appendString:@"아침에"];
		} else if ([dailyTime[i] intValue] == 2) {
			[subtitle appendString:@"오후에"];
		} else if ([dailyTime[i] intValue] == 3) {
			[subtitle appendString:@"저녁에"];
		} else if ([dailyTime[i] intValue] == 4) {
			[subtitle appendString:@"밤에"];
		}
		point.subtitle = subtitle;
		
		[self.mapView addAnnotation:point];
	}
}



@end
