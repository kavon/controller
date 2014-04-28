//
//  SensorViewController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import "SensorViewController.h"
#import "Network/LaserController.h"
#import "Network/Configuration.h"

@interface SensorViewController ()

// laser control boolean
@property BOOL laserEnabled;

// laser control UI toolbar items
@property (weak, nonatomic) IBOutlet UIBarButtonItem *laserStandbyButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *laserWarningButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *laserOffButton;
@property (weak, nonatomic) IBOutlet UIWebView *videoStream;

// laser control methods
- (IBAction)laserStandbyPress:(id)sender;

@end

@implementation SensorViewController

{
    NSString *streamHTML;
    LaserController *lc;
    uint8_t currentTarget;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // THIS SHIT DOESN'T EVEN GET CALLED BY THE UI BUILDER'S CODE
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    lc = [[LaserController alloc] init:SERVER_ADDR :DEST_PORT];
    
    [self reloadStream];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)reloadStream {
    CGRect screenRect = self.view.bounds;
    int screenWidth = screenRect.size.width;
    int screenHeight = (3 * screenWidth) / 4;
    
    NSLog(@"TRying width %d, height %d.", screenWidth, screenHeight);
    
    // link, NSString, http://192.168.23.35/mjpg/video.mjpg is the defacto link right now.
    // width, int
    // height, int
    //bgcolor=\"#000000\"
    streamHTML = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><center><img id=\"stream\" src=\"%@\" width=\"%d\" height=\"%d\" border=\"0\" alt=\"Error, check your configuration.\"/></center></body></html>", @"http://192.168.23.35/mjpg/video.mjpg", screenWidth, screenHeight];
    
    //streamHTML = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><center><img id=\"stream\" src=\"%@\" border=\"0\" alt=\"Error, check your configuration.\"/></center></body></html>", @"http://192.168.23.35/mjpg/video.mjpg"];
    
    // we're going to tell the sensor to "look" at this target now.
    [lc writeLaserMode:0];
    [lc writeTarget:currentTarget];
    [lc sendLaserMessage];
    
    [self.videoStream loadHTMLString:streamHTML baseURL:nil];
    
    [self.videoStream setUserInteractionEnabled:false];
    
}

- (void) setTargetNumber:(uint8_t)targ {
    currentTarget = targ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// method for setting laser to standby
- (IBAction)laserStandbyPress:(id)sender {
    [lc writeLaserMode:1];
    [lc writeTarget:currentTarget];
    [lc sendLaserMessage];
}

- (IBAction)laserOffPress:(id)sender {
    [lc writeLaserMode:0];
    [lc writeTarget:currentTarget];
    [lc sendLaserMessage];
}

- (IBAction)laserWarnPress:(id)sender {
    [lc writeLaserMode:2];
    [lc writeTarget:currentTarget];
    [lc sendLaserMessage];
}


@end
