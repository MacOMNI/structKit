//
//  MACAlbumViewController.h
//  WeChat
//
//  Created by 苏贵明 on 15/9/4.
//  modify by MacKun
//

#import <UIKit/UIKit.h>
#import "MACPhotosViewController.h"


@interface MACAlbumViewController : UIViewController

@property(nonatomic,retain)ALAssetsLibrary *assetsLibrary;
@property int limitNum;//限制选择张数，不设置(<1)即不限制
-(void)doSelectedBlock:(SelectedBlock)bl;

@end
