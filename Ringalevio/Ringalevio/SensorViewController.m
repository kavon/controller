//
//  SensorViewController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import "SensorViewController.h"
#import "Network/LaserController.h"
#import "Network/Configuration.h"
#import "Network/TrackSpotter.h"
#import "Network/TrackDropper.h"

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
    NSLock *mutex;
    NSLock *ts_mutex;
    GimbalController *gc;
    TrackSpotter *ts;
    TrackDropper *dropper;
    
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
    
    double pi = 3.14159/4;
    double speedStep = 64/pi;
    double tolerance = pi/12;
    
    if(self.y > pi) {
        self.y = pi;
    } else if(self.y < -pi) {
        self.y = -pi;
    }
    
    if(self.x > pi) {
        self.x = pi;
    } else if(self.x < -pi) {
        self.x = -pi;
    }
    
    if(self.x > tolerance) {
        NSLog(@"Positive roll.\n");
        
        [gc writeAzimuthSpeed:-self.x*speedStep];
        
    } else if (self.x < -tolerance) {
        
        NSLog(@"Negative roll.\n");
        
        [gc writeAzimuthSpeed:-self.x*speedStep];
        
    } else {
        
        NSLog(@"You've centered roll.\n");
        
        [gc writeAzimuthSpeed:0];
        
    }
    
    if (self.y > tolerance) {
        
        NSLog(@"Positive pitch.\n");
        [gc writeElevationSpeed:-self.y*speedStep];
        
    } else if (self.y < -tolerance) {
        
        NSLog(@"Negative pitch.\n");
        [gc writeElevationSpeed:-self.y*speedStep];
        
    } else {
        NSLog(@"You've centered pitch\n");
        [gc writeElevationSpeed:0];
    }
    
    [gc writeEnableTrackingMode:false];
    
    [gc sendGimbalMessage];
    
    [mutex unlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    lc = [[LaserController alloc] init:SERVER_ADDR :DEST_PORT];
    
    // init motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    mutex = [[NSLock alloc] init];
    
    ts_mutex = [[NSLock alloc] init];
    
    gc = [[GimbalController alloc] init:SERVER_ADDR :DEST_PORT];
    
    ts = [[TrackSpotter alloc] init:SERVER_ADDR :DEST_PORT];
    
    dropper = [[TrackDropper alloc] init:SERVER_ADDR :DEST_PORT];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(sendUpdate)
                                   userInfo:nil
                                    repeats:YES];
    
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
    
    static bool sentOne = false;
    
    if(self.currentTarget != nil) {
        
        //NSLog(@"Will send a message!!!!!\n");
        
        [ts writeTarget:[self.currentTarget getID]];
        [ts writePositionX:[self.currentTarget getX]];
        [ts writePositionY:[self.currentTarget getY]];
        [ts writePositionZ:[self.currentTarget getZ]];
        
        [ts sendTrackUpdateMessage];
        
        sentOne = true;
        
    } else if(sentOne) {
        sentOne = false;
        [dropper writeTarget:(uint8_t)1];
        [dropper sendTrackDropMessage];
        NSLog(@"Sent Target Drop");
    } else {
        //NSLog(@"Decided to not send a message.\n");
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
    NSLog(@"\n\nSETTING TARGET NUMBER, is it nil? %i\n\n", targ == nil);
    self.currentTarget = targ;
    [ts_mutex unlock];
}

-(TrackedObject*) getTargetNumber {
    [ts_mutex lock];
    TrackedObject *cur = self.currentTarget;
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
    [lc writeTarget:[self.currentTarget getID]];
    [lc sendLaserMessage];
}

- (IBAction)laserOffPress:(id)sender {
    [lc writeLaserMode:0];
    [lc writeTarget:[self.currentTarget getID]];
    [lc sendLaserMessage];
}

- (IBAction)laserWarnPress:(id)sender {
    [lc writeLaserMode:2];
    [lc writeTarget:[self.currentTarget getID]];
    [lc sendLaserMessage];
}


@end
