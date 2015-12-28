//
//  MACGalleryPhoto.h
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/23.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Foundation/Foundation.h>


@protocol MACGalleryPhotoDelegate;

@interface MACGalleryPhoto : NSObject {
    
    // value which determines if the photo was initialized with local file paths or network paths.
    BOOL _useNetwork;
    
    BOOL _isThumbLoading;
    BOOL _hasThumbLoaded;
    
    BOOL _isFullsizeLoading;
    BOOL _hasFullsizeLoaded;
    
    NSMutableData *_thumbData;
    NSMutableData *_fullsizeData;
    
    NSURLConnection *_thumbConnection;
    NSURLConnection *_fullsizeConnection;
    
    NSString *_thumbUrl;
    NSString *_fullsizeUrl;
    
    UIImage *_thumbnail;
    UIImage *_fullsize;
    
   
    
    NSUInteger tag;
}

- (id)initWithThumbnailUrl:(NSString*)thumb fullsizeUrl:(NSString*)fullsize delegate:(NSObject<MACGalleryPhotoDelegate>*)delegate;
- (id)initWithThumbnailPath:(NSString*)thumb fullsizePath:(NSString*)fullsize delegate:(NSObject<MACGalleryPhotoDelegate>*)delegate;
//sgm
- (id)initWithAssetDictionary:(NSDictionary*)assetDic delegate:(NSObject<MACGalleryPhotoDelegate>*)delegate;

- (void)loadThumbnail;
- (void)loadFullsize;

- (void)unloadFullsize;
- (void)unloadThumbnail;

@property NSUInteger tag;


@property (readonly) BOOL isThumbLoading;
@property (readonly) BOOL hasThumbLoaded;

@property (readonly) BOOL isFullsizeLoading;
@property (readonly) BOOL hasFullsizeLoaded;

@property (nonatomic,readonly) UIImage *thumbnail;
@property (nonatomic,readonly) UIImage *fullsize;

@property (nonatomic,weak) NSObject<MACGalleryPhotoDelegate> *delegate;

@end


@protocol MACGalleryPhotoDelegate

@required
- (void)galleryPhoto:(MACGalleryPhoto*)photo didLoadThumbnail:(UIImage*)image;
- (void)galleryPhoto:(MACGalleryPhoto*)photo didLoadFullsize:(UIImage*)image;

@optional
- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadThumbnailFromUrl:(NSString*)url;
- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadFullsizeFromUrl:(NSString*)url;

- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadThumbnailFromPath:(NSString*)path;
- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadFullsizeFromPath:(NSString*)path;

@end

