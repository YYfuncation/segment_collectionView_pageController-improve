//
//  XLChannelLabel.h
//  XLNewsBaseFoundation
//
//  Created by YY on 16/6/21.
//  Copyright © 2016年 YY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLChannelLabel : UIView
/**
 每一个Label的缩放比率,规定每一个的缩放比率在0~1之间
 */
@property (nonatomic, assign) float scale;

@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIView *underLine;//底部线条
@end
