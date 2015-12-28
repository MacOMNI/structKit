//
//  MACPhotosViewController.h
//  WeChat
//
//  Created by 苏贵明 on 15/9/4.
//  modify by MacKun
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MACGalleryViewController.h"

typedef enum {
    AssetArrayType,
    SelectedArrayType
}ArrayType;

@interface MACPhotosViewController : UIViewController

@property(nonatomic,retain)ALAssetsGroup *group;
@property(nonatomic,weak)SelectedBlock block;
@property int limitNum;

@end

