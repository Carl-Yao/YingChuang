//
//  DetailTableViewController.m
//  YingChuang
//
//  Created by 姚振兴 on 16/1/13.
//  Copyright © 2016年 YZX. All rights reserved.
//

#import "DetailTableViewController.h"
#import "RGCollectionViewCell.h"
#import "RGCardViewLayout.h"
#import <MediaPlayer/MPMoviePlayerController.h>

@interface DetailTableViewController ()<UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
RGCollectionViewCellDelegate>
@property (nonatomic, strong) UICollectionView * krcPicker;
@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"tableBg%@.jpg",@(self.type)]]];
    [self.view addSubview:bg];
    
    RGCardViewLayout * layout = [[RGCardViewLayout alloc] init];
    self.krcPicker = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 160, self.view.frame.size.width, self.view.frame.size.height - 300) collectionViewLayout:layout];
    [self.view addSubview:self.krcPicker];
    [self.krcPicker registerClass:[RGCollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    self.krcPicker.backgroundColor = [UIColor clearColor];
    //    self.krcPicker.pagingEnabled = YES;
    self.krcPicker.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.krcPicker.decelerationRate= 0.98;
    self.krcPicker.bounces = NO;
    self.krcPicker.delegate = self;
    self.krcPicker.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)showCurrentPageIndex:(NSInteger)pageIndex
//{
//    
//    NSString * pageIndexStr = [NSString stringWithFormat:@"%@", [@(pageIndex) stringValue]];
//    
//    NSString * showStr = [NSString stringWithFormat:@"%@/%@", pageIndexStr, [@(self.totalKrcItems) stringValue]];
//    
//    NSMutableAttributedString *showStrAttr = [[NSMutableAttributedString alloc] initWithString:showStr];
//    
//    NSRange strTotalRange = {0, [showStr length]};
//    
//    UIColor * totalTextColor = [[KGThemeManger shareInstance] getColorByKey:KGColorKeyType_ST];
//    
//    [showStrAttr addAttribute:NSForegroundColorAttributeName value:totalTextColor range:strTotalRange];
//    [showStrAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:strTotalRange];
//    
//    NSRange strFirstRange = {0, [pageIndexStr length]};
//    [showStrAttr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ec8d27"] range:strFirstRange];
//    
//    self.numberIndentify.attributedText = showStrAttr;
//}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.bounds.size.width - 40;
    CGFloat offsetX = scrollView.contentOffset.x + pageWidth * 0.5;
    
    NSInteger currentPageIndex = floor(offsetX / pageWidth);
    
//    [self showCurrentPageIndex:currentPageIndex + 1];
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    NSLog(@"velocity:%f", velocity.x);
    
    if (velocity.x == 0) {
        
        CGFloat pageWidth = scrollView.bounds.size.width - 40;
        CGFloat offsetX = scrollView.contentOffset.x + pageWidth * 0.5;
        
        NSInteger currentPageIndex = floor(offsetX / pageWidth);
        offsetX = pageWidth * currentPageIndex - scrollView.contentInset.left;
        
        // find the nearby content offset
        *targetContentOffset = CGPointMake(offsetX, scrollView.contentOffset.y);
    } else {
        // calculate the slide distance and end scrollview content offset
        CGFloat startVelocityX = fabs(velocity.x);
        CGFloat decelerationRate = 1.0 - scrollView.decelerationRate;
        
        CGFloat decelerationSeconds = startVelocityX / decelerationRate;
        CGFloat distance = startVelocityX * decelerationSeconds - 0.5 * decelerationRate * decelerationSeconds * decelerationSeconds;
        
        CGFloat endOffsetX = velocity.x > 0 ? (scrollView.contentOffset.x + distance) : (scrollView.contentOffset.x - distance);
        
        CGFloat pageWidth = scrollView.bounds.size.width - 40;
        CGFloat offsetX = endOffsetX + pageWidth * 0.5;
        
        //        NSInteger currentPageIndex = floor(offsetX / pageWidth);
        
        NSInteger prePageIndex =  floor((scrollView.contentOffset.x + pageWidth * 0.5) / pageWidth);
        NSInteger currentPageIndex = velocity.x > 0 ? prePageIndex + 1: prePageIndex - 1;
        
        offsetX = pageWidth * currentPageIndex - scrollView.contentInset.left;
        
        // calculate the nearby content offset of the middle cover view
        *targetContentOffset = CGPointMake(offsetX, scrollView.contentOffset.y);
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    return CGPointZero;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    NSInteger count = [self.array count];
    return  count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RGCollectionViewCell *cell = (RGCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RGCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger index = indexPath.section;
    
    /**
     *  获得歌词模型
     */
    NSString * info = [self.array objectAtIndex:index];
    
    [cell showContent:info];
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width - (2 * 30), CGRectGetHeight(collectionView.frame) - 20);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - RGCollectionViewCellDelegate
- (void)collectionViewCell:(RGCollectionViewCell *)cell selectedKrcAtIndex:(NSIndexPath *)indexPath
{
    [self playMovie:@"yjy"];//[self.array objectAtIndex:indexPath.row]];
}

/**
 @method 播放电影
 */
-(void)playMovie:(NSString *)fileName{
    //视频文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp4"];
    //视频URL
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerController *movie = [[MPMoviePlayerController alloc] initWithContentURL:url];
    movie.controlStyle = MPMovieControlStyleFullscreen;
    [movie.view setFrame:self.view.bounds];
    movie.initialPlaybackTime = -1;
    [self.view addSubview:movie.view];
    // 注册一个播放结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:movie];
    [movie play];
}

#pragma mark -------------------视频播放结束委托--------------------

/*
 @method 当视频播放完毕释放对象
 */
-(void)myMovieFinishedCallback:(NSNotification*)notify
{
    //视频播放对象
    MPMoviePlayerController* theMovie = [notify object];
    //销毁播放通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    [theMovie.view removeFromSuperview];
    // 释放视频对象
    //    [theMovie release];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
