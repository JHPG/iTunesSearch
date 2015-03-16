//
//  DetailViewController.m
//  iTunesSearch
//
//  Created by Jorge Henrique P. Garcia on 3/13/15.
//  Copyright (c) 2015 joaquim. All rights reserved.
//

#import "DetailViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_imgDetails setImage:_product.img];
    [_tipoMidia setText:[NSString stringWithFormat:@"%@", [_product.tipo capitalizedString]]];
    
    [_tipoMidia setText: [_product.tipo capitalizedString]];
    [_nome setText: _product.nome];
    [_artist setText:[NSString stringWithFormat:
                       @"%@: %@", NSLocalizedString(@"Artista",nil), _product.artista]];
    [_genre setText:[NSString stringWithFormat:
                       @"%@: %@", NSLocalizedString(@"Genero",nil), _product.genero]];
    [_duracao setText:[NSString stringWithFormat:
                       @"%@: %2.f min", NSLocalizedString(@"Duracao",nil), _product.duracao]];
    [_country setText:[NSString stringWithFormat:
                       @"%@: %@",  NSLocalizedString(@"Pais",nil), _product.pais]];
    
    [_imgDetails.layer setCornerRadius:10.0];
    
    //AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://a680.phobos.apple.com/us/r1000/170/Music2/v4/de/21/90/de2190f3-8749-3326-880d-c562580ebe1c/mzaf_674204922208643616.aac.m4a"]];
    
    AVPlayer *player = [AVPlayer playerWithURL: [NSURL URLWithString: _product.preview]];
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    [layer setPlayer:player];
    
    //[layer setFrame:CGzRectMake(5, 400, 200, 20)];
    //[layer setBackgroundColor:[UIColor blackColor].CGColor];
    //[layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [self.view.layer addSublayer:layer];
    
    [player play];
    
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
