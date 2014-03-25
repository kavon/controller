//
//  AddMissionViewController.m
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import "AddMissionViewController.h"

@interface AddMissionViewController ()

// interface builder items
@property (weak, nonatomic) IBOutlet UITextField *missionName;
@property (weak, nonatomic) IBOutlet UITextField *missionHealthURL;
@property (weak, nonatomic) IBOutlet UITextField *northeastX;
@property (weak, nonatomic) IBOutlet UITextField *northeastY;
@property (weak, nonatomic) IBOutlet UITextField *southwestX;
@property (weak, nonatomic) IBOutlet UITextField *southwestY;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cacheButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;

// doubles for lat and long cache system
@property double northeastXdouble;
@property double northeastYdouble;
@property double southwestXdouble;
@property double southwestYdouble;

// bool for cache status
@property BOOL cached;

@end

@implementation AddMissionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.progressSpinner.hidden = true;
        self.cached = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// function to be called by "cache maps" button
- (IBAction)cacheButtonPress:(id *)sender
{
    if ((self.northeastX.text.length > 0) && (self.northeastY.text.length > 0) && (self.southwestX.text.length > 0)&& (self.southwestY.text.length > 0)) {
        
        // set doubles from text boxes
        self.northeastXdouble = [[_northeastX text] doubleValue];
        self.northeastYdouble = [[_northeastY text] doubleValue];
        self.southwestXdouble = [[_southwestX text] doubleValue];
        self.southwestYdouble = [[_southwestY text] doubleValue];
        
        //mapbox online tile source
        RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"djtsex.heamjmoi" ];
    
        // background tile cache
        [self.mi.cache beginBackgroundCacheForTileSource:(tileSource) southWest:(makeCoordinate(_southwestXdouble, _southwestYdouble)) northEast:(makeCoordinate(_northeastXdouble, _northeastYdouble)) minZoom:(13) maxZoom: (15)];
        
        // animate progress cursor
        self.progressSpinner.hidden = false;
        
        // block while caching?
        /*while ([self.mi.cache isBackgroundCaching] != false)
        {
            self.doneButton.enabled = false;
            
        }*/
        
        // renable done button, stop animation
        self.doneButton.enabled = true;
        self.progressSpinner.hidden = true;
        self.cacheButton.enabled = false;
        
        // set cache flag
        self.cached = true;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // only proceed if done button calls this
    if (sender != self.doneButton) return;
    
    // if there is text in the name and mission health fields, and cache successful
    if ((self.missionName.text.length > 0) && (self.missionHealthURL.text.length > 0) && (self.cached == true)) {
        self.mi = [[MissionItem alloc] init];
        self.mi.missionName = self.missionName.text;
        self.mi.missionHealthURL = self.missionHealthURL.text;
        self.mi.missionNortheast = makeCoordinate(_northeastXdouble, _northeastYdouble);
        self.mi.missionSouthwest = makeCoordinate(_southwestXdouble, _southwestYdouble);
    }
}

// constructor for 2d coordinate for cache system
CLLocationCoordinate2D makeCoordinate (double longitude_i, double latitude_i)
{
    CLLocationCoordinate2D missionNortheast_i;
    missionNortheast_i.longitude = longitude_i;
    missionNortheast_i.latitude = latitude_i;
    return missionNortheast_i;
}

@end
