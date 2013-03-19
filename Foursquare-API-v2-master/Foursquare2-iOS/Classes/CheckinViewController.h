

#import <UIKit/UIKit.h>
@class FSVenue;
@interface CheckinViewController : UIViewController

@property(strong,nonatomic)FSVenue* venue;
@property (strong, nonatomic) IBOutlet UILabel *venueName;
- (IBAction)checkin:(id)sender;



@end
