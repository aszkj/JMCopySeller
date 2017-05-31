//
//  JMPersonCenterTableViewCell.h
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMPersonCenterItemModel.h"

#define JMPersonCenterTableViewCellHeight 68

@interface JMPersonCenterTableViewCell : UITableViewCell

@end


@interface JMPersonCenterTableViewCell (setCellModel)

- (void)setCellModel:(JMPersonCenterItemModel *)model;

@end
