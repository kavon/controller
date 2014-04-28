//
//  AddTrackViewController.h
//  Ringalevio
//
//  Created by Sean Lane on 4/17/14.
//
//

#import <UIKit/UIKit.h>
#import "CameraOverlay.h"

@interface AddTrackViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// camera picker object (inits camera)
@property UIImagePickerController *pickerController;

// camera view object
@property (weak, nonatomic) IBOutlet UIImageView *cameraView;

@end
