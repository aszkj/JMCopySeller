//
//  JMPullSelectStoreTableViewCell.h
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMStoreModel.h"

#define JMPullSelectStoreTableViewCellHeight 51

@interface JMPullSelectStoreTableViewCell : UITableViewCell

@end

@interface JMPullSelectStoreTableViewCell (setCellModel)

- (void)setCellModel:(JMStoreModel *)model;

@end
