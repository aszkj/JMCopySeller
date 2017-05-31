//
//  JMPullSelectStoreView.m
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMPullSelectStoreView.h"
#import "JMPullSelectStoreTableViewCell.h"

const NSInteger SHOW_ITEM_MAX_COUNT = 5;

@implementation JMPullSelectStoreView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pullSelctTableHeight = JMPullSelectStoreTableViewCellHeight * 2;
    }
    return self;
}

- (void)showPullSelectViewWithPullDatas:(NSArray *)pullDatas {
    
    [super showPullSelectViewWithPullDatas:pullDatas];
    NSInteger showItemCount = pullDatas.count;
    showItemCount = showItemCount >= SHOW_ITEM_MAX_COUNT ? SHOW_ITEM_MAX_COUNT : showItemCount;
    self.pullSelctTableHeight = showItemCount * JMPullSelectStoreTableViewCellHeight;
}

- (void)configurePullView {
    
    self.pullSelectTableView.listDatasourceEngine.cellHeight = JMPullSelectStoreTableViewCellHeight;
    WEAK_SELF
    [self.pullSelectTableView.listDatasourceEngine configurecellNibName:@"JMPullSelectStoreTableViewCell" configurecellData:^(id listView, id listCell, id model, NSIndexPath *indexPath) {
        
        JMPullSelectStoreTableViewCell *cell = (JMPullSelectStoreTableViewCell *)listCell;
        JMStoreModel *cellModel = (JMStoreModel *)model;
        [cell setCellModel:cellModel];
        
    } clickCell:^(id listView, id listCell, id model, NSIndexPath *clickIndexPath) {
        JMStoreModel *cellModel = (JMStoreModel *)model;
        [weak_self selectPullItem:cellModel];
    }];
}

@end
