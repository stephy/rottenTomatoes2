//
//  MovieViewController.m
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MovieViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation MovieViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *current = (NSDictionary *)self.currentMovie;
    
    self.movieTitleLabel.text = [current objectForKey:@"title"];
    self.synopsisLabel.text = [current objectForKey:@"synopsis"];

    
    NSCache *memoryCache; //assume there is a memoryCache for images or videos
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *urlString = [current objectForKey:@"posters"][@"original"];
        
        NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        
        if (downloadedData) {
            
            // STORE IN FILESYSTEM
            NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *file = [cachesDirectory stringByAppendingPathComponent:urlString];
            [downloadedData writeToFile:file atomically:YES];
            
            // STORE IN MEMORY
            [memoryCache setObject:downloadedData forKey:urlString];
        }
        
        // NOW YOU CAN CREATE AN AVASSET OR UIIMAGE FROM THE FILE OR DATA
        [self.poster setImageWithURL:[NSURL URLWithString:urlString]];
    });
    
    
    //NSString *posterUrlThumbnail = [current objectForKey:@"posters"][@"original"];
    
    //make poster fade in
    self.poster.alpha = 0.0;
    
    //Asynchronously load the image
    //[self.poster setImageWithURL:[NSURL URLWithString:urlString]];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.poster.alpha = 1;
    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
