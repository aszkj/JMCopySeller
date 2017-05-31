//
//  JMLoginController.m
//  JMSeller
//
//  Created by JM on 2017/5/17.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMLoginController.h"
#import "UITextField+placeHolderSetting.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+BlockGesture.h"
#import "JMHomeController.h"
#import "JMSellerBaseNavController.h"
#import "GlobleUnormalConst.h"
#import "JMStoreManager.h"
#import "ProjectNormalConst.h"
#import "AFNHttpRequestOPManager+specialApi.h"

@interface JMLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *varyCodeTextFiled;
@property (weak, nonatomic) IBOutlet UIImageView *varyCodeImgView;
@property (copy, nonatomic)NSString *imgVaryCodeKey;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation JMLoginController

#pragma mark ------------------------LiftCycle---------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.userNameTextFiled.text = @"堂本家";
//    self.userPasswordTextFiled.text = @"testtest";

    [self _init];
    
    [self _requestVaryCode];
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark ------------------------Init--------------------------------------
- (void)_init {
    [self _configureInputPlaceHolder];
    
    [self _configureLoginButton];
    
    [self _configureVaryCodeImgView];
}

#pragma mark ------------------------Api--------------------------------------
- (void)_requestVaryCode {
    
    [AFNHttpRequestOPManager api_GetLoginImgVaryCode:^(NSDictionary *result, NSError *error) {
    
        NSString *imgVaryCodeUrl = [result sui_stringForKey:@"image_url"];
        NSString *imgVaryCodeKey = [result sui_stringForKey:@"key"];
        [self.varyCodeImgView sd_SetImgWithRelativeUrlStr:imgVaryCodeUrl placeHolderImgName:nil];
        self.imgVaryCodeKey = imgVaryCodeKey;
    }];
}

- (void)_requetLogin {
    self.requestParam = @{@"username":self.userNameTextFiled.text,
                          @"password":self.userPasswordTextFiled.text,
                          @"captcha_key":self.imgVaryCodeKey,
                          @"captcha_value":self.varyCodeTextFiled.text};
    [self showLoadingHubWithText:@"正在登录。。"];
    [AFNHttpRequestOPManager postWithSubUrl:KUrl_NormalUserLogin parameters:self.requestParam result:^(NSDictionary *result, NSError *error) {
        [self hideLoadingHub];
        if (error.code == 1) {
            [self _enterMain];
        }else {
            [self _requestVaryCode];
        }
        JMStoreOwnerModel *loginStoreModel = [[JMStoreOwnerModel alloc] initWithDefaultDataDic:result];
        StoreManager.currentLoginedStore = loginStoreModel;
    }];
}

#pragma mark ------------------------Private-----------------------------------
- (void)_configureVaryCodeImgView {
    WEAK_SELF
    self.varyCodeImgView.userInteractionEnabled = YES;
    [self.varyCodeImgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self _requestVaryCode];
    }];
}



- (void)_configureLoginButton {
    RACSignal *loginEableSignal =
    [RACSignal combineLatest:@[self.userNameTextFiled.rac_textSignal, self.userPasswordTextFiled.rac_textSignal,self.varyCodeTextFiled.rac_textSignal]
                      reduce:^id(NSString*username, NSString *password,NSString *varyCode){
                          return @(!isEmpty(username) && !isEmpty(password) && !isEmpty(varyCode));
                      }];
//    [self.loginButton setTitleColor:Color_Active forState:UIControlStateNormal];
//    [self.loginButton setTitleColor:Color_Enabled forState:UIControlStateDisabled];

    [loginEableSignal subscribeNext:^(NSNumber *enable) {
        self.loginButton.enabled = enable.integerValue;
        self.loginButton.backgroundColor = enable.integerValue ?Color_Active : Color_Enabled;
    
    }];
}

- (void)_configureInputPlaceHolder {
    [self.userNameTextFiled setTextPlaceHolderFont:kSystemFontSize(12) placeHolderTextColor:Color_LightGray];
    [self.userPasswordTextFiled setTextPlaceHolderFont:kSystemFontSize(12) placeHolderTextColor:Color_LightGray];
    [self.varyCodeTextFiled setTextPlaceHolderFont:kSystemFontSize(12) placeHolderTextColor:Color_LightGray];
}

- (void)_setVaryCodeImgWithUrl:(NSString *)varyCodeImgUrl {
    [self.varyCodeImgView sd_SetImgWithUrlStr:varyCodeImgUrl placeHolderImgName:nil];
}

#pragma mark ------------------------Page Navigate-----------------------------
- (void)_enterMain {
    JMHomeController *homeVC = [[JMHomeController alloc] init];
    JMSellerBaseNavController *baseNav = [[JMSellerBaseNavController alloc] initWithRootViewController:homeVC];
    kCurrentKeyWindow.rootViewController = baseNav;
    
}

#pragma mark ------------------------View Event--------------------------------
- (IBAction)loginAction:(id)sender {
    [self _requetLogin];
}

#pragma mark ------------------------Delegate----------------------------------

#pragma mark ------------------------Notification------------------------------

#pragma mark ------------------------Getter / Setter---------------------------



@end
