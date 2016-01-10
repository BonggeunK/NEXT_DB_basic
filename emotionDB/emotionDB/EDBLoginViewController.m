//
//  EDBLoginViewController.m
//  emotionDB
//
//  Created by Bonggeun Kim on 2015. 12. 17..
//  Copyright © 2015년 NEXT Institute. All rights reserved.
//

#import "EDBLoginViewController.h"

@interface EDBLoginViewController ()

@end

@implementation EDBLoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (IBAction)myButton:(id)sender {
	
	NSString * email = self.emailAddress.text;
	
	NSMutableString *makePost = [NSMutableString stringWithCapacity:30];
	[makePost appendString:@"email="];
	[makePost appendString:email];
	
	NSString *post = [NSString stringWithString:makePost];
	
	NSLog(@"my email = %@", email);
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5001/login"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
}

@end
