// NSDictionary+JSONValues.m
//
// Copyright (c) 2013 Héctor Marqués
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NSDictionary+JSONValues.h"
#import "ErrorKitImports.h"

#if  ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag
#endif


#ifdef ERROR_KIT_JSON_VALUES

@implementation NSDictionary (ErrorKit_JSONValues)

+ (NSError *)mr_validationErrorWithKey:(id)aKey JSONPattern:(id)pattern object:(id)object value:(id)value
{
    MRErrorBuilder *builder =
    [MRErrorBuilder builderWithDomain:NSCocoaErrorDomain
                                 code:NSKeyValueValidationError];
    if (object) {
        if ([(id<NSObject>)aKey isKindOfClass:NSString.class]) {
            NSString *key = (NSString *)aKey;
            NSString *optionalKey = [key stringByAppendingString:@"?"];
            builder.localizedFailureReason =
            [MRErrorFormatter stringWithJSONPattern:pattern
                                             forKey:optionalKey];
#ifdef ERROR_KIT_CORE_DATA
            builder.validationKey = aKey;
#endif
        }
#ifdef ERROR_KIT_CORE_DATA
        builder.validationValue = value;
        builder.validationObject = object;
#endif
    } else if (aKey == nil) {
        builder.localizedFailureReason =
        [MRErrorFormatter stringWithExceptionName:NSInvalidArgumentException];
#ifdef ERROR_KIT_CORE_DATA
        builder.validationKey = @"key";
        builder.validationValue = NSNull.null;
#endif
    } else {
        if ([(id<NSObject>)aKey isKindOfClass:NSString.class]) {
            NSString *key = (NSString *)aKey;
            NSString *optionalKey = [key stringByAppendingString:@"?"];
            builder.localizedFailureReason =
            [MRErrorFormatter stringWithJSONPattern:pattern
                                             forKey:optionalKey];
        } else {
            builder.localizedFailureReason =
            [MRErrorFormatter stringWithExceptionName:NSInvalidArgumentException];
        }
#ifdef ERROR_KIT_CORE_DATA
        builder.validationKey = @"value";
        builder.validationValue = value;
#endif
    }
    return builder.error;
}

- (NSNumber *)numberForKey:(id)aKey withError:(NSError **)errorPtr
{
    id candidate = self[aKey];
    if (candidate && ![candidate isKindOfClass:NSNumber.class]) {
        if (errorPtr) {
            *errorPtr = [self.class mr_validationErrorWithKey:aKey
                                                  JSONPattern:@"number"
                                                       object:self
                                                        value:candidate];
        }
        candidate = nil;
    }
    return candidate;
}

- (NSString *)stringForKey:(id)aKey withError:(NSError **)errorPtr
{
    id candidate = self[aKey];
    if (candidate && ![candidate isKindOfClass:NSString.class]) {
        if (errorPtr) {
            *errorPtr = [self.class mr_validationErrorWithKey:aKey
                                                  JSONPattern:@"string"
                                                       object:self
                                                        value:candidate];
        }
        candidate = nil;
    }
    return candidate;
}

- (NSArray *)arrayForKey:(id)aKey withError:(NSError **)errorPtr
{
    id candidate = self[aKey];
    if (candidate && ![candidate isKindOfClass:NSArray.class]) {
        if (errorPtr) {
            *errorPtr = [self.class mr_validationErrorWithKey:aKey
                                                  JSONPattern:@[ ]
                                                       object:self
                                                        value:candidate];
        }
        candidate = nil;
    }
    return candidate;
}

- (NSDictionary *)dictionaryForKey:(id)aKey withError:(NSError **)errorPtr
{
    id candidate = self[aKey];
    if (candidate && ![candidate isKindOfClass:NSDictionary.class]) {
        if (errorPtr) {
            *errorPtr = [self.class mr_validationErrorWithKey:aKey
                                                  JSONPattern:@{ }
                                                       object:self
                                                        value:candidate];
        }
        candidate = nil;
    }
    return candidate;
}


@end

#endif
