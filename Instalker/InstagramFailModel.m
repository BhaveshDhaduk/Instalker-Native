//
//  InstagramFailModel.m
//
//  Created by   on 07/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "InstagramFailModel.h"
#import "Meta.h"


NSString *const kInstagramFailModelMeta = @"meta";


@interface InstagramFailModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation InstagramFailModel

@synthesize meta = _meta;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.meta = [Meta modelObjectWithDictionary:[dict objectForKey:kInstagramFailModelMeta]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.meta dictionaryRepresentation] forKey:kInstagramFailModelMeta];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.meta = [aDecoder decodeObjectForKey:kInstagramFailModelMeta];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_meta forKey:kInstagramFailModelMeta];
}

- (id)copyWithZone:(NSZone *)zone
{
    InstagramFailModel *copy = [[InstagramFailModel alloc] init];
    
    if (copy) {

        copy.meta = [self.meta copyWithZone:zone];
    }
    
    return copy;
}


@end
