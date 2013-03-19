

#import "CheckinViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"

@interface CheckinViewController ()

@end

@implementation CheckinViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Checkin";
    self.venueName.text = self.venue.name;
}

- (void)viewDidUnload {
    [self setVenueName:nil];
    [super viewDidUnload];
}
@end
