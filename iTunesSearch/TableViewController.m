//
//  ViewController.m
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "iTunesManager.h"
#import "Entidades/Product.h"
#import "DetailViewController.h"

@interface TableViewController () {
    NSArray *midias;
    NSMutableArray *songs, *movies, *podcast, *ebook, *others;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    songs = [[NSMutableArray alloc] init];
    movies = [[NSMutableArray alloc] init];
    podcast = [[NSMutableArray alloc] init];
    ebook = [[NSMutableArray alloc] init];
    others = [[NSMutableArray alloc] init];
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    
// Necessario para que a table view tenha um espaco em relacao ao topo, pois caso contrario o texto ficara atras da barra superior
    CGRect frame = CGRectMake(0.0f, 0.0f, self.tableview.bounds.size.width, 70.f);
    
    UINavigationItem *nItem = [[UINavigationItem alloc] init];
    [nItem setTitle: @"iTunes Search"];
    //[self.navigationController.navigationBar addSubview: nItem]; //n funicona
    
    
    self.tableview.tableHeaderView = [[UIView alloc] initWithFrame: frame];
    _searchBar = [[UISearchBar alloc] initWithFrame: frame];
    
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _searchBar.placeholder = NSLocalizedString(@"pesquisa", nil);
    
    [self.tableview.tableHeaderView addSubview: _searchBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Metodos do UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sec = nil;
    
    switch (section) {
        case 0:
            if(songs.count>0) sec= NSLocalizedString(@"musicas", nil); break;
        case 1:
            if(movies.count>0) sec=  NSLocalizedString(@"filmes", nil); break;
        case 2:
            if(podcast.count>0) sec=  NSLocalizedString(@"podcast", nil); break;
        case 3:
            if(ebook.count>0) sec= NSLocalizedString(@"ebook", nil); break;
            
        default:
            if(others.count>0) sec= NSLocalizedString(@"outros", nil);
    }
    return sec;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return songs.count; break;
        case 1:
            return [movies count]; break;
        case 2:
            return podcast.count; break;
        case 3:
            return [ebook count]; break;
            
        default:
            return others.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *celula = [self.tableview dequeueReusableCellWithIdentifier:@"celulaPadrao"];
    
    
    
    Product *prod = nil;
    switch (indexPath.section) {
        case 0 :
            prod = [songs objectAtIndex:indexPath.row]; break;
        case 1 :
            prod = [movies objectAtIndex:indexPath.row]; break;
        case 2 :
            prod = [podcast objectAtIndex:indexPath.row]; break;
        case 3 :
            prod = [ebook objectAtIndex:indexPath.row]; break;
        default:
            prod = [others objectAtIndex:indexPath.row];
            break;
    }
    
    [celula.nome setText:prod.nome];
    [celula.tipo setText: [prod.tipo capitalizedString]];   //Title case
    [celula.genero setText: prod.genero];
    [celula.artist setText: prod.artista];
    
    return celula;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)searchBarSearchButtonClicked: (UISearchBar*)searchBar
{
    iTunesManager *itunes = [iTunesManager sharedInstance];
    
    NSString *texto = searchBar.text;
    texto = [texto stringByReplacingOccurrencesOfString:@" " withString:@"-"];

    midias = [itunes buscarMidias: texto];
    
    [songs removeAllObjects];
    [movies removeAllObjects];
    [others removeAllObjects];
    //Adicionar outros aqui
    
    for(Product *p in midias){
        
        if([p.tipo isEqualToString:@"song"])
            [songs addObject: p];
        else if([p.tipo isEqualToString:@"feature-movie"])
            [movies addObject: p];
        else if([p.tipo isEqualToString:@"podcast"])
            [podcast addObject: p];
        else if([p.tipo isEqualToString:@"ebook"])
            [ebook addObject: p];
        
        //Adicionar outros aqui
        else [others addObject: p];
    }
    
    //Adicionar outros aqui
    [self.tableview reloadData];
    [_searchBar resignFirstResponder];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   
    [_searchBar resignFirstResponder];
   [self resignFirstResponder];
    
    [self.searchBar endEditing:YES];
    
    self.tableview.editing = NO;
    [self.tableview endEditing:YES];
    
    self.editing = NO;
    
    NSLog(@"touch event dispared");
    
    //Nada funciona

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *view = [[DetailViewController alloc] init];
    
    switch (indexPath.section) {
        case 0 :
            view.product = [songs objectAtIndex:indexPath.row]; break;
        case 1:
            view.product = [movies objectAtIndex:indexPath.row]; break;
        case 2:
            view.product = [podcast objectAtIndex:indexPath.row]; break;
        case 3:
            view.product = [ebook objectAtIndex:indexPath.row]; break;
        default:
            view.product = [others objectAtIndex:indexPath.row]; break;
    }
    [self.navigationController pushViewController:view animated:YES];
}

@end







