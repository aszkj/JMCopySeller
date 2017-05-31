//
//  JMSelectStoreTitleView.m
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMSelectStoreTitleView.h"
#import "UIButton+Design.h"

@implementation JMSelectStoreTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.storeNameButton setEnlargeEdgeWithTop:5 right:30 bottom:5 left:30];

}

- (IBAction)selectStoreNameAction:(id)sender {
    emptyBlock(self.selectStoreNameBlock)
}

@end
