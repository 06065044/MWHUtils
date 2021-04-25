//
//  NSString+URL.m
//  
//
//  Created by jinkai on 2017/10/12.
//

#import "NSString+URL.h"

@implementation NSString (URL)

- (NSString *)stringToUnicode {
    NSString *result = [NSString string];
        for (NSUInteger i = 0; i < [self length]; i++) {
            result = [result stringByAppendingFormat:@"\\u%04x", [self characterAtIndex:i]];
            /*
             因为 Unicode 用 16 个二进制位（即 4 个十六进制位）表示字符,对于小于 0x1000 字符要用 0 填充空位,
             所以使用 %04x 这个转换符, 使得输出的十六进制占 4 位并用 0 来填充开头的空位.
             */
        }
        return result;
}

/**
 *  编码  URLEncodedString
 *  @return 编码url
 */
- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                            (CFStringRef)[self copy],
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             NULL,
                                                                            kCFStringEncodingUTF8));
    return encodedString;
}

/**
 *  解码  URLDecodedString
 *  @param str 已编码的Url字符串
 *  @return 解码url
 */
- (NSString *)URLDecodedString
{
    NSString *remakeString = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)remakeString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

/**
 *  解码  URLDecodedString
 *  @param str 已编码的Url字符串
 *  @return 解码url
 */
- (NSString *)sbn_URLDecodedString
{
    NSString *remakeString = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)remakeString, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

/**
 *CFStringRef CFURLCreateStringByAddingPercentEscapes(
 *CFAllocatorRef allocator,
 *CFStringRef originalString,   待转码的类型
 *CFStringRef charactersToLeaveUnescaped, 指示不转义的字符
 *CFStringRef legalURLCharactersToBeEscaped,指示确定转义的字符
 *CFStringEncoding encoding); 编码类型
 */
- (NSString *)URLAllEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)sbn_URLcovert {
    if ([self hasPrefix:@"http"]) {
        return self;
    }

    return [NSString stringWithFormat:@"http%@", self];
}

- (NSString *)sbn_URLAddNewParameterWithKey:(NSString *)key value:(NSString *)value{
    if (self.length == 0) {
        return self;
    }
    NSString *parameter = [NSString stringWithFormat:@"%@=%@",key, value];
    return [self sbn_URLAddNewParameter:parameter];
}

- (NSString *)sbn_URLAddNewParameter:(NSString *)parameter{
    if (self.length == 0 || parameter.length == 0) {
        return self;
    }
    NSRange range = [self rangeOfString:@"?"];
    NSString * newUrl;
    if (range.location != NSNotFound) {
        newUrl = [NSString stringWithFormat:@"%@&%@",self, parameter];
    }else
    {
        newUrl = [NSString stringWithFormat:@"%@?%@",self, parameter];
    }
    return newUrl;
}

@end
