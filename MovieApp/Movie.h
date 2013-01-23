//
//  Movie.h
//  MovieApp
//
//  Created by Myth James on 1/20/13.
//  Copyright (c) 2013 Myth James. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *year;
@property (nonatomic,strong) NSURL *posterUrl;

@end

