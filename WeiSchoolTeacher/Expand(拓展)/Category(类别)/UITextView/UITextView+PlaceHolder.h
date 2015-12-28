//
//  UITextView+PlaceHolder.h
//  MacKun
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (PlaceHolder) <UITextViewDelegate>
@property (nonatomic, strong) UITextView *placeHolderTextView;
//@property (nonatomic, assign) id <UITextViewDelegate> textViewDelegate;
/**
 *  添加占位文本字符串
 *
 *  @param placeHolder 占位文本字符串
 */
- (void)addPlaceHolder:(NSString *)placeHolder;
@end
