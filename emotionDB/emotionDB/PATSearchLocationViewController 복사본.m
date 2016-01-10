//
//  PATSearchLocationViewController.m
//  PatchWork
//
//  Created by BgKim on 2015. 12. 16..
//  Copyright © 2015년 NEXT Institute. All rights reserved.
//

#import "PATSearchLocationViewController.h"

@interface PATSearchLocationViewController ()
{
	NSString* enteredPlace;
	UITableView* associatedPlacesList;
}
@end


@implementation PATSearchLocationViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"searchLocation View Controller Loaded");
	
	self.view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
	
	self.inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*(1/15.0), self.view.bounds.origin.y + 30, self.view.bounds.size.width*(13/15.0), 40)];
	
	self.inputTextField.font = [UIFont fontWithName:@"Odin Rounded" size:self.view.bounds.size.width*0.05];
	self.inputTextField.placeholder = @"ENTER PLACE";
	self.inputTextField.textAlignment = NSTextAlignmentCenter;
	self.inputTextField.backgroundColor = [UIColor whiteColor];
	self.inputTextField.textColor = [UIColor colorWithRed:11/255.0 green:16/255.0 blue:41/255.0 alpha:0.5];
	
	[self.inputTextField setDelegate:self];
	[self.inputTextField addTarget:self action:@selector(textInputFinished:) forControlEvents:UIControlEventEditingDidEndOnExit];
	
	[self.view addSubview:self.inputTextField];
}


- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if (self.willShowKeyboard) {
		[self.inputTextField becomeFirstResponder];
	}
}


- (void) textInputFinished: (id) sender {
	[sender endEditing:YES];
	enteredPlace = self.inputTextField.text;
	
	NSLog(@"enteredPlace = %@", enteredPlace);
	
	NSMutableString* temp_url = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input="];
	[temp_url appendString:enteredPlace];
	[temp_url appendString:@"&types=geocode&key=AIzaSyA7jS3ywIDCjZsnuRywrNOacgCSOpi308c"];
	
	NSString* url = [temp_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	
	NSLog(@"%@", url);
	
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
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
	
	NSLog(@"json = %@", json);
	
	NSArray* predictions = [json objectForKey:@"predictions"];
	NSMutableString* placeId;
	NSString* description;
	
	for (NSDictionary* predictedPlace in predictions) {
		description = [predictedPlace objectForKey:@"description"];
		placeId = [predictedPlace objectForKey:@"place_id"];
		
		NSLog(@"description = %@", description);
		NSLog(@"place id = %@", placeId);
	}
	

	
	NSMutableString* placeId_url = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid="];
	[placeId_url appendString:placeId];
	[placeId_url appendString:@"&key=AIzaSyA7jS3ywIDCjZsnuRywrNOacgCSOpi308c"];
	
	NSLog(@"final url = %@", placeId_url);
	
	NSMutableURLRequest* place_request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:placeId_url]];
	[place_request setHTTPMethod:@"GET"];
	[place_request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"content-type"];
	
	NSError* place_error;
	NSURLResponse* place_response;
	NSData* place_responseData = [NSURLConnection sendSynchronousRequest:place_request
												 returningResponse:&place_response
															 error:&place_error];
	
	NSDictionary* place_json = [NSJSONSerialization JSONObjectWithData:place_responseData
														 options:NSJSONReadingMutableContainers
														   error:&place_error];
	
	NSLog(@"place_json = %@", place_json);
	
	NSDictionary* place_json_result = [place_json objectForKey:@"result"];
	NSDictionary* place_json_geometry = [place_json_result objectForKey:@"geometry"];
	NSDictionary* place_json_location = [place_json_geometry objectForKey:@"location"];
	NSString* place_lat = [place_json_location objectForKey:@"lat"];
	NSString* place_lon = [place_json_location objectForKey:@"lng"];
	
	NSLog(@"lat = %@,\n lon = %@", place_lat, place_lon);
	
}


@end
