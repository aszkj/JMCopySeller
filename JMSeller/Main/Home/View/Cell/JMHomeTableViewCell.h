//
//  JMHomeTableViewCell.h
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSellerMessageModel.h"

#define JMHomeTableViewCellHeight 185

@interface JMHomeTableViewCell : UITableViewCell

@end

@interface JMHomeTableViewCell (setCellModel)

- (void)setCellModel:(JMSellerMessageModel *)model;

@end
