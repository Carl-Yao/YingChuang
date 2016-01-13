
#import "RGCardViewLayout.h"

@implementation RGCardViewLayout
{
    CGFloat previousOffset;
    NSIndexPath *mainIndexPath;
    NSIndexPath *movingInIndexPath;
    CGFloat diffrence;
}

- (void)prepareLayout
{
    [super prepareLayout];
    [self setupLayout];
}


- (void)setupLayout
{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyTransformToLayoutAttributes:attributes];

    return attributes;
}

// indicate that we want to redraw as we scroll
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSArray *cellIndices = [self.collectionView indexPathsForVisibleItems];
    if(cellIndices.count == 0 )
    {
        return attributes;
    }
    else if (cellIndices.count == 1)
    {
        mainIndexPath = cellIndices.firstObject;
        movingInIndexPath = nil;
        
        
    }else if(cellIndices.count > 1)
    {
        NSIndexPath *firstIndexPath = cellIndices.firstObject;
        if(firstIndexPath == mainIndexPath)
        {
            movingInIndexPath = cellIndices[1];
            
        }
        else
        {
            movingInIndexPath = cellIndices.firstObject;
            mainIndexPath = cellIndices[1];
        }
        
    }
    
    diffrence =  self.collectionView.contentOffset.x - previousOffset;
    
    previousOffset = self.collectionView.contentOffset.x;
    
//    NSLog(@"show*****************");
    
//    for (UICollectionViewLayoutAttributes *attribute in attributes)
//    {
//        [self applyTransformToLayoutAttributes:attribute];
//    }
    return  attributes;
}

- (void)applyTransformToLayoutAttributes:(UICollectionViewLayoutAttributes *)attribute
{
    NSInteger currentIndex = attribute.indexPath.section;
    
    NSLog(@"show:%ld", (long)currentIndex);
    
//    if(attribute.indexPath.section == currentPageIndex)
//    {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:attribute.indexPath];
        attribute.transform3D = [self transformFromView:cell];
        
//    }
//    else //if (attribute.indexPath.section == movingInIndexPath.section)
//    {
//        
//        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:movingInIndexPath];
//        attribute.transform3D = [self transformFromView:cell];
//    }
}


- (CGRect)newFrameFromOriginal:(CGRect)orginalFrame withView:(UIView *)view
{
//    CGFloat computedY = [self heightOffsetForView:view];
    return orginalFrame;

}


#pragma mark - Logica
- (CGFloat)baseOffsetForView:(UIView *)view
{
    
    UICollectionViewCell *cell = (UICollectionViewCell *)view;
    
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width - 40;
    
    CGFloat offset =  ([self.collectionView indexPathForCell:cell].section) * scrollViewWidth;
    
    return offset;
}

- (CGFloat)heightOffsetForView:(UIView *)view
{
    CGFloat height;
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x + self.collectionView.contentInset.left;

    CGFloat scrollViewWidth = self.collectionView.bounds.size.width - 40;
    //TODO:make this constant a certain proportion of the collection view
    height = 120 * (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    if(height < 0 )
    {
        height = - 1 *height;
    }
    return height;
}

- (CGFloat)angleForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat scrollViewWidth = self.collectionView.bounds.size.width - 40;
    CGFloat angle = (currentOffset - baseOffsetForCurrentView)/scrollViewWidth;
    return angle;
}

- (BOOL)xAxisForView:(UIView *)view
{
    CGFloat baseOffsetForCurrentView = [self baseOffsetForView:view ];
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat offset = (currentOffset - baseOffsetForCurrentView);
    if(offset >= 0)
    {
        return YES;
    }
    return NO;
    
}

#pragma mark - Transform Related Calculation
- (CATransform3D)transformFromView:(UIView *)view
{
    CGFloat angle = [self angleForView:view];
    CGFloat height = [self heightOffsetForView:view];
    BOOL xAxis = [self xAxisForView:view];
    return [self transformfromAngle:angle height:height xAxis:xAxis];
}

- (CATransform3D)transformfromAngle:(CGFloat )angle height:(CGFloat) height xAxis:(BOOL)axis
{
    CATransform3D t = CATransform3DIdentity;
    t.m34  = 1.0/-500;
    
//    if (axis)
//    {
//        t = CATransform3DRotate(t,angle, 1, 1, 0);
//    }
//    else
//    {
//        t = CATransform3DRotate(t,angle, -1, 1, 0);
//    }
        t = CATransform3DTranslate(t, 0, height, 0);
    
    return t;
}

@end

