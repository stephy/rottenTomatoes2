//
//  DVDCell.h
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/15/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVDCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UIImageView *posterView;

@end
