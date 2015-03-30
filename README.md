# XLHeaderView
A simple UITableView header liked view, like "Me" page in Twitter.

#### How to use
Drag XLHeaderView.m and XLHeaderView.h to your Project.<br/>
####Use Code below to add header view to a navigation based view controller.
    self.headerView = [[XLHeaderView alloc] initWithFrame:CGRectMake(0, 0, 375, 263) backGroudImageName:@"backImage" subTitle:@"This is a UINavigation based view controller, its navigation bar is transparent"];
    self.headerView.scrollView = self.listTableV;
    [self.view addSubview:self.headerView];
Here is the effect<br/>
![github](http://onemin.qiniudn.com/xlheaderviewscroll1.gif "github")
<br/>
Enjoy it.


