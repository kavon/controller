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
    NSLock *mutex;
    GimbalController *gc;
    
    double oldX;
    double oldY;
    double oldZ;
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
    
    double Xdiff = self.x - oldX;
    double Ydiff = self.y - oldY;
    //double Zdiff = self.z - oldZ;
    
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
    
    lc = [[LaserController alloc] init:SERVER_ADDR :DEST_PORT];
    
    // init motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    mutex = [[NSLock alloc] init];
    
    gc = [[GimbalController alloc] init:SERVER_ADDR :DEST_PORT];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25
                                     target:self
                                   selector:@selector(sendUpdate)
                                   userInfo:nil
                                    repeats:YES];
    
    // handle gyroscope: Thanks to stackOverflow
    
    // init motion manager
    self.motionManager = [[CMMotionManager alloc] init];
    
    // check if gyro is present on device
    if([self.motionManager isGyroAvailable])
    {
        /* Start the gyroscope if it is not active already */
        if([self.motionManager isGyroActive] == NO)
        {
            /* Update us 2 times a second */
            [self.motionManager setGyroUpdateInterval:1.0f / 2.0f];
            
            /* Add on a handler block object */
            
            /* Receive the gyroscope data on this block */
            [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue]
                                            withHandler:^(CMGyroData *gyroData, NSError *error)
             {
                 
                 [mutex lock];
                 self.x = gyroData.rotationRate.x;
                 
                 self.y = gyroData.rotationRate.y;
                 
                 self.z = gyroData.rotationRate.z;
                 [mutex unlock];
             }];
        }
    }
    else
    {
        // pitch if no gyro available
        NSLog(@"Gyroscope not Available!");
    }
    
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
    NSLog(@"Roll: %.2f Pitch: %.2f Yaw: %.2f", motion.attitude.roll, motion.attitude.pitch, motion.attitude.yaw);
    self.x = motion.attitude.roll;
    self.y = motion.attitude.pitch;
    self.z = motion.attitude.yaw;
}

// method for sending movement messages to gimbal
-(void) sendMessage
{
    
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
