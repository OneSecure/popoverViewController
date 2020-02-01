//
//  Popover.h
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController
@property(nonatomic, strong, readonly) UIView *contentView;
- (instancetype) initWithContentView:(UIView *)contentView;
@end


@interface PopoverTableViewController : PopoverViewController
@property(nonatomic, strong) NSArray<NSString *> *menuItems;
@property(nonatomic, assign) NSInteger selectedItem;
@property(nonatomic, strong) void (^onItemSelected)(id selectedObject, NSInteger selectedIndex);
- (instancetype) initWithArray:(NSArray<NSString *> *)array selectedItem:(NSInteger)selectedItem;
@end


@interface PopoverImageViewController : PopoverViewController
@property(nonatomic, strong) UIImage *image;
- (instancetype) initWithImage:(UIImage*)image;
@end
