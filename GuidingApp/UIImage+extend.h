//
//  UIImage+extend.h
//  CityNeighbour
//
//  Created by ricky on 12-3-8.
//  Copyright (c) 2012年 Funcity. All rights reserved.
//
#import <Foundation/Foundation.h>

enum _subImagePos
{
    POSITION_CENTENR,
    POSITION_TOP_LEFT,
    POSITION_TOP_RIGHT,
    POSITION_BOTTOM_LEFT,
    POSITION_BOTTOM_RIGHT,
};

typedef enum {    
    ALPHA = 0,    
    BLUE = 1,    
    GREEN = 2,    
    RED = 3    
} PIXELS;

@interface UIImage(extend)
+ (CGSize)fitSizeForBoundSize:(CGSize)boundSize toOriginalSize:(CGSize)oriSize;
- (CGSize) fitSizeForBoundSize:(CGSize)boundSize;
- (UIImage *)subImageAtRect:(CGRect)rect;
- (UIImage *)imageScaledToSize:(CGSize)size;
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageByAddingImage:(UIImage*)anotherImage;
- (UIImage *)imageByCompressRatio:(float)compressRatio;
- (UIImage *)imageBySize:(CGSize)inSize compressRatio:(float)compressRatio;
- (UIImage *)imageFitBoundSize:(CGSize)inSize;
- (UIImage *)imageThumbnail;
- (UIImage *)convertToGrayscale;
- (UIImage *)TransformToSize:(CGSize)Newsize;//转换到指定大小
//有时候美工会出一些纯色图片资源，遇到这种情况，可以用本接口来替代，这样可以减小资源
+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size;
@end;
