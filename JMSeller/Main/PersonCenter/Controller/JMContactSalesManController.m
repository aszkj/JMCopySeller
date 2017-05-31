//
//  JMContactSalesManController.m
//  JMSeller
//
//  Created by JM on 2017/5/18.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMContactSalesManController.h"
#import "KJTableView.h"
#import "Util.h"
#import "JMContactSalesManTableViewCell.h"
#import "AFNHttpRequestOPManager+specialApi.h"
#import "ProjectNormalConst.h"

@interface JMContactSalesManController ()
@property (weak, nonatomic) IBOutlet KJTableView *contactSalesManTableView;

@end

@implementation JMContactSalesManController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"联系业务员";
    
    [self _configureContactSalesManTableView];
    
    [self _requestSalesManData];
    
}

- (void)_configureContactSalesManTableView {
    
    self.contactSalesManTableView.listDatasourceEngine.cellHeight = JMContactSalesManTableViewCellHeight;
    self.contactSalesManTableView.listEngine.emptyShowTitle = @"暂无业务员";
    [self.contactSalesManTableView.listDatasourceEngine configurecellNibName:@"JMContactSalesManTableViewCell" configurecellData:^(id listView, id listCell, id model, NSIndexPath *indexPath) {
        
        JMContactSalesManTableViewCell *cell = (JMContactSalesManTableViewCell *)listCell;
        JMContactSalesManModel *cellModel = (JMContactSalesManModel *)model;
        [cell setCellModel:cellModel];
        
    } clickCell:^(id listView, id listCell, id model, NSIndexPath *clickIndexPath) {
        JMContactSalesManModel *cellModel = (JMContactSalesManModel *)model;
        if (cellModel.saleManPhoneNumber) {
            [Util dialWithPhoneNumber:cellModel.saleManPhoneNumber];
        }
    }];

}

- (void)_requestSalesManData {
//    [self.contactSalesManTableView.listEngine loadDataAfterRequestTotalData:[self _testData]];
    [AFNHttpRequestOPManager api_getSalesManInfoWithShopId:CurrentSelectStore.storeId resutlt:^(NSDictionary *result, NSError *error) {
        if (isEmpty(result)) {
            result = @{};
        }
        JMContactSalesManModel *model = [[JMContactSalesManModel alloc] initWithDefaultDataDic:result];
        [self.contactSalesManTableView.listEngine loadDataAfterRequestTotalData:@[model]];
    }];
}

- (NSArray *)_testData {
    
    JMContactSalesManModel *model1 = [[JMContactSalesManModel alloc] init];
    model1.saleManJobTitle = @"业务经理";
    model1.saleManName = @"小张";
    model1.saleManPhoneNumber = @"15099908196";
    
    
    JMContactSalesManModel *model2 = [[JMContactSalesManModel alloc] init];
    model2.saleManJobTitle = @"业务经理";
    model2.saleManName = @"小李";
    model2.saleManPhoneNumber = @"15099908196";

    return @[model1,model2];
}




@end
