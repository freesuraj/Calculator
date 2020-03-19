//
//  ObjcException.m
//  Calculator
//
//  Created by Suraj Pathak on 19/3/20.
//  Copyright © 2020 Suraj Pathak. All rights reserved.
//

#import "ObjcException.h"

@implementation ObjcException

+ (id)catchException:(id(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        id result = tryBlock();
        return result;
    }
    @catch (NSException *exception) {
        if (error) {
            *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
        }
        return nil;
    }
}

@end
