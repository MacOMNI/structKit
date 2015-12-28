//
//  UIView+HUD.h
//  MacKun
//

#import <UIKit/UIKit.h>
#import "MONActivityIndicatorView.h"

@interface UIView (HUD)<MONActivityIndicatorViewDelegate>
/**
 *  普通展示提示信息 (1.5秒后消失)
 */
-(void)showMessage:(NSString *)message;
/**
 *  展示程序的错误或者警告信息
 */
-(void)showError:(NSString *)error;
/**
 *  展示成功信息
 */
-(void)showSuccess:(NSString *)success;


/**
 *  默认加载进度动画
 */
-(void)showLoading:(NSString*)message;
/**
 *  加载请求数据
 */
-(void)showWaiting;
/**
 *  隐藏HUD
 */
-(void)hideHUD;
/**
 *  展示自定义动画效果的Alert提示信息
 */
//-(void)showAlertMessage:(NSString*)message;
@end
