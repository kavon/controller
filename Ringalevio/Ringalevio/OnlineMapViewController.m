//
//  AddMapViewController.m
//  Ringalevio
//
//  Created by Tim Sexton on 3/13/14.
//     Edited by Sean Lane, 4/1/14
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

- (void)initMissionItem:(MissionItem *)mi_i
{
    // init map missionitem
    _mi = mi_i;
}

- (void)viewDidLoad

    {
        [super viewDidLoad];
        
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"djtsex.heamjmoi" ];
        
        RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
        
        [self.view addSubview:mapView];
        
        // Default to middle of map coordinates
        CLLocationCoordinate2D mapDefault = CLLocationCoordinate2DMake((_mi.missionNortheast.latitude + _mi.missionSouthwest.latitude)/2,(_mi.missionNortheast.longitude + _mi.missionSouthwest.longitude)/2);
        
        [mapView setZoom:11 atCoordinate:mapDefault animated:YES];
        
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
