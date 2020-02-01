//
//  Popover.h
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) NSArray<NSString *> *menuItems;
@property(nonatomic, assign) NSInteger selectedItem;
@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong) void (^onItemSelected)(id selectedObject, NSInteger selectedIndex);

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@end
