//
//  JMSelectStoreTitleView.h
//  JMSeller
//
//  Created by JM on 2017/5/20.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JMSelectStoreNameBlock)(void);

@interface JMSelectStoreTitleView : UIView
@property (weak, nonatomic) IBOutlet UIButton *storeNameButton;

@property (nonatomic, copy)JMSelectStoreNameBlock selectStoreNameBlock;


@end
