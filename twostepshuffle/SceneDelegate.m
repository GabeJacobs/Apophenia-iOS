//
//  SceneDelegate.m
//  twostepshuffle
//
//  Created by Gabe Jacobs on 4/14/20.
//  Copyright © 2020 Gabe Jacobs. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene openURLContexts:(nonnull NSSet<UIOpenURLContext *> *)URLContexts
API_AVAILABLE(ios(13.0)){
    NSURL *url = [[URLContexts allObjects] firstObject].URL;
//    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
//    NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"&"];
//    for (NSString *keyValuePair in urlComponents)
//    {
//        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
//        NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
//        NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
//
//        [queryStringDictionary setObject:value forKey:key];
//    }
//    NSString *token = [queryStringDictionary objectForKey:@"spotify-ios-quick-start://spotify-login-callback/?code"];
//
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    appDelegate.appRemote.connectionParameters.accessToken = token;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.sessionManager application:[UIApplication sharedApplication] openURL:url options:@{}];
}

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.appRemote.playerAPI resume:nil];
}


- (void)sceneWillResignActive:(UIScene *)scene {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.appRemote.playerAPI pause:nil];
    
}


- (void)sceneWillEnterForeground:(UIScene *)scene {

}


- (void)sceneDidEnterBackground:(UIScene *)scene {
   
}


@end
