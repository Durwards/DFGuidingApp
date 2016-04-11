//
//  UIImage+extend.h
//  CityNeighbour
//
//  Created by ricky on 12-3-8.
//  Copyright (c) 2012年 Funcity. All rights reserved.
//

#define THUMBNAIL_HEIGHT    150
#define THUMBNAIL_WIDTH     240

#import "UIImage+extend.h"
CGFloat Degrees2Radians(CGFloat degrees);
CGFloat Radians2Degrees(CGFloat radians);
CGFloat Degrees2Radians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat Radians2Degrees(CGFloat radians) {return radians * 180/M_PI;};

NSMutableDictionary* g_AllColorImages;

@implementation UIImage (extend)

+ (CGSize)fitSizeForBoundSize:(CGSize)boundSize toOriginalSize:(CGSize)oriSize
{
    CGSize sizeRet = CGSizeZero;

    if( 0 == oriSize.width || 0 == oriSize.height || 0 == boundSize.width || 0 == boundSize.height )
        goto EXIT;
    
    if( oriSize.width < boundSize.width && oriSize.height < boundSize.height ) // too small, just return image size
    {
        sizeRet = oriSize;
        goto EXIT;
    }
    
    if( oriSize.height/ oriSize.width > boundSize.height/boundSize.width )  // too height, fit bound height
    {
        sizeRet.height = boundSize.height;
        sizeRet.width = sizeRet.height * oriSize.width / oriSize.height;
    }
    else
    {
        sizeRet.width = boundSize.width;
        sizeRet.height = sizeRet.width * oriSize.height / oriSize.width;
    }
    
EXIT:
    return sizeRet;
}

- (CGSize) fitSizeForBoundSize:(CGSize)boundSize
{
#if 0
    CGSize sizeRet = CGSizeZero;
    CGSize size = self.size;
    if( 0 == size.width || 0 == size.height || 0 == boundSize.width || 0 == boundSize.height )
        goto EXIT;
    
    if( size.width < boundSize.width && size.height < boundSize.height ) // too small, just return image size
    {
        sizeRet = size;
        goto EXIT;
    }
    
    if( size.height/ size.width > boundSize.height/boundSize.width )  // too height, fit bound height
    {
        sizeRet.height = boundSize.height;
        sizeRet.width = sizeRet.height * size.width / size.height;
    }
    else
    {
        sizeRet.width = boundSize.width;
        sizeRet.height = sizeRet.width * size.height / size.width;
    }
    
EXIT:
    return sizeRet;
#else
    return [UIImage fitSizeForBoundSize:boundSize toOriginalSize:self.size];
#endif
}

//截取部分图像
-(UIImage*)subImageAtRect:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
	
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    
    // 设置图片旋转方向
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef scale:1.0f orientation:self.imageOrientation];
    
    UIGraphicsEndImageContext();
//    CGContextRelease(context);
	CFRelease(subImageRef);
    return smallImage;
}

//等比例缩放
-(UIImage*)imageScaledToSize:(CGSize)size 
{
	CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
	
	float verticalRadio = size.height*1.0/height; 
	float horizontalRadio = size.width*1.0/width;
	
	float radio = 1;
	if(verticalRadio>1 && horizontalRadio>1)
	{
		radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;	
	}
	else
	{
		radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;	
	}
	
	width = width*radio;
	height = height*radio;
	
	int xPos = (size.width - width)/2;
	int yPos = (size.height-height)/2;
	
	// 创建一个bitmap的context  
    // 并把它设置成为当前正在使用的context  
    UIGraphicsBeginImageContext(size);  
	
    // 绘制改变大小的图片  
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];  
	
    // 从当前context中创建一个改变大小后的图片  
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();  
	
    // 使当前的context出堆栈  
    UIGraphicsEndImageContext();  
	
    // 返回新的改变大小后的图片  
    return scaledImage;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
	
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	UIImage* subImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	
	return subImage;
	
}
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor < heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}
- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	//   CGSize imageSize = sourceImage.size;
	//   CGFloat width = imageSize.width;
	//   CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	//   CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}
- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
	return [self imageRotatedByDegrees:Radians2Degrees(radians)];
}
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{ 
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(Degrees2Radians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, Degrees2Radians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}

- (UIImage *)imageByAddingImage:(UIImage*)anotherImage
{
    UIGraphicsBeginImageContext(self.size);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    float xPos = 0;
    float yPos = 0;
    float width = 0;
    float height = 0;
    width = anotherImage.size.width;
    height = anotherImage.size.height;
    xPos = (self.size.width-width)/2.0;
    yPos = (self.size.height-height)/2.0;
    
    
    [anotherImage drawInRect:CGRectMake(xPos, yPos, width, height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (UIImage *)imageByCompressRatio:(float)compressRatio
{
    NSData* imageData = UIImageJPEGRepresentation(self, compressRatio);
    if(!imageData)
        return nil;
    
    UIImage* newImage = [UIImage imageWithData:imageData];
    
    return newImage;
}

- (UIImage *)imageBySize:(CGSize)inSize compressRatio:(float)compressRatio
{
    UIImage* newImage = [self imageScaledToSize:inSize];
    newImage = [newImage imageByCompressRatio:compressRatio];
    
    return newImage;
}

- (UIImage *)imageFitBoundSize:(CGSize)inSize {
    CGSize fittedSize = [self fitSizeForBoundSize:inSize];
    return [self imageByScalingToSize:fittedSize];
}

- (UIImage *)imageThumbnail{
    CGFloat width = (self.size.width/self.size.height * THUMBNAIL_HEIGHT);
    if( THUMBNAIL_WIDTH < width )
        width = THUMBNAIL_WIDTH;
    return [self imageByScalingProportionallyToMinimumSize:CGSizeMake(width, THUMBNAIL_HEIGHT)];
}

- (UIImage *)convertToGrayscale {
    
    CGSize size = [self size];    
    int width = size.width;    
    int height = size.height;    
    
    // the pixels will be painted to this array    
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    
    // clear the pixels so any transparency is preserved    
    memset(pixels, 0, width * height * sizeof(uint32_t));    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
    // create a context with RGBA pixels    
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,                                                  
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);    
    
    // paint the bitmap to our context which will fill in the pixels array    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {        
        for(int x = 0; x < width; x++) {            
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];            
            
            /* convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale */        
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];            
            
            // set the pixels to gray            
            rgbaPixel[RED] = gray;            
            rgbaPixel[GREEN] = gray;            
            rgbaPixel[BLUE] = gray;            
        }        
    }    
    
    // create a new CGImageRef from our context with the modified pixels    
    CGImageRef image = CGBitmapContextCreateImage(context);    
    
    // we're done with the context, color space, and pixels    
    CGContextRelease(context);    
    CGColorSpaceRelease(colorSpace);    
    free(pixels);    
    
    // make a new UIImage to return    
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];    
    
    // we're done with image now too    
    CGImageRelease(image);    
    
    return resultUIImage;
    
}

-(UIImage *)TransformToSize:(CGSize)Newsize
{
    // 创建一个bitmap的context
    UIGraphicsBeginImageContextWithOptions(Newsize, NO, [UIScreen mainScreen].scale);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, Newsize.width, Newsize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg=UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

+ (UIImage *)imageNamed:(NSString *)name
{
    NSString* ext = [name pathExtension];
    if (ext == nil || [ext isEqualToString:@""])
        ext = @"png";
    NSString* fileName = [name stringByDeletingPathExtension];
    NSString* path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        if ([fileName hasSuffix:@"@2x"])
            return nil;
        
        fileName = [fileName stringByAppendingString:@"@2x"];
        path = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        if (![[NSFileManager defaultManager] fileExistsAtPath:path])
            return nil;
    }
    else if (![fileName hasSuffix:@"@2x"])
    {
        fileName = [fileName stringByAppendingString:@"@2x"];
        NSString* temp = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temp])
            path = temp;
    }
    else if (![fileName hasSuffix:@"@3x"])
    {
        fileName = [fileName stringByAppendingString:@"@3x"];
        NSString* temp = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
        if ([[NSFileManager defaultManager] fileExistsAtPath:temp])
            path = temp;
    }

    return [UIImage imageWithContentsOfFile:path];
}

+ (void)filteColorImages
{
    DFObject* obj = nil;
    NSArray* allKeys = g_AllColorImages.allKeys;
    for (NSString* pilot in allKeys)
    {
        obj = g_AllColorImages[pilot];
        if (obj.userData == nil)
        {
            [g_AllColorImages removeObjectForKey:pilot];
        }
    }
}

+ (NSString*)formatTitle:(UIColor *)color
{
    CGFloat fRed;
    CGFloat fGreen;
    CGFloat fBlue;
    CGFloat fAlpha;
    [color getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
    
    return [NSString stringWithFormat:@"%d-%d-%d-%d", (int)(fRed * 255.0f+0.5f), (int)(fGreen * 255.0f+0.5f), (int)(fBlue * 255.0f+0.5f), (int)(fAlpha * 255.0f+0.5f)];
}

+ (UIImage *)imageWithColor:(UIColor*)color andSize:(CGSize)size
{
    if (g_AllColorImages == nil)
        g_AllColorImages = [[NSMutableDictionary alloc]init];
    
    NSString* key = [UIImage formatTitle:color];
    UIImage * image;
    DFObject * obj = g_AllColorImages[key];
    if (obj)
    {
        image = (UIImage*)(obj.userData);
        if (image)
        {
            return image;
        }
        else
        {
            [g_AllColorImages removeObjectForKey:key];
        }
    }

    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width,size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [UIImage filteColorImages];
    [g_AllColorImages setObject:[[DFObject alloc]initWithUserData:image] forKey:key];
    
    return image;
}

@end;
