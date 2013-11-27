//
//  OCAAccountCppMapper.m
//  OpenCash
//
//  Created by Serge Gebhardt on 11/18/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import "OCAAccountCppMapper.h"
#import <opencash/model/Account.h>

@interface OCAAccountCppMapper ()

@property (retain) NSMutableDictionary *map;

@end

@implementation OCAAccountCppMapper

@synthesize map;

+ (id)sharedInstance;
{
  static dispatch_once_t p = 0;
  __strong static id _sharedObject = nil;

  dispatch_once(&p, ^{
    _sharedObject = [[self alloc] init];
  });

  return _sharedObject;
}

- (id)init;
{
  if (self = [super init]) {
    map = [[NSMutableDictionary alloc] init];
  }
  return self;
}

- (OCAAccount *)getOrCreate:(AccountPtr)account;
{
  NSString *uuid = [NSString stringWithUTF8String:account->getName().c_str()];
  OCAAccount *ret = [map objectForKey:uuid];
  if (!ret) {
    ret = [[OCAAccount alloc] initWithAccount:account];
    [map setObject:ret forKey:uuid];
  }
  return ret;
}

@end
