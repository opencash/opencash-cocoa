//
//  OCAAccount.m
//  OpenCash-Framework
//
//  Created by Serge Gebhardt on 11/25/13.
//  Copyright (c) 2013 Serge Gebhardt. All rights reserved.
//

#import "OCAAccount.h"
#import "OCAAccountCppMapper.h"
#import <opencash/model/Account.h>
#import <opencash/controller/ModelObserver.h>
#import <Poco/Delegate.h>

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

class KvcProxy : public opencash::controller::ModelObserver {
  using ChangeType = opencash::model::ObservableModel::ChangeType;

private:
  id _objcTarget;

public:
  KvcProxy(opencash::model::ObservableModel & model, id objcTarget)
  : ModelObserver(model)
  , _objcTarget(objcTarget)
  {}

protected:
  void willChange(const std::string & key) override
  {
  NSString *keyStr = [NSString stringWithUTF8String:key.c_str()];
#ifdef DEBUG
  SuppressPerformSelectorLeakWarning
  (
   NSLog(@"willChange:%@ (current: '%@')", keyStr,
         [_objcTarget performSelector:NSSelectorFromString(keyStr)]);
   );
#endif
  [_objcTarget willChangeValueForKey:keyStr];
}

void didChange(const std::string & key) override
{
NSString *keyStr = [NSString stringWithUTF8String:key.c_str()];
#ifdef DEBUG
SuppressPerformSelectorLeakWarning
(
 NSLog(@"didChange:%@ (current: '%@')", keyStr,
       [_objcTarget performSelector:NSSelectorFromString(keyStr)]);
 );
#endif
[_objcTarget didChangeValueForKey:keyStr];
}

void willChangeAtIndex(const std::string & key, const std::size_t & index,
                       const ChangeType & change) override
{
NSString *keyStr = [NSString stringWithUTF8String:key.c_str()];
NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
#ifdef DEBUG
NSLog(@"willChangeAtIndex(%@, %lu)", keyStr, index);
#endif
[_objcTarget willChange:convertChangeTypeToNSKeyValueChange(change)
        valuesAtIndexes:indexSet forKey:keyStr];
}

void didChangeAtIndex(const std::string & key, const std::size_t & index,
                      const ChangeType & change) override
{
NSString *keyStr = [NSString stringWithUTF8String:key.c_str()];
NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:index];
#ifdef DEBUG
NSLog(@"didChangeAtIndex(%@, %lu)", keyStr, index);
#endif
[_objcTarget didChange:convertChangeTypeToNSKeyValueChange(change)
       valuesAtIndexes:indexSet forKey:keyStr];
}

private:
NSKeyValueChange convertChangeTypeToNSKeyValueChange(ChangeType change)
{
  NSKeyValueChange ret;

  switch (change) {
    case ChangeType::Setting:
      ret = NSKeyValueChangeSetting;
      break;
    case ChangeType::Insertion:
      ret = NSKeyValueChangeInsertion;
      break;
    case ChangeType::Removal:
      ret = NSKeyValueChangeRemoval;
      break;
    case ChangeType::Replacement:
      ret = NSKeyValueChangeReplacement;
      break;

    default:
      // TODO
      break;
  }

  return ret;
}
};

@interface OCAAccount ()
@property (assign) AccountPtr _account;
@property (assign) std::shared_ptr<KvcProxy> _kvcProxy;
@end

@implementation OCAAccount

@synthesize _account;
@synthesize _kvcProxy;

#pragma mark Boilerplate

- (id)initWithAccount:(AccountPtr)account;
{
  if (self = [super init]) {
    _kvcProxy = std::make_shared<KvcProxy>(*account, self);
    _account = account;
  }
  return self;
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey;
{
  BOOL automatic = NO;
  if ([theKey isEqualToString:@"name"] ||
      [theKey isEqualToString:@"description"] ||
      [theKey isEqualToString:@"parent"] ||
      [theKey isEqualToString:@"children"])
  {
    automatic = NO;
  }
  else {
    automatic = [super automaticallyNotifiesObserversForKey:theKey];
  }
  return automatic;
}

#pragma mark Functionality

- (NSString *)name;
{
  return [NSString stringWithUTF8String:_account->getName().c_str()];
}

- (void)setName:(NSString *)name;
{
  _account->setName([name UTF8String]);
}

- (NSString *)descr;
{
  return [NSString stringWithUTF8String:_account->getDescr().c_str()];
}

- (void)setDescr:(NSString *)description;
{
  _account->setDescr([description UTF8String]);
}

- (OCAAccount *)parent;
{
  AccountPtr parent = _account->getParent();
  OCAAccount *ret = nil;

  if (parent) {
    ret = [[OCAAccountCppMapper sharedInstance] getOrCreate:parent];
  }

  return ret;
}

- (void)setParent:(OCAAccount *)parent;
{
  _account->setParent(parent._account);
}

- (NSArray *)children;
{
  NSMutableArray *ret = [NSMutableArray array];
  for (auto & child : _account->getChildren()) {
    [ret addObject:[[OCAAccountCppMapper sharedInstance] getOrCreate:child.lock()]];
  }
  return ret;
}

#pragma mark KVC

@end