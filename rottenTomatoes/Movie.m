//
//  Movie.m
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary: (NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.movieTitle = dictionary[@"title"];
        self.synopsis = dictionary[@"synopsis"];
        //self.posterImageURL = dictionary[@"thumbnail"];
    }
    
    return self;
}

+ (NSArray *)moviesWithArray: (NSArray *)array {
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in array){
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movies addObject:movie];
    }
    
    return movies;
}

@end
