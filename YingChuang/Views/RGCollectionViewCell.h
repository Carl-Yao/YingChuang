
#import <UIKit/UIKit.h>
@protocol RGCollectionViewCellDelegate;

@interface RGCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id <RGCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath * indexPath;

- (void)showContent:(NSString*)info;

@end

@protocol RGCollectionViewCellDelegate <NSObject>

- (void)collectionViewCell:(RGCollectionViewCell *)cell selectedKrcAtIndex:(NSIndexPath *)indexPath;

@end