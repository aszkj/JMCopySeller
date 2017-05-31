//
//  UIButton+safeSetTitle.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "UIButton+safeSetTitle.h"

@implementation UIButton (safeSetTitle)

- (void)JM_safeSetButtonTitle:(NSString *)title forState:(UIControlState)state{
    
    if (!title) {
        title = @"";
    }
    [self setTitle:title forState:state];
}


@end
