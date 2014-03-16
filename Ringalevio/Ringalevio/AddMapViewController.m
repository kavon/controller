//
//  AddMapViewController.m
//  Ringalevio
//
//  Created by Tim Sexton on 3/13/14.
//
//

#import "AddMapViewController.h"

#import <Mapbox/Mapbox.h>

@interface AddMapViewController ()

@end

@implementation AddMapViewController

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
        
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"examples.map-z2effxa8"];
        
        RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];
        
        [self.view addSubview:mapView];
    }


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
