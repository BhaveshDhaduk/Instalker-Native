//
//  Meta.h
//
//  Created by   on 07/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Meta : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, strong) NSString *errorType;
@property (nonatomic, assign) double code;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
