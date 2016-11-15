//
//  CategoryModel.h
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Kit.h"
@interface CategoryModel : NSObject

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *icon;

@property (nonatomic, copy) NSArray *spus;


@end


@interface FoodModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *foodId;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, assign) NSInteger praise_content;
@property (nonatomic, assign) NSInteger month_saled;
@property (nonatomic, assign) float min_price;

@end
