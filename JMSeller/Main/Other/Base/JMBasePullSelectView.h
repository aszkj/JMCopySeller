//
//  JMBasePullSelectView.h
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KJTableView.h"

typedef void(^JMSelectPullItemBlock)(id pullItemModel);

@interface JMBasePullSelectView : UIView

@property (strong, nonatomic)KJTableView *pullSelectTableView;

@property (nonatomic, assign)CGFloat pullSelctTableHeight;


#pragma mark - need assign
@property (nonatomic, copy)NSArray *pullDatas;

#pragma mark - public call
@property (nonatomic, copy)JMSelectPullItemBlock selectPullItemBlock;

- (void)showPullSelectViewWithPullDatas:(NSArray *)pullDatas;

- (void)hiddenPullSelectView;

#pragma mark - subclass call
- (void)selectPullItem:(id)pullItemModel;

#pragma mark - subclass override
- (void)configurePullView;

@end
