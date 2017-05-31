//
//  UIButton+safeSetTitle.h
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (safeSetTitle)

- (void)JM_safeSetButtonTitle:(NSString *)title forState:(UIControlState)state;

@end
