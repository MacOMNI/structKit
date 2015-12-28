//
//  SearchContactVC.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/14.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "SearchContactVC.h"
#import "QRScanViewController.h"
#import "UIView+HUD.h"
#import "FSMediaPicker.h"
#import "MACGalleryDelViewController.h"
@interface SearchContactVC ()<FSMediaPickerDelegate>
{
      ALAssetsLibrary* assetLibrary;//照片的生命周期跟它有关，所以弄成全局变量在这里初始化
    __block NSMutableArray *arr;//图片的ALAssets

}

@end

@implementation SearchContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"跳转测试";
    [self setRightBarWithString:@"结束"];
    //全局变量
    assetLibrary = [[ALAssetsLibrary alloc]init];
    //[self.view showAlertMessage:@"牛逼的人生不需要解释"];

    //[self.view showMessage:@"牛逼的人生不需要解释"];
   // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void)RightBarItemAction
{
    [self.view hideHUD];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击事件

- (IBAction)tipAction:(id)sender {
    [self.view showMessage:@"牛逼的人生不需要解释"];
   // NSMutableArray *arr=[NSMutableArray array];
    //id a= (id)arr[1];
}


- (IBAction)netWorkAction:(id)sender {
    [self.view  showWaiting];
    [BaseService POST:@"12" parameters:nil result:^(NSString *urlString, id result, NSError *error) {
        //[self.view  hideHUD];
    }];
}

- (IBAction)pickerAction:(id)sender {
  FSMediaPicker  *imgPicker=[[FSMediaPicker alloc]init];
    imgPicker.delegate=self;
    imgPicker.mediaType=FSMediaTypePhoto;
    [imgPicker showFromView:self.view];
 
}

- (IBAction)loadDataAction:(id)sender {
    //[self.view  showWaiting];
     [self.view  showLoading:@"正在上传中..."];
}

- (IBAction)scanAction:(id)sender {
    QRScanViewController *scanVC=[[QRScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];

}

- (IBAction)alertAction:(id)sender {
    [self showAlertMessage:@"牛逼丸"];
  

}

- (IBAction)hideAction:(id)sender {
    [self.view hideHUD];
}

- (IBAction)choosePicAction:(id)sender {
    MACAlbumViewController *viewVC=[[MACAlbumViewController alloc]init];
    viewVC.assetsLibrary =assetLibrary;
    viewVC.limitNum = 5;//不设置即不限制
    arr=[NSMutableArray array];
    [viewVC doSelectedBlock:^(NSMutableArray *assetDicArray) {
//        [assetDicArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            ALAsset *asset = [obj objectForKey:@"asset"];
//            [arr addObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]];
//        }];
        arr =assetDicArray;
    }];
    
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:viewVC];
    [self presentViewController:nav animated:YES completion:nil];

}

- (IBAction)delPicAction:(id)sender {
    
    MACGalleryDelViewController *delVC=[[MACGalleryDelViewController alloc]init];
    delVC.assetArray=arr;
    delVC.limitNum=(int)arr.count;
    delVC.isAssetDic = YES;
    delVC.isPreview = NO;
    delVC.startingIndex = 0;
    
   // UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:delVC];
   // [self presentViewController:delVC animated:YES completion:nil];
    [self.navigationController pushViewController:delVC animated:YES];

}
#pragma mark FSMediaPicker delegate
-(void)mediaPicker:(FSMediaPicker *)mediaPicker didFinishWithMediaInfo:(NSDictionary *)mediaInfo
{
    DLog(@"WoW");
}
@end
