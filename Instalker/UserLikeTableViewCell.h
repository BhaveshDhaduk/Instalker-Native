//
//  UserLikeTableViewCell.h
//  Instalker
//
//  Created by umut on 1/31/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UserLikeCountModel.h"


@interface UserLikeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AsyncImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelFullname;
@property (weak, nonatomic) IBOutlet UILabel *labelLikeCount;
-(void)setFields:(UserLikeCountModel *)model;

@end
