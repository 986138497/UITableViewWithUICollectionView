//
//  LeftTableViewCell.m
//  两表联动
//
//  Created by lei on 2016/10/12.
//  Copyright © 2016年 lei. All rights reserved.
//
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#import "LeftTableViewCell.h"
@interface LeftTableViewCell()
@property (nonatomic, strong) UIView *redView;
@end
@implementation LeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:15];
        self.name.textColor = RGBAColor(130, 130, 130, 1.0);
        self.name.highlightedTextColor = [UIColor redColor];
        [self.contentView addSubview:self.name];
        
        self.redView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, 45)];
        self.redView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.redView];
    }
    return  self;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.redView.hidden = !selected;
}

@end
