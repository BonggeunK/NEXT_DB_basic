//
//  PATSearchLocationViewController.h
//  PatchWork
//
//  Created by BgKim on 2015. 12. 16..
//  Copyright © 2015년 NEXT Institute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PATMapContainerViewController;

@interface PATSearchLocationViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate>

@property (nonatomic) UITextField* inputTextField;
@property (nonatomic) BOOL willShowKeyboard;

@end

