//
//  MediaCollectionViewCell.h
//  Instalker
//
//  Created by umut on 29/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface MediaCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) InstagramMedia* media;

@property (weak, nonatomic) IBOutlet AsyncImageView *imageView;


@end
