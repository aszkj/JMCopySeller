//
//  HCScanQRViewController.m
//  HCSystemicQRCodeDemo
//
//  Created by Caoyq on 16/5/4.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#import "JMScanQRVaryfyTicketController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"
#import "SystemFunctions.h"
#import "UIButton+Design.h"
#import "ProjectNormalConst.h"
#import "JMSelectStoreTitleView.h"
#import "GlobleUnormalConst.h"
#import "JMPullSelectStoreView.h"
#import "JMStoreModel.h"
#import <Masonry.h>
#import "JMVaryfyTickResultView.h"
#import "ProjectNormalConst.h"
#import "AFNHttpRequestOPManager+specialApi.h"



#define ratio         [[UIScreen mainScreen] bounds].size.width/375.0
#define kBgImgX             20*ratio
#define kBgImgY             (64+102)*ratio
#define kBgImgWidth         331*ratio

#define kScrollLineHeight   3*ratio

#define kTipY               (kBgImgY + kBgImgWidth + 10)
#define kTipHeight          20*ratio

#define kLampX              ([[UIScreen mainScreen] bounds].size.width-kLampWidth)/2
#define kLampY              ([[UIScreen mainScreen] bounds].size.height-kLampWidth-30*ratio)
#define kLampWidth          16
#define kLampHeight          24

#define kBgAlpha            0.6


@interface JMScanQRVaryfyTicketController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *QRCode;
}

#pragma mark - ---属性---
/**
 *输入输出中间桥梁(会话)
 */
@property (strong, nonatomic) AVCaptureSession *session;

/**
 *计时器
 */
@property (strong, nonatomic) CADisplayLink *link;

/**
 *实际有效扫描区域的背景图(亦或者自己设置一个边框)
 */
@property (strong, nonatomic) UIImageView *bgImg;

/**
 *有效扫描区域循环往返的一条线（这里用的是一个背景图）
 */
@property (strong, nonatomic) UIImageView *scrollLine;

/**
 *扫码有效区域外自加的文字提示
 */
@property (strong, nonatomic) UILabel *tip;

/**
 *用于控制照明灯的开启,显示灯
 */
@property (strong, nonatomic) UIButton *lamp;
/**
 *用于控制照明灯的开启，显示开启，关闭
 */
@property (strong, nonatomic)UIButton *lampTitleButton;

/**
 *用于记录scrollLine的上下循环状态
 */
@property (assign, nonatomic) BOOL up;


@property (assign, nonatomic) BOOL hasScanedResult;

@property (strong, nonatomic)JMSelectStoreTitleView *selectStoreTitleView;

@property (strong, nonatomic)JMPullSelectStoreView *pullSelectStoreView;

#pragma mark -------
@property (strong, nonatomic)JMVaryfyTickResultView *varyfyResultView;

@end

@implementation JMScanQRVaryfyTicketController

#pragma mark - ---Life Cycle---
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _checkUserPhotoAccessRight];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self _loadTopView];

    [self setNavigationItem];
    _up = YES;
    
    [self session];
    
    //1.添加一个可见的扫描有效区域的框（这里直接是设置一个背景图片）
    [self.view addSubview:self.bgImg];
    
    //2.添加一个上下循环运动的线条（这里直接是添加一个背景图片来运动）
    [self.view addSubview:self.scrollLine];
    
    //3.添加其他有效控件
    [self.view addSubview:self.tip];
    [self.view addSubview:self.lamp];
    [self.view addSubview:self.lampTitleButton];
    [self _loadBackItem];
    [self _loadSelectStoreNameView];
//    [self performSelector:@selector(showScanResult) withObject:nil afterDelay:5.0f];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hasScanedResult = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self.session startRunning];
    //计时器添加到循环中去
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.session stopRunning];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - api
- (void)_requestVaryfyTicketWithScanedCode:(NSString *)scanedCode {
    [self showLoadingHub];
    
    [AFNHttpRequestOPManager api_varyTickWithCode:scanedCode shopId:CurrentSelectStore.storeId resutlt:^(NSDictionary *result, NSError *error) {
        [self hideLoadingHub];
        if (error.code == 1) {
            [self.varyfyResultView scanVaryfyTicketSuccessShow];
            [self goBackAfter:3.0];
        }else {
            self.varyfyResultView.errorDescrition = error.localizedDescription;
            WEAK_SELF
            [self.varyfyResultView scanVaryfyTicketFailedShowWithRescanBlock:^{
                [weak_self performSelector:@selector(_resetHasScanResult) withObject:nil afterDelay:3.0];
            }];
        }
    }];
}


#pragma mark - private
- (void)_configureStoreNameShowButton {
    JMStoreModel *model = CurrentSelectStore;
    [self _setStoreNameShowButtonWithStoreName:model.storeName];
}

- (void)_resetHasScanResult {
    self.hasScanedResult = NO;
}

- (void)_setStoreNameShowButtonWithStoreName:(NSString *)storeName {
    [self.selectStoreTitleView.storeNameButton JM_safeSetButtonTitle:storeName forState:UIControlStateNormal];
}


- (NSArray *)_getSotoreData {
    return StoreManager.currentLoginedStore.shops;
}


#pragma mark - ---lazy load---
- (UIImageView *)bgImg {
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kBgImgWidth)];
        _bgImg.image = [UIImage imageNamed:@"scan_bg"];
    }
    return _bgImg;
}

- (UIImageView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [[UIImageView alloc]initWithFrame:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kScrollLineHeight)];
        _scrollLine.image = [UIImage imageNamed:@"scan_line"];
    }
    return _scrollLine;
}

- (UILabel *)tip {
    if (!_tip) {
        _tip = [[UILabel alloc]initWithFrame:CGRectMake(kBgImgX, kTipY, kBgImgWidth, kTipHeight)];
        _tip.text = @"将二维码放入取景框汇总即可自动扫描";
        _tip.numberOfLines = 0;
        _tip.textColor = [UIColor whiteColor];
        _tip.textAlignment = NSTextAlignmentCenter;
        _tip.font = [UIFont systemFontOfSize:12.0];
    }
    return _tip;
}



- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(LineAnimation)];
    }
    return _link;
}

- (UIButton *)lamp {
    if (!_lamp) {
        _lamp = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kLampWidth-20*ratio-10, kBgImgY-52, kLampWidth, kLampHeight)];
//        _lamp.alpha = kBgAlpha;
        _lamp.selected = NO;
        [_lamp setEnlargeEdge:kUIExternReponsedEdge];
        [_lamp setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
        [_lamp addTarget:self action:@selector(touchLamp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lamp;
}

- (UIButton *)lampTitleButton {
    if (!_lampTitleButton) {
        _lampTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-kLampWidth-20*ratio-kLampWidth-20, kBgImgY-52, 25, 20)];
        _lampTitleButton.selected = NO;
        [_lampTitleButton setEnlargeEdge:kUIExternReponsedEdge];
        _lampTitleButton.titleLabel.textColor = [UIColor whiteColor];
        _lampTitleButton.titleLabel.font = kSystemFontSize(11);
        [_lampTitleButton setTitle:@"开启" forState:UIControlStateNormal];
        [_lampTitleButton setTitle:@"关闭" forState:UIControlStateSelected];
        [_lampTitleButton addTarget:self action:@selector(touchLamp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lampTitleButton;

}

- (AVCaptureSession *)session {
    if (!_session) {
        //1.获取输入设备（摄像头）
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        //2.根据输入设备创建输入对象
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:NULL];
        if (input == nil) {
            return nil;
        }
        
        //3.创建元数据的输出对象
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
        //4.设置代理监听输出对象输出的数据,在主线程中刷新
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        // 5.创建会话(桥梁)
        AVCaptureSession *session = [[AVCaptureSession alloc]init];
        //实现高质量的输出和摄像，默认值为AVCaptureSessionPresetHigh，可以不写
        [session setSessionPreset:AVCaptureSessionPresetHigh];
        // 6.添加输入和输出到会话中（判断session是否已满）
        if ([session canAddInput:input]) {
            [session addInput:input];
        }
        if ([session canAddOutput:output]) {
            [session addOutput:output];
        }
        
        // 7.告诉输出对象, 需要输出什么样的数据 (二维码还是条形码等) 要先创建会话才能设置
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode];
        
        // 8.创建预览图层
        AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
        [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        previewLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:previewLayer atIndex:0];
        
        //9.设置有效扫描区域，默认整个图层(很特别，1、要除以屏幕宽高比例，2、其中x和y、width和height分别互换位置)
        CGRect rect = CGRectMake(kBgImgY/kScreenHeight, kBgImgX/kScreenWidth, kBgImgWidth/kScreenHeight, kBgImgWidth/kScreenWidth);
        output.rectOfInterest = rect;
        
        //10.设置中空区域，即有效扫描区域(中间扫描区域透明度比周边要低的效果)
        UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kBgAlpha];
        [self.view addSubview:maskView];
        UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
        [rectPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(kBgImgX, kBgImgY, kBgImgWidth, kBgImgWidth) cornerRadius:1] bezierPathByReversingPath]];
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = rectPath.CGPath;
        maskView.layer.mask = shapeLayer;
        
        _session = session;
    }
    return _session;
}

#pragma mark --- enter scan result page
- (void)_enterScanResultPageWithScanedCode:(NSString *)scanedCode {

}

#pragma mark - ---NavigationItem---
- (void)setNavigationItem{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"二维码/条形码";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:@"相册"
                                 style:UIBarButtonItemStylePlain
                                 target:self
                                 action:@selector(openPhoto)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)_loadBackItem {
    UIButton *button_na = [[UIButton alloc]initWithFrame:CGRectMake(20, 28, 11, 18)];
    [button_na setEnlargeEdge:8];
    [button_na setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [button_na addTarget:self action:@selector(scanBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_na];
}

- (void)_loadTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavBarAndStatusBarHeight)];
    topView.alpha = 1;
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
}

- (void)_loadTitleView {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2, (kNavBarAndStatusBarHeight-30)/2+7, 150, 30)];
    titleLabel.text = @"二维码/条形码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = kSystemFontSize(16);
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];
}

- (void)_loadSelectStoreNameView {
    self.selectStoreTitleView = BoundNibView(@"JMSelectStoreTitleView", JMSelectStoreTitleView);
    self.selectStoreTitleView.frame = CGRectMake((kScreenWidth - 150)/2, (kNavBarAndStatusBarHeight-30)/2+5, 150, 30);
    WEAK_SELF
    self.selectStoreTitleView.selectStoreNameBlock = ^{
        [weak_self.pullSelectStoreView showPullSelectViewWithPullDatas:[weak_self _getSotoreData]];
    };
    [self.view addSubview:self.selectStoreTitleView];
    [self _configureStoreNameShowButton];
}

#pragma mark - 线条运动的动画
- (void)LineAnimation {
    if (_up == YES) {
        CGFloat y = self.scrollLine.frame.origin.y;
        y += 2;
        self.scrollLine.top = y;
        if (y >= (kBgImgY+kBgImgWidth-kScrollLineHeight)) {
            _up = NO;
        }
    }else{
        CGFloat y = self.scrollLine.frame.origin.y;
        y -= 2;
        self.scrollLine.top = y;
        if (y <= kBgImgY) {
            _up = YES;
        }
    }
}


#pragma mark - 开灯或关灯
- (void)touchLamp:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    [SystemFunctions openLight:btn.selected];
}

#pragma mark - 返回
- (void)scanBack {
    [self goBack];
}

#pragma mark - 调用相册
- (void)openPhoto {
    //1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    //2.创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    //选中之后大图编辑模式
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark - 检测用户访问摄像头权限
- (void)_checkUserPhotoAccessRight {
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        [self showSimplyAlertWithTitle:@"提示" message:@"您已经禁止了摄像头访问权限，请到系统设置页面将其开启" sureAction:^(UIAlertAction *action) {
            [self goBack];
        }];
    }else{
        
    }
}

#pragma mark - Show Scan Result 

- (IBAction)showScanResult{
    if (random() % 4 == 0) {
        [self.varyfyResultView scanVaryfyTicketSuccessShow];
    }else {
        [self.varyfyResultView scanVaryfyTicketFailedShowWithRescanBlock:^{
            //重新扫描
        
        }];
    }
}


#pragma mark - UIImagePickerControllerDelegate
//相册获取的照片进行处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    // 1.取出选中的图片
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    
    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    //2.从选中的图片中读取二维码数据
    //2.1创建一个探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 2.2利用探测器探测数据
    NSArray *feature = [detector featuresInImage:ciImage];
    
    // 2.3取出探测到的数据
    for (CIQRCodeFeature *result in feature) {
        NSString *urlStr = result.messageString;
        //二维码信息回传
        self.block(urlStr);
        NSLog(@"扫描结果1---%@",urlStr);
    }

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (feature.count == 0) {
        [self showAlertWithTitle:@"扫描结果" Message:@"没有扫描到有效二维码" OptionalAction:@[@"确认"]];
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate
// 扫描到数据时会调用
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    if (metadataObjects.count > 0) {
//        [SystemFunctions openShake:YES Sound:YES];
        // 1.停止扫描
        //        [self.session stopRunning];
        // 2.停止冲击波
        //        [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        // 3.取出扫描到得数据
        if (!self.hasScanedResult) {
            AVMetadataMachineReadableCodeObject *obj = [metadataObjects lastObject];
            if (obj) {
                //二维码信息回传
                if (self.block) {
                    self.block([obj stringValue]);
                }
//                [self _enterScanResultPageWithScanedCode:[obj stringValue]];
                [self _requestVaryfyTicketWithScanedCode:[obj stringValue]];
                DDLogVerbose(@"扫描商品结果---%@",[obj stringValue]);
                self.hasScanedResult = YES;
            }
        }
    }
}

#pragma mark - 提示框
- (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message OptionalAction:(NSArray *)actions {
    
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertCtrl addAction:[UIAlertAction actionWithTitle:actions.firstObject style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

#pragma mark - 二维码块传值
- (void)successfulGetQRCodeInfo:(successBlock)success {
    self.block =success;
}

#pragma mark - Setter/Getter
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



@end
