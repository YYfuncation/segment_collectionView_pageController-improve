//
//  ChainReactionView.m
//  LianDong
//
//  Created by YY on 16/9/17.
//  Copyright © 2016年 YY. All rights reserved.
//

#import "ChainReactionView.h"
#import <Masonry.h>
#import "XLChannelLabel.h"
#import "JhPageControl.h"

static NSString *HomeItemReuseIdentifier = @"HomeItemReuseIdentifier";
@interface ChainReactionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIScrollView *channelView;//频道View
@property (nonatomic, strong) UICollectionView *collectionView;//底部数据
@property (nonatomic, strong) XLChannelLabel *selectedLabel;//选中的按钮
@property (nonatomic, strong) NSMutableArray *labelArray;//频道数组
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong)  JhPageControl *pageControl;
@end



@implementation ChainReactionView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array {
    if (self = [super initWithFrame:frame]) {
        self.nameArray = array;
        //设置UI
        [self setUpUI];
    }
    return self;
}
//设置UI
- (void)setUpUI {
    //添加控件
    [self addSubview:self.channelView];
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    //设置约束
    [self.channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.channelView.mas_bottom);
        make.leading.trailing.equalTo(self);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(30);
        make.bottom.leading.trailing.equalTo(self);
    }];
    
    //注册item
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HomeItemReuseIdentifier];

}

#pragma mark - 懒加载
//频道view
- (UIScrollView *)channelView {
    if (!_channelView) {
        _channelView = [[UIScrollView alloc] init];
        
        //创建按钮
        CGFloat buttonWidth = [UIScreen mainScreen].bounds.size.width/4;
        CGFloat buttonHeight = 44;
        CGFloat buttonY = 0;
        
        self.labelArray = [NSMutableArray array];
        
        for (int i = 0; i < self.nameArray.count; i++) {
            CGFloat buttonX = i * buttonWidth;
            XLChannelLabel *button = [[XLChannelLabel alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
            button.lab.text = self.nameArray[i];
            button.tag = i;
            if (button.tag == 0) {
                button.underLine.hidden = NO;
                button.scale = 1.0;
                self.selectedLabel = button;
            }
            [self.labelArray addObject:button];
            //添加事件
            [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
            
            [_channelView addSubview:button];
        }
        _channelView.backgroundColor = [UIColor whiteColor];
        _channelView.bounces = NO;
        _channelView.contentSize = CGSizeMake(self.nameArray.count * buttonWidth, 0);
        _channelView.showsHorizontalScrollIndicator = NO;
    }
    return _channelView;
}

//底部数据
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //流水布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height - 74);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


//pageController
-(JhPageControl *)pageControl{
    if (!_pageControl) {
        
        JhPageControl *pageControl = [[JhPageControl alloc] init];
        pageControl.numberOfPages = self.nameArray.count;
        pageControl.currentPage = 0;
        pageControl.otherColor = [UIColor grayColor];
        pageControl.currentColor = [UIColor orangeColor];
        pageControl.PageControlContentMode = JhPageControlContentModeCenter; //设置对齐方式
        pageControl.controlSpacing = 8.0;  //间距
        pageControl.marginSpacing = 10;  //距离初始位置 间距  默认10
        pageControl.PageControlStyle = JhPageControlStyelRectangle;//长条样式
        pageControl.enabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}
#pragma mark - collectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.nameArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:HomeItemReuseIdentifier forIndexPath:indexPath];
    
    item.contentView.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
    
    return item;
}

#pragma mark - collectionViewDelegate
//监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self setUpWhenScroll:scrollView];
}

#pragma mark - 滚动时执行的方法
- (void)setUpWhenScroll:(UIScrollView *)scrollView {
    //获取collectionView的中心点
    CGPoint pointItem = [self convertPoint:self.collectionView.center toView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointItem];
    for (XLChannelLabel *channel in self.labelArray) {
        if (channel.tag == indexPath.row) {
            self.selectedLabel = channel;
            [self setChannellabelTextAndColor];
        }
    }
    //1.计算一下,scrollView.contentOffset.x / scrollView.bounds.size.width;
    CGFloat value = (CGFloat)scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if (value < 0 || value > (self.labelArray.count -1)) return;
    
    //2.左边的索引
    int leftIndex = (int)scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    //3.右边的索引
    int rightIndex = leftIndex + 1;
    
    //4.右边的缩放比率
    CGFloat rightScale = (value - leftIndex);
    
    //5.左边的缩放比率
    CGFloat leftScale = 1 - rightScale;
    
    //6.取出左边的ChannelLabel给它设置左边对应的缩放比率
    XLChannelLabel *leftChannelLabel = self.labelArray[leftIndex];
    leftChannelLabel.scale = leftScale;
    
    //7.取出右边的ChannelLabel给它设置左边对应的缩放比率
    if (rightIndex < self.labelArray.count) {
        XLChannelLabel *rightChannelLabel = self.labelArray[rightIndex];
        rightChannelLabel.scale = rightScale;
    }
    self.pageControl.currentPage = indexPath.row;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    XLChannelLabel *chanelLabel = (XLChannelLabel *)recognizer.view;
    self.selectedLabel = chanelLabel;
    [self setChannellabelTextAndColor];
    
    //跳转到对应底部界面
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:chanelLabel.tag inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    self.pageControl.currentPage = indexPath.row;
}
#pragma mark - 选中按钮文字处理方法
//设置channel文字变大、变红、居中的方发
- (void)setChannellabelTextAndColor {
    //1.计算channelView应该滚动多远
    CGFloat needScrollContentOffsetX = self.selectedLabel.center.x - self.channelView.bounds.size.width * 0.5;
    
    //1.1 重新设置,点击最左边的极限值
    if (needScrollContentOffsetX < 0) {
        needScrollContentOffsetX = 0;
    }
    CGFloat maxScrollContentOffsetX = self.channelView.contentSize.width - self.channelView.bounds.size.width;
    
    //1.2 重新设置,点击最右边的极限值
    if (needScrollContentOffsetX > maxScrollContentOffsetX) {
        needScrollContentOffsetX = maxScrollContentOffsetX;
    }
    
    //2.让其滚动
    [self.channelView setContentOffset:CGPointMake(needScrollContentOffsetX, 0) animated:YES];
    
    //3.选中的最大最红,没选中的最小最黑
    for (XLChannelLabel *channelLabel in self.labelArray) {
        if (channelLabel == self.selectedLabel) {
            channelLabel.scale = 1.0; //变成最大最红
            channelLabel.underLine.hidden = NO;
        }else{
            channelLabel.scale = 0.0; //变成最小最黑
            channelLabel.underLine.hidden = YES;
        }
    }
//    [self underLinePosition:needScrollContentOffsetX];
}
#pragma mark - 底线的动画
//- (void)underLinePosition:(CGFloat)needScrollContentOffsetX {
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        CGRect tempFrame = self.underLine.frame;
//        tempFrame.origin.x = self.selectedLabel.frame.origin.x - needScrollContentOffsetX;
//        self.underLine.frame = tempFrame;
//    }];
//    
//}



@end
