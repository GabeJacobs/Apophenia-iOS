//
//  ViewController.m
//  twostepdance
//
//  Created by Gabe Jacobs on 4/14/20.
//  Copyright © 2020 Gabe Jacobs. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createDataSource];
    self.currentVideoIndex = 0;
    
    self.view.backgroundColor = [UIColor blackColor];

    NSError *sessionError = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient
    withOptions:AVAudioSessionCategoryOptionMixWithOthers
            error:&sessionError];

    [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
    NSDictionary *videoDict = self.dataSource[self.currentVideoIndex];
    self.player = [AVPlayer playerWithURL:[NSURL URLWithString:[videoDict objectForKey:@"video_url"]]];
    self.controller = [[AVPlayerViewController alloc] init];
    
    [self addChildViewController:self.controller];
    self.controller.view.alpha = 0.0;
    [self.view addSubview:self.controller.view];

    self.controller.view.frame = self.view.bounds;
    self.controller.view.frame = CGRectMake(self.controller.view.frame.origin.x, self.controller.view.frame.origin.y, self.controller.view.frame.size.width, self.controller.view.frame.size.height);
    self.controller.view.center = self.view.center;
    self.controller.player = self.player;
    [self.controller.player setMuted:YES];
    self.controller.showsPlaybackControls = NO;
    [self.player play];

    self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[self.player currentItem]];
    [self.player addObserver:self
    forKeyPath:@"status"
       options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
       context:nil];
    
    self.hideButtons = [UIButton buttonWithType:UIButtonTypeCustom];
    self.hideButtons.frame = self.view.bounds;
    [self.view addSubview:self.hideButtons];
    [self.hideButtons addTarget:self action:@selector(hideButtonsTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightSideControls = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - self.view.frame.size.width/4, 0, self.view.frame.size.width/4, self.view.frame.size.height)];
    self.rightSideControls.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    self.rightSideControls.hidden = YES;
    [self.view addSubview:self.rightSideControls];

    self.leftSideControls = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4, self.view.frame.size.height)];
    self.leftSideControls.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
    self.leftSideControls.alpha = 1;
    self.leftSideControls.hidden = YES;
    [self.view addSubview:self.leftSideControls];
    
    
    CGFloat left = [UIApplication sharedApplication].windows.firstObject.safeAreaInsets.left;
    if(left != 0) {
        left = left - 12;
    }
    UILabel *musicTitle = [[UILabel alloc] initWithFrame:CGRectMake(left + 10, 15, self.leftSideControls.frame.size.width/1.5, 50)];
    musicTitle.text = @"MUSIC";
    musicTitle.textColor = [UIColor whiteColor];
    musicTitle.numberOfLines = 1;
    musicTitle.font = [UIFont fontWithName:@"IBMPlexMono-Light" size:40];
    [musicTitle sizeToFit];
    [self.leftSideControls addSubview:musicTitle];
    
    UILabel *nowPlayingLabel = [[UILabel alloc] initWithFrame:CGRectMake(musicTitle.frame.origin.x, self.view.frame.size.height/4.5, self.leftSideControls.frame.size.width/1.5, 50)];
    nowPlayingLabel.text = @"NOW PLAYING";
    nowPlayingLabel.textColor = [UIColor whiteColor];
    nowPlayingLabel.numberOfLines = 1;
    nowPlayingLabel.font = [UIFont fontWithName:@"IBMPlexMono-Light" size:19];
    [nowPlayingLabel sizeToFit];
    [self.leftSideControls addSubview:nowPlayingLabel];

    UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(nowPlayingLabel.frame.origin.x, nowPlayingLabel.frame.origin.y + nowPlayingLabel.frame.size.height + 8, self.leftSideControls.frame.size.width - nowPlayingLabel.frame.origin.x - 10, 1)];
    lineLeft.backgroundColor = [UIColor whiteColor];
    lineLeft.alpha = .5;
    [self.leftSideControls addSubview:lineLeft];
    
    self.albumArt = [[UIImageView alloc] initWithFrame:CGRectMake(nowPlayingLabel.frame.origin.x, self.view.frame.size.height/2.8, _leftSideControls.frame.size.width/3, _leftSideControls.frame.size.width/3)];
    self.albumArt.backgroundColor = [UIColor lightGrayColor];
    [_leftSideControls addSubview:self.albumArt];
    
    self.songTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.albumArt.frame.origin.x + self.albumArt.frame.size.width + 7, self.albumArt.frame.origin.y + 21, self.leftSideControls.frame.size.width - (self.albumArt.frame.origin.x + self.albumArt.frame.size.width + 3) - 5, 15)];
    self.songTitle.textColor = [UIColor whiteColor];
    self.songTitle.text = @"Jupiter 4";
    self.songTitle.font = [UIFont fontWithName:@"IBMPlexMono-Bold" size:11];
    [self.leftSideControls addSubview:self.songTitle];
    
    self.artistName = [[UILabel alloc] initWithFrame:CGRectMake(self.songTitle.frame.origin.x,self.songTitle.frame.origin.y + self.songTitle.frame.size.height, self.songTitle.frame.size.width , 15)];
    self.artistName.textColor = [UIColor whiteColor];
    self.artistName.text = @"Sharon Van Etten";
    self.artistName.font = [UIFont fontWithName:@"IBMPlexMono-Light" size:10];
    [self.leftSideControls addSubview:self.artistName];
    
    UILabel *viewOnSpotifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(nowPlayingLabel.frame.origin.x, self.view.frame.size.height/1.66, self.leftSideControls.frame.size.width, 40)];
    viewOnSpotifyLabel.text = @"view on Spotify -->";
    viewOnSpotifyLabel.textColor = [UIColor whiteColor];
    viewOnSpotifyLabel.numberOfLines = 1;
    viewOnSpotifyLabel.font = [UIFont fontWithName:@"IBMPlexMono" size:12];
    [viewOnSpotifyLabel sizeToFit];
    [self.leftSideControls addSubview:viewOnSpotifyLabel];
    
    self.viewOnSpotifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewOnSpotifyButton addTarget:self action:@selector(openSpotify) forControlEvents:UIControlEventTouchUpInside];
    self.viewOnSpotifyButton.frame = CGRectMake(viewOnSpotifyLabel.frame.origin.x - 5, viewOnSpotifyLabel.frame.origin.y - 10, viewOnSpotifyLabel.frame.size.width + 15, viewOnSpotifyLabel.frame.size.height + 20);
    [self.leftSideControls addSubview:self.viewOnSpotifyButton];
    
    UIView *lineLeft2 = [[UIView alloc] initWithFrame:CGRectMake(nowPlayingLabel.frame.origin.x,viewOnSpotifyLabel.frame.origin.y + viewOnSpotifyLabel.frame.size.height + 10, self.leftSideControls.frame.size.width - nowPlayingLabel.frame.origin.x - 10, 1)];
    lineLeft2.backgroundColor = [UIColor whiteColor];
    lineLeft2.alpha = .5;
    [self.leftSideControls addSubview:lineLeft2];
    
    self.shuffleMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shuffleMusic setImage:[UIImage imageNamed:@"ShuffleMusic"] forState:UIControlStateNormal];
    self.shuffleMusic.layer.cornerRadius = 25;
    self.shuffleMusic.frame = CGRectMake(self.leftSideControls.frame.size.width/2 - ([UIImage imageNamed:@"ShuffleMusic"].size.width/2), self.leftSideControls.frame.size.height - [UIImage imageNamed:@"ShuffleMusic"].size.height - 20, [UIImage imageNamed:@"ShuffleMusic"].size.width, [UIImage imageNamed:@"ShuffleMusic"].size.height);
    [self.leftSideControls addSubview:self.shuffleMusic];
    [self.shuffleMusic addTarget:self action:@selector(switchMusicTapped) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *danceTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.rightSideControls.frame.size.width - self.rightSideControls.frame.size.width/1.5 - 30, 15, self.rightSideControls.frame.size.width/1.5, 50)];
    danceTitle.text = @"DANCE";
    danceTitle.textColor = [UIColor whiteColor];
    danceTitle.numberOfLines = 1;
    danceTitle.font = [UIFont fontWithName:@"IBMPlexMono-Light" size:40];
    [danceTitle sizeToFit];
    [self.rightSideControls addSubview:danceTitle];
    
    UILabel *nowPlayingLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.rightSideControls.frame.size.width - (self.rightSideControls.frame.size.width/1.5) - 30, self.view.frame.size.height/4.5, self.rightSideControls.frame.size.width/1.5, 50)];
    nowPlayingLabel2.text = @"NOW PLAYING";
    nowPlayingLabel2.textColor = [UIColor whiteColor];
    nowPlayingLabel2.numberOfLines = 1;
    nowPlayingLabel2.font = [UIFont fontWithName:@"IBMPlexMono-Light" size:19];
    [nowPlayingLabel2 sizeToFit];
    [self.rightSideControls addSubview:nowPlayingLabel2];

    UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(10, nowPlayingLabel2.frame.origin.y + nowPlayingLabel2.frame.size.height + 8, nowPlayingLabel2.frame.origin.x + nowPlayingLabel.frame.size.width - 10, 1)];
    lineRight.backgroundColor = [UIColor whiteColor];
    lineRight.alpha = .5;
    [self.rightSideControls addSubview:lineRight];

     self.youtubeTitle = [[UILabel alloc] initWithFrame:CGRectZero];
     self.youtubeTitle.textColor = [UIColor whiteColor];
     self.youtubeTitle.numberOfLines = 2;
     self.youtubeTitle.textAlignment = NSTextAlignmentRight;
     self.youtubeTitle.text = [videoDict objectForKey:@"video_title"];
     self.youtubeTitle.font = [UIFont fontWithName:@"IBMPlexMono-Italic" size:13];
     self.youtubeTitle.frame = CGRectMake(5, self.albumArt.frame.origin.y, lineRight.frame.size.width + 5, 40);
     [self.rightSideControls addSubview:self.youtubeTitle];
    
    UIView *lineRight2 = [[UIView alloc] initWithFrame:CGRectMake(10, lineLeft2.frame.origin.y, nowPlayingLabel2.frame.origin.x + nowPlayingLabel.frame.size.width - 10, 1)];
    lineRight2.backgroundColor = [UIColor whiteColor];
    lineRight2.alpha = .5;
    [self.rightSideControls addSubview:lineRight2];
    
    UILabel *viewOnYoutube = [[UILabel alloc] initWithFrame:CGRectMake(self.youtubeTitle.frame.origin.x, lineRight2.frame.origin.y - 25, self.youtubeTitle.frame.size.width, 20)];
    viewOnYoutube.text = @"<-- view on YouTube";
    viewOnYoutube.textColor = [UIColor whiteColor];
    viewOnYoutube.textAlignment = NSTextAlignmentRight;
    viewOnYoutube.numberOfLines = 1;
    viewOnYoutube.font = [UIFont fontWithName:@"IBMPlexMono" size:12];
    [self.rightSideControls addSubview:viewOnYoutube];
 
    self.viewOnYoutubeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.viewOnYoutubeButton addTarget:self action:@selector(openYoutube) forControlEvents:UIControlEventTouchUpInside];
    self.viewOnYoutubeButton.frame = CGRectMake(viewOnYoutube.frame.origin.x - 5, viewOnYoutube.frame.origin.y - 10, viewOnYoutube.frame.size.width + 15, viewOnYoutube.frame.size.height + 20);
    [self.rightSideControls addSubview:self.viewOnYoutubeButton];
    
    self.shuffleDance = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shuffleDance setImage:[UIImage imageNamed:@"ShuffleDance"] forState:UIControlStateNormal];
    self.shuffleDance.layer.cornerRadius = 25;
    self.shuffleDance.frame = CGRectMake(self.rightSideControls.frame.size.width/2 - ([UIImage imageNamed:@"ShuffleDance"].size.width/2), self.rightSideControls.frame.size.height - [UIImage imageNamed:@"ShuffleDance"].size.height - 20, [UIImage imageNamed:@"ShuffleDance"].size.width, [UIImage imageNamed:@"ShuffleDance"].size.height);
    [self.rightSideControls addSubview:self.shuffleDance];
    [self.shuffleDance addTarget:self action:@selector(switchDanceTapped) forControlEvents:UIControlEventTouchUpInside];
      
    self.shuffleMusic.alpha = 0.0;
    self.shuffleDance.alpha = 0.0;

    if (!UIAccessibilityIsReduceTransparencyEnabled()) {

        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //always fill the view
        self.blurEffectView.frame = self.view.bounds;
        self.blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        [self.view addSubview:self.blurEffectView]; //if you have more UIViews, use an insertSubview API to place it where needed
    }
    
    self.inAppLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoInApp"]];
    self.inAppLogo.alpha = 0.0;
    self.inAppLogo.center = self.view.center;
    [self.view addSubview:self.inAppLogo];
    
    self.definitionImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Definition"]];
    self.definitionImage.alpha = 0.0;
    self.definitionImage.center = self.view.center;
    [self.view addSubview:self.definitionImage];
    
    self.definitionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.definitionButton.frame = self.view.bounds;
    [self.view addSubview:self.definitionButton];
    self.definitionButton.alpha = 0.0;
    self.definitionButton.userInteractionEnabled = NO;
    [self.definitionButton addTarget:self action:@selector(tappedDefinition) forControlEvents:UIControlEventTouchUpInside];
    
    self.explanationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Explanation"]];
    self.explanationImage.alpha = 0.0;
    self.explanationImage.center = self.view.center;
    [self.view addSubview:self.explanationImage];
    
    self.explanationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.explanationButton.frame = self.view.bounds;
    [self.view addSubview:self.explanationButton];
    self.explanationButton.alpha = 0.0;
    self.explanationButton.userInteractionEnabled = NO;
    [self.explanationButton addTarget:self action:@selector(tappedExplanation) forControlEvents:UIControlEventTouchUpInside];
    
    self.connectSpotifyImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ConnectSpotify"]];
    self.connectSpotifyImage.alpha = 0.0;
    self.connectSpotifyImage.center = self.view.center;
    [self.view addSubview:self.connectSpotifyImage];
    
    self.connectSpotifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.connectSpotifyButton.frame = self.view.bounds;
    [self.view addSubview:self.connectSpotifyButton];
    self.connectSpotifyButton.alpha = 0.0;
    self.connectSpotifyButton.userInteractionEnabled = NO;
    [self.connectSpotifyButton addTarget:self action:@selector(connectSpotify) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(didConnectSpotify:)
         name:@"SpotifyConnected"
         object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
         selector:@selector(trackChanged:)
         name:@"TrackChanged"
         object:nil];
    
//    [self didConnectSpotify:nil];


}

- (void)createDataSource {
    self.dataSource = [[self JSONFromFile] mutableCopy];
}

- (NSArray *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (void)trackChanged:(NSNotification *) notification{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.songTitle.text = appDelegate.playerState.track.name;
    self.artistName.text = appDelegate.playerState.track.artist.name;
    [appDelegate.appRemote.imageAPI fetchImageForItem:appDelegate.playerState.track withSize:CGSizeMake(100, 100) callback:^(id  _Nullable result, NSError * _Nullable error) {
        self.albumArt.image = result;
    }];
    
    

}

- (void)didConnectSpotify:(NSNotification *) notification
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.connectSpotifyButton.userInteractionEnabled = NO;
    self.connectSpotifyButton.hidden = YES;
    [UIView animateWithDuration:.5 delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
       self.blurEffectView.alpha = 0.0;
       self.connectSpotifyImage.alpha = 0.0;
       self.shuffleMusic.alpha = 1.0;
        self.shuffleDance.alpha = 1.0;
       self.rightSideControls.hidden = NO;
       self.leftSideControls.hidden = NO;

    } completion:^(BOOL finished) {
        
    }];

}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];

}

- (void)openYoutube {
    NSDictionary *dict = self.dataSource[self.currentVideoIndex];
    NSURL *url = [NSURL URLWithString:dict[@"youtube_url"]];
    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
        
    }];
}

- (void)openSpotify {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:appDelegate.playerState.track.URI];
    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
        
    }];

}

- (void)switchDanceTapped{
    self.currentVideoIndex = arc4random_uniform(24);
    NSDictionary *dict = self.dataSource[self.currentVideoIndex];
    NSURL *url = [NSURL URLWithString:dict[@"video_url"]];
    NSString *videoTitle = dict[@"video_title"];

    self.player = [AVPlayer playerWithURL:url];
    self.youtubeTitle.text = videoTitle;
    
    self.controller.view.frame = self.view.bounds;
    self.controller.view.frame = CGRectMake(self.controller.view.frame.origin.x, self.controller.view.frame.origin.y, self.controller.view.frame.size.width*1.25, self.self.controller.view.frame.size.height*1.25);
    self.controller.view.center = self.view.center;
    self.controller.player = self.player;
    [self.controller.player setMuted:YES];
    self.controller.showsPlaybackControls = NO;
    [self.player play];

}
- (void)switchMusicTapped {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate skipSong];


    
}
- (void)connectSpotify{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate authSpotify];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideButtonsTapped{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

    if(self.rightSideControls.frame.origin.x < self.view.frame.size.width){
        [UIView animateWithDuration:0.4 animations:^{
            
            self.leftSideControls.frame = CGRectMake(self.leftSideControls.frame.origin.x - 300, self.leftSideControls.frame.origin.y, self.leftSideControls.frame.size.width, self.leftSideControls.frame.size.height);
            self.rightSideControls.frame = CGRectMake(self.rightSideControls.frame.origin.x + 300, self.rightSideControls.frame.origin.y, self.rightSideControls.frame.size.width, self.rightSideControls.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            self.leftSideControls.frame = CGRectMake(self.leftSideControls.frame.origin.x + 300, self.leftSideControls.frame.origin.y, self.leftSideControls.frame.size.width, self.leftSideControls.frame.size.height);
            self.rightSideControls.frame = CGRectMake(self.rightSideControls.frame.origin.x - 300, self.rightSideControls.frame.origin.y, self.rightSideControls.frame.size.width, self.rightSideControls.frame.size.height);
            
        }];
    }
}

- (void)spotifyConnected {

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (object == _player && [keyPath isEqualToString:@"status"]) {
        if (_player.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"PLAYING");
            [UIView animateWithDuration:0.5 delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
                self.controller.view.alpha = 1.0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.3 delay:.2 options:UIViewAnimationOptionCurveLinear animations:^{
                              self.inAppLogo.alpha = 1.0;
                          } completion:^(BOOL finished) {
                              [UIView animateWithDuration:1.0
                                   delay:0.0
                                 options:0
                              animations:^{
                                  CABasicAnimation* rotationAnimation;
                                    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                  rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 1 * 1.0 ];
                                    rotationAnimation.duration = 1.3;
                                    rotationAnimation.cumulative = YES;

                                  [CATransaction begin];

                                  [CATransaction setCompletionBlock:^{
                                      [self fadeOutLogoFadeInDescription];
                                  }];

                                  [self.inAppLogo.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

                                  [CATransaction commit];
                           


                              }
                              completion:^(BOOL finished){
                                  NSLog(@"Done!");
                              }];
                          }];
            }];

        }
    }
}

- (void)tappedDefinition{
    self.definitionButton.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.4 delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.definitionImage.alpha = 0.0;
        self.definitionButton.alpha = 0.0;
        self.explanationImage.alpha = 1.0;
        self.explanationButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.definitionButton.hidden = YES;
        self.explanationButton.userInteractionEnabled = YES;

    }];
}

- (void)tappedExplanation{
    self.explanationButton.userInteractionEnabled = NO;

    [UIView animateWithDuration:0.4 delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.explanationImage.alpha = 0.0;
        self.explanationButton.alpha = 0.0;
        self.connectSpotifyButton.alpha = 1.0;
        self.connectSpotifyImage.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.explanationButton.hidden = YES;
        self.connectSpotifyButton.userInteractionEnabled = YES;
    }];
}


- (void)fadeOutLogoFadeInDescription{
    [UIView animateWithDuration:0.5 delay:.3 options:UIViewAnimationOptionCurveLinear animations:^{
        self.inAppLogo.alpha = 0.0;
        self.definitionImage.alpha = 1.0;
        self.definitionButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.definitionButton.userInteractionEnabled = YES;

    }];
}
@end
