//
//  ViewController.h
//  twostepshuffle
//
//  Created by Gabe Jacobs on 4/14/20.
//  Copyright © 2020 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <SpotifyiOS/SpotifyiOS.h>
#import <SDWebImage/SDWebImage.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *videoURLs;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) UIVisualEffectView *blurEffectView;

@property (nonatomic) UIButton *switchDanceBUFFER;
@property (nonatomic) UIButton *switchMusicBUFFER;
@property (nonatomic) UIButton *hideButtons;

@property (nonatomic) UIImageView *inAppLogo;
@property (nonatomic) UIImageView *definitionImage;
@property (nonatomic) UIButton *definitionButton;
@property (nonatomic) UIImageView *explanationImage;
@property (nonatomic) UIButton *explanationButton;
@property (nonatomic) UIImageView *connectSpotifyImage;
@property (nonatomic) UIButton *connectSpotifyButton;

@property (nonatomic) UIView *leftSideControls;
@property (nonatomic) UIView *rightSideControls;
@property (nonatomic) UIButton *shuffleDance;
@property (nonatomic) UIButton *shuffleMusic;
@property (nonatomic) UIImageView *albumArt;
@property (nonatomic) UILabel *songTitle;
@property (nonatomic) UILabel *artistName;
@property (nonatomic) UILabel *youtubeTitle;
@property (nonatomic) UIButton *viewOnSpotifyButton;
@property (nonatomic) UIButton *viewOnYoutubeButton;

@property (nonatomic) NSMutableArray *dataSource;
@property int currentVideoIndex;
@property (nonatomic) NSMutableArray *arrayOfVideoIndexSelections;
@property (nonatomic) UIImageView *activityView;
@property BOOL didLoadFirstVideo;
@property(nonatomic, readonly, getter=isReadyForDisplay) BOOL readyForDisplay;
@property (nonatomic) AVPlayerLayer *playerLayer;


@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic, strong) AVPlayerViewController *controller;
@property (nonatomic, strong) id playerObserver;


@end

