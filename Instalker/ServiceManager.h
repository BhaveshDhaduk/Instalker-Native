//
//  ServiceManager.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StatsModel.h"


#pragma mark - Blocks
typedef void (^completion)(NSMutableArray *result);
typedef void (^completionFinal)(NSMutableArray *likeList, StatsModel *stats);
typedef void (^completionRaw)(void);
typedef void (^failed)(NSError *error);
typedef void (^failure)(NSError *error, NSString *errorType);
typedef void (^iterationBlock)(float percentage);



@interface ServiceManager : NSObject

#pragma mark - Initilization
+(ServiceManager *)sharedManager;
-(id)init;

#pragma mark - Session variables
@property (nonatomic,strong) NSString *accessToken;

#pragma mark - Call Variables
//all medias for a user
@property (nonatomic,strong) NSMutableArray *allMedia;
//final list
@property (nonatomic,strong) NSMutableArray *followerList;
//method variables
@property (nonatomic,strong) NSMutableDictionary *reducedLikeList;
@property (nonatomic,strong) NSMutableArray *arrayLikes;
@property (nonatomic,strong) NSMutableArray *arrayComments;

@property (nonatomic) NSInteger totalComments;
@property (nonatomic) NSInteger totalLikesCount;
@property (nonatomic) NSInteger follewersCount;
@property (nonatomic) NSInteger follewingsCount;
@property (nonatomic) NSInteger totalPostCount;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSURL *profileImageURL;
@property (nonatomic,strong) NSString *fullName;


#pragma mark - Iteration
@property (nonatomic) float iterationPercantage;
@property (nonatomic) float iterationToken;


#pragma mark - Service Calls


-(void)getSelfDataWithCompletion:(completionFinal)completion  failure:(failure)failure dateinterval:(kMediaDate)numberofDays;
-(void)searchUsersWithKeyword:(NSString*)keyword completion:(completion)completion failed:(failed)failed;
-(void)getDataForUser:(NSString *)username mediaInterval:(kMediaDate)interval  withCompletion:(completionFinal)completion withCounting:(iterationBlock)iteration;

@end
