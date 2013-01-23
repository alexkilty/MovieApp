//
//  ViewController.m
//  MovieApp
//
//  Created by Myth James on 1/19/13.
//  Copyright (c) 2013 Myth James. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "AFNetworking.h"

#define MY_CUSTOM_TAG 1234

@interface ViewController ()
{
    
}
@end

@implementation ViewController
@synthesize movieKeys,webData,searchBar = _searchBar,movies,connectionMovieJson,tableView;

/**
 * tableView  Methods.
 *
 * @param  string    $method
 * @param  array     $parameters
 * @return Response
 */

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"ROWS");
    return [movieKeys count];
}

-(UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //set identifier
    static NSString *CellIdentifier = @"Cell";
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 61, 91)];

    //Use available table cells and not create new one. Faster scroll and keep memory tight
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITabBarSystemItemFeatured reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.numberOfLines=0;
        NSLog(@"Cell loaded");
    }else{
        NSLog(@"Cell re-used");

    }
    //Removes Poster Image from cell
    [[cell.contentView viewWithTag:MY_CUSTOM_TAG]removeFromSuperview] ;

    Movie *currentMovie=[movieKeys objectAtIndex:[indexPath row]];
    [[cell detailTextLabel] setText:currentMovie.title];
    [[cell textLabel] setText:currentMovie.year];
    [imgView setImageWithURL:currentMovie.posterUrl];
    imgView.tag = MY_CUSTOM_TAG;
    [cell.contentView addSubview:imgView];
    return cell;
}

//Change at some point to resize according to text as thumbnails are same
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 100.0f;
}


/**
 * connection Methods for connectionMovieJson. Change to use AFNetworking at some point.
 *
 * @param  string    $method
 * @param  array     $parameters
 * @return Response
 */

-(void)connection:(NSURLConnection *)connectionMovieJson didReceiveResponse:(NSURLResponse *)response{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)connectionMovieJson didReceiveData:(NSData *)data{
    //Grabs data and puts it in webData
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connectionMovieJson didFailWithError:(NSError *)error{
    NSLog(@"FAILED You Cow!");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connectionMovieJson{
    
    //Serialize the Data to a dictionary
    NSDictionary *allData = [NSJSONSerialization JSONObjectWithData:webData options:0 error:nil];
    
    //If total = 0 then error message! -- else build up movieKeys mutablearray
    NSString *total = [NSString stringWithFormat:@"%@",[allData objectForKey:@"total"]];
    
    //For some reason if I compare it to 0 it wont work..--FIXED was comparing Pointers to string objects use isEqualToString!!
    if ([total isEqualToString:@"0"]) {
        UIAlertView *myAlert = [[UIAlertView alloc]
                                initWithTitle:@"Oups - Not Found"
                                message:@"We couldn't find a movie with that title, how about you try again!"
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [myAlert show];
    }
    else {
        //Get the movie array of each movie
        movies = [allData objectForKey:@"movies"];
        
        //Loop through movies as movie and get the info
        for (NSDictionary *movie in movies) {
            
            //title
            NSString *title = [movie objectForKey:@"title"];
            
            //image url
            NSDictionary *imgUrlsDictionary = [movie objectForKey:@"posters"];
            NSString *imgUrlString=[imgUrlsDictionary objectForKey:@"thumbnail"];
            NSURL *imgUrl = [NSURL URLWithString:imgUrlString];
            
            //year of release
            NSString *year = [NSString stringWithFormat:@"%@",[movie objectForKey:@"year"]];
            //Create the Movie object and add it to mutable array
            Movie *movieObject = [[Movie alloc]init];
            movieObject.title = title;
            if (![year isEqual:@""]) {
                movieObject.year=year;
            }
            movieObject.posterUrl=imgUrl;
            [movieKeys addObject:movieObject];            
        }
        [tableView reloadData];
    }
}
/**
 * searchBar Methods.
 * searchBarSearchButtonClicked uses Native connection. Switch to JSONKIT!
 *
 * @param  string    $method
 * @param  array     $parameters
 * @return Response
 */

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //Remove objects for search incase of re-search
    [movieKeys removeAllObjects];
    //Reload tableView data -- to delete existing movies in cells
    [tableView reloadData];
    NSLog(@"Clickity clack that search button");
    [self dismissKeyboard:searchBar];
    
    //Grab query from search bar
    NSString *query = searchBar.text;
    
    //Encode query for url
    NSString *queryEncoded= CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                            (CFStringRef) query,
                                            NULL,
                                            (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8));
    
    //Create the url string
    NSString *urlString =[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?apikey=sznmfjnwdzvsjmub76sxft2p&q=%@",queryEncoded];
    
    //Turns the urlString into a NSURL
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //Connection stuff
    connectionMovieJson = [NSURLConnection connectionWithRequest:request delegate:self];
    if (connectionMovieJson) {
        webData = [[NSMutableData alloc]init];
    }
}


-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    NSLog(@"You are typing!!");
    //Autofeed stuff in UITable at some point or something.
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self dismissKeyboard:searchBar];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {    
    [searchBar setShowsCancelButton:YES animated:YES];
    
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {    
    [searchBar setShowsCancelButton:NO animated:YES];
    [self dismissKeyboard:searchBar];

    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self dismissKeyboard:searchBar];
}

//Keyboard goes away -- In function just incase of logging or doing something while keyboard goes away.
- (void)dismissKeyboard:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // if you want the keyboard to go away
}

/**
 * Normal viewDidLoad method etc.
 *
 * @param  string    $method
 * @param  array     $parameters
 * @return Response
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _searchBar.delegate = (id)self;
    _searchBar.placeholder = @"Search for a movie";
    
    //Initialize mutable array for movieKeys which holds movie objects
    movieKeys = [[NSMutableArray alloc]init];
    
    //Fix some title in the begining
    CGRect titleRect = CGRectMake(0, 0, 20, 40);
    UILabel *tableTitle = [[UILabel alloc] initWithFrame:titleRect];
    tableTitle.textColor = [UIColor orangeColor];
    tableTitle.backgroundColor = [tableView backgroundColor];
    tableTitle.font = [UIFont fontWithName:@"Party LET" size:35];
    tableTitle.text = @"Movies";
    tableView.tableHeaderView = tableTitle;
    // learn to Center :p change the old uitextalignment to something else
    [tableTitle setTextAlignment:UITextAlignmentCenter];
    [tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
