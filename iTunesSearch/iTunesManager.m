//
//  iTunesManager.m
//  iTunesSearch
//
//  Created by joaquim on 09/03/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "iTunesManager.h"
#import "Entidades/Product.h"

@implementation iTunesManager

static iTunesManager *SINGLETON = nil;

static bool isFirstAccess = YES;
NSDictionary *resultado;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}


- (NSArray *)buscarMidias:(NSString *)termo {
    if (!termo) {
        termo = @"";
    }
    
    NSString *url = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@&media=all", termo];
    
    NSError *error;
    
    @try{
        NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        NSDictionary *resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                error:&error];
    } @catch(NSException *e){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erro"
                    message:@"Aparentemente o serviço está indisponível no momento. Tente mais tarde."
                    delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
    if (error) {
        NSLog(@"Não foi possível fazer a busca. ERRO: %@", error);
        return nil;
    }
    
    NSArray *resultados = [resultado objectForKey:@"results"];
    NSMutableArray *filmes = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in resultados) {
        Product *prod = [[Product alloc] init];
        [prod setNome:[item objectForKey:@"trackName"]];
        [prod setTrackId:[item objectForKey:@"trackId"]];
        [prod setArtista:[item objectForKey:@"artistName"]];
        [prod setDuracao:[item objectForKey:@"trackTimeMillis"]];
        [prod setGenero:[item objectForKey:@"primaryGenreName"]];
        [prod setPais:[item objectForKey:@"country"]];
        [prod setTipo:[item objectForKey:@"kind"]];
        [filmes addObject:prod];
    }
    
    return filmes;
}




#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[iTunesManager alloc] init];
}

- (id)mutableCopy
{
    return [[iTunesManager alloc] init];
}

- (id) init
{
    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];
    return self;
}


@end
