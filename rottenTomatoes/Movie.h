//
//  Movie.h
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic, strong) NSString *movieTitle;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *posterImageURL;


- (id)initWithDictionary: (NSDictionary *)dictionary;
+ (NSArray *)moviesWithArray: (NSArray *)array;

@end
