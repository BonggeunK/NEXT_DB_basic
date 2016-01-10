//
//  EDBRepresentViewController.h
//  emotionDB
//
//  Created by Bonggeun Kim on 2016. 1. 9..
//  Copyright © 2016년 NEXT Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EDBRepresentViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic) int emotion;
@property (nonatomic) int subwayStation;

@property (nonatomic, strong) NSArray* emotionArray;
@property (nonatomic, strong) NSArray* stationArray;
@property (strong, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) IBOutlet UIPickerView *emotionPicker;

- (IBAction)doneButton:(id)sender;

@end
