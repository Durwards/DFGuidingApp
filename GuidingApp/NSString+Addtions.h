
//
//  NSString+Addtions.h
//
//  Created by mac on 13-12-6.
//
//


#import <Foundation/Foundation.h>


@interface NSString (Addtions)

- (NSString *)appendForPath;
+ (NSString *)getFilePathWithDir:(NSString *)aDirectory withUserID:(int)userid file:(NSString *)aFilename;
- (NSString *)trim;
- (NSUInteger)unicodeLengthOfString;
- (BOOL)isDigitSymbol;
- (NSString*)extractNickname;//昵称抽取前十个字符
@end

