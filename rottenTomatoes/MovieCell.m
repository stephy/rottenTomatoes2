//
//  MovieCell.m
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MovieCell.h"

@implementation MovieCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(selected){
        NSLog(@"selected");
        [self setBackgroundColor:[UIColor blackColor]];
        self.movieTitleLabel.textColor = [UIColor whiteColor];
        self.synopsisLabel.textColor = [UIColor whiteColor];
    } else {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.movieTitleLabel.textColor = [UIColor blackColor];
        self.synopsisLabel.textColor = [UIColor blackColor];
        
    }
}

@end
