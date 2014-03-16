//
//  SensorViewController.m
//  Ringalevio
//
//  Created by Kavon Farvardin on 3/15/14.
//

#import "SensorViewController.h"

@interface SensorViewController ()

@end

@implementation SensorViewController

{
    NSString *streamLocation;
    UIWebView *videoView;
}

-(id)init
{
    CGRect f = self.view.bounds;
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        CGFloat temp = f.size.width;
        f.size.width = f.size.height;
        f.size.height = temp;
    }
    
    videoView = [[UIWebView alloc] initWithFrame:f];
    
    // link, NSString, http://192.168.1.90/mjpg/video.mjpg is the defacto link right now.
    // width, int
    // height, int
    streamLocation = [NSString stringWithFormat:@"<html><body style=\"margin:0; padding:0\"><img id=\"stream\" src=\"%@\" width=\"%d\" height=\"%d\" border=\"0\" alt=\"If no image is displayed, check your configuration.\"></body></html>", @"http://192.168.1.90/mjpg/video.mjpg", (int)f.size.width, (int)f.size.height];
    
    [videoView loadHTMLString:streamLocation baseURL:NULL];
    
    // remove the user's ability to "scroll" in this web view.
    videoView.userInteractionEnabled = NO;
    
    [self.view addSubview:videoView];
    
    return self;
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

@end
