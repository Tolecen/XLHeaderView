//
//  XLHeaderView.m
//  XLHeaderView
//
//  Created by Tolecen on 15/3/30.
//  Copyright (c) 2015年 Tolecen. All rights reserved.
//

#import "XLHeaderView.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>

@interface XLHeaderView()
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic,strong)NSMutableArray * blurImages;
@property (nonatomic,strong)UIImage * originImage;
@property (nonatomic,assign)int n;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic, assign) CGPoint prePoint;
@property (nonatomic,assign) CGSize originSize;
@end



@implementation XLHeaderView


- (id)initWithFrame:(CGRect)frame backGroudImageName:(NSString *)imageName subTitle:(NSString *)subTitle{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.originImage = [UIImage imageNamed:imageName];
        
        self.originSize = frame.size;

        self.blurImages = [NSMutableArray array];
        
        _backImageView = [[UIImageView alloc] init];
        [_backImageView setFrame:CGRectMake(0, -1, self.frame.size.width, self.frame.size.height)];
        _backImageView.userInteractionEnabled = NO;
        _backImageView.backgroundColor = [UIColor colorWithWhite:250/255.0f alpha:1];
        _backImageView.image = self.originImage;
        
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.85*frame.size.height, frame.size.width, frame.size.height*0.1)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.font = [UIFont systemFontOfSize:16];
        _subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.text = subTitle;
        _subTitleLabel.textColor = [UIColor whiteColor];
        
        
        [self addSubview:_backImageView];
        [self addSubview:_subTitleLabel];
        self.clipsToBounds = YES;
        
        NSMutableParagraphStyle *paragraphStyle2 = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle2.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes2 = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle2};
        cSize = [subTitle boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes2 context:nil].size;
        [_subTitleLabel setFrame:CGRectMake(10, frame.size.height-10-cSize.height, cSize.width, cSize.height)];
        
        [self makeBlurs];
        
    }
    return self;
}

-(void)makeBlurs
{
    self.originImage = _backImageView.image;
    [self.blurImages removeAllObjects];
    dispatch_queue_t queue = dispatch_queue_create("com.pet.blurPics", NULL);
    dispatch_async(queue, ^{
        [self prepareForBlurImages];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
            });
    });

//    [self prepareForBlurImages];
}

-(void)willMoveToSuperview:(UIView *)newSuperview{

    self.scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0 ,0, 0);
}

- (void)prepareForBlurImages
{
    if (self.originImage) {
        CGFloat factor = 0.1;
        
        for (NSUInteger i = 0; i < 20; i++) {
            [self.blurImages insertObject:[self.originImage boxblurImageWithBlur:factor] atIndex:0];
            factor+=0.04;
        }
        [self.blurImages addObject:self.originImage];
    }

}
-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset{
    
    if (!self.originImage&&self.backImageView.image) {
        self.originImage = self.backImageView.image;
    }
    
    float destinaOffset = -64;
    float startChangeOffset = -self.scrollView.contentInset.top;
    
    newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));

    float newY = -newOffset.y-self.scrollView.contentInset.top;
    float d = destinaOffset-startChangeOffset;
    float alpha = 1-(newOffset.y-startChangeOffset)/d;

    NSInteger index = (alpha*self.blurImages.count)/1;
    if (index < 0) {
        index = 0;
    }
    else if(index >= self.blurImages.count && self.blurImages.count>0) {
        index = self.blurImages.count - 1;
    }
    
    UIImage *image;
    if (self.blurImages.count>0) {
        image = self.blurImages[index];
    }
    else
        image = self.originImage;
    

    if (self.scrollView.contentOffset.y<=-self.originSize.height) {
        self.frame = CGRectMake(0,  self.scrollView.contentOffset.y<=-self.originSize.height?-1:newY,  self.frame.size.width, self.scrollView.contentOffset.y<=-self.originSize.height?(-self.scrollView.contentOffset.y):self.originSize.height);
        self.backImageView.frame = CGRectMake(-((self.originSize.width*self.frame.size.height/self.originSize.height)-self.frame.size.width)/2, 0, (self.originSize.width*self.frame.size.height/self.originSize.height), self.frame.size.height);
    }
    else{
        self.frame = CGRectMake(0, newY,  self.originSize.width, self.originSize.height);
        self.backImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    if (self.scrollView.contentOffset.y>=-64) {
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_subTitleLabel setFrame:CGRectMake(44,self.frame.size.height-33, [UIScreen mainScreen].bounds.size.width-88, 20)];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
       
    }
    else
    {
        [_subTitleLabel setFrame:CGRectMake(10, self.frame.size.height-10-cSize.height, cSize.width, cSize.height)];
        _subTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if (self.backImageView.image) {
        
        [self.backImageView setImage:image];

    }

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation UIImage (Blur)

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

@end

