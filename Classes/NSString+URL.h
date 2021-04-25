//
//  NSString+URL.h
//  
//
//  Created by jinkai on 2017/10/12.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/// 将 NSString 字符串转换成 Unicode 编码（形如 \u597d）
- (NSString *)stringToUnicode;

/**
 *  编码  URLEncodedString
 *  @return 编码url
 */
- (NSString *)URLEncodedString;

/**
 *  解码  URLDecodedString
 *  @param str 已编码的Url字符串
 *  @return 解码url
 */
- (NSString *)URLDecodedString;

- (NSString *)URLAllEncodedString;

- (NSString *)sbn_URLDecodedString;

- (NSString *)sbn_URLcovert;

/*
    url 添加参数。
    比如添加a=123:http://confluence.sohuno.com/pages/viewpage.action?pageId=42276489
    变成：http://confluence.sohuno.com/pages/viewpage.action?pageId=42276489&a=123
 */
- (NSString *)sbn_URLAddNewParameterWithKey:(NSString *)key value:(NSString *)value;

/**
 url 添加参数。

 @param parameter 比如：a=123
 @return 改变后的url
 */
- (NSString *)sbn_URLAddNewParameter:(NSString *)parameter;
@end
