//
//  CameraOverlay.h
//  Ringalevio
//
//  Created by Sean Lane on 4/24/14.
//
//

#import <UIKit/UIKit.h>

// camera overlay delegate functions
@protocol CameraOverlayDelegate <NSObject>

// cancel button action to segue back to map
-(void)CancelButtonPress:(id)sender;

@end

@interface CameraOverlay : UIView

// UI elements
@property (strong, nonatomic) UIToolbar *cameraToolbar;
@property (strong, nonatomic) UIBarButtonItem *flexibleSpace;
@property (strong, nonatomic) UIBarButtonItem *addTrackButton;
@property (strong, nonatomic) UIBarButtonItem *cancelButton;

@property (nonatomic, strong) id<CameraOverlayDelegate> delegate;

@end


