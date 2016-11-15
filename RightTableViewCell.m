//
//  RightTableViewCell.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//

#import "RightTableViewCell.h"
#import "CategoryModel.h"
#import "UIImageView+WebCache.h"
#import "UIView+kit.h"
@interface RightTableViewCell()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton * buyBtn;
@end

@implementation RightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.imageV];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 30)];
        self.nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 30)];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyBtn.frame = CGRectMake(200, 10, 50, 20);
        [self.buyBtn setTitle:@"+" forState:UIControlStateNormal];
        [self.buyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.buyBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.buyBtn];
        self.priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

- (void)setModel:(FoodModel *)model {
    
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.nameLabel.text = model.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",@(model.min_price)];
    
}
-(void)clickBtn:(UIButton *)btn{
    
    CGPoint btnPoint = [self convertPoint:btn.center toView:self.superview];
    self.plusTapHandle(btnPoint);
    self.block(btn.tag);
}
-(void)btnBlockReturn:(BtnBlockReturn)block{
    self.block = block;
}
- (void)updateConstraints {
    [self.buyBtn addCornerRadiusWithcorners:UIRectCornerTopRight | UIRectCornerBottomRight AndRadii:CGSizeMake(5, 5)];
    [super updateConstraints];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
