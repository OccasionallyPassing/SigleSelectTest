//
//  ViewController.m
//  Test
//
//  Created by apple on 17/6/27.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"
#import "AddressPickerVC.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)click:(UIButton *)sender {
    AddressPickerVC *addressPickerVC = [[AddressPickerVC alloc]init];
    [self.navigationController pushViewController:addressPickerVC animated:YES];

}


@end
