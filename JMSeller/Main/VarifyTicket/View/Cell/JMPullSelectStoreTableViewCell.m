//
//  JMPullSelectStoreTableViewCell.m
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMPullSelectStoreTableViewCell.h"

@interface JMPullSelectStoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *storeCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectMarkButton;

@end

@implementation JMPullSelectStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation JMPullSelectStoreTableViewCell (setCellModel)

- (void)setCellModel:(JMStoreModel *)model {
    
    [self.storeCityLabel JM_safeSetLabelText:model.storeCityName];
    [self.storeNameLabel JM_safeSetLabelText:model.storeName];
    self.selectMarkButton.hidden = !model.selected;
    
}

@end

