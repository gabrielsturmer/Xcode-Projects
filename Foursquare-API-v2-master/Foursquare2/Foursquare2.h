

#import <Foundation/Foundation.h>
#import "FSRequester.h"
#ifndef __MAC_OS_X_VERSION_MAX_ALLOWED
#import "FSWebLogin.h"
#endif




//1
#define OAUTH_KEY    (@"ABNHFZACB3THGP2WKZBYAUVUQTQZXRF4DTOZZNJ2EWUOFMIT")
#define OAUTH_SECRET (@"LVWKP1H43NBU3YHU51HQFMGYS0JU0R2PZUASV1ZT4E1AGOHF")
#define CATEGORYID (@"4d4b7105d754a06374d81259")

//2, don't forget to added app url in your info plist file CFBundleURLTypes
#define REDIRECT_URL @"app://Foursquare2-iOS"

//3 update this date to use up-to-date Foursquare API
#define VERSION (@"20130117")




#define kBaseUrl @"https://api.foursquare.com/v2/"



typedef void(^Foursquare2Callback)(BOOL success, id result);

typedef enum {
	sortRecent,
	sortNearby,
	sortPopular
} FoursquareSortingType;

typedef enum {
	problemMislocated,
	problemClosed,
	problemDuplicate
} FoursquareProblemType;

typedef enum {
	broadcastPrivate,
	broadcastPublic,
	broadcastFacebook,
	broadcastTwitter,
	broadcastBoth
} FoursquareBroadcastType;

typedef enum {
	intentCheckin,
	intentBrowse,
	intentGlobal,
	intentMatch
} FoursquareIntentType;

@interface Foursquare2 : FSRequester {
	
}

+ (void)setBaseURL:(NSString *)uri;
+(void)setAccessToken:(NSString*)token;
+(void)removeAccessToken;
+(BOOL)isNeedToAuthorize;
+(BOOL)isAuthorized;
#pragma mark -

#pragma mark ---------------------------- Users ------------------------------------------------------------------------
+(void)authorizeWithCallback:(Foursquare2Callback)callback;
 
// !!!: 1. userID is a valid user ID or "self" 
+(void)getDetailForUser:(NSString*)userID
			  callback:(Foursquare2Callback)callback;


//For now, only "self" is supported
+(void)getVenuesVisitedByUser:(NSString*)userID
					 callback:(Foursquare2Callback)callback;




#pragma mark ---------------------------- Venues ------------------------------------------------------------------------

+(void)getDetailForVenue:(NSString*)venueID
				callback:(Foursquare2Callback)callback;

+(void)getVenueCategoriesCallback:(Foursquare2Callback)callback;

+(void)searchVenuesNearByLatitude:(NSNumber*) lat
						longitude:(NSNumber*)lon
					   accuracyLL:(NSNumber*)accuracyLL
						 altitude:(NSNumber*)altitude
					  accuracyAlt:(NSNumber*)accuracyAlt
							query:(NSString*)query
							limit:(NSNumber*)limit
						   intent:(FoursquareIntentType)intent
                           radius:(NSNumber*)radius
						 callback:(Foursquare2Callback)callback;

+(void)searchVenuesInBoundingQuadrangleS:(NSNumber*)s
                                       w:(NSNumber*)w
                                       n:(NSNumber*)n
                                       e:(NSNumber*)e
                                   query:(NSString*)query
                                   limit:(NSNumber*)limit
                                callback:(Foursquare2Callback)callback;
#pragma mark Aspects

+(void)getVenueHereNow:(NSString*)venueID
				 limit:(NSString*)limit
				offset:(NSString*)offset
		afterTimestamp:(NSString*)afterTimestamp
			  callback:(Foursquare2Callback)callback;

+(void)getTipsFromVenue:(NSString*)venueID
				   sort:(FoursquareSortingType)sort
			   callback:(Foursquare2Callback)callback;


#pragma mark ---------------------------- Settings ------------------------------------------------------------------------

+(void)getAllSettingsCallback:(Foursquare2Callback)callback;

@end
