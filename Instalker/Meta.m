//
//  Meta.m
//
//  Created by   on 07/03/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Meta.h"


NSString *const kMetaErrorMessage = @"error_message";
NSString *const kMetaErrorType = @"error_type";
NSString *const kMetaCode = @"code";


@interface Meta ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Meta

@synthesize errorMessage = _errorMessage;
@synthesize errorType = _errorType;
@synthesize code = _code;


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
            self.errorMessage = [self objectOrNilForKey:kMetaErrorMessage fromDictionary:dict];
            self.errorType = [self objectOrNilForKey:kMetaErrorType fromDictionary:dict];
            self.code = [[self objectOrNilForKey:kMetaCode fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.errorMessage forKey:kMetaErrorMessage];
    [mutableDict setValue:self.errorType forKey:kMetaErrorType];
    [mutableDict setValue:[NSNumber numberWithDouble:self.code] forKey:kMetaCode];

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

    self.errorMessage = [aDecoder decodeObjectForKey:kMetaErrorMessage];
    self.errorType = [aDecoder decodeObjectForKey:kMetaErrorType];
    self.code = [aDecoder decodeDoubleForKey:kMetaCode];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_errorMessage forKey:kMetaErrorMessage];
    [aCoder encodeObject:_errorType forKey:kMetaErrorType];
    [aCoder encodeDouble:_code forKey:kMetaCode];
}

- (id)copyWithZone:(NSZone *)zone
{
    Meta *copy = [[Meta alloc] init];
    
    if (copy) {

        copy.errorMessage = [self.errorMessage copyWithZone:zone];
        copy.errorType = [self.errorType copyWithZone:zone];
        copy.code = self.code;
    }
    
    return copy;
}


@end
