//
//  MACAlertView.h
//  MACAlertView
//  MacKun
//

#import <UIKit/UIKit.h>
#import"RTLabel.h"
extern NSString *const MACAlertViewWillShowNotification;
extern NSString *const MACAlertViewDidShowNotification;
extern NSString *const MACAlertViewWillDismissNotification;
extern NSString *const MACAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, MACAlertViewButtonType) {
    MACAlertViewButtonTypeDefault = 0,
    MACAlertViewButtonTypeDestructive,
    MACAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, MACAlertViewBackgroundStyle) {
    MACAlertViewBackgroundStyleGradient = 0,
    MACAlertViewBackgroundStyleSolid,
};

typedef NS_ENUM(NSInteger, MACAlertViewTransitionStyle) {
    MACAlertViewTransitionStyleSlideFromBottom = 0,
    MACAlertViewTransitionStyleSlideFromTop,
    MACAlertViewTransitionStyleFade,
    MACAlertViewTransitionStyleBounce,
    MACAlertViewTransitionStyleDropDown
};

@class MACAlertView;
typedef void(^MACAlertViewHandler)(MACAlertView *alertView);

@interface MACAlertView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) RTLabel *messageLabel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) MACAlertViewTransitionStyle transitionStyle; // default is MACAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) MACAlertViewBackgroundStyle backgroundStyle; // default is MACAlertViewButtonTypeGradient

@property (nonatomic, copy) MACAlertViewHandler willShowHandler;
@property (nonatomic, copy) MACAlertViewHandler didShowHandler;
@property (nonatomic, copy) MACAlertViewHandler willDismissHandler;
@property (nonatomic, copy) MACAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0



- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)addButtonWithTitle:(NSString *)title type:(MACAlertViewButtonType)type handler:(MACAlertViewHandler)handler;

- (void)show;
- (void)dismissAnimated:(BOOL)animated;

@end

