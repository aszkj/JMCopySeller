//
//  JMRequestUrl.h
//  YilidiSeller
//
//  Created by yld on 16/3/23.
//  Copyright © 2016年 Dellidc. All rights reserved.
//

#ifndef DLRequestUrl_h
#define DLRequestUrl_h

//#define ServerDomain @"192.168.0.92"

//联调主机
//#define JMBASEURL @"http://192.168.1.123:8080/interfaces/buyer/"
//#define ServerDomain @"http://buyertest.yldbkd.com"
//#define ImgServerDomain  @"http://upload.yldbkd.com"
//#define POSTIMAGEURL @"http://optest.yldbkd.com/"

//测试
//#define JMBASEURL @"https://businessdev.jinmailife.com/"
//#define ServerDomain @"https://businessdev.jinmailife.com/"

//正式
#define JMBASEURL @"https://business.jinmailife.com/"
#define ServerDomain @"https://business.jinmailife.com/"

#pragma mark ------------------ ServerModuleDomain-------------
#define JMModuleDomain_Common     @"store-center/"
#define JMModuleDomain_Refresh    @"captcha/refresh/"
#define JMModuleDomain_Image        @"captcha/image/"

#pragma mark ------------------- business manager info -------
#warning 单独域名,url后面加 (店铺id)/info/
//生产环境的
#define KUrl_GetBussinessInfo   @"https://shopmanage.jinmailife.com/account-manage/"
//开发环境的
//#define KUrl_GetBussinessInfo   @"https://shopmanagedev.jinmailife.com/account-manage/"

#pragma mark ------------------ account --------------------
#define KUrl_GetAcountInfo        @"accounts/info/"
#define KUrl_AccountLogout    @"accounts/logout/"


#pragma mark ------------------ login&register -------------
#define KUrl_NormalUserLogin    @"accounts/login/"
#define KUrl_SuperUserLogin     @"accounts/login/employee-superuser/"


#pragma mark ------------------ message --------------------
#define KUrl_GetUserMessages    @"user/messages/"

#pragma mark ------------------ ticket ---------------------
#warning url后面加 (券id)/info/
#define KUrl_VaryfyTicket    @"token/"





#endif /* DLRequestUrl_h */
