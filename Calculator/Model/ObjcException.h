//
//  ObjcException.h
//  Calculator
//
//  Created by Suraj Pathak on 19/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ObjcException : NSObject

+ (id)catchException:(id(^)(void))tryBlock error:(__autoreleasing NSError **)error;

@end

NS_ASSUME_NONNULL_END
