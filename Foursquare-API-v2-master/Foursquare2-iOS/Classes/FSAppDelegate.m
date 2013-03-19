

#import "FSAppDelegate.h"
#import "NearbyVenuesViewController.h"

@implementation FSAppDelegate

@synthesize window;
//@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *c = [[NearbyVenuesViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:c];
    window.rootViewController = nav;
    [window makeKeyAndVisible];
    [GMSServices provideAPIKey:@"AIzaSyB5rDX-Caj9XjGbf9Vex3x_9SBx3-7G_Xo"];
	return YES;
}


@end
