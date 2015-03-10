//
//  ViewController.h
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

    @property (strong, nonatomic) IBOutlet UITableView *tableview;
    @property (strong, nonatomic) IBOutlet UISearchBar *searchBar;


- (IBAction)searchBar:(id)sender;


@end