//
//  JMContactSalesManTableViewCell.h
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMContactSalesManModel.h"

#define JMContactSalesManTableViewCellHeight 83

@interface JMContactSalesManTableViewCell : UITableViewCell

@end

@interface JMContactSalesManTableViewCell (setCellModel)

- (void)setCellModel:(JMContactSalesManModel *)model;

@end
