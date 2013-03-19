
#import "Foursquare2.h"
#import "FSTargetCallback.h"



@interface Foursquare2 (PrivateAPI)
+ (void)        get:(NSString *)methodName
         withParams:(NSDictionary *)params 
		   callback:(Foursquare2Callback)callback;

+ (void)       post:(NSString *)methodName
		 withParams:(NSDictionary *)params
		   callback:(Foursquare2Callback)callback;

+ (void)    request:(NSString *)methodName 
	     withParams:(NSDictionary *)params 
	     httpMethod:(NSString *)httpMethod
		   callback:(Foursquare2Callback)callback;

+ (void)    uploadPhoto:(NSString *)methodName 
			 withParams:(NSDictionary *)params 
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED
			  withImage:(NSImage*)image
#else
			  withImage:(UIImage*)image
#endif
			   callback:(Foursquare2Callback)callback;

+(void)setAccessToken:(NSString*)token;
+(NSString*)problemTypeToString:(FoursquareProblemType)problem;
+(NSString*)broadcastTypeToString:(FoursquareBroadcastType)broadcast;
+(NSString*)sortTypeToString:(FoursquareSortingType)type;
// Declared in HRRestModel
+ (void)setAttributeValue:(id)attr forKey:(NSString *)key;
+ (NSMutableDictionary *)classAttributes;
@end

@implementation Foursquare2

static NSMutableDictionary *attributes;

+ (void)initialize
{
    [self setBaseURL:kBaseUrl];
	NSUserDefaults *usDef = [NSUserDefaults standardUserDefaults];
	if ([usDef objectForKey:@"access_token2"] != nil) {
		[self classAttributes][@"access_token"] = [usDef objectForKey:@"access_token2"];
	}
}



+ (void)setBaseURL:(NSString *)uri {
    [self setAttributeValue:uri forKey:@"kBaseUrl"];
}

+ (void)setAttributeValue:(id)attr forKey:(NSString *)key {
    [self classAttributes][key] = attr;
}

+ (NSMutableDictionary *)classAttributes {
    if(attributes) {
        return attributes;
    } else {
        attributes = [[NSMutableDictionary alloc] init];
    }
    
    return attributes;
}

+(void)setAccessToken:(NSString*)token{
	[self classAttributes][@"access_token"] = token;
	[[NSUserDefaults standardUserDefaults]setObject:token forKey:@"access_token2"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}

+(void)removeAccessToken{
	[[self classAttributes]removeObjectForKey:@"access_token"];
	[[NSUserDefaults standardUserDefaults]removeObjectForKey:@"access_token2"];
	[[NSUserDefaults standardUserDefaults]synchronize];
}

+(BOOL)isNeedToAuthorize{
	return ([self classAttributes][@"access_token"] == nil);
}

+(BOOL)isAuthorized{
    return ([self classAttributes][@"access_token"] != nil);
}


+(NSString*)stringFromArray:(NSArray*)array{
	if (array.count) {
        return [array componentsJoinedByString:@","];
    }
    return @"";
	
}
#pragma mark -
#pragma mark Users

+(void)getDetailForUser:(NSString*)userID
			   callback:(Foursquare2Callback)callback
{
	NSString *path = [NSString stringWithFormat:@"users/%@",userID];
	[self get:path withParams:nil callback:callback];
}

#pragma mark Actions

#pragma mark -


#pragma mark Venues

+(void)getDetailForVenue:(NSString*)venueID
				callback:(Foursquare2Callback)callback
{
	NSString *path = [NSString stringWithFormat:@"venues/%@",venueID];
	[self get:path withParams:nil callback:callback];
}

+(void)getVenueCategoriesCallback:(Foursquare2Callback)callback
{
	[self get:@"venues/categories" withParams:nil callback:callback];
}

+(void)searchVenuesNearByLatitude:(NSNumber*)lat
						longitude:(NSNumber*)lon
					   accuracyLL:(NSNumber*)accuracyLL
						 altitude:(NSNumber*)altitude
					  accuracyAlt:(NSNumber*)accuracyAlt
							query:(NSString*)query
							limit:(NSNumber*)limit
						   intent:(FoursquareIntentType)intent
                           radius:(NSNumber*)radius
						 callback:(Foursquare2Callback)callback
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	if (lat && lon) {
		dic[@"ll"] = [NSString stringWithFormat:@"%@,%@",lat,lon];
	}
	if (accuracyLL) {
		dic[@"llAcc"] = accuracyLL.stringValue;
	}
	if (altitude) {
		dic[@"alt"] = altitude.stringValue;
	}
	if (accuracyAlt) {
		dic[@"altAcc"] = accuracyAlt.stringValue;
	}
	if (query) {
		dic[@"query"] = query;
	}
	if (limit) {
		dic[@"limit"] = limit.stringValue;
	}
	if (intent) {
		dic[@"intent"] = [self inentTypeToString:intent];
	}
    if (radius) {
		dic[@"radius"] = radius.stringValue;
	}
	[self get:@"venues/search" withParams:dic callback:callback];
}

+(void)searchVenuesInBoundingQuadrangleS:(NSNumber*)s
                                       w:(NSNumber*)w
                                       n:(NSNumber*)n
                                       e:(NSNumber*)e
                                   query:(NSString*)query
                                   limit:(NSNumber*)limit
                                callback:(Foursquare2Callback)callback
{
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	if (s && w && n && e) {
		dic[@"sw"] = [NSString stringWithFormat:@"%@,%@",s,w];
        dic[@"ne"] = [NSString stringWithFormat:@"%@,%@",n,e];
	}
	if (query) {
		dic[@"query"] = query;
	}
	if (limit) {
		dic[@"limit"] = limit.stringValue;
	}
    dic[@"intent"] = [self inentTypeToString:intentBrowse];
    
	[self get:@"venues/search" withParams:dic callback:callback];
}

#pragma mark Aspects
+(void)getVenueHereNow:(NSString*)venueID
				 limit:(NSString*)limit
				offset:(NSString*)offset
		afterTimestamp:(NSString*)afterTimestamp
			  callback:(Foursquare2Callback)callback
{
	if(nil == venueID){
		callback(NO,nil);
		return;
	}
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	if (limit) {
		dic[@"limit"] = limit;
	}
	if (offset) {
		dic[@"offset"] = offset;
	}
	if (afterTimestamp) {
		dic[@"afterTimestamp"] = afterTimestamp;
	}
	NSString *path = [NSString stringWithFormat:@"venues/%@/herenow",venueID];
	[self get:path withParams:dic callback:callback];
}

+(void)getTipsFromVenue:(NSString*)venueID
				   sort:(FoursquareSortingType)sort
			   callback:(Foursquare2Callback)callback
{
	if (nil == venueID || sort == sortNearby) {
		callback(NO,nil);
		return;
	}
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"sort"] = [self sortTypeToString:sort];
	NSString *path = [NSString stringWithFormat:@"venues/%@/tips",venueID];
	[self get:path withParams:dic callback:callback];
}


#pragma mark Settings
+(void)getAllSettingsCallback:(Foursquare2Callback)callback
{
	[self get:@"settings/all" withParams:nil callback:callback];
}

#pragma mark -


#pragma mark Private methods

+(NSString*)inentTypeToString:(FoursquareIntentType)broadcast{
	switch (broadcast) {
		case intentBrowse:
			return @"browse";
			break;
		case intentCheckin:
			return @"checkin";
			break;
		case intentGlobal:
			return @"global";
			break;
		case intentMatch:
			return @"match";
			break;
		default:
			return nil;
			break;
	}
	
}


+ (void)        get:(NSString *)methodName
         withParams:(NSDictionary *)params 
		   callback:(Foursquare2Callback)callback
{
	[self request:methodName withParams:params httpMethod:@"GET" callback:callback];
}

+ (void)       post:(NSString *)methodName
		 withParams:(NSDictionary *)params
		   callback:(Foursquare2Callback)callback 
{
	[self request:methodName withParams:params httpMethod:@"POST" callback:callback];
}

+ (NSString *)constructRequestUrlForMethod:(NSString *)methodName
                                    params:(NSDictionary *)paramMap {
    NSMutableString *paramStr = [NSMutableString stringWithString: [self classAttributes][@"kBaseUrl"]];
    
    [paramStr appendString:methodName];
	[paramStr appendFormat:@"?client_id=%@",OAUTH_KEY];
    [paramStr appendFormat:@"&client_secret=%@",OAUTH_SECRET];
    [paramStr appendFormat:@"&v=%@",VERSION];
    [paramStr appendFormat:@"&categoryId=%@",CATEGORYID];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleLanguageCode];
    [paramStr appendFormat:@"&locale=%@",countryCode];
    
	NSString *accessToken  = [self classAttributes][@"access_token"];
	if ([accessToken length] > 0)
        [paramStr appendFormat:@"&oauth_token=%@",accessToken];
	
	if(paramMap) {
		NSEnumerator *enumerator = [paramMap keyEnumerator];
		NSString *key, *value;
		
		while ((key = (NSString *)[enumerator nextObject])) {
			value = (NSString *)paramMap[key];
			//DLog(@"value: " @"%@", value);
			
			NSString *urlEncodedValue = [value stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];//NSASCIIStringEncoding];
			
			if(!urlEncodedValue) {
				urlEncodedValue = @"";
			}
			[paramStr appendFormat:@"&%@=%@",key,urlEncodedValue];
		}
	}
	
	return paramStr;
}



#pragma -


static Foursquare2 *instance;
+(Foursquare2*)sharedInstance{
    if (!instance) {
        instance = [[Foursquare2 alloc]init];
    }
    return instance;
    
}

+ (void)    request:(NSString *)methodName 
	     withParams:(NSDictionary *)params 
	     httpMethod:(NSString *)httpMethod
		   callback:(Foursquare2Callback)callback{
    [[Foursquare2 sharedInstance]request:methodName 
                              withParams:params
                              httpMethod:httpMethod
                                callback:callback];   
}

- (void) callback: (NSDictionary *)d target:(FSTargetCallback *)target {
    if (d[@"access_token"]) {
        target.callback(YES,d);
        return;
    }
    NSNumber *code = [d valueForKeyPath:@"meta.code"];
    if (d!= nil && (code.intValue == 200 || code.intValue == 201)) {
        target.callback(YES,d);
    }else{
        target.callback(NO,[d valueForKeyPath:@"meta.errorDetail"]);
    }
}

-(void)    request:(NSString *)methodName 
        withParams:(NSDictionary *)params 
        httpMethod:(NSString *)httpMethod
          callback:(Foursquare2Callback)callback
{
    //	callback = [callback copy];
    NSString *path = [Foursquare2 constructRequestUrlForMethod:methodName
                                                        params:params];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:path ]];
    request.HTTPMethod = httpMethod;
	
    FSTargetCallback *target = [[FSTargetCallback alloc] initWithCallback:callback
                                                       resultCallback:@selector(callback:target:)
                                                           requestUrl: path
                                                             numTries: 2];
	
	[self makeAsyncRequestWithRequest:request 
                               target:target];
}

#ifndef __MAC_OS_X_VERSION_MAX_ALLOWED

Foursquare2Callback authorizeCallbackDelegate;
+(void)authorizeWithCallback:(Foursquare2Callback)callback{
	authorizeCallbackDelegate = [callback copy];
	NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&response_type=token&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
	FSWebLogin *loginCon = [[FSWebLogin alloc] initWithUrl:url];
	loginCon.delegate = self;
	loginCon.selector = @selector(done:);
	UINavigationController *navCon = [[UINavigationController alloc]initWithRootViewController:loginCon];
    navCon.navigationBar.tintColor = [UIColor lightGrayColor];
	UIWindow *mainWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *controller = [self topViewController:mainWindow.rootViewController];
	[controller presentViewController:navCon animated:YES completion:nil];
}

+ (UIViewController *)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}

+(void)done:(NSError*)error{
    if ([Foursquare2 isAuthorized]) {
        [Foursquare2 setBaseURL:kBaseUrl];
        authorizeCallbackDelegate(YES,error);
    }else{
        authorizeCallbackDelegate(NO,error);
    }
    
}
#endif
@end
