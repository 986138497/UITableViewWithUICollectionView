//
//  CollectionViewCell.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "CollectionViewCell.h"
#import "collectModel.h"
#import "UIImageView+WebCache.h"
@interface CollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *name;

@end

@implementation CollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageV];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 2, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];

    }
    return self;
}

- (void)setModel:(SubCategoryModel *)model
{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    self.name.text = model.name;
}

@end
