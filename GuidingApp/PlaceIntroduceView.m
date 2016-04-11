//
//  PlaceIntroduceView.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/25.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "PlaceIntroduceView.h"
#import "UIImageView+WebCache.h"

@interface PlaceIntroduceView ()

@property (weak, nonatomic) IBOutlet UIView *placeImages;
@property (weak, nonatomic) IBOutlet UITextView *placeIntroduceText;

@end

@implementation PlaceIntroduceView {
    NSMutableArray *imagesArray;
    UIImageView *currentImageView;
    int currentImageIndex;
}

- (void)awakeFromNib {
    imagesArray = [[NSMutableArray alloc]init];
}


- (void)setContentWithImages:(NSArray *)imageStr withIntroduction:(NSString *)text {
    if (imageStr.count == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:Screen_Frame];
        imageView.image = IMG(@"unloading");
        [imagesArray addObject:imageView];
    }
    self.placeIntroduceText.text = text;
    for (int i = 0; i < imageStr.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:Screen_Frame];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr[i]] placeholderImage:IMG(@"unloading") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (i == 0) {
                currentImageIndex = 0;
                currentImageView = imageView;
                [_placeImages addSubview:currentImageView];
                [NSTimer scheduledTimerWithTimeInterval:10
                                                 target:self
                                               selector:@selector(showNextImage)
                                               userInfo:nil
                                                repeats:YES];

            }
        }];
        [imagesArray addObject:imageView];

    }
    
}

- (void)showNextImage {
    //隐藏原有的
    [UIView animateWithDuration:1 animations:^{
        currentImageView.alpha = 0;
    }completion:^(BOOL finished) {
        [currentImageView removeFromSuperview];
        
        //显示下一张
        UIImageView *nextImageView = imagesArray[(currentImageIndex+1 == imagesArray.count)?0:currentImageIndex+1];

        nextImageView.alpha = 0;
        [_placeImages addSubview:nextImageView];
        
        [UIView animateWithDuration:0.5 animations:^{
            nextImageView.alpha = 1;
        }completion:^(BOOL finished) {
            currentImageView = nextImageView;
            currentImageIndex ++;
            if (currentImageIndex >= imagesArray.count) {
                currentImageIndex = 0;
            }
        }];
    }];

}


@end
