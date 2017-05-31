//
//  JMPersonCenterController.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMPersonCenterController.h"
#import "KJTableView.h"
#import "JMPersonCenterTableViewCell.h"
#import "JMPersonCenterTableViewCell.h"
#import "UIButton+Block.h"
#import "JMLoginController.h"
#import "JMSellerBaseNavController.h"
#import "GlobleUnormalConst.h"
#import "ProjectUnormalConst.h"
#import "JMContactSalesManController.h"
#import "UIButton+Design.h"
#import <UIButton+WebCache.h>
#import "JMStoreManager.h"
#import "ProjectNormalConst.h"
#import "AFNHttpRequestOPManager+setCookes.h"
#import "ProjectNormalConst.h"

@interface JMPersonCenterController ()
@property (weak, nonatomic) IBOutlet KJTableView *personCenterTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *storeLogoButton;
@property (weak, nonatomic) IBOutlet UIButton *currentUserNameButton;

@end

@implementation JMPersonCenterController

#pragma mark ------------------------LiftCycle---------------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configureUserInfoUI];
    
    [self _configurePersonCenterTableView];
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
- (void)_configurePersonCenterTableView {
    WEAK_SELF
    self.personCenterTableView.listDatasourceEngine.cellHeight = JMPersonCenterTableViewCellHeight;
    [self.personCenterTableView.listDatasourceEngine configurecellNibName:@"JMPersonCenterTableViewCell" configurecellData:^(id listView, id listCell, id model, NSIndexPath *indexPath) {;
        JMPersonCenterTableViewCell *cell = (JMPersonCenterTableViewCell *)listCell;
        JMPersonCenterItemModel *cellModel = (JMPersonCenterItemModel *)model;
        [cell setCellModel:cellModel];
        
    } clickCell:^(id listView, id listCell, id model, NSIndexPath *clickIndexPath) {
        JMPersonCenterItemModel *cellModel = (JMPersonCenterItemModel *)model;
        [weak_self _clickPersonCenterItem:cellModel atIndexPath:clickIndexPath];
        
    }];
    
    self.personCenterTableView.listDatasourceEngine.firstSectionFooterHeight = 79;
    [self.personCenterTableView.listDatasourceEngine configureFirstSectioFooterNibName:@"JMPersonCenterQuitLoginFooterView" configureTablefirstSectionFooterBlock:^(id listView, id model, id sectionHeaderView) {
        UIView *footerView = (UIView *)sectionHeaderView;
        UIButton *loginButton = [footerView viewWithTag:10];
        [loginButton addActionHandler:^(NSInteger tag) {
            [weak_self _sureQuitLogin];
        }];
    }];
    
    [self.personCenterTableView.listEngine loadDataAfterRequestTotalData:[self _getPersonCenterListData]];
    
}

- (void)_configureUserInfoUI {
    [self.storeLogoButton sd_setImageWithURL:[NSURL URLWithString:StoreManager.currentLoginedStore.storeLogo] forState:UIControlStateNormal placeholderImage:IMAGE(@"sellerHeader")];
    NSString *accountName = JMFormat(@"%@%@",@"管理员账号:",CurrentSelectStore.storeName);
    [self.currentUserNameButton JM_safeSetButtonTitle:accountName forState:UIControlStateNormal];
}

- (void)_sureQuitLogin {
    WEAK_SELF
    [self showSimplyAlertWithTitle:@"提示" message:@"确定退出账号吗？退出后将无法验券及接受相关信息" sureAction:^(UIAlertAction *action) {
        [weak_self _requestQuitLogin];
    } cancelAction:^(UIAlertAction *action) {
        
    }];
}

- (NSArray *)_getPersonCenterListData {
    
    JMPersonCenterItemModel *model1 = [[JMPersonCenterItemModel alloc] init];
    model1.itemTitle = PersonCenter_ItemTitle_Contact_SalesMan;
    model1.itemIconName = @"person_center_icon_contactUs";
    
//    JMPersonCenterItemModel *model2 = [[JMPersonCenterItemModel alloc] init];
//    model2.itemTitle = PersonCenter_ItemTitle_AboutUs;
//    model2.itemIconName = @"person_center_icon_aboutUs";

    return @[model1];
}


#pragma mark ------------------------Api--------------------------------------
- (void)_requestQuitLogin {
    [self showLoadingHub];
    [AFNHttpRequestOPManager postWithSubUrl:KUrl_AccountLogout parameters:nil result:^(NSDictionary *result, NSError *error) {
        [self hideLoadingHub];
        if (error.code == 1) {
            [AFNHttpRequestOPManager clearCookie];
            [StoreManager clearStoreInfo];
            [self performSelector:@selector(_enterLogin) withObject:nil afterDelay:0.8];
        }
    }];
}

#pragma mark ------------------------Private-----------------------------------
- (void)_clickPersonCenterItem:(JMPersonCenterItemModel *)itemModel atIndexPath:(NSIndexPath *)indexPath{
    if ([itemModel.itemTitle isEqualToString:PersonCenter_ItemTitle_Contact_SalesMan]) {
        [self _enterContactSalesManPage];
    }else if ([itemModel.itemTitle isEqualToString:PersonCenter_ItemTitle_AboutUs]) {
        [self _enterAboutUsPage];
    }
}

#pragma mark ------------------------Page Navigate-----------------------------
- (void)_enterLogin {
    JMLoginController *loginVc = [[JMLoginController alloc] init];
    JMSellerBaseNavController *loginNav = [[JMSellerBaseNavController alloc] initWithRootViewController:loginVc];
    kCurrentKeyWindow.rootViewController= loginNav;
}

- (void)_enterContactSalesManPage {
    JMContactSalesManController *contactSalesManVC = [[JMContactSalesManController alloc] init];
    [self navigatePushViewController:contactSalesManVC animate:YES];
}

- (void)_enterAboutUsPage {
    
}

#pragma mark ------------------------View Event--------------------------------
- (IBAction)backAction:(id)sender {
    [self goBack];
}

#pragma mark ------------------------Delegate----------------------------------

#pragma mark ------------------------Notification------------------------------

#pragma mark ------------------------Getter / Setter---------------------------




@end
