//
//  NSString+Addtions.h
//
//  Created by mac on 13-12-6.
//
//



#import "NSString+Addtions.h"

@implementation NSString (Addtions)


-(NSString *)appendForPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:self];
//    NSLog(@"%@",path);
	return path;
}

+(NSString *)getFilePathWithDir:(NSString *)aDirectory withUserID:(int)userid file:(NSString *)aFilename
{
    NSString *str = [NSString stringWithFormat:@"%@%d",aDirectory,userid];
	NSString *dirpath = [str appendForPath];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	if (![manager fileExistsAtPath:dirpath])
    {
		[manager createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return [dirpath stringByAppendingPathComponent:aFilename];
}

-(NSString *)trim
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//统计ASCII和Unicode混合文本长度的 和新浪微博的统计结果是一致,a
- (NSUInteger)unicodeLengthOfString
{
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++) {
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    if(asciiLength % 2) {
        unicodeLength++;
    }
    return unicodeLength;
}

- (BOOL)isDigitSymbol
{
    if (self.length == 0)
    {
        return NO;
    }

    //判断是不是纯数字
    if ([self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (NSString*)extractNickname//昵称抽取前十个字符
{
    if (self.length <= 10)
        return self;
    
    return [self substringToIndex:10];
}

@end

