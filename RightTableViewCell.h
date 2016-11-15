//
//  RightTableViewCell.h
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ BtnBlockReturn)(NSInteger x);

@class  FoodModel;
@interface RightTableViewCell : UITableViewCell

/** 模型  */
@property (nonatomic, strong)FoodModel *model;


@property (nonatomic, copy) BtnBlockReturn block;

@property (nonatomic, strong) void(^plusTapHandle)(CGPoint position);

-(void)btnBlockReturn:(BtnBlockReturn)block;


@end
