//
//  JMVaryfyTickResultView.m
//  JMSeller
//
//  Created by JM on 2017/5/19.
//  Copyright © 2017年 JMai. All rights reserved.
//

#import "JMVaryfyTickResultView.h"

static NSString *varyfyTicketErrorTicketNone = @"凭证不存在";
static NSString *varyfyTicketErrorTicketAlreadyUsed = @"凭证已使用";

@interface JMVaryfyTickResultView ()
@property (weak, nonatomic) IBOutlet UIView *inputVaryTicketFaledView;
@property (weak, nonatomic) IBOutlet UIView *varyfyTicketSuccedView;
@property (weak, nonatomic) IBOutlet UIView *scanVaryfyTicketFailedView;
@property (copy, nonatomic)RescanBlock rescanBlock;
@property (weak, nonatomic) IBOutlet UILabel *scanFailedResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputFailedResultLabel;

@end

@implementation JMVaryfyTickResultView

- (IBAction)rescanAction:(id)sender {
    emptyBlock(self.rescanBlock);
    [self performSelector:@selector(_displayResultView:) withObject:self.scanVaryfyTicketFailedView afterDelay:0.3];
}

- (void)inputVaryfyTicketSuccessShow {
    self.varyfyTicketSuccedView.alpha = 1.0f;
    self.inputVaryTicketFaledView.alpha = 0.0f;
    self.scanVaryfyTicketFailedView.alpha = 0.0f;
    [self _showResultView:self.varyfyTicketSuccedView];
    [self _delayHiddenResultView:self.varyfyTicketSuccedView];
}

- (void)inputVaryfyTicketFailedShow {
    self.inputVaryTicketFaledView.alpha = 1.0f;
    self.varyfyTicketSuccedView.alpha = 0.0f;
    self.scanVaryfyTicketFailedView.alpha = 0.0f;

    self.inputFailedResultLabel.text = [self _getInputErrorStr];
    [self _showResultView:self.inputVaryTicketFaledView];
    [self _delayHiddenResultView:self.inputVaryTicketFaledView];

}

- (NSString *)_getInputErrorStr {
    NSString *errorStr = self.errorDescrition;
    if ([errorStr isEqualToString:varyfyTicketErrorTicketNone]) {
        errorStr = @"凭证码错误，请重新输入";
    }else if ([errorStr isEqualToString:varyfyTicketErrorTicketAlreadyUsed]) {
        errorStr = @"凭证码已被使用";
    }
    return errorStr;
}

- (NSString *)_getScanErrorStr {
    NSString *errorStr = self.errorDescrition;
    if ([errorStr isEqualToString:varyfyTicketErrorTicketNone]) {
        errorStr = @"此凭证码错误，不能接待。请与消费者确认提供的凭证是否正确";
    }else if ([errorStr isEqualToString:varyfyTicketErrorTicketAlreadyUsed]) {
        errorStr = @"此凭证已被使用，不能接待。请与消费者确认提供的凭证是否正确";
    }
    return errorStr;
}


- (NSAttributedString *)_getAttributedScanErroStrWithOriginalErorrorStr:(NSString *)errorStr{
//        errorStr = @"此密码错误，不能接待。请与消费者确认提供的密码是否正确";
    errorStr = [self _getScanErrorStr];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:errorStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:2];
    paragraphStyle.lineHeightMultiple = 1.3;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [errorStr length])];
    return (NSAttributedString *)attributedString;
}

- (void)scanVaryfyTicketSuccessShow {
    self.varyfyTicketSuccedView.alpha = 1.0f;
    self.inputVaryTicketFaledView.alpha = 0.0f;
    self.scanVaryfyTicketFailedView.alpha = 0.0f;
    [self _showResultView:self.varyfyTicketSuccedView];
    [self _delayHiddenResultView:self.varyfyTicketSuccedView];

}

- (void)scanVaryfyTicketFailedShowWithRescanBlock:(RescanBlock)rescanBlock {
    self.scanVaryfyTicketFailedView.alpha = 1.0f;
    self.inputVaryTicketFaledView.alpha = 0.0f;
    self.varyfyTicketSuccedView.alpha = 0.0f;
    self.scanFailedResultLabel.attributedText = [self _getAttributedScanErroStrWithOriginalErorrorStr:self.errorDescrition];
    [self _showResultView:self.scanVaryfyTicketFailedView];
    self.rescanBlock = rescanBlock;
}


- (void)_showResultView:(UIView *)resultView {
    resultView.transform =  CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:1.0 delay:0.2 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        resultView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)_delayHiddenResultView:(UIView *)resultView {
    [self performSelector:@selector(_displayResultView:) withObject:resultView afterDelay:3];
}

- (void)_displayResultView:(UIView *)resultView {
    [UIView animateWithDuration:0.3 animations:^{
        resultView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
