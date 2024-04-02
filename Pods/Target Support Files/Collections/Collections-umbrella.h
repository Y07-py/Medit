#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Collections.h"
#import "Common.h"
#import "CommonHelpers.h"
#import "MDPair.h"
#import "NSArray+Collections.h"
#import "NSDictionary+Collections.h"
#import "NSSet+Collections.h"
#import "NSString+Collections.h"

FOUNDATION_EXPORT double CollectionsVersionNumber;
FOUNDATION_EXPORT const unsigned char CollectionsVersionString[];

