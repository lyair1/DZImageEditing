//
// Created by Dmitry Zozulya on 03.04.14.
// Copyright (c) 2014 MLSDev. All rights reserved.
//

#import "DZImageHelper.h"


@implementation DZImageHelper

+ (UIImage *)cropImage:(UIImage *)image
        fromScrollView:(UIScrollView *)scrollView
              withSize:(CGSize)size
{
    CGSize scaledSize = CGSizeMake(image.size.width * scrollView.zoomScale, image.size.height * scrollView.zoomScale);
    CGFloat x = scrollView.contentOffset.x + scrollView.contentInset.left;
    CGFloat y = scrollView.contentOffset.y + scrollView.contentInset.top;
    CGRect cropRect = CGRectMake(x, y, size.width, size.height);
    return [self cropImage:image withRect:cropRect withScaledSize:scaledSize];
}

+ (CGFloat)minimumScaleFromSize:(CGSize)size toFitTargetSize:(CGSize)targetSize
{
    CGFloat widthScale = targetSize.width / size.width;
    CGFloat heightScale = targetSize.height / size.height;
    return (widthScale > heightScale) ? widthScale : heightScale;
}

+ (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect withScaledSize:(CGSize)scaledSize
{
    UIImage *scaledImage = [self imageWithImage:image
                                   scaledToSize:scaledSize];
    return [self cropImage:scaledImage withRect:rect];
}

+ (UIImage *)cropImage:(UIImage *)image withRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(imageRef);
    return resultImage;
}

#pragma mark - private

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end