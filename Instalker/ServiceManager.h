//
//  ServiceManager.h
//  Instalker
//
//  Created by umut on 1/26/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion)(NSMutableArray *result);

@interface ServiceManager : NSObject

+(ServiceManager *)sharedManager;

-(id)init;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSMutableArray *followerList;


@property (nonatomic,strong) NSMutableDictionary *reducedLikeList;
@property (nonatomic,strong) NSMutableArray *arrayLikes;



-(void )getMediasWithCompletion:(completion)completion;



@end
