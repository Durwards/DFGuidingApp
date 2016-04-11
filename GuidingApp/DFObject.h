//
//  DFStringManager.h
//  GuidingApp
//
//  Created by 何定飞 on 15/11/23.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NSObject_StringMapping)
- (NSDictionary *)getDictionaryFromObject;  //把对象转成字典
- (NSString*)getJSONString;//把自定义对象的属性转换为JSON字符串

@end


@interface NSDictionary (NSDictionary_ObjectMapping)

- (void)setJSONObjectValue:(id)obj;//把NSDictionary映射到对应的对象

@end


@interface NSString (NSString_ObjectMapping)

- (id)JSONValue;//返回NSDictionary或NSArray对象

- (void)setJSONObjectValue:(id)obj;//把JSON字符串映射到对应的对象

@end