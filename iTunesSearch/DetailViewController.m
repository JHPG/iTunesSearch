//
//  DetailViewController.m
//  iTunesSearch
//
//  Created by Jorge Henrique P. Garcia on 3/13/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imgDetails setImage:_product.img];
    [_tipoMidia setText: [_product.tipo capitalizedString]];
    [_nome setText: _product.nome];
    [_artist setText:_product.artista];
    [_genre setText:_product.genero];
    [_duracao setText:_product.genero];
    [_country setText:_product.pais];
     
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
