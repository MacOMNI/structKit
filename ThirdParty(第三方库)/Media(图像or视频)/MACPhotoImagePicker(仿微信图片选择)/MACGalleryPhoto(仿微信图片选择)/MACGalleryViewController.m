//
//  MACGalleryViewController.m
//  WeiSchoolTeacher
//
//  Created by MacKun on 15/12/23.
//  Copyright © 2015年 MacKun. All rights reserved.
//

#import "MACGalleryViewController.h"
#import "UIView+MAC.h"
#define kThumbnailSize 75
#define kThumbnailSpacing 4
#define kCaptionPadding 3
#define kToolbarHeight 40


@interface MACGalleryViewController (Private)

// general
- (void)buildViews;
- (void)destroyViews;
- (void)layoutViews;
- (void)moveScrollerToCurrentIndexWithAnimation:(BOOL)animation;
- (void)updateTitle;
- (void)layoutButtons;
- (void)updateScrollSize;
- (void)updateCaption;
- (void)resizeImageViewsWithRect:(CGRect)rect;
- (void)resetImageViewZoomLevels;

- (void)enterFullscreen;
- (void)exitFullscreen;
- (void)enableApp;
- (void)disableApp;

- (void)positionInnerContainer;
- (void)positionScroller;
- (void)positionToolbar;
- (void)resizeThumbView;

// thumbnails
- (void)toggleThumbnailViewWithAnimation:(BOOL)animation;
- (void)showThumbnailViewWithAnimation:(BOOL)animation;
- (void)hideThumbnailViewWithAnimation:(BOOL)animation;
- (void)buildThumbsViewPhotos;

- (void)arrangeThumbs;
- (void)loadAllThumbViewPhotos;

- (void)preloadThumbnailImages;
- (void)unloadFullsizeImageWithIndex:(NSUInteger)index;

- (void)scrollingHasEnded;

- (void)handleSeeAllTouch:(id)sender;
- (void)handleThumbClick:(id)sender;

- (MACGalleryPhoto*)createGalleryPhotoForIndex:(NSUInteger)index;

- (void)loadThumbnailImageWithIndex:(NSUInteger)index;
- (void)loadFullsizeImageWithIndex:(NSUInteger)index;

@end



@implementation MACGalleryViewController{
    
    //sgm
    UILabel* numLabel;
    UIButton* finishBt;
    UIButton* checkBt;
    NSMutableDictionary* currentDic;
    
}
@synthesize assetArray,selectedArray,isPreview,block,limitNum;

@synthesize galleryID;
@synthesize photoSource = _photoSource;
@synthesize currentIndex = _currentIndex;
@synthesize thumbsView = _thumbsView;
@synthesize toolBar = _toolbar;
@synthesize useThumbnailView = _useThumbnailView;
@synthesize startingIndex = _startingIndex;
@synthesize beginsInThumbnailView = _beginsInThumbnailView;
@synthesize hideTitle = _hideTitle;
@synthesize isAssetDic;

#pragma mark - Public Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if((self = [super initWithNibName:nil bundle:nil])) {
        
        // init gallery id with our memory address
        self.galleryID						= [NSString stringWithFormat:@"%p", self];
        
        // configure view controller
        self.hidesBottomBarWhenPushed		= YES;
        
        // set defaults
        _useThumbnailView                   = YES;
        _prevStatusStyle					= [[UIApplication sharedApplication] statusBarStyle];
        _hideTitle                          = NO;
        
        // create storage objects
        _currentIndex						= 0;
        _startingIndex                      = 0;
        _photoLoaders						= [[NSMutableDictionary alloc] init];
        _photoViews							= [[NSMutableArray alloc] init];
        _photoThumbnailViews				= [[NSMutableArray alloc] init];
        _barItems							= [[NSMutableArray alloc] init];
        
        /*
         // debugging:
         _container.layer.borderColor = [[UIColor yellowColor] CGColor];
         _container.layer.borderWidth = 1.0;
         
         _innerContainer.layer.borderColor = [[UIColor greenColor] CGColor];
         _innerContainer.layer.borderWidth = 1.0;
         
         _scroller.layer.borderColor = [[UIColor redColor] CGColor];
         _scroller.layer.borderWidth = 2.0;
         */
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) {
        self.galleryID						= [NSString stringWithFormat:@"%p", self];
        
        // configure view controller
        self.hidesBottomBarWhenPushed		= YES;
        
        // set defaults
        _useThumbnailView                   = YES;
        _prevStatusStyle					= [[UIApplication sharedApplication] statusBarStyle];
        _hideTitle                          = NO;
        
        // create storage objects
        _currentIndex						= 0;
        _startingIndex                      = 0;
        _photoLoaders						= [[NSMutableDictionary alloc] init];
        _photoViews							= [[NSMutableArray alloc] init];
        _photoThumbnailViews				= [[NSMutableArray alloc] init];
        _barItems							= [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithPhotoSource:(NSObject<MACGalleryViewControllerDelegate>*)photoSrc
{
    if((self = [self initWithNibName:nil bundle:nil])) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        _photoSource = photoSrc;
    }
    return self;
}


- (id)initWithPhotoSource:(NSObject<MACGalleryViewControllerDelegate>*)photoSrc barItems:(NSArray*)items
{
    if((self = [self initWithPhotoSource:photoSrc])) {
        
        [_barItems addObjectsFromArray:items];
    }
    return self;
}


- (void)loadView
{
    // create public objects first so they're available for custom configuration right away. positioning comes later.
    _container							= [[UIView alloc] initWithFrame:CGRectZero];
    _innerContainer						= [[UIView alloc] initWithFrame:CGRectZero];
    _scroller							= [[UIScrollView alloc] initWithFrame:CGRectZero];
    _thumbsView							= [[UIScrollView alloc] initWithFrame:CGRectZero];
   // _toolbar							= [[UIToolbar alloc] initWithFrame:CGRectZero];
    _captionContainer					= [[UIView alloc] initWithFrame:CGRectZero];
    _caption							= [[UILabel alloc] initWithFrame:CGRectZero];
    
   // _toolbar.barStyle					= UIBarStyleBlackTranslucent;
    _container.backgroundColor			= [UIColor blackColor];
    
    // listen for container frame changes so we can properly update the layout during auto-rotation or going in and out of fullscreen
    [_container addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    
    // setup scroller
    _scroller.delegate							= self;
    _scroller.pagingEnabled						= YES;
    _scroller.showsVerticalScrollIndicator		= NO;
    _scroller.showsHorizontalScrollIndicator	= NO;
    
    // setup caption
    _captionContainer.backgroundColor			= [UIColor colorWithWhite:0.0 alpha:.35];
    _captionContainer.hidden					= YES;
    _captionContainer.userInteractionEnabled	= NO;
    _captionContainer.exclusiveTouch			= YES;
    _caption.font								= [UIFont systemFontOfSize:14.0];
    _caption.textColor							= [UIColor whiteColor];
    _caption.backgroundColor					= [UIColor clearColor];
    _caption.textAlignment						= NSTextAlignmentCenter;
    _caption.shadowColor						= [UIColor blackColor];
    _caption.shadowOffset						= CGSizeMake( 1, 1 );
    
    // make things flexible
    _container.autoresizesSubviews				= NO;
    _innerContainer.autoresizesSubviews			= NO;
    _scroller.autoresizesSubviews				= NO;
    _container.autoresizingMask					= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // setup thumbs view
    _thumbsView.backgroundColor					= [UIColor whiteColor];
    _thumbsView.hidden							= YES;
    _thumbsView.contentInset					= UIEdgeInsetsMake( kThumbnailSpacing, kThumbnailSpacing, kThumbnailSpacing, kThumbnailSpacing);
    
    // set view
    self.view                                   = _container;
    
    // add items to their containers
    [_container addSubview:_innerContainer];
    [_container addSubview:_thumbsView];
    
    [_innerContainer addSubview:_scroller];
   // [_innerContainer addSubview:_toolbar];
    
    //	[_toolbar addSubview:_captionContainer];
    //	[_captionContainer addSubview:_caption];
    
    // build stuff
    [self reloadGallery];
}

- (void)viewDidUnload {
    
    [self destroyViews];
    
    _barItems = nil;
    _container = nil;
    _innerContainer = nil;
    _scroller = nil;
    _thumbsView = nil;
    _toolbar = nil;
    _captionContainer = nil;
    _caption = nil;
  
    [super viewDidUnload];
}


- (void)destroyViews {
    // remove previous photo views
    for (UIView *view in _photoViews) {
        [view removeFromSuperview];
    }
    [_photoViews removeAllObjects];
    
    // remove previous thumbnails
    for (UIView *view in _photoThumbnailViews) {
        [view removeFromSuperview];
    }
    [_photoThumbnailViews removeAllObjects];
    
    // remove photo loaders
    NSArray *photoKeys = [_photoLoaders allKeys];
    for (int i=0; i<[photoKeys count]; i++) {
        MACGalleryPhoto *photoLoader = [_photoLoaders objectForKey:[photoKeys objectAtIndex:i]];
        photoLoader.delegate = nil;
        [photoLoader unloadFullsize];
        [photoLoader unloadThumbnail];
    }
    [_photoLoaders removeAllObjects];
}


- (void)reloadGallery
{
    _currentIndex = _startingIndex;
    _isThumbViewShowing = NO;
    
    // remove the old
    [self destroyViews];
    
    // build the new
    if ([_photoSource numberOfPhotosForPhotoGallery:self] > 0) {
        // create the image views for each photo
        [self buildViews];
        
        // create the thumbnail views
        [self buildThumbsViewPhotos];
        
        // start loading thumbs
        [self preloadThumbnailImages];
        
        // start on first image
        [self gotoImageByIndex:_currentIndex animated:NO];
        
        // layout
        [self layoutViews];
    }
}

- (MACGalleryPhoto*)currentPhoto
{
    return [_photoLoaders objectForKey:[NSString stringWithFormat:@"%li", (long)_currentIndex]];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _isActive = YES;
    
    self.useThumbnailView = _useThumbnailView;
    
    // toggle into the thumb view if we should start there
    if (_beginsInThumbnailView && _useThumbnailView) {
        [self showThumbnailViewWithAnimation:NO];
        [self loadAllThumbViewPhotos];
    }
    
    [self layoutViews];
    
    // update status bar to be see-through
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    // init with next on first run.
    if( _currentIndex == -1 ) [self next];
    else [self gotoImageByIndex:_currentIndex animated:NO];
    
    [self initCustomView];
    [self refreshFooterView];
    [self refreshCheckBt];
}

-(void)initCustomView{
    // create buttons for toolbar
   // float VIEW_WIDTH = self.view.frame.size.width;
    
//    finishBt = [[UIButton alloc]initWithFrame:CGRectMake(VIEW_WIDTH-60, 0, 60, 40)];
//    [finishBt setTitle:@"完成" forState:UIControlStateNormal];
//    finishBt.titleLabel.font = [UIFont systemFontOfSize:15];
//    [finishBt addTarget:self action:@selector(finishBtTaped) forControlEvents:UIControlEventTouchUpInside];
//    [finishBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
//    [_toolbar addSubview:finishBt];
//    
//    numLabel = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_WIDTH-70, 10, 20, 20)];
//    numLabel.textAlignment = NSTextAlignmentCenter;
//    numLabel.textColor = [UIColor whiteColor];
//    numLabel.font = [UIFont systemFontOfSize:12];
//    numLabel.backgroundColor = [UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1];
//    numLabel.layer.cornerRadius = 10;
//    numLabel.layer.masksToBounds = YES;
//    [_toolbar addSubview:numLabel];
//    numLabel.hidden = YES;
    
    
    checkBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [checkBt setBackgroundImage:[UIImage imageNamed:@"notSelected"] forState:UIControlStateNormal];
    [checkBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    [checkBt setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateHighlighted];
    [checkBt addTarget:self action:@selector(selectBtTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithCustomView:checkBt]];
    
    
}

-(void)finishBtTaped{
    if (!numLabel.isHidden) {
        if (isPreview) {
            NSArray* tmpAry = [NSArray arrayWithArray:selectedArray];
            for (NSDictionary* dic in tmpAry) {
                BOOL isSelected = [[dic objectForKey:@"select"] boolValue];
                if (!isSelected) {
                    [selectedArray removeObject:dic];
                }
            }
        }
        block(selectedArray);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)selectBtTaped:(UIButton*)bt{
    if (bt.selected) {
        bt.selected = NO;
        //取消选中
        if (isPreview) {
            [currentDic setObject:@NO forKey:@"select"];
            [self refreshAssetArray:NO];
            
        }else{
            [currentDic setObject:@NO forKey:@"select"];
            [selectedArray removeObject:currentDic];
        }
        
    }else{
        if (limitNum>0) {
            int num = 0;
            NSArray* tmpAry = [NSArray arrayWithArray:selectedArray];
            for (NSDictionary* dic in tmpAry) {
                BOOL isSelected = [[dic objectForKey:@"select"] boolValue];
                if (isSelected) {
                    num++;
                }
            }
            if (num>=limitNum) {
                UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"最多只能选择%d张照片",limitNum] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
        }
        
        bt.selected = YES;
        //选中图片
        if (isPreview) {
            [currentDic setObject:@YES forKey:@"select"];
            [self refreshAssetArray:YES];
            
        }else{
            [currentDic setObject:@YES forKey:@"select"];
            [selectedArray addObject:currentDic];
        }
    }
    [self refreshFooterView];

}

-(void)refreshAssetArray:(BOOL) bl{
    int currentAssetIndex = [[currentDic objectForKey:@"assetIndex"] intValue];
    
    NSArray* tmpAry = [NSArray arrayWithArray:assetArray];
    for (NSDictionary* dic in tmpAry) {
        int index = [[dic objectForKey:@"assetIndex"] intValue];
        if (index == currentAssetIndex) {
            if (bl) {
                [dic setValue:@YES forKey:@"select"];
            }else{
                [dic setValue:@NO forKey:@"select"];
            }
        }
        
    }
}

-(void)refreshFooterView{
    int num = 0;
    NSArray* tmpAry = [NSArray arrayWithArray:selectedArray];
    for (NSDictionary* dic in tmpAry) {
        BOOL isSelected = [[dic objectForKey:@"select"] boolValue];
        if (isSelected) {
            num++;
        }
    }
    
    if (num>0) {
        [finishBt setTitleColor:[UIColor colorWithRed:143/255.0 green:195/255.0 blue:31/255.0 alpha:1] forState:UIControlStateNormal];
        numLabel.hidden = NO;
        numLabel.text = [NSString stringWithFormat:@"%d",num];
        
    }else{
        [finishBt setTitleColor:[UIColor colorWithWhite:0.5 alpha:0.3] forState:UIControlStateNormal];
        numLabel.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _isActive = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:_prevStatusStyle animated:animated];
    
    if (isPreview) {
        NSArray* tmpAry = [NSArray arrayWithArray:selectedArray];
        for (NSDictionary* dic in tmpAry) {
            BOOL isSelected = [[dic objectForKey:@"select"] boolValue];
            if (!isSelected) {
                [selectedArray removeObject:dic];
            }
        }
    }
    
}


- (void)resizeImageViewsWithRect:(CGRect)rect
{
    // resize all the image views
    NSUInteger i, count = [_photoViews count];
    float dx = 0;
    for (i = 0; i < count; i++) {
        MACGalleryPhotoView * photoView = [_photoViews objectAtIndex:i];
        photoView.frame = CGRectMake(dx, 0, rect.size.width, rect.size.height );
        dx += rect.size.width;
    }
}


- (void)resetImageViewZoomLevels
{
    // resize all the image views
    NSUInteger i, count = [_photoViews count];
    for (i = 0; i < count; i++) {
        MACGalleryPhotoView * photoView = [_photoViews objectAtIndex:i];
        [photoView resetZoom];
    }
}


- (void)removeImageAtIndex:(NSUInteger)index
{
    // remove the image and thumbnail at the specified index.
    MACGalleryPhotoView *imgView = [_photoViews objectAtIndex:index];
    MACGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:index];
    MACGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    
    [photo unloadFullsize];
    [photo unloadThumbnail];
    
    [imgView removeFromSuperview];
    [thumbView removeFromSuperview];
    
    [_photoViews removeObjectAtIndex:index];
    [_photoThumbnailViews removeObjectAtIndex:index];
    [_photoLoaders removeObjectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)index]];
    
    [self layoutViews];
    [self updateTitle];
}


- (void)next
{
    NSUInteger numberOfPhotos = [_photoSource numberOfPhotosForPhotoGallery:self];
    NSUInteger nextIndex = _currentIndex+1;
    
    // don't continue if we're out of images.
    if( nextIndex <= numberOfPhotos )
    {
        [self gotoImageByIndex:nextIndex animated:NO];
    }
}



- (void)previous
{
    NSUInteger prevIndex = _currentIndex-1;
    [self gotoImageByIndex:prevIndex animated:NO];
}



- (void)gotoImageByIndex:(NSUInteger)index animated:(BOOL)animated
{
    NSUInteger numPhotos = [_photoSource numberOfPhotosForPhotoGallery:self];
    
    // constrain index within our limits
    if( index >= numPhotos ) index = numPhotos - 1;
    
    
    if( numPhotos == 0 ) {
        
        // no photos!
        _currentIndex = -1;
    }
    else {
        
        // clear the fullsize image in the old photo
        [self unloadFullsizeImageWithIndex:_currentIndex];
        
        _currentIndex = index;
        [self moveScrollerToCurrentIndexWithAnimation:animated];
        [self updateTitle];
        
        if( !animated )	{
            [self preloadThumbnailImages];
            [self loadFullsizeImageWithIndex:index];
        }
    }
    [self updateCaption];
}


- (void)layoutViews
{
    [self positionInnerContainer];
    [self positionScroller];
    [self resizeThumbView];
    [self positionToolbar];
    [self updateScrollSize];
    [self updateCaption];
    [self resizeImageViewsWithRect:_scroller.frame];
    [self layoutButtons];
    [self arrangeThumbs];
    [self moveScrollerToCurrentIndexWithAnimation:NO];
}


- (void)setUseThumbnailView:(BOOL)useThumbnailView
{
    _useThumbnailView = useThumbnailView;
    
    //    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil];
    //    [[self navigationItem] setBackBarButtonItem: newBackButton];
    //    [newBackButton release];
    //
    //    _useThumbnailView = useThumbnailView;
    //    if( self.navigationController ) {
    //        if (_useThumbnailView) {
    //            UIBarButtonItem *btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"See all", @"") style:UIBarButtonItemStylePlain target:self action:@selector(handleSeeAllTouch:)] autorelease];
    //            [self.navigationItem setRightBarButtonItem:btn animated:YES];
    //        }
    //        else {
    //            [self.navigationItem setRightBarButtonItem:nil animated:NO];
    //        }
    //    }
}


#pragma mark - Private Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"])
    {
        [self layoutViews];
    }
}


- (void)positionInnerContainer
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect innerContainerRect;
    
    if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {//portrait
        innerContainerRect = CGRectMake( 0, _container.frame.size.height - screenFrame.size.height, _container.frame.size.width, screenFrame.size.height );
    }
    else
    {// landscape
        innerContainerRect = CGRectMake( 0, _container.frame.size.height - screenFrame.size.width, _container.frame.size.width, screenFrame.size.width );
    }
    
    _innerContainer.frame = innerContainerRect;
}


- (void)positionScroller
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGRect scrollerRect;
    
    if( self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown )
    {//portrait
        scrollerRect = CGRectMake( 0, 0, screenFrame.size.width, screenFrame.size.height );
    }
    else
    {//landscape
        scrollerRect = CGRectMake( 0, 0, screenFrame.size.height, screenFrame.size.width );
    }
    
    _scroller.frame = scrollerRect;
}


- (void)positionToolbar
{
    _toolbar.frame = CGRectMake( 0, _scroller.frame.size.height-kToolbarHeight, _scroller.frame.size.width, kToolbarHeight );
}


- (void)resizeThumbView
{
    int barHeight = 0;
    if (self.navigationController.navigationBar.barStyle == UIBarStyleBlackTranslucent) {
        barHeight = self.navigationController.navigationBar.frame.size.height;
    }
    _thumbsView.frame = CGRectMake( 0, barHeight, _container.frame.size.width, _container.frame.size.height-barHeight );
}


- (void)enterFullscreen
{
    if (!_isThumbViewShowing)
    {
        _isFullscreen = YES;
        
        [self disableApp];
        
        UIApplication* application = [UIApplication sharedApplication];
        if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
            [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
        } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            [[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
            #pragma GCC diagnostic warning "-Wdeprecated-declarations"
        }
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView beginAnimations:@"galleryOut" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(enableApp)];
        _toolbar.alpha = 0.0;
        _captionContainer.alpha = 0.0;
        [UIView commitAnimations];
    }
}



- (void)exitFullscreen
{
    _isFullscreen = NO;
    
    [self disableApp];
    
    UIApplication* application = [UIApplication sharedApplication];
    if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
        #pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [UIView beginAnimations:@"galleryIn" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(enableApp)];
    _toolbar.alpha = 1.0;
    _captionContainer.alpha = 1.0;
    [UIView commitAnimations];
}



- (void)enableApp
{
    [self.view setFrameOriginY:0];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}


- (void)didTapPhotoView:(MACGalleryPhotoView*)photoView
{
    // don't change when scrolling
    if( _isScrolling || !_isActive ) return;
    
    // toggle fullscreen.
    if( _isFullscreen == NO ) {
        
        [self enterFullscreen];
    }
    else {
        
        [self exitFullscreen];
    }
    
}


- (void)updateCaption
{
    if([_photoSource numberOfPhotosForPhotoGallery:self] > 0 )
    {
        if([_photoSource respondsToSelector:@selector(photoGallery:captionForPhotoAtIndex:)])
        {
            NSString *caption = [_photoSource photoGallery:self captionForPhotoAtIndex:_currentIndex];
            
            if([caption length] > 0 )
            {
                float captionWidth = _container.frame.size.width-kCaptionPadding*2;
                //CGSize textSize = [caption sizeWithFont:_caption.font];
               CGSize textSize= [caption sizeWithAttributes:@{@"NSFontAttributeName":_caption.font}];
                NSUInteger numLines = ceilf( textSize.width / captionWidth );
                NSInteger height = ( textSize.height + kCaptionPadding ) * numLines;
                
                _caption.numberOfLines = numLines;
                _caption.text = caption;
                
                NSInteger containerHeight = height+kCaptionPadding*2;
                _captionContainer.frame = CGRectMake(0, -containerHeight, _container.frame.size.width, containerHeight );
                _caption.frame = CGRectMake(kCaptionPadding, kCaptionPadding, captionWidth, height );
                
                // show caption bar
                _captionContainer.hidden = NO;
            }
            else {
                
                // hide it if we don't have a caption.
                _captionContainer.hidden = YES;
            }
        }
    }
}


- (void)updateScrollSize
{
    float contentWidth = _scroller.frame.size.width * [_photoSource numberOfPhotosForPhotoGallery:self];
    [_scroller setContentSize:CGSizeMake(contentWidth, _scroller.frame.size.height)];
}


- (void)updateTitle
{
    if (!_hideTitle){
        [self setTitle:[NSString stringWithFormat:@"%li %@ %i", _currentIndex+1, NSLocalizedString(@"/", @"") , [_photoSource numberOfPhotosForPhotoGallery:self]]];
    }else{
        [self setTitle:@""];
    }
    [self refreshCheckBt];
}

-(void)refreshCheckBt{
    if (isPreview) {
        currentDic = [selectedArray objectAtIndex:_currentIndex];
    }else{
        currentDic = [assetArray objectAtIndex:_currentIndex];
    }
    BOOL isSelected = [[currentDic objectForKey:@"select"] boolValue];
    if (isSelected) {
        checkBt.selected = YES;
    }else{
        checkBt.selected = NO;
    }
}

- (void)layoutButtons
{
    NSUInteger buttonWidth = roundf( _toolbar.frame.size.width / [_barItems count] - _prevNextButtonSize * .5);
    
    // loop through all the button items and give them the same width
    NSUInteger i, count = [_barItems count];
    for (i = 0; i < count; i++) {
        UIBarButtonItem *btn = [_barItems objectAtIndex:i];
        btn.width = buttonWidth;
    }
    [_toolbar setNeedsLayout];
}


- (void)moveScrollerToCurrentIndexWithAnimation:(BOOL)animation
{
    int xp = _scroller.frame.size.width * _currentIndex;
    [_scroller scrollRectToVisible:CGRectMake(xp, 0, _scroller.frame.size.width, _scroller.frame.size.height) animated:animation];
    _isScrolling = animation;
}


// creates all the image views for this gallery
- (void)buildViews
{
    NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
    for (i = 0; i < count; i++) {
        MACGalleryPhotoView *photoView = [[MACGalleryPhotoView alloc] initWithFrame:CGRectZero];
        photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        photoView.autoresizesSubviews = YES;
        photoView.photoDelegate = self;
        [_scroller addSubview:photoView];
        [_photoViews addObject:photoView];
    }
}


- (void)buildThumbsViewPhotos
{
    NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
    for (i = 0; i < count; i++) {
        
        MACGalleryPhotoView *thumbView = [[MACGalleryPhotoView alloc] initWithFrame:CGRectZero target:self action:@selector(handleThumbClick:)];
        [thumbView setContentMode:UIViewContentModeScaleAspectFill];
        [thumbView setClipsToBounds:YES];
        [thumbView setTag:i];
        [_thumbsView addSubview:thumbView];
        [_photoThumbnailViews addObject:thumbView];
    }
}



- (void)arrangeThumbs
{
    float dx = 0.0;
    float dy = 0.0;
    // loop through all thumbs to size and place them
    NSUInteger i, count = [_photoThumbnailViews count];
    for (i = 0; i < count; i++) {
        MACGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:i];
        [thumbView setBackgroundColor:[UIColor grayColor]];
        
        // create new frame
        thumbView.frame = CGRectMake( dx, dy, kThumbnailSize, kThumbnailSize);
        
        // increment position
        dx += kThumbnailSize + kThumbnailSpacing;
        
        // check if we need to move to a different row
        if( dx + kThumbnailSize + kThumbnailSpacing > _thumbsView.frame.size.width - kThumbnailSpacing )
        {
            dx = 0.0;
            dy += kThumbnailSize + kThumbnailSpacing;
        }
    }
    
    // set the content size of the thumb scroller
    [_thumbsView setContentSize:CGSizeMake( _thumbsView.frame.size.width - ( kThumbnailSpacing*2 ), dy + kThumbnailSize + kThumbnailSpacing )];
}


- (void)toggleThumbnailViewWithAnimation:(BOOL)animation
{
    if (_isThumbViewShowing) {
        [self hideThumbnailViewWithAnimation:animation];
    }
    else {
        [self showThumbnailViewWithAnimation:animation];
    }
}


- (void)showThumbnailViewWithAnimation:(BOOL)animation
{
    _isThumbViewShowing = YES;
    
    [self arrangeThumbs];
    //    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"Close", @"")];
    
    if (animation) {
        // do curl animation
        [UIView beginAnimations:@"uncurl" context:nil];
        [UIView setAnimationDuration:.666];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:_thumbsView cache:YES];
        [_thumbsView setHidden:NO];
        [UIView commitAnimations];
    }
    else {
        [_thumbsView setHidden:NO];
    }
}


- (void)hideThumbnailViewWithAnimation:(BOOL)animation
{
    _isThumbViewShowing = NO;
    //    [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedString(@"See all", @"")];
    
    if (animation) {
        // do curl animation
        [UIView beginAnimations:@"curl" context:nil];
        [UIView setAnimationDuration:.666];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:_thumbsView cache:YES];
        [_thumbsView setHidden:YES];
        [UIView commitAnimations];
    }
    else {
        [_thumbsView setHidden:NO];
    }
}


- (void)handleSeeAllTouch:(id)sender
{
    // show thumb view
    [self toggleThumbnailViewWithAnimation:YES];
    
    // tell thumbs that havent loaded to load
    [self loadAllThumbViewPhotos];
}


- (void)handleThumbClick:(id)sender
{
    MACGalleryPhotoView *photoView = (MACGalleryPhotoView*)[(UIButton*)sender superview];
    [self hideThumbnailViewWithAnimation:YES];
    [self gotoImageByIndex:photoView.tag animated:NO];
}


#pragma mark - Image Loading


- (void)preloadThumbnailImages
{
    NSUInteger index = _currentIndex;
    NSUInteger count = [_photoViews count];
    
    // make sure the images surrounding the current index have thumbs loading
    NSUInteger nextIndex = index + 1;
    NSUInteger prevIndex = index - 1;
    
    // the preload count indicates how many images surrounding the current photo will get preloaded.
    // a value of 2 at maximum would preload 4 images, 2 in front of and two behind the current image.
    NSUInteger preloadCount = 1;
    
    MACGalleryPhoto *photo;
    
    // check to see if the current image thumb has been loaded
    photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    
    if( !photo )
    {
        [self loadThumbnailImageWithIndex:index];
        photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    }
    
    if( !photo.hasThumbLoaded && !photo.isThumbLoading )
    {
        [photo loadThumbnail];
    }
    
    NSUInteger curIndex = prevIndex;
    while( curIndex > -1 && curIndex > prevIndex - preloadCount )
    {
        photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)curIndex]];
        
        if( !photo ) {
            [self loadThumbnailImageWithIndex:curIndex];
            photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)curIndex]];
        }
        
        if( !photo.hasThumbLoaded && !photo.isThumbLoading )
        {
            [photo loadThumbnail];
        }
        
        curIndex--;
    }
    
    curIndex = nextIndex;
    while( curIndex < count && curIndex < nextIndex + preloadCount )
    {
        photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)curIndex]];
        
        if( !photo ) {
            [self loadThumbnailImageWithIndex:curIndex];
            photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)curIndex]];
        }
        
        if( !photo.hasThumbLoaded && !photo.isThumbLoading )
        {
            [photo loadThumbnail];
        }
        
        curIndex++;
    }
}


- (void)loadAllThumbViewPhotos
{
    NSUInteger i, count = [_photoSource numberOfPhotosForPhotoGallery:self];
    for (i=0; i < count; i++) {
        
        [self loadThumbnailImageWithIndex:i];
    }
}


- (void)loadThumbnailImageWithIndex:(NSUInteger)index
{
    MACGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    
    if( photo == nil )
        photo = [self createGalleryPhotoForIndex:index];
    
    [photo loadThumbnail];
}


- (void)loadFullsizeImageWithIndex:(NSUInteger)index
{
    MACGalleryPhoto *photo = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
    
    if( photo == nil )
        photo = [self createGalleryPhotoForIndex:index];
    
    [photo loadFullsize];
}


- (void)unloadFullsizeImageWithIndex:(NSUInteger)index
{
    if (index < [_photoViews count]) {
        MACGalleryPhoto *loader = [_photoLoaders objectForKey:[NSString stringWithFormat:@"%lu", (unsigned long)index]];
        [loader unloadFullsize];
        
        MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:index];
        photoView.imageView.image = loader.thumbnail;
    }
}


- (MACGalleryPhoto*)createGalleryPhotoForIndex:(NSUInteger)index
{
    MACGalleryPhotoSourceType sourceType = [_photoSource photoGallery:self sourceTypeForPhotoAtIndex:index];
    MACGalleryPhoto *photo;
    NSString *thumbPath;
    NSString *fullsizePath;
    NSDictionary* assetDic;
    
    
    if( sourceType == MACGalleryPhotoSourceTypeLocal )
    {
        if (isAssetDic) {
            assetDic = [_photoSource photoGallery:self assetDictionaryAtIndex:index];
            photo = [[MACGalleryPhoto alloc]initWithAssetDictionary:assetDic delegate:self];
        }else{
            thumbPath = [_photoSource photoGallery:self filePathForPhotoSize:MACGalleryPhotoSizeThumbnail atIndex:index];
            fullsizePath = [_photoSource photoGallery:self filePathForPhotoSize:MACGalleryPhotoSizeFullsize atIndex:index];
            photo = [[MACGalleryPhoto alloc] initWithThumbnailPath:thumbPath fullsizePath:fullsizePath delegate:self];
        }
    }
    else if( sourceType == MACGalleryPhotoSourceTypeNetwork )
    {
        thumbPath = [_photoSource photoGallery:self urlForPhotoSize:MACGalleryPhotoSizeThumbnail atIndex:index];
        fullsizePath = [_photoSource photoGallery:self urlForPhotoSize:MACGalleryPhotoSizeFullsize atIndex:index];
        photo = [[MACGalleryPhoto alloc] initWithThumbnailUrl:thumbPath fullsizeUrl:fullsizePath delegate:self];
    }
    else
    {
        // invalid source type, throw an error.
        [NSException raise:@"Invalid photo source type" format:@"The specified source type of %d is invalid", sourceType];
    }
    
    // assign the photo index
    photo.tag = index;
    
    // store it
    [_photoLoaders setObject:photo forKey: [NSString stringWithFormat:@"%lu", (unsigned long)index]];
    
    return photo;
}


- (void)scrollingHasEnded {
    
    _isScrolling = NO;
    
    NSUInteger newIndex = floor( _scroller.contentOffset.x / _scroller.frame.size.width );
    
    // don't proceed if the user has been scrolling, but didn't really go anywhere.
    if( newIndex == _currentIndex )
        return;
    
    // clear previous
    [self unloadFullsizeImageWithIndex:_currentIndex];
    
    _currentIndex = newIndex;
    [self updateCaption];
    [self updateTitle];
    [self loadFullsizeImageWithIndex:_currentIndex];
    [self preloadThumbnailImages];
}


#pragma mark - MACGalleryPhoto Delegate Methods


- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadThumbnailFromPath:(NSString*)path
{
    // show activity indicator for large photo view
    MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
    [photoView.activity startAnimating];
    
    // show activity indicator for thumbail
    if( _isThumbViewShowing ) {
        MACGalleryPhotoView *thumb = [_photoThumbnailViews objectAtIndex:photo.tag];
        [thumb.activity startAnimating];
    }
}


- (void)galleryPhoto:(MACGalleryPhoto*)photo willLoadThumbnailFromUrl:(NSString*)url
{
    // show activity indicator for large photo view
    MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
    [photoView.activity startAnimating];
    
    // show activity indicator for thumbail
    if( _isThumbViewShowing ) {
        MACGalleryPhotoView *thumb = [_photoThumbnailViews objectAtIndex:photo.tag];
        [thumb.activity startAnimating];
    }
}


- (void)galleryPhoto:(MACGalleryPhoto*)photo didLoadThumbnail:(UIImage*)image
{
    // grab the associated image view
    MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
    
    // if the gallery photo hasn't loaded the fullsize yet, set the thumbnail as its image.
    if( !photo.hasFullsizeLoaded )
        photoView.imageView.image = photo.thumbnail;
    
    [photoView.activity stopAnimating];
    
    // grab the thumbail view and set its image
    MACGalleryPhotoView *thumbView = [_photoThumbnailViews objectAtIndex:photo.tag];
    thumbView.imageView.image = image;
    [thumbView.activity stopAnimating];
}



- (void)galleryPhoto:(MACGalleryPhoto*)photo didLoadFullsize:(UIImage*)image
{
    // only set the fullsize image if we're currently on that image
    if( _currentIndex == photo.tag )
    {
        MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:photo.tag];
        photoView.imageView.image = photo.fullsize;
    }
    // otherwise, we don't need to keep this image around
    else [photo unloadFullsize];
}


#pragma mark - UIScrollView Methods


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _isScrolling = YES;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( !decelerate )
    {
        [self scrollingHasEnded];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingHasEnded];
}


#pragma mark - Memory Management Methods

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    
    // unload fullsize and thumbnail images for all our images except at the current index.
    NSArray *keys = [_photoLoaders allKeys];
    NSUInteger i, count = [keys count];
    if (_isThumbViewShowing==YES) {
        for (i = 0; i < count; i++)
        {
            MACGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
            [photo unloadFullsize];
            
            // unload main image thumb
            MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:i];
            photoView.imageView.image = nil;
        }
    } else {
        for (i = 0; i < count; i++)
        {
            if( i != _currentIndex )
            {
                MACGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
                [photo unloadFullsize];
                [photo unloadThumbnail];
                
                // unload main image thumb
                MACGalleryPhotoView *photoView = [_photoViews objectAtIndex:i];
                photoView.imageView.image = nil;
                
                // unload thumb tile
                photoView = [_photoThumbnailViews objectAtIndex:i];
                photoView.imageView.image = nil;
            }
        }
    }
}


- (void)dealloc {
    
    // remove KVO listener
    [_container removeObserver:self forKeyPath:@"frame"];
    
    // Cancel all photo loaders in progress
    NSArray *keys = [_photoLoaders allKeys];
    NSUInteger i, count = [keys count];
    for (i = 0; i < count; i++) {
        MACGalleryPhoto *photo = [_photoLoaders objectForKey:[keys objectAtIndex:i]];
        photo.delegate = nil;
        [photo unloadThumbnail];
        [photo unloadFullsize];
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    self.galleryID = nil;
    
    _photoSource = nil;
    
    _caption = nil;
    
    _captionContainer = nil;
    
    _container = nil;
    
    _innerContainer = nil;
    
    _toolbar = nil;
    
    _thumbsView = nil;
    
    _scroller = nil;
    
    [_photoLoaders removeAllObjects];
    _photoLoaders = nil;
    
    [_barItems removeAllObjects];
    _barItems = nil;
    
    [_photoThumbnailViews removeAllObjects];
    _photoThumbnailViews = nil;
    
    [_photoViews removeAllObjects];
    _photoViews = nil;
    
    numLabel = nil;
    
    checkBt = nil;
    
    finishBt = nil;
}


@end


/**
 *	This section overrides the auto-rotate methods for UINaviationController and UITabBarController
 *	to allow the tab bar to rotate only when a MACGalleryController is the visible controller. Sweet.
 */

@implementation UINavigationController (MACGallery)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if([self.visibleViewController isKindOfClass:[MACGalleryViewController class]])
    {
        return YES;
    }
    
    // To preserve the UINavigationController's defined behavior,
    // walk its stack.  If all of the view controllers in the stack
    // agree they can rotate to the given orientation, then allow it.
    BOOL supported = YES;
    for(UIViewController *sub in self.viewControllers)
    {
        if(![sub shouldAutorotateToInterfaceOrientation:interfaceOrientation])
        {
            supported = NO;
            break;
        }
    }
    if(supported)
        return YES;
    
    // we need to support at least one type of auto-rotation we'll get warnings.
    // so, we'll just support the basic portrait.
    return ( interfaceOrientation == UIInterfaceOrientationPortrait ) ? YES : NO;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // see if the current controller in the stack is a gallery
    if([self.visibleViewController isKindOfClass:[MACGalleryViewController class]])
    {
        MACGalleryViewController *galleryController = (MACGalleryViewController*)self.visibleViewController;
        [galleryController resetImageViewZoomLevels];
    }
}

@end




@implementation UITabBarController (MACGallery)


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // only return yes if we're looking at the gallery
    if( [self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController*)self.selectedViewController;
        
        // see if the current controller in the stack is a gallery
        if([navController.visibleViewController isKindOfClass:[MACGalleryViewController class]])
        {
            return YES;
        }
    }
    
    // we need to support at least one type of auto-rotation we'll get warnings.
    // so, we'll just support the basic portrait.
    return ( interfaceOrientation == UIInterfaceOrientationPortrait ) ? YES : NO;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if([self.selectedViewController isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController*)self.selectedViewController;
        
        // see if the current controller in the stack is a gallery
        if([navController.visibleViewController isKindOfClass:[MACGalleryViewController class]])
        {
            MACGalleryViewController *galleryController = (MACGalleryViewController*)navController.visibleViewController;
            [galleryController resetImageViewZoomLevels];
        }
    }
}



@end

