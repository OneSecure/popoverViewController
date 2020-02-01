//
//  Popover.m
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "PopoverViewController.h"

@implementation PopoverViewController {
    UITableView *_tableView;
}

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedItem = -1;
    }
    return self;
}

- (void) setSelectedItem:(NSInteger)selectedItem {
    if (0 <= selectedItem && selectedItem < _menuItems.count) {
        _selectedItem = selectedItem;
    } else {
        _selectedItem = -1;
    }
    [_tableView reloadData];
}

- (void) setMenuItems:(NSArray<NSString *> *)menuItems {
    _menuItems = menuItems;
    [_tableView reloadData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    CGRect frame = self.view.frame;
    _tableView = [[UITableView alloc] initWithFrame:frame];
    [self.view addSubview:_tableView];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = YES;
    
    // 这一句很重要, 否则 tableView 在 iOS 13 下会错位. 
    _tableView.bounces = NO;
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
     _tableView.frame = self.view.frame;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _menuItems[indexPath.row]];
    cell.accessoryType = (_selectedItem == indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedItem = indexPath.row;
    if (_onItemSelected) {
        _onItemSelected(_menuItems[_selectedItem], _selectedItem);
    }
}

// 重写 preferredContentSize, 让 popover 返回你期望的大小
- (CGSize) preferredContentSize {
    if (self.presentingViewController && _tableView != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        //tempSize.width = 150;
        
        // sizeThatFits 返回的是最合适的尺寸，但不会改变控件的大小
        CGSize size = [_tableView sizeThatFits:tempSize];
        return size;
    } else {
        return [super preferredContentSize];
    }
}

- (void) setPreferredContentSize:(CGSize)preferredContentSize {
    super.preferredContentSize = preferredContentSize;
}

- (void) dealloc {
    // NSLog(@"%@ dead", self);
}

@end
