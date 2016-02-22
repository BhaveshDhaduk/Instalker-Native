//
//  SearchTableViewCell.m
//  Instalker
//
//  Created by umut on 22/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "SearchTableViewCell.h"


@implementation SearchTableViewCell

-(void)configureViews:(InstagramUser *)user
{
    if (user.profilePictureURL) {
        _imageViewProfile.imageURL = user.profilePictureURL;
    }
    _labelUserName.text = user.username;
    _labelFollowerCount.text = user.fullName;
    [self setNeedsDisplay];

}



@end
