
#import "RGCollectionViewCell.h"

@interface RGCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation RGCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc] init];
        _imgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);;
        [self addSubview:_imgView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

}

- (void)selectedPressed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewCell:selectedKrcAtIndex:)]) {
        [self.delegate collectionViewCell:self selectedKrcAtIndex:self.indexPath];
    }
}

- (void)showContent:(NSString*)info
{
    if ([info hasSuffix:@".jpg"] || [info hasSuffix:@".png"]) {
        [_imgView setImage:[UIImage imageNamed:info]];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        [_imgView setImage:[UIImage imageNamed:@"yjy2"]];
        _imgView.contentMode = UIViewContentModeCenter;
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_imgView addGestureRecognizer:tap];
    }
    
}
-(void)tap{
    [self selectedPressed];
}

@end
