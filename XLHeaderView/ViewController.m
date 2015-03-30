//
//  ViewController.m
//  XLHeaderView
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 Tolecen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.alpha=0;
            }
        }
        
    }

    
    self.listTableV = [[UITableView alloc]initWithFrame:self.view.frame];
    self.listTableV.delegate = self;
    self.listTableV.dataSource = self;
    self.listTableV.scrollsToTop = YES;
    self.listTableV.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.listTableV];
    
    
    self.headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, 375, 263) backGroudImageName:@"backImage" subTitle:@"This is a UINavigation based view controller, its navigation bar is transparent"];
    self.headerView.scrollView = self.listTableV;
    [self.view addSubview:self.headerView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView updateSubViewsWithScrollOffset:scrollView.contentOffset];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"theCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell index %d",(int)indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
