//
//  DetailViewController.h
//  iTunesSearch
//
//  Created by Jorge Henrique P. Garcia on 3/13/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"

@interface DetailViewController : UIViewController

@property Product *product;

@property (weak, nonatomic) IBOutlet UIImageView *imgDetails;
@property (weak, nonatomic) IBOutlet UILabel *nome;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UILabel *genre;
@property (weak, nonatomic) IBOutlet UILabel *duracao;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *price;



@end
