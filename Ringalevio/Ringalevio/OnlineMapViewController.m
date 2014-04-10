//
//  AddMapViewController.m
//  Ringalevio
//
//  Created by Tim Sexton on 3/13/14.
//     Edited by Sean Lane, 4/10/14
//
//

#import "OnlineMapViewController.h"
#import "HealthViewController.h"
#import <Mapbox/Mapbox.h>

@interface OnlineMapViewController ()

// UI elements
@property (weak, nonatomic) IBOutlet UIBarButtonItem *laserButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewButton;


// data elements
@property NSString* subtitle1;
@property NSString* subtitle2;
@property RMAnnotation* selectedMarker;

@end

@implementation OnlineMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Method for segue preparation (pass data references)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"healthSegue"]) {
        
        // Get destination view
        HealthViewController *vc = [segue destinationViewController];
        
        // Pass the information to your destination view
        vc.mi = self.mi;
    }
    else
        return;
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
        self.laserButton.enabled = NO;
        self.viewButton.enabled = NO;
        
        // set up mapbox
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"461group.hocfjnai" ];
        
        RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
        
        mapView.Delegate = self;
        
        [self.view addSubview:mapView];
        
        // Default to middle of map coordinates
        CLLocationCoordinate2D mapDefault = CLLocationCoordinate2DMake((self.mi.missionNortheast.longitude + self.mi.missionSouthwest.longitude)/2,(self.mi.missionNortheast.latitude + self.mi.missionSouthwest.latitude)/2);
        
        // set zoom
        [mapView setZoom:14 atCoordinate:mapDefault animated:YES];
        
        self.navigationController.toolbarHidden = NO;
        
        // add some sample markers
        RMAnnotation *annotation1 = [[RMAnnotation alloc] initWithMapView:mapView coordinate:mapView.centerCoordinate
                                                                          andTitle:@"Sensor"];
        annotation1.annotationType = @"sensor";
        
        [mapView addAnnotation:annotation1];
        
        
        RMAnnotation *annotation2 = [[RMAnnotation alloc] initWithMapView:mapView coordinate:CLLocationCoordinate2DMake(annotation1.coordinate.latitude + 0.00005, annotation1.coordinate.longitude - 0.003) andTitle:@"Track 1"];
        annotation2.annotationType = @"track";
        
        [mapView addAnnotation:annotation2];
        
        RMAnnotation *annotation3 = [[RMAnnotation alloc] initWithMapView:mapView coordinate:CLLocationCoordinate2DMake(annotation1.coordinate.latitude + 0.0024, annotation1.coordinate.longitude - 0.0016) andTitle:@"Track 2"];
        annotation3.annotationType = @"track";
        
        [mapView addAnnotation:annotation3];
    }

// method that controls the annotation layer styling
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    RMMarker *marker;
    if ([annotation.annotationType  isEqual: @"track"])
    {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"cross" tintColor:[UIColor redColor]];
    }
    else
    {
        marker = [[RMMarker alloc] initWithMapboxMarkerImage:@"star" tintColor:[UIColor blueColor]];
    }
    self.subtitle1 = [NSString stringWithFormat:@"%.4f", annotation.coordinate.longitude];
    self.subtitle2 = [NSString stringWithFormat:@"%.4f", annotation.coordinate.latitude];
    annotation.subtitle = [self.subtitle1 stringByAppendingString:@", "];
    annotation.subtitle = [annotation.subtitle stringByAppendingString:self.subtitle2];
    
    marker.canShowCallout = YES;
    
    marker.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return marker;
}

- (void)tapOnCalloutAccessoryControl:(UIControl *)control forAnnotation:(RMAnnotation *)annotation onMap:(RMMapView *)map
{
    NSLog(@"You tapped the callout button!");
}

// Delegate function: one of the markers was selected
- (void)mapView:(RMMapView *)mapView didSelectAnnotation:(RMAnnotation *)annotation
{
    // set selected marker in code
    self.selectedMarker = annotation;
    
    // manage buttons
    if ([annotation.annotationType  isEqual: @"sensor"])
    {
        self.laserButton.enabled = NO;
        self.viewButton.enabled = NO;
    }
    else if ([annotation.annotationType  isEqual: @"track"])
    {
        self.laserButton.enabled = YES;
        self.viewButton.enabled = YES;
    }
}


- (void)mapView:(RMMapView *)mapView didDeselectAnnotation:(RMAnnotation *)annotation
{
    // disable buttons and clear marker selection
    self.selectedMarker = nil;
    self.laserButton.enabled = NO;
    self.viewButton.enabled = NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
