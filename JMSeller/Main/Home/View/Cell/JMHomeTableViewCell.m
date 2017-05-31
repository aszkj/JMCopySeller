//
//  JMHomeTableViewCell.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMHomeTableViewCell.h"


@interface JMHomeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *topTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation JMHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation JMHomeTableViewCell (setCellModel)

- (void)setCellModel:(JMSellerMessageModel *)model {
    
    [self.topTimeLabel JM_safeSetLabelText:model.messageDate];
    [self.titleLabel JM_safeSetLabelText:model.messageTitle];
    [self.middleTimeLabel JM_safeSetLabelText:model.messageDate];
    [self.descriptionLabel JM_safeSetLabelText:model.messageBody];
    
}
@end
