//
//  AppDelegate.h
//  twostepdance
//
//  Created by Gabe Jacobs on 4/14/20.
//  Copyright © 2020 Gabe Jacobs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpotifyiOS/SpotifyiOS.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate,SPTAppRemotePlayerStateDelegate>

@property (nonatomic, strong) SPTSessionManager *sessionManager;
@property (nonatomic, strong) SPTConfiguration *configuration;
@property (nonatomic, strong) SPTAppRemote *appRemote;
@property (nonatomic) id<SPTAppRemotePlayerState> playerState;
@property (nonatomic) id<SPTAppRemoteContentItem> likedSongs;

- (void)authSpotify;
- (void)skipSong;
- (void)connect;
- (void)disconnect;

@end

