//
//  JMHomeController.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMHomeController.h"
#import "KJTableView.h"
#import "JMHomeTableViewCell.h"
#import "UIBarButtonItem+WNXBarButtonItem2.h"
#import "JMPersonCenterController.h"
#import "JMInputVaryfyTicketController.h"
#import "JMScanQRVaryfyTicketController.h"

@interface JMHomeController ()
@property (weak, nonatomic) IBOutlet KJTableView *homeTableView;

@end

@implementation JMHomeController

#pragma mark ------------------------LiftCycle---------------------------------

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"近脉商家";

    [self _configureHomeTableView];
    
    [self _configureLeftItem];
    
    [self showLoadingHub];
    
    [self _requestData];
    
}

#pragma mark ------------------------Init--------------------------------------
- (void)_configureHomeTableView {
    self.homeTableView.listDatasourceEngine.cellHeight = JMHomeTableViewCellHeight;
    self.homeTableView.listEngine.emptyShowTitle = @"暂无消息数据";
    [self.homeTableView.listDatasourceEngine configurecellNibName:@"JMHomeTableViewCell" configurecellData:^(id listView, id listCell, id model, NSIndexPath *indexPath) {
        JMHomeTableViewCell *cell = (JMHomeTableViewCell *)listCell;
        JMSellerMessageModel *kjModel = (JMSellerMessageModel *)model;
        [cell setCellModel:kjModel];
    } clickCell:^(id listView, id listCell, id model, NSIndexPath *clickIndexPath) {
        
    }];
    self.homeTableView.listEngine.needPaging = NO;
    WEAK_SELF
    //头部刷新
    [self.homeTableView.listEngine beginHeaderRefresh:^{
        [weak_self _requestData];
    }];

}

- (void)_configureLeftItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem initWithNormalImage:@"personCenterIcon" target:self action:@selector(clickPersonCenterIconAction) width:18 height:21];
}

#pragma mark ------------------------Api--------------------------------------
- (void)_requestData {
    [AFNHttpRequestOPManager getInfoWithSubUrl:KUrl_GetUserMessages parameters:nil result:^(NSDictionary *result, NSError *error) {
        [self hideLoadingHub];
        NSArray *messages = result[@"mlist"];
        messages = [messages transferDicArrToModelArrWithModelClass:[JMSellerMessageModel class]];
        [self.homeTableView.listEngine loadDataAfterRequestPagingData:messages];
    }];
    
}

#pragma mark ------------------------Private-----------------------------------

#pragma mark ------------------------Page Navigate-----------------------------
- (void)_enterPersonCenterPage {
    JMPersonCenterController *personCenterVC = [[JMPersonCenterController alloc] init];
    [self navigatePushViewController:personCenterVC animate:YES];
}

- (void)_enterInputVaryfyTicketPage {
    JMInputVaryfyTicketController *inputVaryfyTicketPage = [[JMInputVaryfyTicketController alloc] init];
    [self navigatePushViewController:inputVaryfyTicketPage animate:YES];
}

- (void)_enterScanVaryfyTicketPage {
    JMScanQRVaryfyTicketController *scanQRVaryfyTicketPage = [[JMScanQRVaryfyTicketController alloc] init];
    [self navigatePushViewController:scanQRVaryfyTicketPage animate:YES];
}

#pragma mark ------------------------View Event--------------------------------
- (void)clickPersonCenterIconAction {
    [self _enterPersonCenterPage];
}

- (IBAction)inputVaryfyTicketAction:(id)sender {
    [self _enterInputVaryfyTicketPage];
}

- (IBAction)scanVaryfyTicketAction:(id)sender {
    [self _enterScanVaryfyTicketPage];
}

#pragma mark ------------------------Delegate----------------------------------

#pragma mark ------------------------Notification------------------------------

#pragma mark ------------------------Getter / Setter---------------------------




@end
