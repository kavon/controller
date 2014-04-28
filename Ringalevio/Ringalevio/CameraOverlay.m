//
//  CameraOverlay.m
//  Ringalevio
//
//  Created by Sean Lane on 4/24/14.
//
//

#import "CameraOverlay.h"

@implementation CameraOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code goes here
        // set background color
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        // init toolbar
        self.cameraToolbar = [[UIToolbar alloc] init];
        self.cameraToolbar.frame = CGRectMake(0, self.frame.size.height - 45, self.frame.size.width, 45);
        
        // init toolbar items
        self.flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        self.addTrackButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Track" style:UIBarButtonItemStyleBordered target:self action:@selector(AddTrackButtonPress)];
        self.cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(CancelButtonPress:)];
        
        // place items in array
        NSMutableArray *items = [NSMutableArray arrayWithObjects:self.flexibleSpace, self.addTrackButton, self.flexibleSpace, self.cancelButton, self.flexibleSpace, nil];
        
        // set toolbar to use array, add to view
        [self.cameraToolbar setItems:items animated:NO];
        [self addSubview:self.cameraToolbar];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(IBAction)CancelButtonPress:(id)sender
{
    [self.delegate CancelButtonPress:self];
    NSLog(@"Cancel pressed");
}

-(void) AddTrackButtonPress
{
    NSLog(@"Add Track Pressed");
}

@end
