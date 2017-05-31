//
//  JMBasePullSelectView.m
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMBasePullSelectView.h"
#import <Masonry.h>
#import "JMBaseModel.h"
#import "UIView+BlockGesture.h"
#import "NSObject+setModelIndexPath.h"

#define DefaultPullSelectTableViewHeight 200

@interface JMBasePullSelectView ()

@property (nonatomic, strong)UIView *maskView;

@end

@implementation JMBasePullSelectView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUp];
    }
    return self;
}

- (void)_setUp {
    self.maskView = [UIView new];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.6;
    self.maskView.frame = self.bounds;
    WEAK_SELF
    [self.maskView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self hiddenPullSelectView];
    }];
    
    self.pullSelectTableView = [[KJTableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, DefaultPullSelectTableViewHeight)];
    self.pullSelctTableHeight = DefaultPullSelectTableViewHeight;
    [self addSubview:self.pullSelectTableView];
    self.pullSelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self configurePullView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.maskView.frame = self.bounds;
    self.pullSelectTableView.frame = CGRectMake(0, 0, self.bounds.size.width, self.pullSelctTableHeight);
}

- (void)_setDefaultSelectItem {
    if (![self _hasSelectItemInPullDatas]) {
        JMBaseModel *firstModel = self.pullDatas.firstObject;
        firstModel.selected = YES;
    }
}

- (BOOL)_hasSelectItemInPullDatas {
    for (JMBaseModel *model in self.pullDatas) {
        if (model.selected) {
            return YES;
            break;
        }
    }
    return NO;
}

- (void)showPullSelectViewWithPullDatas:(NSArray *)pullDatas {
//    if (!self.hidden) {
//        return;
//    }
    if (isEmpty(self.pullDatas) || !self.pullDatas.count) {
        self.pullDatas = pullDatas;
        [self _setDefaultSelectItem];
        //设置每个model的indexPath（为选择使用）
        [self.pullDatas setIndexPathInselfContainer];
        [self.pullSelectTableView.listEngine loadDataAfterRequestPagingData:self.pullDatas];
    }
    [self showPullSelectView];
}

- (void)showPullSelectView {
    self.hidden = NO;
}

- (void)hiddenPullSelectView {
    self.hidden = YES;
}

- (void)selectPullItem:(id)pullItemModel {
    JMBaseModel *selectModel = (JMBaseModel *)pullItemModel;
    if (selectModel.selected) {
        emptyBlock(self.selectPullItemBlock,selectModel);
        [self hiddenPullSelectView];
    }else {
        [JMBaseModel singleSelectedModel:selectModel inModelArr:self.pullSelectTableView.listEngine.listDatas];
        [self.pullSelectTableView reloadData];
        emptyBlock(self.selectPullItemBlock,selectModel);
        [self hiddenPullSelectView];
    }
}



@end
