//
//  ProjectNormalConst.h
//  JMSeller
//
//  Created by JM on 2017/5/17.
//  Copyright © 2017年 JMai. All rights reserved.
//

#ifndef ProjectNormalConst_h
#define ProjectNormalConst_h
#import "JMStoreManager.h"

#define SESSIONID [[NSUserDefaults standardUserDefaults] objectForKey:JMSessionID]
#define JMSessionID @"sessionid"
#define KSetCookieKey   @"KSetCookieKey"
#define KUserInfoKey    @"KUserInfoKey"

#define KCSRTokenKey @"csrftoken"
#define KCSRToken [[NSUserDefaults standardUserDefaults] objectForKey:KCSRTokenKey]


#define kUIExternReponsedEdge 8

#define StoreManager [JMStoreManager sharedManager]
#define CurrentSelectStore [JMStoreManager sharedManager].currentSelectStore



#endif /* ProjectNormalConst_h */
