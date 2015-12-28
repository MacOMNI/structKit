//
//  MACGalleryPhotoView.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/23.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol MACGalleryPhotoViewDelegate;

//@interface MACGalleryPhotoView : UIImageView {
@interface MACGalleryPhotoView : UIScrollView <UIScrollViewDelegate> {
    
    UIImageView *imageView;
    UIActivityIndicatorView *_activity;
    UIButton *_button;
    BOOL _isZoomed;
    NSTimer *_tapTimer;
    //NSObject <MACGalleryPhotoViewDelegate> *photoDelegate;
}

- (void)killActivityIndicator;

// inits this view to have a button over the image
- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

- (void)resetZoom;

@property (nonatomic,weak) NSObject <MACGalleryPhotoViewDelegate> *photoDelegate;
@property (nonatomic,readonly) UIImageView *imageView;
@property (nonatomic,readonly) UIButton *button;
@property (nonatomic,readonly) UIActivityIndicatorView *activity;

@end



@protocol MACGalleryPhotoViewDelegate

// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapPhotoView:(MACGalleryPhotoView*)photoView;

@end

