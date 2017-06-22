//
//  imageTools.h
//  实现图片打码效果
//
//  Created by 这个男人来自地球 on 2017/6/21.
//  Copyright © 2017年 zhang yannan. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface imageTools : NSObject
//通过系统实现图片的打码效果
+(UIImage *)iosImageProcess:(UIImage *)image;
//通过openCV实现图片的打码效果
+(UIImage *)openCVImageProcess:(UIImage *)image;

@end
