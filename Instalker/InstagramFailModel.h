//
//  InstagramFailModel.h
//
//  Created by   on 07/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meta;

@interface InstagramFailModel : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) Meta *meta;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
