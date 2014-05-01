//
//  SensorViewController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import "SensorViewController.h"
#import "Network/LaserController.h"
#import "Network/Configuration.h"
#import "NEtwork/TrackSpotter.h"

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
    TrackedObject *currentTarget;
    NSLock *mutex;
    NSLock *ts_mutex;
    GimbalController *gc;
    TrackSpotter *ts;
    
    int oldX;
    int oldY;
    int oldZ;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // THIS SHIT DOESN'T EVEN GET CALLED BY THE UI BUILDER'S CODE
        
    }
    return self;
}

-(void)sendUpdate {
    [mutex lock];
    
    int fixedSpeed = 5;
    
    double Xdiff = (int)self.x - oldX;
    double Ydiff = (int)self.y - oldY;
    //double Zdiff = (int)self.z - oldZ;
    
    oldX = self.x;
    oldY = self.y;
    oldZ = self.z;
    
    if(Xdiff > 0) {
        [gc writeAzimuthSpeed:fixedSpeed];
    } else if (Xdiff < 0) {
        [gc writeAzimuthSpeed:-fixedSpeed];
    } else {
        [gc writeElevationSpeed:0];
    }
    
    if (Ydiff > 0) {
        [gc writeElevationSpeed:fixedSpeed];
    } else if (Ydiff < 0) {
        [gc writeElevationSpeed:-fixedSpeed];
    } else {
        [gc writeElevationSpeed:0];
    }
    
    [gc writeEnableTrackingMode:true];
    
    [gc sendGimbalMessage];
    
    [mutex unlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentTarget = nil;
    
    lc = [[LaserController alloc] init:SERVER_ADDR :DEST_PORT];
    
    // init motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    mutex = [[NSLock alloc] init];
    
    ts_mutex = [[NSLock alloc] init];
    
    gc = [[GimbalController alloc] init:SERVER_ADDR :DEST_PORT];
    
    ts = [[TrackSpotter alloc] init:SERVER_ADDR :DEST_PORT];
    /*
    [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(sendUpdate)
                                   userInfo:nil
                                    repeats:YES];
    */
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(sendMessage)
                                   userInfo:nil
                                    repeats:YES];

    
    [self reloadStream];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    // start motion reporting
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        [self processMotion:motion];
    }];
}

// enable motion tracking
-(void) enableMotion
{
    CMDeviceMotion *deviceMotion = self.motionManager.deviceMotion;
    self.attitude = deviceMotion.attitude;
    [self.motionManager startDeviceMotionUpdates];
}

-(void)processMotion:(CMDeviceMotion*)motion {
    // constantly set roll/pitch/yaw, send to console as well
    //NSLog(@"Roll: %.2f Pitch: %.2f Yaw: %.2f", motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw);
    self.x = motion.attitude.roll;
    self.y = motion.attitude.pitch;
    self.z = motion.attitude.yaw;
}

// method for sending movement messages to gimbal
-(void) sendMessage
{
    [ts_mutex lock];
    
    if(currentTarget != nil) {
        
        [ts writeTarget:[currentTarget getID]];
        [ts writePositionX:[currentTarget getX]];
        [ts writePositionY:[currentTarget getY]];
        [ts writePositionZ:[currentTarget getZ]];
        
        [ts sendTrackUpdateMessage];
        
    }
    
    [ts_mutex unlock];
}

// method for leaving this view
-(void) viewWillDisappear:(BOOL)animated
{
    // stop updating the motion controls
    [self.motionManager stopDeviceMotionUpdates];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)reloadStream {
    CGRect screenRect = self.view.bounds;
    int screenWidth = screenRect.size.width;
    int screenHeight = (3 * screenWidth) / 4;
    
    NSLog(@"Trying width %d, height %d.", screenWidth, screenHeight);
    
    // link, NSString, http://192.168.23.35/mjpg/video.mjpg is the defacto link right now.
    // width, int
    // height, int
    //bgcolor=\"#000000\"
    streamHTML = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><center><img id=\"stream\" src=\"%@\" width=\"%d\" height=\"%d\" border=\"0\" alt=\"Error, check your configuration.\"/></center></body></html>", @"http://192.168.23.35/mjpg/video.mjpg", screenWidth, screenHeight];
    
    //streamHTML = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><center><img id=\"stream\" src=\"%@\" border=\"0\" alt=\"Error, check your configuration.\"/></center></body></html>", @"http://192.168.23.35/mjpg/video.mjpg"];
    
    [self.videoStream loadHTMLString:streamHTML baseURL:nil];
    
    [self.videoStream setUserInteractionEnabled:false];
    
}

- (void) setTargetNumber:(TrackedObject*)targ {
    [ts_mutex lock];
    currentTarget = targ;
    [ts_mutex unlock];
}

-(TrackedObject*) getTargetNumber {
    [ts_mutex lock];
    TrackedObject *cur = currentTarget;
    [ts_mutex unlock];
    return cur;
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
    [lc writeTarget:[currentTarget getID]];
    [lc sendLaserMessage];
}

- (IBAction)laserOffPress:(id)sender {
    [lc writeLaserMode:0];
    [lc writeTarget:[currentTarget getID]];
    [lc sendLaserMessage];
}

- (IBAction)laserWarnPress:(id)sender {
    [lc writeLaserMode:2];
    [lc writeTarget:[currentTarget getID]];
    [lc sendLaserMessage];
}


@end
