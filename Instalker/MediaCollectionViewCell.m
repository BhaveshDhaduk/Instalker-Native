//
//  MediaCollectionViewCell.m
//  Instalker
//
//  Created by umut on 29/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "MediaCollectionViewCell.h"

@implementation MediaCollectionViewCell

- (void)awakeFromNib {
    _imageView.imageURL = _media.thumbnailURL;
    
    // Initialization code
}

-(void)configureImageView:(NSURL *)url
{
    _imageView.imageURL = url;    
}

-(void)configureImageViewSelfURL
{
    _imageView.imageURL = _media.thumbnailURL;
    [_imageView setContentMode:UIViewContentModeScaleAspectFit];
}
@end
