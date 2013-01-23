//
//  ViewController.h
//  MovieApp
//
//  Created by Myth James on 1/19/13.
//  Copyright (c) 2013 Myth James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,UISearchBarDelegate>
{

}
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableData *webData;
@property (nonatomic,strong) NSMutableData *posterData;
@property (nonatomic,strong) NSMutableArray *movieKeys;
@property (nonatomic,strong) NSMutableArray *movies;
@property (nonatomic,strong) NSURLConnection *connectionMovieJson;

@end
