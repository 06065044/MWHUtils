//
//  NSString+Emoji.m
//  iPhoneNews
//
//  Created by 黄安华 on 2017/11/30.
//  Copyright © 2017年 sohu. All rights reserved.
//

#import "NSString+Character.h"
#import <objc/runtime.h>

@interface NSString()
@property (nonatomic, strong) NSNumber *p_charLength;
@end

@implementation NSString (Character)

- (void)setP_charLength:(NSNumber *)charLength {
    objc_setAssociatedObject(self, @selector(p_charLength), charLength, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)p_charLength {
    return objc_getAssociatedObject(self, @selector(p_charLength));
}

- (BOOL)containsEmoji {
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                     *stop = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
                 *stop = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
                 *stop = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
                 *stop = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
                 *stop = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
                 *stop = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
                 *stop = YES;
             }
         }
     }];
    
    return returnValue;
}

- (NSInteger)emojiCount {
    __block NSInteger count = 0;
        [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
         ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // 代理对
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 //左移4位
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     count ++;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 count ++;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 count ++;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 count ++;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 count ++;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 count ++;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 count ++;
             }
         }
     }];
    
    return count;
}

- (NSInteger)charLength {

    if (self.p_charLength) return self.p_charLength.integerValue;
    //123😆 length=5
    __block NSInteger length = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         length ++;
     }];
    
    self.p_charLength = @(length);
    
    return length;
}

- (NSString *)substringWithMaxIndex:(NSInteger )index {
    
    if (index <= 0) {
        return @"";
    }
    
    NSInteger length = self.charLength;
    if (length <= index) {
        return self;
    }
    
    // 0 < index < self.charLength - 1
    __block NSInteger enumerateCount = 0;
    __block NSInteger toIndex = 0;
    [self enumerateSubstringsInRange:NSMakeRange(0, self.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         //123458
         enumerateCount ++;
         if (enumerateCount == index) {
             toIndex = substringRange.location+substringRange.length;
             *stop = YES;
         }
     }];

    if (toIndex > 0) {
        return [self substringToIndex:toIndex];
    }

    return self;
}

@end
