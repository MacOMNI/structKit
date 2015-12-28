//
//  MACPhotosViewController.m
//  WeChat
//
//  Created by 苏贵明 on 15/9/4.
//  modify by MacKun
//

#import "MACPhotosViewController.h"


@interface MACPhotosViewController ()<UITableViewDataSource,UITableViewDelegate,MACGalleryViewControllerDelegate>

@end

@implementation MACPhotosViewController{
    
    float VIEW_WIDTH;
    float VIEW_HEIGHT;
    
    float imgWidth;//照片宽度
    float imgGap;//照片间隙宽度
    
    UITableView* mainTable;
    NSMutableArray* assetArray;
    NSMutableArray* selectedArray;
    
    long numOfPerRow;//每行几张照片
    long rowNum;//总共多少行
    
    //--- footerView上的控件
    UIButton* previewBt;
    UIButton* finishBt;
    UILabel* numLabel;
    
    MACGalleryViewController *localGallery;
    ArrayType arrayType;//0 assetArray, 1 selectedArray;
    
}
@synthesize group,block,limitNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    VIEW_WIDTH = self.view.frame.size.width;
    VIEW_HEIGHT = self.view.frame.size.height;
    
    imgWidth = 72;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(cancelBtTap)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:nil];
    
    NSString* name =[group valueForProperty:ALAssetsGroupPropertyName];
    if ([name  isEqual: @"Camera Roll"]) {
        name = @"相机胶卷";
    }
    self.title =name;
    
    assetArray = [[NSMutableArray alloc]init];
    selectedArray = [[NSMutableArray alloc]init];
    numOfPerRow = 4;//默认
    
    CGRect tableFrame = self.view.bounds;
    //tableFrame.size.height -= 45;
    mainTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    mainTable.dataSource = self;
    mainTable.delegate = self;
    mainTable.tableFooterView = [[UIView alloc] init];
    mainTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainTable];
    
    [self initFooterView];
    
    //---获取group中的asset
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            NSMutableDictionary* tmpDic = [[NSMutableDictionary alloc]init];
            [tmpDic setObject:result forKey:@"asset"];
            [tmpDic setObject:[NSString stringWithFormat:@"%d",(int)index] forKey:@"assetIndex"];
            [tmpDic setObject:@NO forKey:@"select"];
            [assetArray addObject:tmpDic];
        }else{
            [self calculateNum];
            [mainTable reloadData];
        }
    }];
}
-(void)calculateNum{
    
    //numOfPerRow = VIEW_WIDTH/imgWidth;
   // imgGap = (VIEW_WIDTH-numOfPerRow*imgWidth)/(numOfPerRow+1);
    imgGap=5;
    rowNum = (assetArray.count+(numOfPerRow-1))/numOfPerRow;
    imgWidth = (VIEW_WIDTH-imgGap*(numOfPerRow+1))/numOfPerRow;

//    if (imgGap>5) {
//        imgGap = 5;
//        imgWidth = (VIEW_WIDTH-imgGap*(numOfPerRow+1))/numOfPerRow;
//    }
}

-(void)initFooterView{
    
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT-45, VIEW_WIDTH, 45)];
    backView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:backView];
    
    UILabel* grayLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 1)];
    grayLine.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.3];
    [backView addSubview:grayLine];
    
    previewBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
    [previewBt setTitle:@"预览" forState:UIControlStateNormal];
    previewBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [previewBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
    [previewBt addTarget:self action:@selector(previewBtTaped) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:previewBt];
    
    finishBt = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH-60, 0, 60, 45)];
    [finishBt setTitle:@"完成" forState:UIControlStateNormal];
    finishBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [finishBt addTarget:self action:@selector(finishBtTaped) forControlEvents:UIControlEventTouchUpInside];
    [finishBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
    [backView addSubview:finishBt];
    
    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH-70, 13, 20, 20)];
    numLabel.textAlignment = NSTextAlignmentCenter;
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:12];
    numLabel.backgroundColor = [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1];
    numLabel.layer.cornerRadius = 10;
    numLabel.layer.masksToBounds = YES;
    [backView addSubview:numLabel];
    numLabel.hidden = YES;
}
-(void)previewBtTaped{
    if (selectedArray.count>0) {
        arrayType = SelectedArrayType;
        
        localGallery = [[MACGalleryViewController alloc] initWithPhotoSource:self];
        localGallery.isAssetDic = YES;
        localGallery.isPreview = YES;
        localGallery.block = block;
        localGallery.limitNum = limitNum;
        localGallery.assetArray = assetArray;
        localGallery.selectedArray = selectedArray;
        [self.navigationController pushViewController:localGallery animated:YES];
    }
}

-(void)finishBtTaped{
    if (selectedArray.count>0) {
        block(selectedArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)refreshFooterView{
    if (selectedArray.count>0) {
        [previewBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [finishBt setTitleColor:[UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",(int)selectedArray.count];
        
    }else{
        [previewBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
        [finishBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
        numLabel.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshFooterView];
    [mainTable reloadData];
}

-(void)cancelBtTap{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return rowNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return imgWidth+imgGap;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }else{
        while (cell.contentView.subviews.lastObject) {
            [cell.contentView.subviews.lastObject removeFromSuperview];
        }
    }
    tableView.separatorColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    for (int i=0; i<numOfPerRow; i++) {
        long assetIndex = indexPath.row*numOfPerRow+i;
        
        if (assetIndex < assetArray.count) {
            ALAsset *asset = [[assetArray objectAtIndex:assetIndex] objectForKey:@"asset"];
            BOOL isSelected = [[[assetArray objectAtIndex:assetIndex] objectForKey:@"select"] boolValue];
            
            UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake(imgGap+(imgWidth+imgGap)*i, imgGap, imgWidth, imgWidth)];
            [imgView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
            imgView.tag = assetIndex;
            imgView.userInteractionEnabled = YES;
            [cell.contentView addSubview:imgView];
            
            UIButton* checkBt = [[UIButton alloc]initWithFrame:CGRectMake(imgWidth-25, 2, 23, 23)];
            [checkBt setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:UIControlStateNormal];
            [checkBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
            [checkBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
            checkBt.tag = assetIndex;
            [checkBt addTarget:self action:@selector(selectBtTaped:) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:checkBt];
            if (isSelected) {
                checkBt.selected = YES;
            }
            
            UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgViewTaped:)];
            [imgView addGestureRecognizer:tapGes];
            
        }
    }
    
    return cell;
}

-(void)imgViewTaped:(UITapGestureRecognizer*)gest{
    
    UIImageView* imgV = (UIImageView*)[gest view];
    
    arrayType = AssetArrayType;
    
    localGallery = [[MACGalleryViewController alloc] initWithPhotoSource:self];
    localGallery.isAssetDic = YES;
    localGallery.isPreview = NO;
    localGallery.block = block;
    localGallery.limitNum = limitNum;
    localGallery.assetArray = assetArray;
    localGallery.selectedArray = selectedArray;
    localGallery.startingIndex = imgV.tag;
    [self.navigationController pushViewController:localGallery animated:YES];
    
}

-(void)selectBtTaped:(UIButton*)bt{
    if (bt.selected) {
        bt.selected = NO;
        //取消选中
        NSArray * tmpArray = [NSArray arrayWithArray: selectedArray];
        for (NSMutableDictionary* dic in tmpArray) {
            int assetIndex = [[dic objectForKey:@"assetIndex"] intValue];
            if (assetIndex == (int)bt.tag) {
                [dic setObject:@NO forKey:@"select"];
                [selectedArray removeObject:dic];
            }
        }
        
    }else{
        if (limitNum>0) {
            if (selectedArray.count>=limitNum) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多只能选择%d张照片",limitNum] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        
        bt.selected = YES;
        //选中图片
        NSMutableDictionary* tmpDic = [assetArray objectAtIndex:(int)bt.tag];
        [tmpDic setObject:@YES forKey:@"select"];
        [selectedArray addObject:tmpDic];
    }
    [self refreshFooterView];
    
}


//-(void)dealloc{
//    [assetArray removeAllObjects];
//    assetArray = nil;
//    group = nil;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FGallery methods
- (int)numberOfPhotosForPhotoGallery:(MACGalleryViewController *)gallery
{
    int num;
    if( arrayType == AssetArrayType ) {
        num = (int)[assetArray count];
    }else{
        num = (int)[selectedArray count];
    }
    return num;
}

- (MACGalleryPhotoSourceType)photoGallery:(MACGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return MACGalleryPhotoSourceTypeLocal;
}

-(NSDictionary*)photoGallery:(MACGalleryViewController *)gallery assetDictionaryAtIndex:(NSUInteger)index{
    NSDictionary* dic;
    if (arrayType == AssetArrayType) {
        dic = [assetArray objectAtIndex:index];
    }else{
        dic = [selectedArray objectAtIndex:index];
    }
    return dic;
}


@end

