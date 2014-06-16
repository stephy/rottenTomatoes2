//
//  MovieViewController.m
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MovieViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "AFHTTPRequestOperation.h"

@interface MovieViewController ()
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UIImage *posterImage;
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
        
        //load image
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath =  [[paths objectAtIndex:0] stringByAppendingPathComponent:@"tempPath"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: urlString]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.posterImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            [self.poster setImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]]];
            self.posterImage = [UIImage imageWithData:[NSData dataWithContentsOfFile:filePath]];
            
        }];
        
        [operation start];

        
        
    });
    
    //make poster/image fade in
    self.poster.alpha = 0.0;
    
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
