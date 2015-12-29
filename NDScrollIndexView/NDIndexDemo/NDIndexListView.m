//
//  NDIndexListView.m
//  Demo
//
//  Created by NDMAC on 15/11/9.
//  Copyright © 2015年 NDMAC. All rights reserved.
//

#import "NDIndexListView.h"
#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r,g,b)          RGBA(r,g,b,1)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavBarHeight 64
#define TopViewHeight 44
#define LineViewHeight 0.3
#define TitleBarWidth ScreenWidth/3
#define MainLineGrayColor [UIColor colorWithRed:(203.0 / 255.0) green:(205.0 / 255.0) blue:(208.0 / 255.0) alpha:1.0]
#define NavTextColor RGB(155, 155, 155)
#define ContextTextColor RGB(155, 155, 155)
#define tableViewBackColor [UIColor colorWithRed:245/255. green:245/255. blue:245/255. alpha:1]
#define LoadMoreText @"点击加载更多"
#define FinishLoadMoreText @"数据没有更多了"
#define LoadingMoreText @"正在加载......"


typedef NS_ENUM(NSInteger, whichScrollView){
    firstScrollView = 100,
    SecondScrollView,
    LastScrollView
};

@interface NDIndexListCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;  //表格label
@property (nonatomic, strong) UIView *lineView;     //线条
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andIndexCount:(NSInteger)count;
- (void)configWithDataArray:(NSArray *)array andReuseIdentifier:(NSString *)reuseIdentifier; //填充UI数据

@end

@implementation NDIndexListCell
{
    NSArray *dataArray;
    NSInteger indexCount;
}

#pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andIndexCount:(NSInteger)count
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        indexCount = count;
        [self configUIWithReusIdentifier:(NSString *)reuseIdentifier];
    }
    return self;
}

#pragma mark - private

- (void)configUIWithReusIdentifier:(NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:@"NAVCELLID"]) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, TitleBarWidth-14, TopViewHeight)];
        _titleLabel.textColor = NavTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_titleLabel];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) - LineViewHeight, TitleBarWidth, LineViewHeight)];
        _lineView.backgroundColor = MainLineGrayColor;
        [self.contentView addSubview:_lineView];
    } else if ([reuseIdentifier isEqualToString:@"BOTCELLID"]) {
        for (int i = 0; i < indexCount; i++) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * TitleBarWidth, 0, TitleBarWidth, TopViewHeight)];
            _titleLabel.textColor = ContextTextColor;
            _titleLabel.font = [UIFont systemFontOfSize:14];
            _titleLabel.tag = 201 + i;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:_titleLabel];
            _lineView = [[UIView alloc]initWithFrame:CGRectMake(i * TitleBarWidth, CGRectGetMaxY(_titleLabel.frame) - LineViewHeight, TitleBarWidth, LineViewHeight)];
            _lineView.backgroundColor = MainLineGrayColor;
            [self.contentView addSubview:_lineView];
        }
        
    }
}

- (void)configWithDataArray:(NSArray *)array andReuseIdentifier:(NSString *)reuseIdentifier
{
    if ([reuseIdentifier isEqualToString:@"NAVCELLID"]) {
        self.titleLabel.text = array[0];
    } else if ([reuseIdentifier isEqualToString:@"BOTCELLID"]) {
        for (int i = 1; i < array.count; i++) {
            UILabel *label = (UILabel *)[self.contentView viewWithTag:200 + i];
            label.text = array[i];
        }
    }
}


@end


@interface NDIndexListView()<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic, strong) UIView *topScrollContentView;
@property (nonatomic, strong) UITableView *navTableView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UITableView *bottomTableView;

@end


@implementation NDIndexListView
{
    NSArray *indexArray;  //索引数组
    UIButton *bottomButton;
    BOOL isLoad;
}

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame indexTitleArray:(NSArray *)indexs dataSourceArray:(NSArray *)dataSource load:(BOOL)load;
{
    self = [super initWithFrame:frame];
    if (self) {
        indexArray = indexs;
        isLoad = load;
        self.dataArray = dataSource;
        [self configUI];
    }
    return self;
}


#pragma mark - private

- (void)configUI
{
    //创建索引视图
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TopViewHeight)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    //标签
    UILabel *indexFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, TitleBarWidth, TopViewHeight)];
    indexFirstLabel.text = indexArray[0];
    indexFirstLabel.textColor = RGB(74, 74, 74);
    indexFirstLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:indexFirstLabel];
    
    //线条颜色
    UIView *topLineLabel = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(indexFirstLabel.frame), TitleBarWidth, LineViewHeight)];
    topLineLabel.backgroundColor = MainLineGrayColor;
    [topView addSubview:topLineLabel];
    
    UIView *bottomLineLabel = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(indexFirstLabel.frame) - LineViewHeight, TitleBarWidth - 10, LineViewHeight)];
    bottomLineLabel.backgroundColor = MainLineGrayColor;
    [topView addSubview:bottomLineLabel];
    
    //标签ScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(TitleBarWidth, 0, ScreenWidth - TitleBarWidth, TopViewHeight)];
    self.topScrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.tag = 100;
    scrollView.contentSize = CGSizeMake((indexArray.count - 1)* TitleBarWidth, TopViewHeight);
    scrollView.delegate = self;
    scrollView.bounces = NO;
    [topView addSubview:scrollView];
    
    for (int i = 1; i < indexArray.count; i++) {
        //标签
        UILabel *indexLabel = [[UILabel alloc]initWithFrame:CGRectMake((i - 1) * TitleBarWidth, 0, TitleBarWidth, TopViewHeight)];
        indexLabel.text = indexArray[i];
        indexLabel.textColor = RGB(74, 74, 74);
        indexLabel.font = [UIFont systemFontOfSize:14];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        
        [scrollView addSubview:indexLabel];
        
        //线条颜色
        UIView *topLineLabel = [[UIView alloc]initWithFrame:CGRectMake((i - 1) * TitleBarWidth, CGRectGetMinY(indexFirstLabel.frame), TitleBarWidth, LineViewHeight)];
        topLineLabel.backgroundColor = MainLineGrayColor;
        [scrollView addSubview:topLineLabel];
        
        UIView *lineLabel = [[UIView alloc]initWithFrame:CGRectMake((i - 1) * TitleBarWidth, TopViewHeight - LineViewHeight, TitleBarWidth, LineViewHeight)];
        lineLabel.backgroundColor = MainLineGrayColor;
        [scrollView addSubview:lineLabel];
    }
    
    
    
    //创建内容视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), ScreenWidth, CGRectGetHeight(self.frame) - TopViewHeight)];
    [self addSubview:bottomView];
    
    //创建底部视图左边TableView
    UITableView *navTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(bottomView.frame))];
    self.navTableView = navTableView;
    navTableView.backgroundColor = [UIColor clearColor];
    navTableView.showsVerticalScrollIndicator = NO;
    navTableView.dataSource = self;
    navTableView.delegate = self;
    navTableView.tag = 101;
    [bottomView addSubview:navTableView];
    self.navTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //创建底部视图右边ScrollView
    UIScrollView *botScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(TitleBarWidth, 0, ScreenWidth - TitleBarWidth, CGRectGetHeight(bottomView.frame))];
    self.bottomScrollView = botScrollView;
    botScrollView.showsHorizontalScrollIndicator = NO;
    botScrollView.bounces = NO;
    botScrollView.delegate = self;
    botScrollView.tag = 102;
    botScrollView.contentSize = CGSizeMake((indexArray.count - 1)* TitleBarWidth, TopViewHeight);
    [bottomView addSubview:botScrollView];
    
    //创建底部视图右边TableView
    UITableView *botTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, (indexArray.count - 1) * TitleBarWidth, CGRectGetHeight(bottomView.frame))];
    self.bottomTableView = botTableView;
    botTableView.backgroundColor = [UIColor clearColor];
    botTableView.showsVerticalScrollIndicator = NO;
    botTableView.dataSource = self;
    botTableView.delegate = self;
    [botScrollView addSubview:botTableView];
    self.bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (isLoad) {
        //创建点击加载更多视图
        self.reloadMoreView = [[NDReloadMoreView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        [self.reloadMoreView showPromptViewWithText:LoadMoreText];
        self.navTableView.tableFooterView = self.reloadMoreView;
        [self.reloadMoreView.reloadButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //右边tableView的footerView
    bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame = CGRectMake(0, 0, (indexArray.count - 1) * TitleBarWidth, 40);
    [bottomButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    self.bottomTableView.tableFooterView = bottomButton;
    
}


#pragma mark - 滚动逻辑处理

- (void)dealWithScrollView:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {
        
    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        if (scrollView.contentOffset.x > 0) {
            CGFloat num = scrollView.contentOffset.x;
            NSInteger den = (NSInteger)TitleBarWidth;
            NSInteger result = (NSInteger)num/den;
            NSInteger i = ((NSInteger)(scrollView.contentOffset.x)%(NSInteger)(TitleBarWidth)) > TitleBarWidth/2?1:0;
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                scrollView.contentOffset = CGPointMake(TitleBarWidth * (i + result), 0);
            } completion:nil];
        }
    }
}


#pragma mark - 点击加载

-(void)btnClick
{
    self.reloadMoreView.reloadButton.enabled = NO;
    bottomButton.enabled = NO;
    [self.reloadMoreView showLoadingAnimationWithText:LoadingMoreText];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexListView:loadMoreDataSuccess:)]) {
        [self.delegate indexListView:self loadMoreDataSuccess:YES];
    }
}

#pragma mark - delegate

#pragma mark - UITableViewDelegate UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == SecondScrollView) {
        static NSString *cellId = @"NAVCELLID";
        NDIndexListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[NDIndexListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId andIndexCount:0];
        }
        [cell configWithDataArray:self.dataArray[indexPath.row] andReuseIdentifier:cellId];
        if (self.dataArray.count == indexPath.row + 1) {
            CGRect rect = cell.lineView.frame;
            cell.lineView.frame = CGRectMake(0, CGRectGetMinY(rect), CGRectGetWidth(rect) + 10, CGRectGetHeight(rect));
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    static NSString *cellId = @"BOTCELLID";
    NDIndexListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NDIndexListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId andIndexCount:indexArray.count - 1];
    }
    [cell configWithDataArray:self.dataArray[indexPath.row] andReuseIdentifier:cellId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_navTableView] || [scrollView isEqual:_bottomTableView]) {
        if (scrollView.contentOffset.y < 0) {
            scrollView.bounces = NO;
            [scrollView setContentOffset:CGPointZero];
            return;
        }else{
            scrollView.bounces = YES;
        }
    }
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tmp = (UITableView *)scrollView;
        if (tmp.tag  == SecondScrollView) {
            self.bottomTableView.contentOffset = tmp.contentOffset;
        } else {
            self.navTableView.contentOffset = tmp.contentOffset;
        }
        
    } else if ([scrollView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *tmp = (UIScrollView *)scrollView;
        if (tmp.tag  == firstScrollView) {
            self.bottomScrollView.contentOffset = tmp.contentOffset;
        } else {
            self.topScrollView.contentOffset = tmp.contentOffset;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self dealWithScrollView:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:_navTableView] || [scrollView isEqual:_bottomTableView]) {
        
        scrollView.bounces = YES;
    }
    [self dealWithScrollView:scrollView];
}


#pragma mark - public

#pragma mark - 完成加载

- (void)isFinishLoadMoreView:(BOOL)isFinish
{
    if (!isFinish) {
        [self.reloadMoreView showPromptViewWithText:LoadMoreText];
    } else [self.reloadMoreView showPromptViewWithText:FinishLoadMoreText];
    self.reloadMoreView.reloadButton.enabled = YES;
    bottomButton.enabled = YES;
}

#pragma mark - 刷新界面
- (void)reloadListView
{
    [self.navTableView reloadData];
    [self.bottomTableView reloadData];
}

@end


@implementation NDReloadMoreView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)dealloc {
    [self stopActivityIndicatorView];
    self.activityIndicatorView = nil;
    self.loadingLabel = nil;
    self.reloadButton = nil;
}

#pragma mark - private

- (void)initUI
{
    self.backgroundColor = tableViewBackColor;
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.alpha = 0.;
    
    _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 44)];
    self.loadingLabel.alpha = 0.;
    self.loadingLabel.textColor = [UIColor grayColor];
    self.loadingLabel.font = [UIFont systemFontOfSize:14.0];
    
    _reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _reloadButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.activityIndicatorView];
    [self addSubview:self.loadingLabel];
    [self addSubview:self.reloadButton];
}

- (void)stopActivityIndicatorView {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)setupAllUIWithAlpha {
    self.loadingLabel.alpha = 0.;
    self.activityIndicatorView.alpha = 0.;
}

- (void)showFriendlyLoadingViewWithText:(NSString *)text loadingAnimated:(BOOL)animated {
    [self setupAllUIWithAlpha];
    if (animated) {
        [self showLoadingAnimationWithText:text];
    } else {
        [self showPromptViewWithText:text];
    }
}

- (CGRect)setpLoadingLabelForWidth:(CGFloat)width {
    CGRect loadingLabelFrame = self.loadingLabel.frame;
    loadingLabelFrame.size.width = width;
    loadingLabelFrame.origin.x = 0;
    loadingLabelFrame.origin.y = CGRectGetHeight(self.bounds) / 2.0 - CGRectGetHeight(loadingLabelFrame) / 2.0;
    return loadingLabelFrame;
}

#pragma mark - public
- (void)showPromptViewWithText:(NSString *)promptString {
    [self stopActivityIndicatorView];
    
    // 只是显示一行文本
    self.loadingLabel.frame = [self setpLoadingLabelForWidth:CGRectGetWidth(self.bounds)];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.text = promptString;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.activityIndicatorView.alpha = 0.;
        self.loadingLabel.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showLoadingAnimationWithText:(NSString *)loadingString {
    CGPoint activityIndicatorViewCentet = CGPointMake(CGRectGetWidth(self.bounds) / 2.0 * 2 / 2.8, CGRectGetHeight(self.bounds) / 2.0);
    self.activityIndicatorView.center = activityIndicatorViewCentet;
    [self.activityIndicatorView startAnimating];
    
    CGRect loadingLabelFrmae = [self setpLoadingLabelForWidth:CGRectGetWidth(self.bounds) / 3];
    self.loadingLabel.textAlignment = NSTextAlignmentLeft;
    loadingLabelFrmae.origin.x = CGRectGetWidth(self.activityIndicatorView.frame) + self.activityIndicatorView.frame.origin.x + 8;
    loadingLabelFrmae.origin.y = CGRectGetHeight(self.bounds) / 2.0 - CGRectGetHeight(loadingLabelFrmae) / 2.0;
    self.loadingLabel.frame = loadingLabelFrmae;
    self.loadingLabel.text = loadingString;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.loadingLabel.alpha = 1.;
        self.activityIndicatorView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
}


@end




