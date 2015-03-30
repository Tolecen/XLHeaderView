//
//  XLHeaderView.h
//  XLHeaderView
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLHeaderView : UIView
{
    CGSize cSize;
}
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame backGroudImageName:(NSString *)imageName subTitle:(NSString *)subTitle;
-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;
@end
@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end