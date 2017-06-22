//
//  imageTools.m
//  实现图片打码效果
//
//  Created by 这个男人来自地球 on 2017/6/21.
//  Copyright © 2017年 zhang yannan. All rights reserved.
//

#import "imageTools.h"

@implementation imageTools
//通过系统实现图片的打码效果
+(UIImage *)iosImageProcess:(UIImage *)image{
    //第一步：获取图片的大小
    CGImageRef imageRef=image.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    //第二步：创建颜色空间（明确图片是什么类型）
    /*彩色与灰色图片*/
    CGColorSpaceRef colorSpace=CGImageGetColorSpace(imageRef);
    //第三步：创建图片上下文
    /*
        参数一：数据源
        参数二：图片的宽
        参数三：图片的高
        参数四：每一个像素点（图片是有像素组成，每一个像素点是由分量ARGB组成，一个颜色就是一个分量。固定代表8位==1字节）
        参数五：每一行占用内存的大小
        一个像素大小=4 * 8 = 32位=4字节
        参数六：颜色空间
        参数七：是否需要透明度
     */
    CGContextRef contextRef=CGBitmapContextCreate(nil,
                                                  width,
                                                  height,
                                                  8,
                                                  width * 4,
                                                  colorSpace, kCGImageAlphaPremultipliedLast);
    //第四步：根据图片上下文绘制图片
    CGContextDrawImage(contextRef,
                       CGRectMake(0, 0, width, height),
                       imageRef);
    //第五步：根据图片上下文获取  刚刚创建的图片
    unsigned char *imageData = (unsigned char*)CGBitmapContextGetData(contextRef);
    //第六：进行打码过程
    int currentIndex=0 , preindex=0;
    int level=20;
    //定义像素点数组，用于保存像素点的值
    unsigned char pixcels[4]={0};
    for (int i=0; i<height; i++) {
        for (int j=0; j<width; j++) {
            //计算当前的位置
            currentIndex = i*width+j;
            //获取马赛克第一列第一行的像素值
            if (i%level==0) {
                //马赛克矩形第一行
                
                if (j%level==0) {
                    //马赛克第一行第一列
                    //要想获取第一个像素的值，要使用C语言的数据拷贝
                    /*
                        参数一：目标数据（拷贝到哪里）
                        参数二：数据源（从哪里拷贝）
                        参数三：拷贝多少内容
                     */
                    memcpy(pixcels, imageData+4*currentIndex, 4);
                }else{
                    //其他列
                    //将第一个像素点的值复制给其他像素（在同一行的）
                    //实现：C函数的拷贝
                    //计算上一行马赛克的位置
                    memcpy(imageData+4*currentIndex, pixcels, 4);
                }
            }else{
                //马赛克矩形的其他行
                //相对于上一行
                preindex=(i-1)*width+j;
                
                memcpy(imageData+4*currentIndex, imageData+4*preindex, 4);
                
            }
        }
    }
    //第七步：获取图片数据集合
   CGDataProviderRef provider = CGDataProviderCreateWithData(NULL,
                                                             imageData, width*height*4,
                                                             NULL);
    //第八步：形成马赛克图片
    /*
        参数一：图片的宽
        参数二：图片的高
        参数三：每一个像素点，每一个分量的大小
        参数四：每一个像素点占用内存的大小
        参数五：每一行占用内存的大小
        参数六：颜色空间
        参数七：是否需要透明度
        参数八：数据集合
        参数九：数据解码器
        参数十：是否抗锯齿
        参数十一：图片渲染器
     */
    CGImageRef masaicImageRef = CGImageCreate(width,
                  height,
                  8,
                  32,
                  width*4,
                  colorSpace,
                  kCGBitmapByteOrderDefault,
                  provider,
                  NULL,
                  NO,
                  kCGRenderingIntentDefault);
    //第九步，去创建输出图片，并显示在控制器上
    CGContextRef outputContextRef=CGBitmapContextCreate(nil,
                                                        width,
                                                        height,
                                                        8,
                                                        width * 4, colorSpace, kCGImageAlphaPremultipliedLast);
    //绘制
    CGContextDrawImage(outputContextRef, CGRectMake(0, 0, width, height), masaicImageRef);
    CGImageRef outputImageRef = CGBitmapContextCreateImage(outputContextRef);
    UIImage *outputImage=[UIImage imageWithCGImage:outputImageRef];
    //释放内存
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(outputImageRef);
    CGImageRelease(masaicImageRef);
    CGDataProviderRelease(provider);
    CGContextRelease(outputContextRef);

    
    return outputImage;
}
@end
