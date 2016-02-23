//
//  ServiceManager.m
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "ServiceManager.h"

#import <AFNetworking/AFNetworking.h>
#import <InstagramKit/InstagramKit.h>
#import "UserLikeCountModel.h"



@implementation ServiceManager


#pragma mark - Inıt
+(ServiceManager *)sharedManager
{
    static ServiceManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{ _sharedManager = [[ServiceManager alloc]init];});
    return  _sharedManager;
}

-(id)init
{
    
    if (self) {
        _followerList=[NSMutableArray array];
    }
    return self;
}

-(void)clean{
    _arrayLikes = nil;
    _followerList = nil;
    _reducedLikeList = nil;
    _arrayLikes = nil;
    
    _totalLikesCount = 0;
    _follewersCount = 0;
    _follewingsCount = 0;
    _totalPostCount = 0;
    _userName = nil;
    _profileImageURL = nil;
    
    
    
    
}

#pragma mark - Profile

-(void)getMyProfileInfoWithCompletion:(completionRaw)completion failed:(failed)failed
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
        
        _follewersCount =user.followedByCount;
        _follewingsCount = user.followsCount;
        _totalPostCount = user.mediaCount;
        _userName = user.username;
        _fullName = user.fullName;
        _profileImageURL = user.profilePictureURL;
        
        if (completion) {
            completion();
        }
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
    }];
    
}
-(void)getProfileInfoWith:(NSString *)userID completion:(completionRaw)completion failed:(failed)failed
{
    [[InstagramEngine sharedEngine]getUserDetails:userID withSuccess:^(InstagramUser * _Nonnull user) {
        
        _follewersCount =user.followedByCount;
        _follewingsCount = user.followsCount;
        _totalPostCount = user.mediaCount;
        _userName = user.username;
        _fullName = user.fullName;
        _profileImageURL = user.profilePictureURL;
        
        if (completion) {
            completion();
        }

        
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
        
    }];
}


#pragma mark - Follewers
-(void)getFollowersOfUser:(NSString *)userID
{
    [[InstagramEngine sharedEngine]getFollowersOfUser:userID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        _follewersCount=users.count;
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
}

#pragma mark - Followings
-(void )getFollowsOfUser:(NSString *)userID{
    
    [[InstagramEngine sharedEngine] getUsersFollowedByUser:userID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        _follewingsCount =users.count;
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
}

#pragma  mark - Get medias of user
-(void)getmediaOfUser:(NSString *)userID forMonths:(NSInteger)numberOfMonth withCompletion:(completion)completion withFailure:(failed)failed
{
    [[InstagramEngine sharedEngine] getMediaForUser:userID withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
            if (completion) {
                completion((NSMutableArray *)media);
            }
            
      
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
        
    }];
    
}


-(void )getMediasWithCompletion:(completion)completion failed:(failed)failed
{
    
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        if (completion) {
            completion((NSMutableArray *)media);
        }
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
    }];
}


#pragma mark - Sort Media By Date Intervals
-(NSArray *)sortMedia:(NSArray *)media from:(NSInteger )numberOfDays to:(NSInteger)endDayNumber
{
    //daily start
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-numberOfDays];
    date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    //end date
    NSDate *endDate = [NSDate date];
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setDay:-endDayNumber];
    endDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponents toDate:endDate options:0];
    
    
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (InstagramMedia* photo in media ) {
        if ([photo.createdDate laterDate:date] && [photo.createdDate earlierDate:endDate]) {
            [result addObject:photo];
        }
    }
    
    
    return result;
}

-(NSArray *)sortMedia:(NSArray *)media forMonth:(NSInteger)numberOfMonths toMonth:(NSInteger)endNumberOfMonths
{
    //one month
    NSDate *date = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-numberOfMonths];
    date = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    
    //end date
    NSDate *endDate = [NSDate date];
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setMonth:-endNumberOfMonths];
    endDate = [[NSCalendar currentCalendar] dateByAddingComponents:endDateComponents toDate:endDate options:0];
    
    
    
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (InstagramMedia* photo in media ) {
        if ([photo.createdDate laterDate:date] && [photo.createdDate earlierDate:endDate]) {
            [result addObject:photo];
        }
    }
    
    return result;
}

#pragma mark - Likes For Medias

-(void)getLikesForMedias:(NSArray *)media withCompletion:(completion)completion
{
    _arrayLikes = [NSMutableArray array];
    _reducedLikeList = [NSMutableDictionary dictionary];
    _totalLikesCount = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        __block int ready=0;
        
        for (InstagramMedia *dict in media) {
            
            NSString *mediaID = dict.Id;
            
            [[InstagramEngine sharedEngine] getLikesOnMedia:mediaID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
                
                _totalLikesCount = _totalLikesCount + users.count;
                [_arrayLikes addObjectsFromArray:users];
                ready++;
                
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }
                
                
            } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                
                ready++;
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }

            
            
            }];
            
        }
        
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSMutableDictionary *users = [NSMutableDictionary dictionary];
        
        
        for (InstagramUser *usr  in _arrayLikes) {
            
            if( [_reducedLikeList objectForKey:usr.username] )
            {
                NSNumber *count = [_reducedLikeList objectForKey:usr.username];
                NSNumber *updated= [NSNumber numberWithInt:count.intValue+1];
                [_reducedLikeList setObject:updated forKey:usr.username];
            }
            else
            {
                NSNumber *one = [NSNumber numberWithInt:1];
                [_reducedLikeList setObject:one forKey:usr.username];
                [users setObject:usr forKey:usr.username];
            }
            
        }
        
        
        NSArray *orderedKeys = [_reducedLikeList keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2){
            
            return [obj2 compare:obj1];
            
        }];
        
        NSMutableArray *orderedUserLike = [NSMutableArray array];
        
        for (NSString *key in orderedKeys) {
            
            UserLikeCountModel *obj = [[UserLikeCountModel alloc]initWithUser:[users objectForKey:key] withLike:[_reducedLikeList objectForKey:key]];
            [orderedUserLike addObject:obj];
            
            
            
        }
        
        //reduce th array
        if (completion) {
            completion(orderedUserLike);
        }
        
    });
    
}

#pragma mark - Comments

-(void)getCommentsForMedia:(NSArray *)media withCompletion:(completionRaw)completion
{
    _arrayComments = [NSMutableArray array];
    _totalComments = 0;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        __block int ready=0;
        for (InstagramMedia *dict in media) {
            NSString *mediaID = dict.Id;
            
            [[InstagramEngine sharedEngine] getCommentsOnMedia:mediaID withSuccess:^(NSArray<InstagramComment *> * _Nonnull comments, InstagramPaginationInfo * _Nonnull paginationInfo) {
                
                
                _totalComments = _totalComments + (int)comments.count;
                
                ready++;
                
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }
                
                
            } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                ready++;
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }

            }];
            
            
        }
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        if (completion) {
            completion();
        }
        
    });
    
    
    
    
}


#pragma mark - Final Methods

-(void)getSelfDataWithCompletion:(completionFinal)completion  failure:(failure)failure
{
    [self clean];
    
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self getMediasWithCompletion:^(NSMutableArray *result) {
            _allMedia = result;
            

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_semaphore_t semant = dispatch_semaphore_create(0);
                
                [self getMyProfileInfoWithCompletion:^{
                 
                    dispatch_semaphore_signal(semant);
                   
                }failed:^(NSError *error) {
                    
                }];
                
                [self getCommentsForMedia:_allMedia withCompletion:^{
                   
                    dispatch_semaphore_signal(semant);
                    
                    
                }];
                
                [self getLikesForMedias:_allMedia withCompletion:^(NSMutableArray *result) {
                    
                    _followerList  = result;
                     dispatch_semaphore_signal(semant);
                    
                    
                }];
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                
                
                StatsModel *model = [StatsModel new];
                [model setImageURLString:_profileImageURL
                                textName:_fullName
                           followerCount:_follewersCount
                            followsCount:_follewingsCount
                              totalLikes:_totalLikesCount
                          totalPostCount:_totalPostCount
                           totalComments:_totalComments
                                userName:_userName];
                
                if (completion) {
                    completion(_followerList,model);
                }

                
                
            });
            
           
           
            
            
            
           
        } failed:^(NSError *error) {
           //failed get profile info
            if (failure) {
                failure(error,@"no-profile");
            }
            
        }];
    });
    
}

dispatch_queue_t backgroundQueue() {
    static dispatch_once_t queueCreationGuard;
    static dispatch_queue_t queue;
    dispatch_once(&queueCreationGuard, ^{
        queue = dispatch_queue_create("com.smartclick.instalker.backgroundQueue", 0);
    });
    return queue;
}

-(void)getDataForUser:(NSString *)username withCompletion:(completionFinal)completion
{
    
    [self clean];
    
   
    
    dispatch_async(backgroundQueue(), ^{
        
        [self getmediaOfUser:username forMonths:3 withCompletion:^(NSMutableArray *result) {
            _allMedia = result;
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_semaphore_t semant = dispatch_semaphore_create(0);
                
               [self getProfileInfoWith:username completion:^{
                    
                    dispatch_semaphore_signal(semant);
                    
                }failed:^(NSError *error) {
                    
                }];
                
                [self getCommentsForMedia:_allMedia withCompletion:^{
                    
                    dispatch_semaphore_signal(semant);
                    
                    
                }];
                
                [self getLikesForMedias:_allMedia withCompletion:^(NSMutableArray *result) {
                    
                    _followerList  = result;
                    dispatch_semaphore_signal(semant);
                    
                    
                }];
                
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                dispatch_semaphore_wait(semant, DISPATCH_TIME_FOREVER);
                
                
                StatsModel *model = [StatsModel new];
                [model setImageURLString:_profileImageURL
                                textName:_fullName
                           followerCount:_follewersCount
                            followsCount:_follewingsCount
                              totalLikes:_totalLikesCount
                          totalPostCount:_totalPostCount
                           totalComments:_totalComments
                                userName:_userName];
                
                if (completion) {
                    completion(_followerList,model);
                }
                
                
                
            });
            

            
        } withFailure:^(NSError *error) {
            //failed to get profile
        }];
    });



}

#pragma mark - Search Method

-(void)searchUsersWithKeyword:(NSString*)keyword completion:(completion)completion failed:(failed)failed
{
    [[InstagramEngine sharedEngine] searchUsersWithString:keyword withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        if (completion) {
            completion(users);
        }
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
        
    }];


}


@end
