//
//  XLHeaderView.h
//  TalkingPet
//
//  Created by Tolecen on 15-3-25.
//  Copyright (c) 2015年 wangxr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "TTImageHelper.h"
@interface XLHeaderView : UIView<EGOImageButtonDelegate>
{
    CGSize cSize;
}
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame backGroudImageURL:(NSString *)backImageURL headerImageURL:(NSString *)headerImageURL title:(NSString *)title subTitle:(NSString *)subTitle;
-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;
@end
@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end