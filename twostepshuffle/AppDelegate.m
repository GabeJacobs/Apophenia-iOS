//
//  AppDelegate.m
//  twostepdance
//
//  Created by Gabe Jacobs on 4/14/20.
//  Copyright © 2020 Gabe Jacobs. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <MBProgressHUD.h>
#import <StoreKit/StoreKit.h>
@import Firebase;

@interface AppDelegate () <UIApplicationDelegate>

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *spotifyClientID = @"70cfd503041e4dd095e5b9656d51060f";
    NSURL *spotifyRedirectURL = [NSURL URLWithString:@"twostepshuffle://spotify-login-callback"];
    self.configuration  = [[SPTConfiguration alloc] initWithClientID:spotifyClientID redirectURL:spotifyRedirectURL];
    
    
    NSURL *tokenSwapURL = [NSURL URLWithString:@"https://spotify-twostepshuffle-token.herokuapp.com/api/token"];
    NSURL *tokenRefreshURL = [NSURL URLWithString:@"https://spotify-twostepshuffle-token.herokuapp.com/api/refresh_token"];

    self.configuration.tokenSwapURL = tokenSwapURL;
    self.configuration.tokenRefreshURL = tokenRefreshURL;
    self.configuration.playURI = @"spotify:collection:tracks";

    self.sessionManager = [[SPTSessionManager alloc] initWithConfiguration:self.configuration delegate:self];
    
    self.appRemote = [[SPTAppRemote alloc] initWithConfiguration:self.configuration logLevel:SPTAppRemoteLogLevelDebug];
    self.appRemote.delegate = self;
    
    [FIRApp configure];
    [FIRAnalytics logEventWithName:kFIREventLogin parameters:nil];

    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    [self.sessionManager application:app openURL:url options:options];
    return true;
}

- (void)authSpotify{
    if(self.sessionManager.spotifyAppInstalled){
        SPTScope requestedScope = SPTPlaylistReadPrivateScope | SPTUserLibraryReadScope | SPTAppRemoteControlScope;
        [self.sessionManager initiateSessionWithScope:requestedScope options:SPTDefaultAuthorizationOption];
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                      [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"SpotifyNotInstalled"
                      object:self];
          });
        NSString *iTunesLink = @"https://apps.apple.com/us/app/spotify-music-and-podcasts/id324684580?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

- (void)skipSong {
    __weak typeof(self) weakSelf = self;
    
    if(!self.appRemote.isConnected){
        [self authSpotify];
    } else{
        if(!self.playerState.playbackOptions.isShuffling){
              [self.appRemote.playerAPI setShuffle:YES callback:^(id  _Nullable result, NSError * _Nullable error) {
                 if(weakSelf.likedSongs){
                     [weakSelf.appRemote.playerAPI playItem:weakSelf.likedSongs callback:nil];
                 } else{
                     [weakSelf.appRemote.playerAPI skipToNext:nil];
                 }
              }];
          } else {
              if(self.likedSongs){
                  [self.appRemote.playerAPI playItem:self.likedSongs callback:nil];
              } else{
                  [self.appRemote.playerAPI skipToNext:nil];
              }
          }
    }
}

#pragma mark - SPTSessionManagerDelegate

- (void)sessionManager:(SPTSessionManager *)manager didInitiateSession:(SPTSession *)session
{
    NSLog(@"success: %@", session);
    self.appRemote.connectionParameters.accessToken = session.accessToken;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.appRemote connect];

    });

  

}

- (void)sessionManager:(SPTSessionManager *)manager didFailWithError:(NSError *)error
{
   [[NSNotificationCenter defaultCenter]
                postNotificationName:@"SpotifyError"
                object:self];
}

- (void)sessionManager:(SPTSessionManager *)manager didRenewSession:(SPTSession *)session
{
  NSLog(@"renewed: %@", session);
}
    
#pragma mark - SPTAppRemoteDelegate

- (void)appRemoteDidEstablishConnection:(SPTAppRemote *)appRemote
{
    self.appRemote = appRemote;
    [[NSNotificationCenter defaultCenter]
           postNotificationName:@"SpotifyConnected"
           object:self];

  // Connection was successful, you can begin issuing commands
    self.appRemote.playerAPI.delegate = self;
    
      [self.appRemote.playerAPI subscribeToPlayerState:^(id _Nullable result, NSError * _Nullable error) {
          if (error) {
          NSLog(@"error: %@", error.localizedDescription);
        }
      }];

    
    [self.appRemote.playerAPI getPlayerState:^(id  _Nullable result, NSError * _Nullable error) {
          self.playerState = (id<SPTAppRemotePlayerState>) result;
    }];
    
    __weak __typeof(self) weakSelf = self;


    [self.appRemote.contentAPI fetchRootContentItemsForType:SPTAppRemoteContentTypeDefault callback:^(id  _Nullable result, NSError * _Nullable error) {

               NSArray *array = (NSArray*)result;
                 for (id<SPTAppRemoteContentItem>item in array) {
                     if([item.title isEqualToString:@"Your Library"]){
                        [self.appRemote.contentAPI fetchChildrenOfContentItem:item callback:^(id  _Nullable result, NSError * _Nullable error) {
                             NSArray *array = (NSArray*)result;
                                      for (id<SPTAppRemoteContentItem>item in array) {
                                          
                                          if([item.title isEqualToString:@"Liked Songs"]){
                                              weakSelf.likedSongs = item;
                                          }
//                                          NSLog(@"%@",item.title);
//                                          NSLog(@"%@",item.URI);

                                      }
                           }];
                     }
                 }

    }];
}

- (void)playerStateDidChange:(id<SPTAppRemotePlayerState>)playerState
{
  self.playerState = playerState;
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"TrackChanged"
            object:self];
}

- (void)appRemote:(SPTAppRemote *)appRemote didDisconnectWithError:(NSError *)error
{
  NSLog(@"disconnected");
}

- (void)appRemote:(SPTAppRemote *)appRemote didFailConnectionAttemptWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter]
               postNotificationName:@"SpotifyError"
               object:self];
}

    
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)connect{
  if (!self.appRemote.isConnected) {
       [self.appRemote connect];
  } 
}

- (void)disconnect{
  if (self.appRemote.isConnected) {
      [self.appRemote disconnect];
  }
}

@end
