//
//  MacSwipeView.h
//
//  滑动翻页类似广告位翻动，需实现SwipeViewDataSource的内部方法
//  对于View来自于其他控制器的情况 可 添加到 self 的childVC中，然后再滑动显示
//  Created by MacKun on 15/11/4.
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wauto-import"
#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"


#import <Availability.h>
#undef weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif


#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SwipeViewAlignment)
{
    SwipeViewAlignmentEdge = 0,
    SwipeViewAlignmentCenter
};


@protocol SwipeViewDataSource, SwipeViewDelegate;

@interface MacSwipeView : UIView

@property (nonatomic, weak_delegate) IBOutlet id<SwipeViewDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet id<SwipeViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger numberOfItems;
@property (nonatomic, readonly) NSInteger numberOfPages;
@property (nonatomic, readonly) CGSize itemSize;
@property (nonatomic, assign) NSInteger itemsPerPage;
/**
 *  是否缩放最后一个页面
 */
@property (nonatomic, assign) BOOL truncateFinalPage;
@property (nonatomic, strong, readonly) NSArray *indexesForVisibleItems;
@property (nonatomic, strong, readonly) NSArray *visibleItemViews;
@property (nonatomic, strong, readonly) UIView *currentItemView;
@property (nonatomic, assign) NSInteger currentItemIndex;
/**
 *  当前的页面下标
 */
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) SwipeViewAlignment alignment;
@property (nonatomic, assign) CGFloat scrollOffset;
/**
 *  是否可以翻页
 */
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;
@property (nonatomic, assign, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;
@property (nonatomic, assign) BOOL delaysContentTouches;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, assign) float decelerationRate;
@property (nonatomic, assign) CGFloat autoscroll;
@property (nonatomic, readonly, getter = isDragging) BOOL dragging;
@property (nonatomic, readonly, getter = isDecelerating) BOOL decelerating;
@property (nonatomic, readonly, getter = isScrolling) BOOL scrolling;
@property (nonatomic, assign) BOOL defersItemViewLoading;
@property (nonatomic, assign, getter = isVertical) BOOL vertical;

- (void)reloadData;
- (void)reloadItemAtIndex:(NSInteger)index;
- (void)scrollByOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollToOffset:(CGFloat)offset duration:(NSTimeInterval)duration;
- (void)scrollByNumberOfItems:(NSInteger)itemCount duration:(NSTimeInterval)duration;
- (void)scrollToItemAtIndex:(NSInteger)index duration:(NSTimeInterval)duration;
- (void)scrollToPage:(NSInteger)page duration:(NSTimeInterval)duration;
- (UIView *)itemViewAtIndex:(NSInteger)index;
- (NSInteger)indexOfItemView:(UIView *)view;
- (NSInteger)indexOfItemViewOrSubview:(UIView *)view;

@end


@protocol SwipeViewDataSource <NSObject>
/**
 *  滚动view的个数
 *
 *  @param swipeView self
 *
 *  @return 数量
 */
- (NSInteger)numberOfItemsInSwipeView:(MacSwipeView *)swipeView;
/**
 *  滚动的时候 当前index 要显示的UIView
 *
 *  @param swipeView self
 *  @param index     下标坐标
 *  @param view      唤醒的View
 *
 *  @return 显示的UIView
 */
- (UIView *)swipeView:(MacSwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view;

@end


@protocol SwipeViewDelegate <NSObject>
@optional
/**
 *  滚动范围
 *
 *  @param swipeView self
 *
 *  @return 设置滚动范围 防止滚出所设区域，默认可设为self bounds size
 */
- (CGSize)swipeViewItemSize:(MacSwipeView *)swipeView;
- (void)swipeViewDidScroll:(MacSwipeView *)swipeView;
- (void)swipeViewCurrentItemIndexDidChange:(MacSwipeView *)swipeView;
- (void)swipeViewWillBeginDragging:(MacSwipeView *)swipeView;
- (void)swipeViewDidEndDragging:(MacSwipeView *)swipeView willDecelerate:(BOOL)decelerate;
- (void)swipeViewWillBeginDecelerating:(MacSwipeView *)swipeView;
- (void)swipeViewDidEndDecelerating:(MacSwipeView *)swipeView;
- (void)swipeViewDidEndScrollingAnimation:(MacSwipeView *)swipeView;
- (BOOL)swipeView:(MacSwipeView *)swipeView shouldSelectItemAtIndex:(NSInteger)index;
- (void)swipeView:(MacSwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index;

@end


#pragma GCC diagnostic pop

