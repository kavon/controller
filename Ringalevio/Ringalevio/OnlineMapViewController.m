//
//  AddMapViewController.m
//  Ringalevio
//
//  Created by Tim Sexton on 3/13/14.
//
//

#import "OnlineMapViewController.h"

#import <Mapbox/Mapbox.h>

@interface OnlineMapViewController ()

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

- (void)viewDidLoad

    {
        [super viewDidLoad];
        
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"djtsex.heamjmoi" ];
        
        RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
        
        [self.view addSubview:mapView];
        
        // Default View to State College
        CLLocationCoordinate2D NorthEastStateCollege = CLLocationCoordinate2DMake(40.8196546,-77.8336887);
        
        CLLocationCoordinate2D SouthWestStateCollege = CLLocationCoordinate2DMake(40.7811256,-77.8711967);
        
        CLLocationCoordinate2D StateCollege = CLLocationCoordinate2DMake(40.7880144,-77.8525715);
        
        [mapView setZoom:13 atCoordinate:StateCollege animated:YES];
        
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
