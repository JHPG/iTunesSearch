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
    
    NSString *url = [NSString stringWithFormat:
                     @"https://itunes.apple.com/search?term=%@&media=music&limit=10", termo];
    NSString *url1 = [NSString stringWithFormat:
                     @"https://itunes.apple.com/search?term=%@&media=movie&limit=10", termo];
    NSString *url2= [NSString stringWithFormat:
                     @"https://itunes.apple.com/search?term=%@&media=podcast&limit=10", termo];
    NSString *url3 = [NSString stringWithFormat:
                      @"https://itunes.apple.com/search?term=%@&media=ebook&limit=10", termo];
    
    NSError *error;
    NSMutableArray *resultados = [[NSMutableArray alloc] init];
    
    @try{
    //Musica
        NSData *jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url]];
        resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        [resultados addObjectsFromArray: [resultado objectForKey:@"results"]];
        
    //Filmes
        jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url1]];
        resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        [resultados addObjectsFromArray: [resultado objectForKey:@"results"]];
        
    //Podcast
        jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url2]];
        resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        [resultados addObjectsFromArray: [resultado objectForKey:@"results"]];
        
    //Ebook
        jsonData = [NSData dataWithContentsOfURL: [NSURL URLWithString:url3]];
        resultado = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
        [resultados addObjectsFromArray: [resultado objectForKey:@"results"]];
        
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
    
    //[resultados addObjectsFromArray: [resultado objectForKey:@"results"]];
    
    NSMutableArray *midia = [[NSMutableArray alloc] init];
    
    double doubleValue = [@"11" doubleValue];
    
    for (NSDictionary *item in resultados) {
        Product *prod = [[Product alloc] init];
        
        [prod setNome:[item objectForKey:@"trackName"]];
        [prod setTrackId:[item objectForKey:@"trackId"]];
        [prod setArtista:[item objectForKey:@"artistName"]];
        [prod setDuracao:[item objectForKey:@"trackTimeMillis"]];
        [prod setGenero:[item objectForKey:@"primaryGenreName"]];
        [prod setPais:[item objectForKey:@"country"]];
        [prod setTipo:[item objectForKey:@"kind"]];
        [prod setPreview:[item objectForKey:@"previewUrl"]];
        
        NSURL *imageURL = [NSURL URLWithString: [item objectForKey:@"artworkUrl100"]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [prod setImg:[UIImage imageWithData:imageData]];
            });
        });
        
        //Add previewURL com preview da midia
        
        [midia addObject:prod];
    }
    
    return midia;
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
