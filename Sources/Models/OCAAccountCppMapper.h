//
//  OCAAccountCppMapper.h
//  OpenCash
//
//  Created by Serge Gebhardt on 11/18/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCAAccount.h"

@interface OCAAccountCppMapper : NSObject

+ (id)sharedInstance;
- (OCAAccount *)getOrCreate:(AccountPtr)account;

@end
