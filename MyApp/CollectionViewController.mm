//
//  CollectionViewController.mm
//  MyApp
//
//  Created by Jinwoo Kim on 1/6/24.
//

#import "CollectionViewController.h"
#import "TranslatedSheetInteraction.hpp"
#import "TranslatedScrollToTop.hpp"

@interface CollectionViewController ()
@property (retain, nonatomic) UICollectionViewCellRegistration *cellRegistration;
@end

@implementation CollectionViewController

- (instancetype)init {
    UICollectionLayoutListConfiguration *listConfiguration = [[UICollectionLayoutListConfiguration alloc] initWithAppearance:UICollectionLayoutListAppearanceInsetGrouped];
    UICollectionViewCompositionalLayout *collectionViewLayout = [UICollectionViewCompositionalLayout layoutWithListConfiguration:listConfiguration];
    [listConfiguration release];
    
    self = [super initWithCollectionViewLayout:collectionViewLayout];
    
    if (self) {
        UICollectionViewCellRegistration *cellRegistration = [UICollectionViewCellRegistration registrationWithCellClass:UICollectionViewListCell.class configurationHandler:^(__kindof UICollectionViewListCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
            UIListContentConfiguration *contentConfiguration = [cell defaultContentConfiguration];
            contentConfiguration.text = @(indexPath.item).stringValue;
            cell.contentConfiguration = contentConfiguration;
        }];
        
        [self->_cellRegistration release];
        self->_cellRegistration = [cellRegistration retain];
    }
    
    return self;
}

- (void)dealloc {
    [_cellRegistration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionView *collectionView = self.collectionView;
    
    collectionView.transform = CGAffineTransformMakeScale(1.f, -1.f);
    objc_setAssociatedObject(collectionView, TranslatedSheetInteraction::useTranslatedSheetInteractionKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(collectionView, TranslatedScrollToTop::useTranslatedScrollToTopKey, @YES, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 200;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueConfiguredReusableCellWithRegistration:_cellRegistration forIndexPath:indexPath item:[NSNull null]];
}

@end
