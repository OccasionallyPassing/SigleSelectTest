//
//  AddressPickerVC.m
//  AdressPicker
//
//  Created by apple on 17/6/27.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "AddressPickerVC.h"
#import <objc/runtime.h>
#define kTopBarHeight 64
#define kBaseNumer 1000
#define kWindowSize [UIScreen mainScreen].bounds.size

NSString *const ADDRESSPICKERVC_BINDING_KEY = @"com.baidu.AddressPickerVCKey";
@interface AddressPickerVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *areaArr;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

@end

@implementation AddressPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发货地";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadSubviews];
}

- (void)loadSubviews{
    for (NSInteger i = 0; i < 3; i ++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake((i % 3)*kWindowSize.width/3, kTopBarHeight, kWindowSize.width/3, kWindowSize.height - kTopBarHeight) style:UITableViewStyleGrouped];
        tableView.tag = i + kBaseNumer;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 44.f;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
    }
    [self getDataFromJson];
}

- (void)getDataFromJson
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.provinceArray = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves) error:nil];
    UITableView *tableView = (UITableView *)[self.view viewWithTag:kBaseNumer];
    [tableView reloadData];
    
}

#pragma mark - lazyMethod

- (NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [@[] mutableCopy];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [@[] mutableCopy];
    }
    return _cityArr;
}

- (NSMutableArray *)areaArr{
    if (!_areaArr) {
        _areaArr = [@[] mutableCopy];
    }
    return _areaArr;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == kBaseNumer) {
        return self.provinceArray.count;
    }else if (tableView.tag == kBaseNumer + 1){
        return self.cityArr.count;
    }
    return self.areaArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    if (tableView.tag == kBaseNumer) {
        if (self.lastIndexPath != nil && self.lastIndexPath == indexPath) {
            cell.contentView.backgroundColor = [UIColor orangeColor];
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];

        }
        cell.textLabel.text = self.provinceArray[indexPath.row][@"name"];
    }else if (tableView.tag == kBaseNumer + 1){
        cell.textLabel.text = self.cityArr[indexPath.row][@"name"];
    }else{
        cell.textLabel.text = self.areaArr[indexPath.row][@"name"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == kBaseNumer) {
        self.lastIndexPath = self.lastIndexPath ? self.lastIndexPath : [NSIndexPath indexPathForRow:-1 inSection:0];
        if (self.lastIndexPath != indexPath) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor orangeColor];
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
            oldCell.contentView.backgroundColor = [UIColor whiteColor];
            self.lastIndexPath = indexPath;
        }
        self.cityArr = self.provinceArray[indexPath.row][@"children"];
        UITableView *tableView = (UITableView *)[self.view viewWithTag:kBaseNumer + 1];
        [tableView reloadData];
    }else if (tableView.tag == kBaseNumer + 1){
        self.areaArr = self.cityArr[indexPath.row][@"children"];
        UITableView *tableView = (UITableView *)[self.view viewWithTag:kBaseNumer + 2];
        [tableView reloadData];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
