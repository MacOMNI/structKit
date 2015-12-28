//
//  MACGalleryDelViewController.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/23.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MACGalleryPhotoView.h"
#import "MACGalleryPhoto.h"


typedef enum
{
    MACGalleryDelPhotoSizeThumbnail,
    MACGalleryDelPhotoSizeFullsize//全屏
} MACGalleryDelPhotoSize;

typedef enum
{
    MACGalleryDelPhotoSourceTypeNetwork,
    MACGalleryDelPhotoSourceTypeLocal//本地
} MACGalleryDelPhotoSourceType;


@protocol MACGalleryDelViewControllerDelegate;

@interface MACGalleryDelViewController : UIViewController <UIScrollViewDelegate,MACGalleryPhotoDelegate,MACGalleryPhotoViewDelegate> {
    
    BOOL _isActive;
    BOOL _isFullscreen;
    BOOL _isScrolling;
    BOOL _isThumbViewShowing;
    
    UIStatusBarStyle _prevStatusStyle;
    CGFloat _prevNextButtonSize;
    CGRect _scrollerRect;
    NSString *galleryID;
    NSInteger _currentIndex;
    
    UIView *_container; // used as view for the controller
    UIView *_innerContainer; // sized and placed to be fullscreen within the container
    UIToolbar *_toolbar;
    UIScrollView *_thumbsView;
    UIScrollView *_scroller;
    UIView *_captionContainer;
    UILabel *_caption;
    
    NSMutableDictionary *_photoLoaders;
    NSMutableArray *_barItems;
    NSMutableArray *_photoThumbnailViews;
    NSMutableArray *_photoViews;
    
    //NSObject <MACGalleryDelViewControllerDelegate> *_photoSource;
    
}

- (id)initWithPhotoSource:(NSObject<MACGalleryDelViewControllerDelegate>*)photoSrc;
- (id)initWithPhotoSource:(NSObject<MACGalleryDelViewControllerDelegate>*)photoSrc barItems:(NSArray*)items;

- (void)next;
- (void)previous;
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)reloadGallery;
- (MACGalleryPhoto*)currentPhoto;

@property NSInteger currentIndex;
@property NSInteger startingIndex;
@property (nonatomic,assign) NSObject<MACGalleryDelViewControllerDelegate> *photoSource;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIView* thumbsView;
@property (nonatomic,retain) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;
@property (nonatomic) BOOL hideTitle;


@property int limitNum;
//@property(nonatomic,assign)SelectedBlock block;
@property (nonatomic) BOOL isAssetDic;
@property (nonatomic) BOOL isPreview;//是预览
/**
 *  数据源
 */
@property (nonatomic,assign)NSMutableArray* assetArray;
@property (nonatomic,assign)NSMutableArray* selectedArray;

@end


@protocol MACGalleryDelViewControllerDelegate

@required
/**
 *  删除代理回调函数
 *
 *  @param 删除的下标
 */
//- (void)delNumberOfPhotosForPhotoGallery:(int)galleryIndex;
//- (MACGalleryDelPhotoSourceType)photoGallery:(MACGalleryDelViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(MACGalleryDelViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which MACGalleryDelPhotoSourceType is specified
- (NSString*)photoGallery:(MACGalleryDelViewController*)gallery filePathForPhotoSize:(MACGalleryDelPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(MACGalleryDelViewController*)gallery urlForPhotoSize:(MACGalleryDelPhotoSize)size atIndex:(NSUInteger)index;
//sgm  isAssetDic时使用
- (NSDictionary*)photoGallery:(MACGalleryDelViewController*)gallery assetDictionaryAtIndex:(NSUInteger)index;


@end



