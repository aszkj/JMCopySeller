//
//  JMContactSalesManTableViewCell.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMContactSalesManTableViewCell.h"

@interface JMContactSalesManTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *saleManJobTitleLabel;

@end

@implementation JMContactSalesManTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation JMContactSalesManTableViewCell (setCellModel)

- (void)setCellModel:(JMContactSalesManModel *)model {
    
    self.saleManJobTitleLabel.text = JMFormat(@"%@",model.saleManName);
    
}

@end

