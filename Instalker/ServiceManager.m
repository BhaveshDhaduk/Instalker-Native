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

-(void)getMyProfileInfo
{
    [[InstagramEngine sharedEngine] getSelfUserDetailsWithSuccess:^(InstagramUser * _Nonnull user) {
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];

}
-(void)getProfileInfoWith:(NSString *)userID
{
    [[InstagramEngine sharedEngine]getUserDetails:userID withSuccess:^(InstagramUser * _Nonnull user) {
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
}

-(void)getFollowersOfUser:(NSString *)userID
{
    [[InstagramEngine sharedEngine]getFollowersOfUser:userID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
}

-(void )getFollowsOfUser:(NSString *)userID{
    
   [[InstagramEngine sharedEngine] getUsersFollowedByUser:userID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
        
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
    }];
    
}

-(void)getmediaOfUser:(NSString *)userID forMonths:(NSInteger)numberOfMonth
{
    [[InstagramEngine sharedEngine] getMediaForUser:userID withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
       
        [self getLikesForMedias:media withCompletion:^(NSMutableArray *result) {
            
        }];
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        
        
    }];

}


-(void )getMediasWithCompletion:(completion)completion{

    
   [[InstagramEngine sharedEngine] getSelfRecentMediaWithSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
       
       [self getLikesForMedias:media withCompletion:^(NSMutableArray *result) {
           if (completion) {
               completion(result);
           }
           
       }] ;
       
   } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
       
   }];
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



-(void)getLikesForMedias:(NSArray *)media withCompletion:(completion)completion
{
    _arrayLikes = [NSMutableArray array];
    _reducedLikeList = [NSMutableDictionary dictionary];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
      
        __block int ready=0;

        for (InstagramMedia *dict in media) {
            
            NSString *mediaID = dict.Id;
            
            [[InstagramEngine sharedEngine] getLikesOnMedia:mediaID withSuccess:^(NSArray<InstagramUser *> * _Nonnull users, InstagramPaginationInfo * _Nonnull paginationInfo) {
                
                
                [_arrayLikes addObjectsFromArray:users];
                ready++;
                
                if (ready+1 > media.count) {
                    dispatch_semaphore_signal(sema);
                }

                
            } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                dispatch_semaphore_signal(sema);
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



@end
