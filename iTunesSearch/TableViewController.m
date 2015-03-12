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

@interface TableViewController () {
    NSArray *midias;
    NSMutableArray *songs, *movies, *others, *organiz;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    songs = [[NSMutableArray alloc] init];
    movies = [[NSMutableArray alloc] init];
    organiz = [[NSMutableArray alloc] init];
    
    
    UINib *nib = [UINib nibWithNibName:@"TableViewCell" bundle:nil];
    [self.tableview registerNib:nib forCellReuseIdentifier:@"celulaPadrao"];
    
// Necessario para que a table view tenha um espaco em relacao ao topo, pois caso contrario o texto ficara atras da barra superior
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.tableview.bounds.size.width, 70.f);
    
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
    // Dispose of any resources that can be recreated.
}


#pragma mark - Metodos do UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return @"Songs"; break;
        case 1:
            return @"Movies"; break;
            
        default:
            return @"Outros";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
    case 0:
        return songs.count; break;
    case 1:
        return [movies count]; break;
        
    default:
        return others.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *celula = [self.tableview dequeueReusableCellWithIdentifier:@"celulaPadrao"];
    
    Product *prod = [organiz objectAtIndex:indexPath.row];
    
    //if (indexPath.section == 0){    //Se a celula atual for da section 0 (songs)
    //}
    
    //if ([prod.tipo isEqual:@"Song"] && (indexPath.section == 0)) {

        [celula.nome setText:prod.nome];
        [celula.tipo setText: prod.tipo];
         //[celula.tipo setText: [prod.tipo capitalizedString]];
        [celula.genero setText: prod.genero];
    
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
    [organiz removeAllObjects];
    //Adicionar outros aqui
    
    for(Product *p in midias){
        //NSLog(p.tipo);
        if([p.tipo isEqualToString:@"song"])
            [songs addObject: p];
        if([p.tipo isEqualToString:@"feature-movie"])
            [movies addObject: p];
        //Adicionar outros aqui
        else [others addObject: p];
    }
    [organiz addObjectsFromArray: songs];
    [organiz addObjectsFromArray: movies];
    [organiz addObjectsFromArray: others];
    //Adicionar outros aqui
    [self.tableview reloadData];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_searchBar resignFirstResponder];
}


@end
