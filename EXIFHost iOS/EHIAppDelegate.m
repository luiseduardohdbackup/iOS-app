//
//  EHIAppDelegate.m
//  EXIFHost iOS
//
//  Created by Andrew Wilcox on 2012-Nov-02.
//  Copyright (c) 2012 EXIFHost. All rights reserved.
//

#import "EHIAppDelegate.h"

#import "EHIAuthViewController.h"

@implementation EHIAppDelegate

-(void)dealloc
{
	[_window release];
	[super dealloc];
}


-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	UITabBarController *tabBarController;
	
	
	
	UIViewController *albumsController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
	[albumsController setTitle:@"Albums"];
	UINavigationController *albumsNavi = [[UINavigationController alloc] initWithRootViewController:albumsController];
	albumsNavi.navigationBar.tintColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.0];
	[albumsController release];
	
	UIViewController *searchController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
	[searchController setTitle:@"Search"];
	UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:searchController];
	searchNavi.navigationBar.tintColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.0];
	[searchController release];
	
	NSArray *tabs = [NSArray arrayWithObjects:albumsNavi, searchNavi, nil];
	[searchNavi release];
	[albumsNavi release];
	
	tabBarController = [[UITabBarController alloc] init];
	[tabBarController setViewControllers:tabs];
	
	
	
	self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	
	if([self.window respondsToSelector:@selector(setRootViewController:)])
		self.window.rootViewController = tabBarController;
	[self.window addSubview:tabBarController.view];
	self.window.backgroundColor = [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	
	
	NSURLProtectionSpace *protectionSpace = [[NSURLProtectionSpace alloc]
						 initWithHost:@"exifhost-codeblock.rhcloud.com"
						 port:0
						 protocol:@"https"
						 realm:nil
						 authenticationMethod:nil];
	if([[NSURLCredentialStorage sharedCredentialStorage] defaultCredentialForProtectionSpace:protectionSpace] == nil)
	{
		EHIAuthViewController *authController = [[EHIAuthViewController alloc] initWithNibName:@"EHIAuthViewController" bundle:[NSBundle mainBundle]];
		UINavigationController *authNavi = [[UINavigationController alloc] initWithRootViewController:authController];
		authNavi.navigationBar.tintColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1.0];
		[authController release];
		[tabBarController presentModalViewController:authNavi animated:NO];
		[authNavi release];
	}
	[protectionSpace release];
	return YES;
}


#pragma mark - Application delegate mthods

-(void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


-(void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


-(void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


-(void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


-(void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
