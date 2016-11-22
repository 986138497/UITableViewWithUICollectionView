# UITableViewWithUICollectionView
UITableView和UICollectionView联动


//模型转字典,数组
#import <Foundation/Foundation.h>

@protocol KeyValue <NSObject>

@optional
/**
 *  数组中需要转换的模型类
 *
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)objectClassInArray;

/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)replacedKeyFromPropertyName;

@end


@interface NSObject (Kit)<KeyValue>

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary;


@end




#import "NSObject+Kit.h"
#import <objc/runtime.h>
@implementation NSObject (Kit)

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    
    id obj = [[self alloc] init];
    
    // 获取所有的成员变量
    unsigned int count;
    Ivar *ivars = class_copyIvarList(self, &count);
    
    for (unsigned int i = 0; i < count; i++)
    {
        Ivar ivar = ivars[i];
        
        // 取出的成员变量，去掉下划线
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];
        
        id value = dictionary[key];
        
        // 当这个值为空时，判断一下是否执行了replacedKeyFromPropertyName协议，如果执行了替换原来的key查值
        if (!value)
        {
            if ([self respondsToSelector:@selector(replacedKeyFromPropertyName)])
            {
                NSString *replaceKey = [self replacedKeyFromPropertyName][key];
                value = dictionary[replaceKey];
            }
        }
        
        // 字典嵌套字典
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex:range.location];
            Class modelClass = NSClassFromString(type);
            
            if (modelClass)
            {
                value = [modelClass objectWithDictionary:value];
            }
        }
        
        // 字典嵌套数组
        if ([value isKindOfClass:[NSArray class]])
        {
            if ([self respondsToSelector:@selector(objectClassInArray)])
            {
                NSMutableArray *models = [NSMutableArray array];
                
                NSString *type = [self objectClassInArray][key];
                Class classModel = NSClassFromString(type);
                for (NSDictionary *dict in value)
                {
                    id model = [classModel objectWithDictionary:dict];
                    [models addObject:model];
                }
                value = models;
            }
        }
        
        if (value)
        {
            [obj setValue:value forKey:key];
        }
    }
    
    // 释放ivars
    free(ivars);
    
    return obj;
}



@end
