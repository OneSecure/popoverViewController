//
//  Popover.m
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "PopoverViewController.h"

@implementation PopoverViewController {
    @protected UIView *_contentView;
}

- (instancetype) initWithContentView:(UIView *)contentView {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _contentView = contentView;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    if (_contentView) {
        [self.view addSubview:_contentView];
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_contentView) {
        ;
    }
}

// 重写 preferredContentSize, 让 popover 返回你期望的大小
- (CGSize) preferredContentSize {
    if (self.presentingViewController && _contentView != nil) {
        return _contentView.frame.size;
    } else {
        return [super preferredContentSize];
    }
}

- (void) dealloc {
    // NSLog(@"%@ dead", self);
}

@end


@interface PopoverTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@end

@implementation PopoverTableViewController

- (instancetype) initWithArray:(NSArray<NSString *> *)array selectedItem:(NSInteger)selectedItem {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    if (self = [super initWithContentView:tableView]) {
        _menuItems = array;
        _selectedItem = selectedItem;
    }
    return self;
}

- (void) setSelectedItem:(NSInteger)selectedItem {
    if (0 <= selectedItem && selectedItem < _menuItems.count) {
        _selectedItem = selectedItem;
    } else {
        _selectedItem = -1;
    }
    [(UITableView *)_contentView reloadData];
}

- (void) setMenuItems:(NSArray<NSString *> *)menuItems {
    _menuItems = menuItems;
    [(UITableView *)_contentView reloadData];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    if (_menuItems) {
        UITableView *tableView = (UITableView *)_contentView;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.scrollEnabled = YES;
        tableView.frame = self.view.frame;
    
        // 这一句很重要, 否则 tableView 在 iOS 13 下会错位.
        tableView.bounces = NO;
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _contentView.frame = self.view.frame;
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

- (CGSize) preferredContentSize {
    if (self.presentingViewController && _menuItems != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        //tempSize.width = 150;
        
        // sizeThatFits 返回的是最合适的尺寸，但不会改变控件的大小
        CGSize size = [_contentView sizeThatFits:tempSize];
        return size;
    } else {
        return [super preferredContentSize];
    }
}

@end


@implementation PopoverImageViewController {
    UIImage *_image;
}

- (instancetype) initWithImage:(UIImage *)image {
    UIImageView *view = [[UIImageView alloc] init];
    if ((self = [super initWithContentView:view])) {
        _image = image;
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    if (_image) {
        _contentView.contentMode = UIViewContentModeScaleAspectFit;
    }
}

- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_image) {
        _contentView.frame = self.view.frame;
        [self drawImage];
    }
}

- (void) drawImage {
    CGSize imgSize = _image.size;
    CGSize viewSize = _contentView.frame.size;
    float scaleFactor = MIN(viewSize.width/imgSize.width, viewSize.height/imgSize.height);
    CGRect frame = CGRectMake(0, 0, imgSize.width * scaleFactor, imgSize.height * scaleFactor);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    [_image drawInRect:frame];
    UIImage *fitImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    ((UIImageView*)_contentView).image = fitImage;
}

- (CGSize) preferredContentSize {
    if (self.presentingViewController && _image != nil) {
        CGSize imgSize = _image.size;
        CGSize viewSize = self.view.frame.size;
        float scaleFactor = MIN(viewSize.width / imgSize.width, viewSize.height / imgSize.height);
        CGSize fitSize = CGSizeMake(imgSize.width * scaleFactor, imgSize.height * scaleFactor);
        CGSize size = [_contentView sizeThatFits:fitSize];
        return size;
    } else {
        return [super preferredContentSize];
    }
}

@end
