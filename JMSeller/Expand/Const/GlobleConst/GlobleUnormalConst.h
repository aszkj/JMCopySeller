//
//  GlobleUnormalConst.h
//  JMSeller
//
//  Created by JM on 2017/5/17.
//  Copyright © 2017年 JMai. All rights reserved.
//

#ifndef GlobleUnormalConst_h
#define GlobleUnormalConst_h

#define BoundNibView(viewNibName,ViewClass) (ViewClass *)[[[NSBundle mainBundle] loadNibNamed:viewNibName owner:nil options:nil] lastObject]
#define kCurrentKeyWindow    [UIApplication sharedApplication].keyWindow

//通知中心全局数据常量单例
#define kNotification [NSNotificationCenter defaultCenter]
//NSUserDefaults 的全局
#define kUserDefaults [NSUserDefaults standardUserDefaults]
//UIApplication
#define kAppDelegate (AppDelegate*)[[UIApplication sharedApplication] delegate]

#define MD5(src) [src MD5Hash]
#define IntToString(src) [NSString stringWithFormat:@"%ld", (long)src]
#define kNumberToStr(number) [NSString stringWithFormat:@"%@",number]
#define jSetButtonNormalStateTile(button,title) [button setTitle:title forState:UIControlStateNormal]

//collectionHeight
#define kCollectionHeight(itemCount,cellHeihgt,horizonalCellCount) ((itemCount % horizonalCellCount ? (itemCount / horizonalCellCount + 1) : itemCount / horizonalCellCount) * cellHeihgt)

#define scrollViewMaxScrollHeight(scrollView) (scrollView.contentSize.height-scrollView.frame.size.height)
#define scrollViewMaxScrollWidth(scrollView) (scrollView.contentSize.width-scrollView.frame.size.width)

//传入ipone6下的尺寸，根据比例得到在其他屏幕下的尺寸
#define ADAPT_SCREEN_WIDTH(widthInPhone6) (widthInPhone6 * 1.0 / iPhone6_width ) * kScreenWidth
#define ADAPT_SCREEN_HEIGHT(heightInPhone6) (heightInPhone6 * 1.0/ iPhone6_Height * 1.0) * kScreenHeight


//根据字符串长度求字符串尺寸
#define kStringSize(str,fSize,str_W,str_H) [str sizeWithFont:[UIFont systemFontOfSize:fSize] constrainedToSize:CGSizeMake(str_W, str_H)]
//打印对象地址
#define DlogObjectAddress(obj) NSLog(@"address is %p",(id)obj);

#define afterSecondsLoadData(secondes,__stuff) {\
dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, secondes * NSEC_PER_SEC);\
dispatch_after(popTime, dispatch_get_main_queue(), ^(void){\
__stuff\
});\
}

#define kFilePathWithName(name) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:name]


#endif /* GlobleUnormalConst_h */
