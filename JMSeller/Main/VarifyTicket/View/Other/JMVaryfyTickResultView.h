//
//  JMVaryfyTickResultView.h
//  JMSeller
//
//  Created by JM on 2017/5/19.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RescanBlock)(void);

@interface JMVaryfyTickResultView : UIView

@property (nonatomic, copy)NSString *errorDescrition;

- (void)inputVaryfyTicketSuccessShow;

- (void)inputVaryfyTicketFailedShow;

- (void)scanVaryfyTicketSuccessShow;

- (void)scanVaryfyTicketFailedShowWithRescanBlock:(RescanBlock)rescanBlock;

@end
