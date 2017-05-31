//
//  CommonImgTitleModel.h
//  YilidiSeller
//
//  Created by yld on 16/4/29.
//  Copyright © 2016年 yld. All rights reserved.
//

#import "JMBaseModel.h"

/**
 *  通用文字，图片model
 */
@interface CommonImgTitleModel : JMBaseModel

@property (nonatomic,copy)NSString *title;

@property (nonatomic,copy)NSString *normalImgName;

@property (nonatomic,copy)NSString *highlighteImgName;

@property (nonatomic,copy)NSString *phone;
@end
