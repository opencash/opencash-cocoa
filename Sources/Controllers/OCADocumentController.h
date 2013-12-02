//
//  OCADocumentController.h
//  OpenCash-Framework
//
//  Created by Serge Gebhardt on 11/25/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCAAccount.h"

@interface OCADocumentController : NSObject

- (id)initWithFilename:(NSString *)aName shouldInitialize:(bool)shouldInitialize;
- (NSArray *)retrieveAccounts;
- (OCAAccount *)newAccount;
- (void)persistAccount:(OCAAccount *)account;

+ (NSString *)getAString;

@end