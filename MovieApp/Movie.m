//
//  Movie.m
//  MovieApp
//
//  Created by Myth James on 1/20/13.
//  Copyright (c) 2013 Myth James. All rights reserved.
//

#import "Movie.h"

@implementation Movie
{
    
}
@synthesize title,year,posterUrl;

//Initialize movie data and other stuff when object created php-> __construct()
-(id)init {
    if (self = [super init])  {
        self.year = @"0000";
    }
    return self;
}

@end
