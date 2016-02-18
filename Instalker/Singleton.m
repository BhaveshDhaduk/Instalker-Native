//
//  Singleton.m
//  Instalker
//
//  Created by umut on 1/25/16.
//  Copyright © 2016 SmartClick. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton


+(Singleton*)sharedInstance
{
    static Singleton *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate,^{ _sharedInstance = [[Singleton alloc]init];});
    
    return  _sharedInstance;
}


-(id)init
{
 
    if (self) {
        self.accessToken = nil;
    }
    return self;
}


@end