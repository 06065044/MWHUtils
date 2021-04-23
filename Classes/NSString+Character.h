//
//  NSString+Character.h
//  iPhoneNews
//
//  Created by 黄安华 on 2017/11/30.
//  Copyright © 2017年 sohu. All rights reserved.
//



@interface NSString (Character)

- (BOOL)containsEmoji;
- (NSInteger)emojiCount;

//字符长度，一个emoji长度为1
- (NSInteger)charLength;

- (NSString *)substringWithMaxIndex:(NSInteger )index;
@end
