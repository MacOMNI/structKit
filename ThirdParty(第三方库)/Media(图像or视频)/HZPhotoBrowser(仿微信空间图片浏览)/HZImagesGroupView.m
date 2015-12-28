//
//  HZImagesGroupView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  modify by MacKun on 15/11/6.
//

#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "UIImageView+WebCache.h"


#define kImagesMargin 5
#define kImageMaxCount 3

@interface HZImagesGroupView() <HZPhotoBrowserDelegate>
{
    NSMutableArray *btnArr;
    CGSize size;
}

@end

@implementation HZImagesGroupView
//-(void)awakeFromNib
//{
//    if (!self.image) {
//        self.image = [UIImage imageNamed:@"random.jpg"];
//        if (NULL != UIGraphicsBeginImageContextWithOptions)
//            UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
//        else
//            UIGraphicsBeginImageContext(imageSize);
//        [image drawInRect:imageRect];
//        self.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//    }
//}
//Xib 自动布局
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super initWithCoder:aDecoder];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
      //  [self initBtn];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        self.backgroundColor = [UIColor redColor];
      //  [self initBtn];
    }
    return self;
}
-(void)initUIImageView
{

    btnArr=[NSMutableArray array];
    for (int i=0; i<kImageMaxCount; i++) {
        UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectZero];
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        imgView.contentMode =UIViewContentModeScaleAspectFill ;
        imgView.tag = i;
        imgView.userInteractionEnabled=YES;
        imgView.clipsToBounds=YES;
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(TapAction:)];
        [imgView addGestureRecognizer:gesture];
        [self addSubview:imgView];
        [btnArr addObject:imgView];
        //DLog(@"图片控件的个数 - - - %lu\n",(unsigned long)self.subviews.count);
    }
}
- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
       _photoItemArray = photoItemArray;
    CGFloat Twidth=(appWidth-self.frame.origin.x-kImagesMargin*4)/3.0;
    size=CGSizeMake(Twidth, Twidth);
     [photoItemArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if (idx <kImageMaxCount) {
            UIImageView *imgView=(UIImageView *)btnArr[idx];
            [imgView setFrame:CGRectMake(idx*(size.width)+kImagesMargin*(idx+1), 0, size.width, size.height)];

//            dispatch_async(dispatch_get_main_queue(), ^{
//                [imgView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                }];
//            });
            [imgView sd_setImageWithURL: [NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]  options:SDWebImageLowPriority];
            [imgView setHidden:NO];
        }
    }];
    for(long i=_photoItemArray.count;i<kImageMaxCount;i++)
    {
        UIImageView *imgView=(UIImageView *)btnArr[i];
        [imgView setHidden:YES];
        imgView.image=nil;
    }
}
//-(CGSize)getBtnSize:(long)arrCount
//{
//    CGSize btnSize;
//    switch (arrCount) {
//        case 0:
//            [self setHeight:0.1];
//            btnSize=CGSizeMake(0, 0);
//            break;
//        case 1:
//            [self setHeight:appWidth*0.46];
//             btnSize=CGSizeMake(self.frame.size.width*0.75, self.frame.size.height);
//            break;
//        default:
//            [self setHeight:95];
//            btnSize=CGSizeMake((self.frame.size.width-kImagesMargin*4)/3, self.frame.size.height);
//
//            break;
//    }
//    return btnSize;
//}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    DLog(@"子视图个数：%d",self.subviews.count);
//}

- (void)buttonClick:(UIButton *)button
{
    //启动图片浏览器
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photoItemArray.count; // 图片总数
    browserVc.currentImageIndex = (int)button.tag;
    browserVc.delegate = self;
    [browserVc show];

}
-(void)TapAction:(UITapGestureRecognizer   *)gesture
{
   NSInteger indx= gesture.view.tag;
    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
    browserVc.sourceImagesContainerView = self; // 原图的父控件
    browserVc.imageCount = self.photoItemArray.count; // 图片总数
    browserVc.currentImageIndex = (int)indx;
    browserVc.delegate = self;
    [browserVc show];
    
}

#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [(UIImageView *)self.subviews[index] image];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.photoItemArray[index];
    return [NSURL URLWithString:urlStr];
}
@end
