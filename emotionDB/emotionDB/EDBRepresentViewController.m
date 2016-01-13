//
//  EDBRepresentViewController.m
//  emotionDB
//
//  Created by Bonggeun Kim on 2016. 1. 9.
//  Copyright © 2016년 NEXT Institute. All rights reserved.
//

#import "EDBRepresentViewController.h"

@implementation EDBRepresentViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	_emotion = 1;
	_subwayStation = 201;
	
	_emotionArray = @[@"ㅎㅎㅎ", @"귀차나", @"ㅋㅋㅋ", @"아쒸", @"웬열?", @"무섭", @"ㅠㅠ", @"으헝헝"];
	_stationArray = @[@"시청역", @"을지로입구역", @"을지로3가역", @"을지로4가역", @"동대문역사문화공원역",
					  @"신당역", @"상왕십리역", @"왕십리역", @"한양대역", @"뚝섬역",
					  @"성수역", @"건국대입구역", @"구의역", @"강변역", @"잠실나루역",
					  @"잠실역", @"신천역", @"종합운동장역", @"삼성역", @"선릉역",
					  @"역삼역", @"강남역", @"교대역", @"서초역", @"방배역",
					  @"사당역", @"낙성대역", @"서울대입구역", @"봉천역", @"신림역",
					  @"신대방역", @"구로디지털단지역", @"대림역", @"신도림역", @"문래역",
					  @"영등포구청역", @"당산역", @"합정역", @"홍대입구역", @"신촌역",
					  @"이대역", @"아현역", @"충정로역"];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (pickerView.tag == 2)
		return _emotionArray.count;
	else
		return _stationArray.count;
}


- (NSAttributedString*) pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
	if (pickerView.tag == 2)
		return [[NSAttributedString alloc] initWithString:_emotionArray[row] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
	else
		return [[NSAttributedString alloc] initWithString:_stationArray[row] attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}


- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (pickerView.tag == 2)
		self.emotion = (int) row + 1;
	else
		self.subwayStation = (int) row + 201;
}



- (IBAction)doneButton:(id)sender {
	
	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"hh"];
	NSLocale* currentLocale = [NSLocale currentLocale];
	NSDate* date = [NSDate date];
	[date descriptionWithLocale:currentLocale];
	NSString* dateTime = [dateFormatter stringFromDate:date];
	NSLog(@"%@",dateTime);
	
	NSMutableString *makePost = [NSMutableString stringWithCapacity:30];
	[makePost appendString:@"emotion="];
	[makePost appendString:[NSString stringWithFormat:@"%d", _emotion]];
	[makePost appendString:@"&location="];
	[makePost appendString:[NSString stringWithFormat:@"%d", _subwayStation]];
	[makePost appendString:@"&time="];
	[makePost appendString:[NSString stringWithFormat:@"%@", dateTime]];
	
	NSString *post = [NSString stringWithString:makePost];
	
	NSLog(@"post = %@", post);

	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	
	NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:5001/insertEmotion"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];
	
	NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

}
@end
