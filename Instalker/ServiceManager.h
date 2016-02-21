//
//  ServiceManager.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsModel.h"

typedef void (^completion)(NSMutableArray *result);
typedef void (^completionFinal)(NSMutableArray *likeList, StatsModel *stats);
typedef void (^completionRaw)(void);

@interface ServiceManager : NSObject

#pragma mark - Initilization
+(ServiceManager *)sharedManager;
-(id)init;

#pragma mark - Session variables
@property (nonatomic,strong) NSString *accessToken;

#pragma mark - Call Variables
@property (nonatomic,strong) NSMutableArray *followerList;
@property (nonatomic,strong) NSMutableDictionary *reducedLikeList;
@property (nonatomic,strong) NSMutableArray *arrayLikes;
@property (nonatomic,strong) NSMutableArray *arrayComments;

@property (nonatomic,strong) NSNumber *totalComments;
@property (nonatomic,strong) NSNumber *totalLikesCount;
@property (nonatomic,strong) NSNumber *follewersCount;
@property (nonatomic,strong) NSNumber *follewingsCount;
@property (nonatomic,strong) NSNumber *totalPostCount;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *profileImageURL;




#pragma mark - Service Calls

-(void )getMediasWithCompletion:(completion)completion;



@end
