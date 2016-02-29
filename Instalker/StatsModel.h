//
//  StatsModel.h
//  Instalker
//
//  Created by umut on 21/02/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatsModel : NSObject

@property (nonatomic,strong) NSURL *imageURLString;
@property (nonatomic,strong) NSString *textName;
@property (nonatomic) NSInteger followerCount;
@property (nonatomic) NSInteger followingCount;
@property (nonatomic) NSInteger totalLikes;
@property (nonatomic) NSInteger totalComments;
@property (nonatomic) NSInteger averageLikes;
@property (nonatomic) NSInteger averageComments;
@property (nonatomic) NSInteger totalPostCount;
@property (nonatomic) NSInteger filteredPostCount;

-(void)setImageURLString:(NSURL *)imageURLString
                textName:(NSString *)textName
           followerCount:(NSInteger )followerCount
            followsCount:(NSInteger )followsCount
              totalLikes:(NSInteger )totalLikes
          totalPostCount:(NSInteger )totalPostCount
           totalComments:(NSInteger )totalComments
                userName:(NSString *)userName
       filteredPostCount:(NSInteger)filteredPostCount;

@end
