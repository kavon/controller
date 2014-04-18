//
//  AddTrackViewController.h
//  Ringalevio
//
//  Created by Sean Lane on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"

@interface AddTrackViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// camera picker object (inits camera)
@property UIImagePickerController *pickerController;

// camera overlay view
@property CameraOverlayViewController* cameraOverlay;

// camera view object
@property (weak, nonatomic) IBOutlet UIImageView *cameraView;

@end
