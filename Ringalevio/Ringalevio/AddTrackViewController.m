//
//  AddTrackViewController.m
//  Ringalevio
//
//  Created by Sean Lane on 4/17/14.
//
//

#import "AddTrackViewController.h"

@interface AddTrackViewController ()

-(IBAction)AddTrackButtonPress:(id)sender;

@end

@implementation AddTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // prevent non-camera equipped iOS devices (or simulator) from exploding from camera access
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *cameraAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Camera Found on Device!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [cameraAlertView show];
        
    }
    else
    {
        // initialize camera, set proper options
        self.pickerController = [[UIImagePickerController alloc] init];
        self.pickerController.delegate = self;
        self.pickerController.allowsEditing = NO;
        self.pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        self.pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.pickerController.showsCameraControls = NO;
        self.pickerController.navigationBarHidden = NO;
        self.pickerController.toolbarHidden = YES;
        
        // add camera to panel
        [self addChildViewController:self.pickerController];
        
        [self.pickerController didMoveToParentViewController:self];
        
        [self.view addSubview:self.pickerController.view];
        
        // set size of camera
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        int heightOffset = 0;
        
        float cameraAspectRatio = 4.0 / 3.0; //! Note: 4.0 and 4.0 works
        float imageWidth = floorf(screenSize.width * cameraAspectRatio);
        float scale = ceilf(((screenSize.height + heightOffset) / imageWidth) * 10.0) / 10.0;
        self.pickerController.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
        
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
                     NSString *x = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.x];
                     
                     NSString *y = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.y];
                     
                     NSString *z = [[NSString alloc] initWithFormat:@"%.02f",gyroData.rotationRate.z];
                 }];
            }
        }
        else
        {
            // pitch if no gyro available
            NSLog(@"Gyroscope not Available!");
        }
        
        if([self.motionManager isMagnetometerAvailable])
        {
            if([self.motionManager isMagnetometerActive] == NO)
            {
                [self.motionManager setMagnetometerUpdateInterval:1.0f / 2.0f];
                
                //[self.motionManager startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:(CMMagnetometerData *magData, NSError *error)
                 //{
                   //  NSString *magX = [[NSString alloc] initWithFormat:@"%.02f", magData.magneticField.x];
                     
                     //NSString
                 //}]
            }
        }
        // handle compass (TODO)

    }
    
}

// call camera when view has loaded
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

-(IBAction)AddTrackButtonPress:(id)sender
{
    
}

@end
