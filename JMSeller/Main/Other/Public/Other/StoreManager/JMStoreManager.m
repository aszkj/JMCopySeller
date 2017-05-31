//
//  JMStoreManager.m
//  JMSeller
//
//  Created by JM on 2017/5/22.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMStoreManager.h"
#import "TMCache.h"

static JMStoreManager *_storeManager = nil;
static NSString *cachekey_loginStoreModel = @"cachekey_loginStoreModel";
static NSString *cachekey_selectSoreModel = @"cachekey_selectSoreModel";

@interface JMStoreManager ()

@property (nonatomic,strong)TMCache *storeCache;

@end

@implementation JMStoreManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _storeManager = [[JMStoreManager alloc] init];
    });
    return _storeManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _storeCache = [TMCache sharedCache];
        [self initCache];
    }
    return self;
}

- (void)initCache {
    _currentLoginedStore = [self.storeCache objectForKey:cachekey_loginStoreModel];
    _currentSelectStore = [self.storeCache objectForKey:cachekey_selectSoreModel];
}

- (void)setCurrentLoginedStore:(JMStoreOwnerModel *)currentLoginedStore {
    _currentLoginedStore = currentLoginedStore;
    [self.storeCache setObject:_currentLoginedStore forKey:cachekey_loginStoreModel];
    self.currentSelectStore = _currentLoginedStore.shops.firstObject;
}

- (void)setCurrentSelectStore:(JMStoreModel *)currentSelectStore {
    _currentSelectStore = currentSelectStore;
    [self.storeCache setObject:_currentSelectStore forKey:cachekey_selectSoreModel];
}

- (void)clearStoreInfo;
 {
     self.currentLoginedStore = nil;
     self.currentSelectStore = nil;
}


@end
