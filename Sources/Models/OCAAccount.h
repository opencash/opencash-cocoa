//
//  OCAAccount.h
//  OpenCash-Framework
//
//  Created by Serge Gebhardt on 11/25/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import <opencash/model/Account.h>
typedef opencash::model::Account::AccountPtr AccountPtr;
#else
typedef void* AccountPtr;
#endif

@interface OCAAccount : NSObject

@property (assign) NSString *name;
@property (assign) NSString *descr;
@property (assign, readonly) NSArray *children;

- (id)initWithAccount:(AccountPtr)account;
- (id)init __attribute__((unavailable("not an initializer")));

- (OCAAccount *)parent;
- (void)setParent:(OCAAccount *)parent;

@end