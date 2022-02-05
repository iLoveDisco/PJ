//
//  OpenCVWrapper.h
//  PictoJump iOS
//
//  Created by Eric Tu on 11/20/21.
//
#import "OpenCVWrapper.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject
+ (UIImage *)toGray:(UIImage *)source;

+ (UIImage *)toCanny:(UIImage *)source: (double) thresh1: (double) thresh2;
@end

NS_ASSUME_NONNULL_END
