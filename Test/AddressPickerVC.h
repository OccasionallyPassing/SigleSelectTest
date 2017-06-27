//
//  AddressPickerVC.h
//  AdressPicker
//
//  Created by apple on 17/6/27.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressPickerVC : UIViewController

@property (nonatomic, copy) void(^addressCompletionHandler)(NSString *address);

@end
