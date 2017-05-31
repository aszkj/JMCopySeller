//
//  JMInputVaryfyTicketController.m
//  JMSeller
//
//  Created by JM on 2017/5/19.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMInputVaryfyTicketController.h"
#import "UITextField+placeHolderSetting.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ProjectUIAttributeConst.h"
#import "UIButton+Design.h"
#import "JMVaryfyTickResultView.h"
#import <Masonry.h>
#import "GlobleUnormalConst.h"
#import "JMPullSelectStoreView.h"
#import "JMStoreModel.h"
#import "ProjectNormalConst.h"
#import "JMStoreManager.h"
#import "AFNHttpRequestOPManager+specialApi.h"

const NSInteger MaxPasswdCount = 12;
const NSInteger PasswdGroupCount = 4;

@interface JMInputVaryfyTicketController ()
@property (weak, nonatomic) IBOutlet UIButton *varyfyButton;
@property (weak, nonatomic) IBOutlet UIButton *showStoreNameButton;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *deletePasswdButton;
@property (strong, nonatomic)JMVaryfyTickResultView *varyfyResultView;
@property (strong, nonatomic)JMPullSelectStoreView *pullSelectStoreView;

@end

@implementation JMInputVaryfyTicketController

#pragma mark ------------------------LifeCycle---------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark ------------------------Init--------------------------------------
- (void)_init {
    [self _configurevaryfyButton];
    
    [self _configreInputTextFiled];
    
    [self _configureDeletePasswdButton];
    
    [self _configureStoreNameShowButton];
}

- (void)_configurevaryfyButton {
    const CGFloat inputNumberGap = 17.5;
    CGFloat varyfyButtonCornerRadius = (kScreenWidth*0.757 - 2 * inputNumberGap)/3/2;
    self.varyfyButton.layer.masksToBounds = YES;
    self.varyfyButton.layer.cornerRadius = varyfyButtonCornerRadius;
//    [self.varyfyButton setTitleColor:Color_Black forState:UIControlStateNormal];
//    [self.varyfyButton setTitleColor:Color_White forState:UIControlStateDisabled];
    [self _varyfyButtonActiveConfigure];
}

- (void)_configreInputTextFiled {
    [self.inputPasswdTextFiled setTextPlaceHolderFont:kSystemFontSize(18) placeHolderTextColor:Color_LightGray];
}

- (void)_configureDeletePasswdButton {
    [self.deletePasswdButton setEnlargeEdgeWithTop:15 right:30 bottom:15 left:15];
    [self _showDisplayDeletePasswdButton];
}

- (void)_varyfyButtonActiveConfigure {
    BOOL canVaryfyPasswd = !isEmpty(self.inputPasswdTextFiled.text);
    self.varyfyButton.enabled = canVaryfyPasswd;
    self.varyfyButton.backgroundColor = canVaryfyPasswd ? Color_Active : Color_Enabled;
}

- (void)_showDisplayDeletePasswdButton {

    self.deletePasswdButton.hidden = ![self _hasInputPasswdF];
    
}

#pragma mark ------------------------Api--------------------------------------
- (void)_requestVaryfyTicketResult {
    
    NSString *passwd = [self _getNoneSpacePasswdWithPasswdStr:self.inputPasswdTextFiled.text];
    [AFNHttpRequestOPManager api_varyTickWithCode:passwd shopId:CurrentSelectStore.storeId resutlt:^(NSDictionary *result, NSError *error) {
        if (error.code == 1) {
            [self.varyfyResultView inputVaryfyTicketSuccessShow];
            [self goBackAfter:3];
        }else {
            self.varyfyResultView.errorDescrition = error.localizedDescription;
            [self.varyfyResultView inputVaryfyTicketFailedShow];
        }
    }];
}

#pragma mark ------------------------Private-----------------------------------
- (void)_configureStoreNameShowButton {
    JMStoreModel *model = CurrentSelectStore;
    [self.showStoreNameButton setEnlargeEdgeWithTop:5 right:30 bottom:5 left:30];
    [self _setStoreNameShowButtonWithStoreName:model.storeName];
}

- (void)_setStoreNameShowButtonWithStoreName:(NSString *)storeName {
    [self.showStoreNameButton JM_safeSetButtonTitle:storeName forState:UIControlStateNormal];
}

- (BOOL)_hasInputPasswdF{
    return !isEmpty(self.inputPasswdTextFiled.text);
}

- (NSString *)_getNoneSpacePasswdWithPasswdStr:(NSString *)passwd {
    return [passwd stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSArray *)_getSotoreData {
    return StoreManager.currentLoginedStore.shops;
}

#pragma mark ------------------------Page Navigate-----------------------------

#pragma mark ------------------------View Event--------------------------------
- (IBAction)backAction:(id)sender {
    [self goBack];
}

- (IBAction)varyfyAction:(id)sender {
    [self _requestVaryfyTicketResult];
}

- (IBAction)clickNumberAction:(id)sender {
    NSInteger clickNumber = [(UIButton *)sender tag] - 10;
    NSString *currentInputPasswd = self.inputPasswdTextFiled.text;
    if (isEmpty(currentInputPasswd)) {
        currentInputPasswd = @"";
    }
    NSString *newPasswd = JMFormat(@"%@%ld",currentInputPasswd,clickNumber);
    NSString *newPasswdNoneSpace = [self _getNoneSpacePasswdWithPasswdStr:newPasswd];
    
    if (newPasswdNoneSpace.length >= MaxPasswdCount+1) {
        return;
    }
    if (newPasswdNoneSpace.length % PasswdGroupCount == 0) {
        newPasswd = JMFormat(@"%@%@",newPasswd,@" ");
    }
    self.inputPasswdTextFiled.text = newPasswd;
    [self _showDisplayDeletePasswdButton];
    [self _varyfyButtonActiveConfigure];

}
- (IBAction)selectStoreAction:(id)sender {
    if (_pullSelectStoreView && !_pullSelectStoreView.hidden) {
        [self.pullSelectStoreView hiddenPullSelectView];
    }else {
        [self.pullSelectStoreView showPullSelectViewWithPullDatas:[self _getSotoreData]];
    }
}

- (IBAction)deletePassWordAction:(id)sender {
    if (self.inputPasswdTextFiled.text.length == 1) {
        self.inputPasswdTextFiled.text = nil;
    }else {
        
        if (!self.inputPasswdTextFiled.text.length) {
            return;
        }
        NSString *lastStr = [self.inputPasswdTextFiled.text substringFromIndex:self.inputPasswdTextFiled.text.length-1];
        NSInteger toIndex;
        if ([lastStr isEqualToString:@" "]) {
            toIndex = self.inputPasswdTextFiled.text.length - 2;
        }else {
            toIndex = self.inputPasswdTextFiled.text.length - 1;
        }
        self.inputPasswdTextFiled.text = [self.inputPasswdTextFiled.text substringToIndex:toIndex];
    }
    [self _showDisplayDeletePasswdButton];
    [self _varyfyButtonActiveConfigure];

}

#pragma mark ------------------------Delegate----------------------------------

#pragma mark ------------------------Notification------------------------------

#pragma mark ------------------------Getter / Setter---------------------------
- (JMVaryfyTickResultView *)varyfyResultView {
    if (!_varyfyResultView) {
        _varyfyResultView = BoundNibView(@"JMVaryfyTickResultView", JMVaryfyTickResultView);
        [self.view addSubview:_varyfyResultView];
        [_varyfyResultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
    }
    _varyfyResultView.hidden = NO;
    return _varyfyResultView;
}

- (JMPullSelectStoreView *)pullSelectStoreView {
    if (!_pullSelectStoreView) {
        _pullSelectStoreView = [JMPullSelectStoreView new];
        [self.view addSubview:_pullSelectStoreView];
        [_pullSelectStoreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(60);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
        WEAK_SELF
        _pullSelectStoreView.selectPullItemBlock = ^(JMStoreModel* pullItemModel) {
            [weak_self _setStoreNameShowButtonWithStoreName:pullItemModel.storeName];
            CurrentSelectStore = pullItemModel;
        };
        _pullSelectStoreView.hidden = YES;
    }
    return _pullSelectStoreView;

}



@end
