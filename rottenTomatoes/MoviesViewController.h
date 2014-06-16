//
//  MoviesViewController.h
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "MovieCell.h"
#import "MovieViewController.h"

//implementing a protocol (interface)
@interface MoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@end
