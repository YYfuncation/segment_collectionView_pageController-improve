//
//  XLChannelLabel.m
//  XLNewsBaseFoundation
//
//  Created by YY on 16/6/21.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "XLChannelLabel.h"
#import <Masonry.h>

@implementation XLChannelLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //文字居中
        self.lab.textAlignment = NSTextAlignmentCenter;
        //字体大小
        self.lab.font = [UIFont systemFontOfSize:15];
        
        self.userInteractionEnabled = YES;
        
        self.scale = 0;
        
        [self addSubview:self.lab];
        [self addSubview:self.underLine];
        
        [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(self);
            make.height.mas_equalTo(self);
        }];
        [self.underLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).with.offset(self.bounds.size.width/4);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(self.bounds.size.width/2);
        }];
        
    }
    return self;
}

//重设比例
- (void)setScale:(float)scale{
    _scale = scale;
    
    self.lab.textColor = [UIColor blackColor];
    
    //2.让其tranform的scale发生变化
    //0.8 ~ 1.0
//    CGFloat lastScale = 0.8 + (1 - 0.8) * scale;
//    self.transform = CGAffineTransformMakeScale(lastScale, lastScale);
}
//底部线条
- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = [UIColor orangeColor];
        _underLine.hidden = YES;
    }
    return _underLine;
}

-(UILabel *)lab{
    if (!_lab) {
        _lab = [[UILabel alloc]init];
        self.lab.textColor = [UIColor colorWithRed:_scale green:0 blue:0 alpha:1.0];
    }
    return _lab;
}
@end
