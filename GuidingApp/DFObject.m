//
//  DFStringManager.m
//  GuidingApp
//
//  Created by 何定飞 on 15/11/23.
//  Copyright © 2015年 Hdu. All rights reserved.
//

#import "DFObject.h"
#import <objc/runtime.h>

@implementation NSObject (NSObject_StringMapping)

- (void)setDic:(NSDictionary*)dic fromClass:(Class)cls
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &count); //获取该类的所有属性
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char* key = property_getName(property);
        NSString* strKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:strKey];
        [dic setValue:value forKey:strKey];
    }
    free(properties);
}

- (void)setDic:(NSDictionary*)dic fromAllClass:(Class)cls
{
    [self setDic:dic fromClass:cls];
    Class superCls = class_getSuperclass(cls);
    if(superCls != nil && strcmp(class_getName(superCls), "NSObject") != 0)
        [self setDic:dic fromAllClass:superCls];
}

- (NSDictionary *)getDictionaryFromObject {
    const char* className = object_getClassName(self);
    Class cls = objc_getClass(className);
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self setDic:dic fromAllClass:cls];
    return dic;
}

- (NSString*)getJSONString//查看http请求发送的字符串
{
    const char* className = object_getClassName(self);
    Class cls = objc_getClass(className);
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self setDic:dic fromAllClass:cls];
    
    [dic removeObjectForKey:@"hash"];
    [dic removeObjectForKey:@"superclass"];
    [dic removeObjectForKey:@"description"];
    [dic removeObjectForKey:@"debugDescription"];
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (!data)
        return nil;
    
    NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
}

@end


@implementation NSDictionary (NSDictionary_ObjectMapping)

- (void)setObject:(id)obj fromClass:(Class)cls
{
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &count); //获取该类的所有属性
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char* key = property_getName(property);
        NSString* strKey = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
        id value = [self valueForKey:strKey];
        if(value != nil && ![value isKindOfClass:[NSNull class]])
            [obj setValue:value forKey:strKey];
    }
    free(properties);
}

- (void)setObject:(id)obj fromAllClass:(Class)cls
{
    [self setObject:obj fromClass:cls];
    Class superCls = class_getSuperclass(cls);
    if(superCls != nil && strcmp(class_getName(superCls), "NSObject") != 0)
        [self setObject:obj fromAllClass:superCls];
}

- (void)setJSONObjectValue:(id)obj
{
    Class class = object_getClass(obj);
    [self setObject:obj fromAllClass:class];
}

@end

@implementation NSString (NSString_ObjectMapping)

- (id)replaceNSNull:(id)obj
{
    if (obj)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* srcDic = (NSDictionary*)obj;
            NSMutableDictionary* desDic = [[NSMutableDictionary alloc]init];
            
            NSArray* keys = [srcDic allKeys];
            for (NSString* strKey in keys)
            {
                id dicItem = srcDic[strKey];
                if (dicItem && ![dicItem isKindOfClass:[NSNull class]])
                {
                    desDic[strKey] = [self replaceNSNull:dicItem];
                }
            }
            
            return [[NSDictionary alloc]initWithDictionary:desDic];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray* srcArray = (NSArray*)obj;
            NSMutableArray* desArray = [[NSMutableArray alloc]init];
            
            int count = (int)srcArray.count;
            for (int ii=0; ii<count; ii++)
            {
                id arrayItem = srcArray[ii];
                if (arrayItem && ![arrayItem isKindOfClass:[NSNull class]])
                {
                    [desArray addObject:[self replaceNSNull:arrayItem]];
                }
            }
            
            return [[NSArray alloc]initWithArray:desArray];
        }
    }
    
    return obj;
}

- (id)JSONValue
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!data)
        return nil;
    NSError *error;
    id ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (ret && [ret isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    
    return ret;//[self replaceNSNull:ret];
}

- (void)setJSONObjectValue:(id)obj
{
    id repr = [self JSONValue];
    if ([repr isKindOfClass:[NSDictionary class]])
        [(NSDictionary*)repr setJSONObjectValue:obj];
}

@end