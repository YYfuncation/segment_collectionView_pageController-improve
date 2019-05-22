//
//  ViewController.m
//  LianDong
//
//  Created by YY on 16/9/13.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "ViewController.h"
#import "ChainReactionView.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *nameArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
}

- (void)setUpUI {
    
    ChainReactionView *chainView = [[ChainReactionView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 300) titleArray:@[@"1",@"2",@"3",@"4",]];
    
    [self.view addSubview:chainView];
    
    
}

@end
