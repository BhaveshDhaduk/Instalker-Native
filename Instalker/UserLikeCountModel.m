//
//  UserLikeCountModel.m
//  Instalker
//
//  Created by umut on 1/29/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "UserLikeCountModel.h"

@implementation UserLikeCountModel

-(id)initWithUser:(InstagramUser *)user withLike:(NSNumber *)count{
    if (self) {
        self.user=user;
        self.likeCount=count;
    }
    
    
    return self;
}

@end
