//
//  StatsProfileView.h
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface StatsProfileView : UIView

#pragma mark - IBOUTLETS
@property (nonatomic,weak) IBOutlet AsyncImageView *imageViewProfile;
@property (nonatomic,weak) IBOutlet UILabel *labelName;
@property (nonatomic,weak) IBOutlet UILabel *labelMediaCount;
@property (nonatomic,weak) IBOutlet UILabel *labelFollewsCount;
@property (nonatomic,weak) IBOutlet UILabel *labelFollowingCount;
@property (nonatomic,weak) IBOutlet UILabel *labelPostCount;
@property (nonatomic,weak) IBOutlet UILabel *labelTotalLikes;
@property (nonatomic,weak) IBOutlet UILabel *labelAveragePosts;
@property (nonatomic,weak) IBOutlet UILabel *labelAverageComments;

@end
