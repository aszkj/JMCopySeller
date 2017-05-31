//
//  DLCacheManager.m
//  YilidiSeller
//
//  Created by yld on 16/6/2.
//  Copyright © 2016年 yld. All rights reserved.
//

#import "DLCacheManager.h"
#import "TMCache.h"
#import "SUIUtils.h"

static DLCacheManager *_cacheManager = nil;

@interface DLCacheManager()

@property (nonatomic, strong)TMCache *cache;

@end

@implementation DLCacheManager

+ (instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _cacheManager = [[DLCacheManager alloc] init];
        
    });
    return _cacheManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [TMCache sharedCache];
    }
    return self;
}



@end
