//
//  OnlineMapViewController.m
//  Ringalevio
//
//  Online Map View Controller is the view controller subclass that dictates how the map operates.
//
//  Created by Tim Sexton on 3/13/14.
//     Edited by Sean Lane, 4/10/14
//
//

#import "OnlineMapViewController.h"
#import "HealthViewController.h"
#import "SensorViewController.h"
#import "Network/HostReciever.h"
#import "TrackedObject.h"
#import <Mapbox/Mapbox.h>

@interface OnlineMapViewController ()

// UI elements
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewButton;


// data elements
@property NSString* subtitle1;
@property NSString* subtitle2;

// map elements
@property RMAnnotation* selectedMarker;
@property RMMapboxSource* mapSource;

@end

@implementation OnlineMapViewController
{
    NSRecursiveLock *mutex;
    TrackedObject *permRef; //id is irrelevant
    // sensors/tracks are non-positive values
    NSMutableArray *mapItems;
    RMMapView *mapView;
    SensorViewController *svc;
}

-(void) removeOldTracks
{
    [mutex lock];
    NSLog(@"Cleaning out stale tracks.");
    
    NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];
    
    TrackedObject *td = nil;
    // we have to collect them first, because we can't modify the array we're iterating through.
    for(int i = 0; i < [mapItems count]; i++) {
        td = [mapItems objectAtIndex:i];
        
        if([td getID] <= 0) {
            continue; // we do not remove other items for being stale such as sensors.
        }
        
        if([[td getTimestamp] timeIntervalSinceNow] <= -10.0) {
            [toBeRemoved addObject:[NSNumber numberWithInt:[td getID]]];
        }
    }
    
    for(int i = 0; i < [toBeRemoved count]; i++) {
        [self removeTrackID:[[toBeRemoved objectAtIndex:i] intValue]];
        if([svc getTargetNumber] != nil && [[svc getTargetNumber] getID] == [[toBeRemoved objectAtIndex:i] intValue]) {
            [svc setTargetNumber:nil];
        }
    }
    
    [mutex unlock];
}

/**
 * Fields: @"sensor_id", @"x_position", @"y_position", "z_position"
 */
-(void) recievedSensorLocationMessage: (NSDictionary*) data
{
    [mutex lock];

    int32_t theID = [[data valueForKey:@"sensor_id"] intValue];
    theID = -theID; // it's not a track, don't drop it due to inactivity.
    TrackedObject *td = nil;
    for(int i = 0; i < [mapItems count]; i++) {
        if([[mapItems objectAtIndex:i] getID] == theID) {
            td = [mapItems objectAtIndex:i];
        }
    }
    
    // we gotta make a new one.
    if(td == nil) {
        td = [[TrackedObject alloc] initWithID:theID];
        [mapItems addObject:td];
    }
    
    [td setX:[[data valueForKey:@"x_position"] intValue]];
    [td setY:[[data valueForKey:@"y_position"] intValue]];
    [td setZ:[[data valueForKey:@"z_position"] intValue]];
    [td updatePosition:permRef];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([td getLatitude], [td getLongitude]);
    
    // gotta make onea these too.
    RMAnnotation *annotation = [td getAnnotation];
    if(annotation == nil) {
        annotation = [[RMAnnotation alloc] initWithMapView:mapView coordinate:coord andTitle:[NSString stringWithFormat:@"Sensor %d", theID]];
        annotation.annotationType = @"sensor";
        [td setAnnotation:annotation];
        [mapView addAnnotation:annotation];
    } else {
        // for tracks
        [annotation setCoordinate:coord];
        [self mapView:self->mapView layerForAnnotation:annotation];
    }
    
    [mutex unlock];
}

/**
 * Fields: @"sensor_id", @"x_position", @"y_position", "z_position"
 */
-(void) recievedTrackSourceLocationMessage: (NSDictionary*) data
{
    [mutex lock];
    
    int32_t theID = [[data valueForKey:@"sensor_id"] intValue];
    theID = -theID; // it's not a track, don't drop it due to inactivity.
    TrackedObject *td = nil;
    for(int i = 0; i < [mapItems count]; i++) {
        if([[mapItems objectAtIndex:i] getID] == theID) {
            td = [mapItems objectAtIndex:i];
        }
    }
    
    // we gotta make a new one.
    if(td == nil) {
        td = [[TrackedObject alloc] initWithID:theID];
        [mapItems addObject:td];
    }
    
    [td setX:[[data valueForKey:@"x_position"] intValue]];
    [td setY:[[data valueForKey:@"y_position"] intValue]];
    [td setZ:[[data valueForKey:@"z_position"] intValue]];
    [td updatePosition:permRef];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([td getLatitude], [td getLongitude]);
    
    // gotta make onea these too.
    RMAnnotation *annotation = [td getAnnotation];
    if(annotation == nil) {
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView coordinate:coord andTitle:[NSString stringWithFormat:@"Track Source %d", theID]];
        annotation.annotationType = @"sensor";
        [td setAnnotation:annotation];
        [mapView addAnnotation:annotation];
    } else {
        [annotation setCoordinate:coord];
    }
    
    [mutex unlock];
}

/**
 * Fields: @"sensor_id", @"track_number", @"x_position", @"y_position", "z_position"
 */
-(void) recievedTrackUpdateMessage: (NSDictionary*) data
{
    // TODO: THE SENSOR THAT IS ASSOCIATED TO THE TRACK IS CURRENTLY UNIMPLEMENTED.
    // WE ASSUME ONE SENSOR RIGHT NOW.
    
    [mutex lock];
    
    int32_t theID = [[data valueForKey:@"track_number"] intValue];
    TrackedObject *td = nil;
    for(int i = 0; i < [mapItems count]; i++) {
        if([[mapItems objectAtIndex:i] getID] == theID) {
            td = [mapItems objectAtIndex:i];
        }
    }
    
    // we gotta make a new one.
    if(td == nil) {
        td = [[TrackedObject alloc] initWithID:theID];
        [mapItems addObject:td];
    }
    
    
    
    [td setX:[[data valueForKey:@"x_position"] intValue]];
    [td setY:[[data valueForKey:@"y_position"] intValue]];
    [td setZ:[[data valueForKey:@"z_position"] intValue]];
    [td updatePosition:permRef];
    
    //NSLog(@"ref pt -- x: %u, y: %u, z: %u", [permRef getX], [permRef getY], [permRef getZ]);
    //NSLog(@"ref pt -- lat: %g, long: %g", [permRef getLatitude], [permRef getLongitude]);
    
    //NSLog(@"new track -- x: %i, y: %i, z: %i", [td getX], [td getY], [td getZ]);
    //NSLog(@"new track -- lat: %g, long: %g", [td getLatitude], [td getLongitude]);
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([td getLatitude], [td getLongitude]);
    
    // gotta make onea these too.
    RMAnnotation *annotation = [td getAnnotation];
    if(annotation == nil) {
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView coordinate:coord andTitle:[NSString stringWithFormat:@"Track %d", theID]];
        annotation.annotationType = @"track";
        [td setAnnotation:annotation];
        [mapView addAnnotation:annotation]; // TODO: might be unnessecary.
    } else {
        [annotation setCoordinate:coord];
    }
    
    [td refreshTimestamp]; // track's can expire.
    
    [mutex unlock];
}

/**
 * Fields: @"sensor_id", @"track_number"
 */
-(void) recievedTrackDropMessage: (NSDictionary*) data
{   [mutex lock];
    int32_t theID = [[data valueForKey:@"track_number"] intValue];
    NSLog(@"removing track %i by request", theID);
    [self removeTrackID:theID];
    [mutex unlock];
}

-(void) removeTrackID: (int32_t) theID {
    [mutex lock];
    TrackedObject *td = nil;
    int i = 0;
    for(; i < [mapItems count]; i++) {
        if([[mapItems objectAtIndex:i] getID] == theID) {
            td = [mapItems objectAtIndex:i];
            break;
        }
    }
    
    if (td != nil) {
        [mapView removeAnnotation:[td getAnnotation]];
        [mapItems removeObjectAtIndex:i];
        NSLog(@"REMOVED TRACK %i", theID);
    }
    
    [mutex unlock];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Method for segue preparation (pass data references, prepare network for next panel)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // segue to health web page
    if ([segue.identifier  isEqual: @"healthSegue"]) {
        
        // Get destination view
        HealthViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        vc.mi = self.mi;
    
    } else if ([segue.identifier  isEqual: @"sensorSegue"]) {
        // segue to sensor, "move to target" network packet goes here
        [mutex lock];
        svc = [segue destinationViewController];
        svc.mi = self.mi;
        
        TrackedObject *td = nil;
        // we have to collect them first, because we can't modify the array we're iterating through.
        
        for(int i = 0; i < [mapItems count]; i++) {
            td = [mapItems objectAtIndex:i];
            
            if([td getAnnotation] == self.selectedMarker) {
                [svc setTargetNumber:td];
                break;
            }
        }
        [mutex unlock];
        
        [svc reloadStream];
        
    }

}

- (void)initMissionItem:(MissionItem *)mi_i
{
 
   // init map missionitem
    self.mi = mi_i;
}

- (void)viewDidLoad

{
        [super viewDidLoad];
        
        // disable buttons initially
        self.viewButton.enabled = NO;
        
        // set up mapbox
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"Mapbox" ofType:@"json"];
        NSError *error = nil;
        NSString* tileJSON = [NSString stringWithContentsOfFile:fullPath encoding:NSASCIIStringEncoding error:&error];
        
        // check error
        if (tileJSON == nil)
            NSLog(@"error: %@", [error description]);
        
        self.mapSource = [[RMMapboxSource alloc] initWithTileJSON:tileJSON];
        
        mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:self.mapSource];
        
        mapView.Delegate = self;
        
        [self.view addSubview:mapView];
        
        // Default to middle of map coordinates
        CLLocationCoordinate2D mapDefault = CLLocationCoordinate2DMake((self.mi.missionNortheast.longitude + self.mi.missionSouthwest.longitude)/2,(self.mi.missionNortheast.latitude + self.mi.missionSouthwest.latitude)/2);
        
        // set zoom
        [mapView setZoom:12 atCoordinate:mapDefault animated:YES];
        
        self.navigationController.toolbarHidden = NO;
        
        
        /////
        // initialize map network recieving stuff.
        /////
        
        mutex = [[NSRecursiveLock alloc] init];
        
        permRef = [[TrackedObject alloc] initFixedLat:[self.mi missionReferencePoint].longitude andLong:[self.mi missionReferencePoint].latitude andAlt:[self.mi missionReferencePointAltitude]];
        
        mapItems = [[NSMutableArray alloc] init];
        
        // register this instance of a packet listerner with the host reciever.
        // this should be the last thing done in this block.
        [[HostReciever getInstance] registerListener:self];
        
        [NSTimer scheduledTimerWithTimeInterval:10.0
                                         target:self
                                       selector:@selector(removeOldTracks)
                                       userInfo:nil
                                        repeats:YES];
        
}

-(void)viewDidAppear:(BOOL)animated
{
    // unhide toolbar
    self.navigationController.toolbarHidden = NO;
}


// method that controls the annotation layer styling
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMarker *marker;
    if ([annotation.annotationType  isEqual: @"track"])
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"star"]];
    }
    else
    {
        marker = [[RMMarker alloc] initWithUIImage:[UIImage imageNamed:@"cross"]];
    }
    self.subtitle1 = [NSString stringWithFormat:@"%.4f", annotation.coordinate.longitude];
    self.subtitle2 = [NSString stringWithFormat:@"%.4f", annotation.coordinate.latitude];
    annotation.subtitle = [self.subtitle1 stringByAppendingString:@", "];
    annotation.subtitle = [annotation.subtitle stringByAppendingString:self.subtitle2];
    
    marker.canShowCallout = YES;
    
    return marker;
}

// Delegate function: one of the markers was selected
- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation
{
    // set selected marker in code
    self.selectedMarker = annotation;
    
    // manage buttons
    if ([annotation.annotationType  isEqual: @"sensor"])
    {
        self.viewButton.enabled = NO;
    }
    else if ([annotation.annotationType  isEqual: @"track"])
    {
        self.viewButton.enabled = YES;
    }
}


- (void)mapView:(RMMapView *)mapView didDeselectAnnotation:(RMAnnotation *)annotation
{
    // disable buttons and clear marker selection
    self.selectedMarker = nil;
    self.viewButton.enabled = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
