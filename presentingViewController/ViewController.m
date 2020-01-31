//
//  ViewController.m
//  presentingViewController
//
//  Created by yiban on 15/8/17.
//  Copyright (c) 2015年 yiban. All rights reserved.
//

#import "ViewController.h"
#import "PopoverViewController.h"

@interface ViewController () <UIPopoverPresentationControllerDelegate>
@end

@implementation ViewController {
    UIButton *_button;
    PopoverViewController *_buttonPopVC;
    PopoverViewController *_itemPopVC;
    NSArray<NSString *> *_colorArray;
    NSArray<UIColor *> *_colorObjArray;
    NSInteger _selected;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:@"item"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(rightItemClick)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    _colorArray = @[@"white", @"green", @"gray", @"blue", @"purple", @"yellow", ];
    _colorObjArray = @[[UIColor whiteColor], [UIColor greenColor], [UIColor grayColor], [UIColor blueColor], [UIColor purpleColor], [UIColor yellowColor], ];
    _selected = 0;
    
    self.view.backgroundColor = _colorObjArray[_selected];
    _button = [[UIButton alloc] initWithFrame:CGRectMake(20, 100, 100, 40)];
    [_button setTitle:@"button" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) rightItemClick {
    _itemPopVC = [[PopoverViewController alloc] init];
    _itemPopVC.colorArray = _colorArray;
    _itemPopVC.currentSelected = _selected;
    _itemPopVC.modalPresentationStyle = UIModalPresentationPopover;
    //rect参数是以view的左上角为坐标原点（0，0）
    _itemPopVC.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    //箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
    _itemPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown;
    _itemPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:_itemPopVC animated:YES completion:nil];
    
    __weak typeof(self) weakSelf = self;
    [_itemPopVC setOnItemSelected:^(id selectedObject, NSInteger selectedIndex) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf->_itemPopVC dismissViewControllerAnimated:YES completion:nil];
        strongSelf->_itemPopVC = nil;
        [strongSelf tableDidSelected:selectedObject index:selectedIndex];
    }];
}

//处理popover上的talbe的cell点击
- (void) tableDidSelected:(NSString*)color index:(NSInteger)index {
    _selected = index;
    self.view.backgroundColor = _colorObjArray[_selected];
}

- (void)buttonClick:(UIButton *)sender{
    _buttonPopVC = [[PopoverViewController alloc] init];
    _buttonPopVC.colorArray = _colorArray;
    _buttonPopVC.currentSelected = _selected;
    _buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    _buttonPopVC.popoverPresentationController.sourceView = _button;  //rect参数是以view的左上角为坐标原点（0，0）
    _buttonPopVC.popoverPresentationController.sourceRect = _button.bounds; //指定箭头所指区域的矩形框范围（位置和尺寸），以view的左上角为坐标原点
    _buttonPopVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp; //箭头方向
    _buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:_buttonPopVC animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    [_buttonPopVC setOnItemSelected:^(id selectedObject, NSInteger selectedIndex) {
        __strong typeof(self) strongSelf = weakSelf;
        // 我暂时使用这个方法让 popover 消失，但我觉得应该有更好的方法，因为这个方法并不会调用 popover 消失的时候会执行的回调。
        [strongSelf->_buttonPopVC dismissViewControllerAnimated:YES completion:nil];
        strongSelf->_buttonPopVC = nil;
        [strongSelf tableDidSelected:selectedObject index:selectedIndex];
    }];
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

//- (BOOL) popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
//    return NO; // 点击蒙板 popover 是否消失， 默认 yes
//}

- (void) popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"%@ popoverPresentationControllerDidDismissPopover", popoverPresentationController);
    _buttonPopVC = nil;
    _itemPopVC = nil;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
