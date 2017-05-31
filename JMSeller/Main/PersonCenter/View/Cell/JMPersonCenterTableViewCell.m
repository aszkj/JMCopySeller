//
//  JMPersonCenterTableViewCell.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMPersonCenterTableViewCell.h"

@interface JMPersonCenterTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImgView;
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@end

@implementation JMPersonCenterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation JMPersonCenterTableViewCell (setCellModel)

- (void)setCellModel:(JMPersonCenterItemModel *)model {
    
    self.itemImgView.image = IMAGE(model.itemIconName);
    self.itemLabel.text = model.itemTitle;
    
}

@end
