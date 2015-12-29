//
//  NDIndexListView.h
//  Demo
//
//  Created by NDMAC on 15/11/9.
//  Copyright © 2015年 NDMAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NDReloadMoreView;
@class NDIndexListView;

@protocol NDIndexListViewDelegate <NSObject>

@optional
- (void)indexListView:(NDIndexListView *)indexListView loadMoreDataSuccess:(BOOL)success;

@end

@interface NDIndexListView : UIView

//数据源数组
@property (nonatomic ,strong)  NSArray *dataArray;

//点击刷新视图
@property (nonatomic, strong) NDReloadMoreView *reloadMoreView;

@property (nonatomic, assign) id <NDIndexListViewDelegate> delegate;

@property (nonatomic, assign) BOOL load;

/**
 *  依赖注入
 *
 *  @param frame frame
 *  @param items indexTitleArray         索引数组
 *  @param items dataSourceArray      数据源数组
 *
 *  @return 当前实例
 */
- (instancetype)initWithFrame:(CGRect)frame indexTitleArray:(NSArray *)indexs dataSourceArray:(NSArray *)dataSource load:(BOOL)load;

//刷新界面  (修改数据源数组)
- (void)reloadListView;

//完成加载
- (void)isFinishLoadMoreView:(BOOL)isFinish;

@end

@interface NDReloadMoreView : UIView
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIButton *reloadButton;

/**
 *  纯文字提示
 *
 *  @param promptString 要显示的提示字符串
 */
- (void)showPromptViewWithText:(NSString *)promptString;

/**
 *  页面加载动画及信息提示
 *
 *  @param loadingString 要显示的提示字符串
 */
- (void)showLoadingAnimationWithText:(NSString *)loadingString;



@end
