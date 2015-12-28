//
//  MACGalleryViewController.h
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
    MACGalleryPhotoSizeThumbnail,
    MACGalleryPhotoSizeFullsize
} MACGalleryPhotoSize;

typedef enum
{
    MACGalleryPhotoSourceTypeNetwork,
    MACGalleryPhotoSourceTypeLocal
} MACGalleryPhotoSourceType;

typedef void  (^SelectedBlock) (NSMutableArray* assetDicArray);

@protocol MACGalleryViewControllerDelegate;

@interface MACGalleryViewController : UIViewController <UIScrollViewDelegate,MACGalleryPhotoDelegate,MACGalleryPhotoViewDelegate> {
    
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
    
    //NSObject <MACGalleryViewControllerDelegate> *_photoSource;
    
}

- (id)initWithPhotoSource:(NSObject<MACGalleryViewControllerDelegate>*)photoSrc;
- (id)initWithPhotoSource:(NSObject<MACGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items;

- (void)next;
- (void)previous;
- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)reloadGallery;
- (MACGalleryPhoto*)currentPhoto;

@property NSInteger currentIndex;
@property NSInteger startingIndex;
@property (nonatomic,assign) NSObject<MACGalleryViewControllerDelegate> *photoSource;
@property (nonatomic,readonly) UIToolbar *toolBar;
@property (nonatomic,readonly) UIView* thumbsView;
@property (nonatomic,retain) NSString *galleryID;
@property (nonatomic) BOOL useThumbnailView;
@property (nonatomic) BOOL beginsInThumbnailView;
@property (nonatomic) BOOL hideTitle;

//sgm
@property int limitNum;
@property(nonatomic,assign)SelectedBlock block;
@property (nonatomic) BOOL isAssetDic;
@property (nonatomic) BOOL isPreview;//是预览
@property (nonatomic,assign)NSMutableArray* assetArray;
@property (nonatomic,assign)NSMutableArray* selectedArray;

@end


@protocol MACGalleryViewControllerDelegate

@required
- (int)numberOfPhotosForPhotoGallery:(MACGalleryViewController*)gallery;
- (MACGalleryPhotoSourceType)photoGallery:(MACGalleryViewController*)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index;

@optional
- (NSString*)photoGallery:(MACGalleryViewController*)gallery captionForPhotoAtIndex:(NSUInteger)index;

// the photosource must implement one of these methods depending on which MACGalleryPhotoSourceType is specified
- (NSString*)photoGallery:(MACGalleryViewController*)gallery filePathForPhotoSize:(MACGalleryPhotoSize)size atIndex:(NSUInteger)index;
- (NSString*)photoGallery:(MACGalleryViewController*)gallery urlForPhotoSize:(MACGalleryPhotoSize)size atIndex:(NSUInteger)index;
//sgm  isAssetDic时使用
- (NSDictionary*)photoGallery:(MACGalleryViewController*)gallery assetDictionaryAtIndex:(NSUInteger)index;


@end

