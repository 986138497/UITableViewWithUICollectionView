//
//  CategoryModel.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+(NSDictionary *)objectClassInArray{

    return @{@"spus":@"FoodModel"};

}



@end

@implementation FoodModel

+(NSDictionary *)replacedKeyFromPropertyName{

    return @{@"foodId":@"id"};
}

@end
