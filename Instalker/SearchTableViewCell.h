//
//  SearchTableViewCell.h
//  Instalker
//
//  Created by umut on 22/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <InstagramKit/InstagramKit.h>
#import "AsyncImageView/AsyncImageView.h"

@interface SearchTableViewCell : UITableViewCell
#pragma mark - IBoutlets
@property (weak, nonatomic) IBOutlet AsyncImageView *imageViewProfile;
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
@property (weak, nonatomic) IBOutlet UILabel *labelFollowerCount;

#pragma mark - Properties 

@property (nonatomic,strong) InstagramUser *user;

#pragma mark - Methods
-(void)configureViews:(InstagramUser *)user;

@end
