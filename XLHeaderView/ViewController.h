//
//  ViewController.h
//  XLHeaderView
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLHeaderView.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * listTableV;
@property (nonatomic, strong) XLHeaderView *headerView;

@end

