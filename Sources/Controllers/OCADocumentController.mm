//
//  OCADocumentController.m
//  OpenCash-Framework
//
//  Created by Serge Gebhardt on 11/25/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import "OCADocumentController.h"
#import <opencash/controller/DocumentController.h>
#import <opencash/model/Account.h>
#import <opencash/model/AccountsMeta.h>
#import <opencash/model/TransactionsMeta.h>

@interface OCADocumentController ()

@property (assign) std::shared_ptr<opencash::controller::DocumentController> _docController;

@end

@implementation OCADocumentController

@synthesize _docController;

- (id) initWithFilename:(NSString *)aName shouldInitialize:(bool)shouldInitialize;
{
  if (self = [super init]) {
    // TODO handle cpp exceptions?
    _docController = std::make_shared<opencash::controller::DocumentController>([aName UTF8String], shouldInitialize);
  }
  return self;
}

- (id) init;
{
  return [self initWithFilename:@"mydocument.db" shouldInitialize:NO];
}

- (NSArray *)retrieveAccounts;
{
  NSMutableArray *ret = [NSMutableArray array];
  auto accounts = _docController->retrieveAccounts();
  for (auto & account : accounts) {
    [ret addObject:[[OCAAccount alloc] initWithAccount:account]];
  }
  return ret;
}

- (OCAAccount *)newAccount;
{
  return [[OCAAccount alloc] initWithAccount:_docController->newAccount()];
}

- (void)persistAccount:(OCAAccount *)account;
{
}

+ (NSString *)getAString;
{
  return @"blaaaaH";
}

@end