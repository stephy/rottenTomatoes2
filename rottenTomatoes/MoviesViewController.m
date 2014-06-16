//
//  MoviesViewController.m
//  rottenTomatoes
//
//  Created by Stephani Alves on 6/8/14.
//  Copyright (c) 2014 stephanimoroni. All rights reserved.
//

#import "MoviesViewController.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import "MBProgressHUD.h"
#import "Reachability.h"


@interface MoviesViewController () {
    BOOL canRefresh;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSMutableArray *filteredMovies;
@property BOOL *isFiltered;


@end

@implementation MoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //title for main navigation controller
       self.title = @"Box Office";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //hide network error banner
    [self hideNetworkErrorView:YES];
    //load data
    [self loadData];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    //adding pull to refresh feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    //load personalized cell
    //registration process
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    //set row height
    self.tableView.rowHeight = 120;
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        self.isFiltered = NO;
    }else{
        self.isFiltered = YES;
        self.filteredMovies = [[NSMutableArray alloc] init];
        
        int i;
        int count = self.movies.count;
        //to be able to use the search bar
        //fast enumeration
        for (i=0; i<count; i++) {
            
            NSDictionary *currentMovie =[self.movies objectAtIndex:i];
            NSString *movieTitle = currentMovie[@"title"];
            NSRange movieTitleRange = [movieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            
            if (movieTitleRange.location != NSNotFound) {
                [self.filteredMovies addObject:currentMovie];
            }
        }
        
    }
    
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self dismissKeyboard];
}


#pragma mark - Table view methods
//number of rows
- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows you want in this table view
    
    //for filtered search
    if(self.isFiltered){
        return self.filteredMovies.count;
    }else{
        return self.movies.count;
    }
    
}

//what kind of data do you want in your table view?
//this is a personalized row view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    if (self.isFiltered) {
        //show filtered movies by the search bar
        NSDictionary *movie = self.filteredMovies[indexPath.row];
        cell.movieTitleLabel.text = movie[@"title"];
        cell.synopsisLabel.text = movie[@"synopsis"];
        NSString *posterUrlThumbnail = movie[@"posters"][@"thumbnail"];
        //Asynchronously load the image
        [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrlThumbnail]];
    }else{
        //show all movies
        NSDictionary *movie = self.movies[indexPath.row];
        cell.movieTitleLabel.text = movie[@"title"];
        cell.synopsisLabel.text = movie[@"synopsis"];
        NSString *posterUrlThumbnail = movie[@"posters"][@"thumbnail"];
        //Asynchronously load the image
        [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrlThumbnail]];
    }
    return cell;
}

//on row click open detailed view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //dismiss keyboard
    [self dismissKeyboard];
    Movie *movie;
    
    if (self.isFiltered) {
        movie = self.filteredMovies[indexPath.row];
    }else{
        movie = self.movies[indexPath.row];
    }
    
    MovieViewController *mvc = [[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:[NSBundle mainBundle]];
    mvc.currentMovie = movie;
    [self.navigationController pushViewController:mvc animated:YES];
}


#pragma mark - Support for network error

- (BOOL) connectedToNetwork {
    Reachability *r = [Reachability reachabilityWithHostName:@"rottentomatoes.com"];
    
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
    
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

-(BOOL) checkInternet {
    NSLog(@"Checking internet");
	//Make sure we have internet connectivity
	if([self connectedToNetwork] != YES) {
        [self hideNetworkErrorView:NO];
		return NO;
	} else {
        [self hideNetworkErrorView:YES];
		return YES;
	}
}


-(void)hideNetworkErrorView: (BOOL)status {
    if (status) {
        //resize to 0,0
        self.networkErrorView.hidden = YES;
        CGRect newFrame = self.networkErrorView.frame;
        
        newFrame.size.height = 0;
        [self.networkErrorView setFrame:newFrame];
        
    }else{
        //resize to 0, 50
        self.networkErrorView.hidden = NO;
        CGRect newFrame = self.networkErrorView.frame;
        
        newFrame.size.height = 50;
        [self.networkErrorView setFrame:newFrame];
    }
}


-(void)loadData {
    
    BOOL internet = [self checkInternet];
    
    //only load data if there's internet
    if (internet) {
         NSLog(@"internet ok");
        //add loader
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            //load data from rotten tomattoes
            
            //set up network call
            NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            //callback
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                self.movies = object[@"movies"];
                //without this table loads empty
                [self.tableView reloadData];
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
        
    }//end of if
    else{
        //network error
        NSLog(@"no internet connection");
        [self hideNetworkErrorView:NO];
    }
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadData];
    [refreshControl endRefreshing];
}


-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}
@end
