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
    _followerList = [NSMutableArray array];
    _reducedLikeList = [NSMutableDictionary dictionary];
    _arrayLikes = [NSMutableArray array];
    _allMedia = [NSMutableArray array];
    _dictUserMedia = [NSMutableDictionary dictionary];
    _arrayComments =nil;
    
    _fullName =nil;
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
-(BOOL)cropMediaByDate:(NSArray*)media  days:(NSInteger)numberOfDays{
    for (id medium in media) {
        InstagramMedia *currentMedia = (InstagramMedia *)medium;
        if ([self isMediaLaterThanInterval:currentMedia.createdDate forDays:numberOfDays]) {
            [_allMedia addObject:currentMedia];
            
        }else
        {
            return NO;
        }
    
    }
    return YES;
}


-(void)getmediaOfUser:(NSString *)userID forDays:(NSInteger)numberOfdays withCompletion:(completion)completion withFailure:(failed)failed
{
    [[InstagramEngine sharedEngine] getMediaForUser:userID withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
    
        if ([self cropMediaByDate:media days:numberOfdays]) {
            
            if (paginationInfo.nextURL) {
                [self getPaginatedData:paginationInfo completion:^{
                    if (completion) {
                        completion((NSMutableArray *)media);
                    }
                } numberOfDays:numberOfdays failed:^(NSError *error) {
                    if (failed) {
                        failed(error);
                    }
                }];
            }
            else
            {
                if (completion) {
                    completion(media);
                }
            
            }
            
        }else
        {
            if (completion) {
                completion((NSMutableArray *)media);
            }
            
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
        
    }];
    
}

-(void)handleError:(NSError *)error completion:(errorHandle)completion
{
    NSInteger tokenCount =[[[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.response"]allHeaderFields]objectForKey:@"x-ratelimit-remaining"];
    NSHTTPURLResponse *response = error.userInfo;
    NSURL *errorUrl = [error.userInfo objectForKey:@"NSErrorFailingURLKey"];
  
    [self getFailModel:errorUrl withCompletion:^(InstagramFailModel *model) {
        if (completion) {
            completion(model);
        }
    }];
    

}

-(void)getFailModel:(NSURL *)url withCompletion:(completionErrorDetail)completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        InstagramFailModel *response = [[InstagramFailModel alloc]initWithDictionary:(NSDictionary *)responseObject];
        if (completion) {
            completion(response);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        InstagramFailModel *response = [[InstagramFailModel alloc]initWithDictionary:(NSDictionary *)operation.responseObject];
        if (completion) {
            completion(response);
        }
        // 4
       
    }];
    
    // 5
    [operation start];


}

-(void)getPaginatedData:(InstagramPaginationInfo *)pagination completion:(completionRaw)completion numberOfDays:(NSInteger)numberOfDays failed:(failed)failed
{
    [[InstagramEngine sharedEngine]getPaginatedItemsForInfo:pagination withSuccess:^(NSArray<InstagramModel *> * _Nonnull paginatedObjects, InstagramPaginationInfo * _Nonnull paginationInfo) {
     
        if ([self cropMediaByDate:paginatedObjects days:numberOfDays]) {
            
            if (paginationInfo.nextURL) {
                
                [self getPaginatedData:paginationInfo completion:completion numberOfDays:numberOfDays failed:failed];
                
            }else
            {
                if (completion)
                    completion();
            }
        }else
        {
            if(completion)
                completion();
            
        }
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (completion) {
            completion();
        }
        
        
    }];
    
    
}



-(void )getMediasWithCompletion:(completion)completion failed:(failed)failed numberOfDate:(kMediaDate)numberOfdays
{
    
    
    [[InstagramEngine sharedEngine] getSelfRecentMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
        if ([self cropMediaByDate:media days:numberOfdays]) {
            
            if (paginationInfo.nextURL) {
                [self getPaginatedData:paginationInfo completion:^{
                    if (completion) {
                        completion((NSMutableArray *)media);
                    }
                } numberOfDays:numberOfdays failed:failed];
            }else
            {
                if (completion) {
                    completion(media);
                }
            
            }
            
        }else
        {
            if (completion) {
                completion((NSMutableArray *)media);
            }
            
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failed) {
            failed(error);
        }
    }];
}


#pragma mark - Sort Media By Date Intervals
-(BOOL)isMediaLaterThanInterval:(NSDate *)date forDays:(NSInteger)numberOfDays
{
    NSDate *startDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-numberOfDays];
    startDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:startDate options:0];
    
    if ([date isEqualToDate:[date laterDate:startDate]]) {
        return YES;
    }
    
    
    return NO;
}

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

#pragma mark - Media Helper

-(void)allUsersForMedia:(InstagramMedia *)media users:(NSArray *)users
{
    for (int i = 0; i< users.count; i++) {
        [self addMediaId:media ForUser:(InstagramUser *)[users objectAtIndex:i]];
    }

}

-(void)addMediaId:(InstagramMedia *)media ForUser:(InstagramUser *)user
{
    if ([_dictUserMedia objectForKey:user.username]) {
        NSMutableArray *arr = [_dictUserMedia objectForKey:user.username];
        [arr addObject:media];
        [_dictUserMedia setObject:arr forKey:user.username];
        
    }
    else
    {
        NSMutableArray *arr = [NSMutableArray arrayWithObjects:media, nil];
        [_dictUserMedia setObject:arr forKey:user.username];
        
    
    }
    
    

}


#pragma mark - Likes For Medias
-(void)getLikesOnMedia:(InstagramMedia *)media  index:(NSInteger)index withCompletion:(completionRaw)completion failure:(failed)failure{
    [[InstagramEngine sharedEngine] getLikesOnMedia:media.Id withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        [self allUsersForMedia:media users:users];
        [[_arrayLikes objectAtIndex:index] addObjectsFromArray:users];
        
        if (paginationInfo.nextURL) {
            
            [self getPaginatedLikesOnMediaWithPagination:paginationInfo index:0 completion:completion failure:failure];
            
        }else
        {
            if (completion)
                completion();
        }

    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)getPaginatedLikesOnMediaWithPagination:(InstagramPaginationInfo *)pagination index:(NSInteger)index completion:(completionRaw)completion failure:(failed)failure
{
    [[InstagramEngine sharedEngine]getPaginatedItemsForInfo:pagination withSuccess:^(NSArray<InstagramModel *> * _Nonnull paginatedObjects, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        [[_arrayLikes objectAtIndex:index] addObjectsFromArray:paginatedObjects];
        if (paginationInfo.nextURL) {
            [self getPaginatedLikesOnMediaWithPagination:paginationInfo index:index completion:completion failure:failure];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        if (failure) {
            failure(error);
        }
    }];

}



-(void)getLikesForMedias:(NSArray *)media withCompletion:(completion)completion iterationBlock:(iterationBlock)iteration failed:(failed)failed
{
    _arrayLikes = [NSMutableArray array];
 
    _reducedLikeList = [NSMutableDictionary dictionary];
    _totalLikesCount = 0;
    
                                 
    for (NSInteger i = 0; i < media.count; ++i)
    {
        [_arrayLikes addObject:[NSMutableArray array]];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        __block int ready=0;
        
        for (int i = 0 ; i< media.count ; i++) {
            InstagramMedia *dict = [media objectAtIndex:i];
            
//            NSString *mediaID = dict.Id;
            
            [self getLikesOnMedia:dict index:i withCompletion:^{
                ready++;
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }
                if(iteration){
                    _iterationPercantage = _iterationPercantage + _iterationToken;
                    iteration(_iterationPercantage);
                }
                
            } failure:^(NSError *error) {
                ready++;
                if (failed) {
                    failed(error);
                }
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }
                if(iteration){
                    _iterationPercantage = _iterationPercantage + _iterationToken;
                    iteration(_iterationPercantage);
                }
                
            }];
        }
        if (media.count > 0) {
            
        }
        else
            dispatch_semaphore_signal(sema);
       
        
      
        
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        NSMutableDictionary *users = [NSMutableDictionary dictionary];
        
        NSMutableArray *arrayLinearLikes = [NSMutableArray array];
        for(int k = 0; k<_arrayLikes.count; k++)
        {
            [arrayLinearLikes addObjectsFromArray:[_arrayLikes objectAtIndex:k]];
        
        }
        _totalLikesCount = arrayLinearLikes.count;
        
        for (InstagramUser *usr  in arrayLinearLikes) {
            
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
            obj.arrayMedias = [NSMutableArray arrayWithArray:[_dictUserMedia objectForKey:obj.user.username]];
            [orderedUserLike addObject:obj];
            
        }
        
        //reduce th array
        if (completion) {
            completion(orderedUserLike);
        }
        
    });
    
}

#pragma mark - Comments

-(void)getCommentsForMedia:(NSArray *)media withCompletion:(completionRaw)completion failure:(failed)failed
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
                if (failed) {
                    failed(error);
                }
                ready++;
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }

            }];
            
            
        }
        dispatch_semaphore_signal(sema);
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        if (completion) {
            completion();
        }
        
    });
    
    
    
    
}


#pragma mark - Final Methods

-(void)getSelfDataWithCompletion:(completionFinal)completion  failure:(failure)failure dateinterval:(kMediaDate)numberofDays
{
    [self clean];
    
   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self getMediasWithCompletion:^(NSMutableArray *result) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_semaphore_t semant = dispatch_semaphore_create(0);
                
                [self getMyProfileInfoWithCompletion:^{
                 
                    dispatch_semaphore_signal(semant);
                   
                }failed:^(NSError *error) {
                    
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];
                    
                    
                    dispatch_semaphore_signal(semant);
                    
                }];
                
                [self getCommentsForMedia:_allMedia withCompletion:^{
                 
                    dispatch_semaphore_signal(semant);
                    
                    
                }failure:^(NSError *error) {
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];
                }];
                
                [self getLikesForMedias:_allMedia withCompletion:^(NSMutableArray *result) {
                    
                    _followerList  = result;
                     dispatch_semaphore_signal(semant);
                    
                    
                } iterationBlock:nil failed:^(NSError *error) {
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];
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
                                userName:_userName
                       filteredPostCount:_allMedia.count];
                
                if (completion) {
                    completion(_followerList,model);
                }

                
                
            });
            
            
           
        } failed:^(NSError *error) {
           //failed get profile info
            [self handleError:error completion:^(InstagramFailModel *model) {
                if (failure) {
                    failure(error,model);
                }
            }];
            
        }numberOfDate:numberofDays];
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

-(void)getDataForUser:(NSString *)username mediaInterval:(kMediaDate)interval  withCompletion:(completionFinal)completion withCounting:(iterationBlock)iteration failure:(failure)failure
{
    
    [self clean];
    

    
    dispatch_async(backgroundQueue(), ^{
        
        [self getmediaOfUser:username forDays:interval withCompletion:^(NSMutableArray *result) {
           
            _iterationToken  = 100.0 / _allMedia.count;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                
                dispatch_semaphore_t semant = dispatch_semaphore_create(0);
                
               [self getProfileInfoWith:username completion:^{
                    
                    dispatch_semaphore_signal(semant);
                    
                }failed:^(NSError *error) {
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];                }];
                
                [self getCommentsForMedia:_allMedia withCompletion:^{
                    
                    dispatch_semaphore_signal(semant);
                    
                    
                }failure:^(NSError *error) {
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];
                }];
                
                [self getLikesForMedias:_allMedia withCompletion:^(NSMutableArray *result) {
                    
                    _followerList  = result;
                    dispatch_semaphore_signal(semant);
                    
                    
                } iterationBlock:iteration failed:^(NSError *error) {
                    [self handleError:error completion:^(InstagramFailModel *model) {
                        if (failure) {
                            failure(error,model);
                        }
                    }];
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
                                userName:_userName
                 filteredPostCount:_allMedia.count];
                
                if (completion) {
                    completion(_followerList,model);
                }
                
                
                
            });
            

            
        } withFailure:^(NSError *error) {
            //failed to get profile
            [self handleError:error completion:^(InstagramFailModel *model) {
                if (failure) {
                    failure(error,model);
                }
            }];
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
