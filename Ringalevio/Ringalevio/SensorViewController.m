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
    NSString *streamLocation;
    LaserController *lc;
    uint8_t currentTarget;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        lc = [[LaserController alloc] init:SERVER_ADDR :SERVER_RCV_PORT];
        
        currentTarget = 0;
        
        //CGRect f = self.view.bounds;
        
        // link, NSString, http://192.168.23.35/mjpg/video.mjpg is the defacto link right now.
        // width, int
        // height, int
        //streamLocation = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><center><img id=\"stream\" src=\"%@\" width=\"%d\" height=\"%d\" border=\"0\" alt=\"Error, check your configuration.\"/></center></body></html>", @"http://192.168.23.35/mjpg/video.mjpg", 160, 100];
        
        //streamLocation = @"<html><body style=\"margin:0; padding:0\"><center><h1>VIDEO STREAM SHOULD APPEAR.</h1></center></body></html>";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadStream];
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)reloadStream {
    //[self.videoStream loadHTMLString:streamLocation baseURL:nil];
    
    // create URL
    NSString *fullURL = @"http://google.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    // go to webpage
    [self.videoStream loadRequest:requestObj];
    
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
