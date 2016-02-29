//
//  UserLikeCountModel.h
//  Instalker
//
//  Created by umut on 1/29/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <InstagramKit/InstagramKit.h>

@interface UserLikeCountModel : NSObject

@property (nonatomic,strong) InstagramUser *user;
@property (nonatomic,strong) NSNumber *likeCount;
@property (nonatomic,strong) NSMutableArray *arrayMedias;

-(id)initWithUser:(InstagramUser *)user withLike:(NSNumber *)count;
@end
