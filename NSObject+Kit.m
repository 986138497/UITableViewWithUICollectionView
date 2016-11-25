//
//  NSObject+Kit.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "NSObject+Kit.h"
#import <objc/runtime.h>
@implementation NSObject (Kit)
/*
 局部变量是根据其生存周期定义的，在源文件中的array1，其生命周期是在以“{ }”为界限的代码块中，虽然它的名称与成员变量相同，但不是同一个变量。成员变量是用于一个区域内的临时变量。
 成员变量，本例中的是实例成员变量，是作用于整个类对象内的。从生命周期来看，它比局部变量要长一些，但它默认是私有的，其他对象是无法访问到的。因此，一般自定义方法，作为一个接口让其他对象访问这个变量。因此，成员变量用于类内部，无需与外界接触的变量。
 实例变量:实例变量是成员变量中的一种！
 根据成员变量的私有性，为了方便访问，所以就有了属性变量。属性变量的好处就是允许让其他对象访问到该变量。当然，你可以设置只读或者可写等，设置方法也可自定义。所以，属性变量是用于与其他对象交互的变量。
 
 
 
 //实例变量,一般带下划线  ,如_age
 Ivar *ivarPtr = class_copyIvarList(self, &outCount);
 for (NSInteger i =0;i<outCount ; i++) {
 Ivar ivar = ivarPtr[i];
 NSLog(@"实例变量:%s",ivar_getName(ivar));
 }
 
 //属性  一般不带下划线  ,如age
 objc_property_t * proPtr= class_copyPropertyList(self, &outCount);
 
 for (NSInteger i =0; i<outCount; i++) {
 objc_property_t prt = proPtr[i];
 NSLog(@"属性名称:%s",property_getName(prt));
 }
 //遍历对象方法 打印age,setAge,.cxx_destruct(.cxx_destruct方法原本是为了C++对象析构的，ARC借用了这个方法插入代码实现了自动内存释放的工作)
 Method *method= class_copyMethodList(self, &outCount);
 for (NSInteger i=0; i<outCount; i++) {
 Method me = method[i];
 SEL sel = method_getName(me);
 NSLog(@"%@",NSStringFromSelector(sel));
 }
 
 
 */
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
