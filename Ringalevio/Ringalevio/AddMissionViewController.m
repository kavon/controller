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
@property (weak, nonatomic) IBOutlet UITextField *referencePointX;
@property (weak, nonatomic) IBOutlet UITextField *referencePointY;
@property (weak, nonatomic) IBOutlet UITextField *referencePointAlt;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *cacheButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressSpinner;

// doubles for lat and long cache system
@property double northeastXdouble;  //longitude
@property double northeastYdouble;  //latitude
@property double southwestXdouble;
@property double southwestYdouble;
@property double referencePointXdouble;
@property double referencePointYdouble;
@property double referencePointAltdouble;


@property RMTileCache* tileCache;
@property RMMapboxSource* mapSource;

// bool for cache status
@property BOOL cached;

@end

@implementation AddMissionViewController

// offset for keyboard; scrollfixes provided by internet
#define kOFFSET_FOR_KEYBOARD 100.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if (([sender isEqual:self.northeastX]) || ([sender isEqual:self.northeastY]) || ([sender isEqual:self.southwestX]) || ([sender isEqual:self.southwestY]) || ([sender isEqual:self.referencePointX]) || ([sender isEqual:self.referencePointY]) || ([sender isEqual:self.referencePointAlt]))
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cached = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // initialize mapbox caches
    self.tileCache = [[RMTileCache alloc] initWithExpiryPeriod:0];
    [self.tileCache setBackgroundCacheDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// function to be called by "cache maps" button
- (IBAction)cacheButtonPress:(id *)sender
{
    if ((self.northeastX.text.length > 0) && (self.northeastY.text.length > 0) && (self.southwestX.text.length > 0)&& (self.southwestY.text.length > 0) && (self.cached != YES) && (self.referencePointX.text.length > 0) && (self.referencePointY.text.length > 0) && (self.referencePointAlt.text.length > 0)) {
        
        // set doubles from text boxes (for coord usage)
        self.northeastXdouble = [[_northeastX text] doubleValue];
        self.northeastYdouble = [[_northeastY text] doubleValue];
        self.southwestXdouble = [[_southwestX text] doubleValue];
        self.southwestYdouble = [[_southwestY text] doubleValue];
        
        // get reference point coord values
        self.referencePointXdouble = [[_referencePointX text] doubleValue];
        self.referencePointYdouble = [[_referencePointY text] doubleValue];
        self.referencePointAltdouble = [[_referencePointAlt text] doubleValue];
        
        // cache in background
        self.mapSource = [[RMMapboxSource alloc] initWithMapID:@"461group.hocfjnai"];
        
        [self.tileCache beginBackgroundCacheForTileSource:(self.mapSource) southWest:(makeCoordinate(_southwestYdouble, _southwestXdouble)) northEast:(makeCoordinate(_northeastYdouble, _northeastXdouble)) minZoom:(7) maxZoom: (16)];
        
        // block while caching?
        NSLog(@"Cache Begin");
        
        // disable cache button
        self.cacheButton.enabled = NO;
        [self.progressSpinner startAnimating];
    }
    else
        NSLog(@"Not enough data in fields! Need indication here!");
        return;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // only proceed if done button calls this
    if (sender != self.doneButton) return;
    
    // if there is text in the name and mission health fields, and cache successful
    if ((self.missionName.text.length > 0) && (self.missionHealthURL.text.length > 0) && (self.cached == true)) {
        self.mi = [[MissionItem alloc] init];
        
        // set missionItem fields
        self.mi.missionName = self.missionName.text;
        self.mi.missionHealthURL = self.missionHealthURL.text;
        self.mi.missionNortheast = makeCoordinate(_northeastXdouble, _northeastYdouble);
        self.mi.missionSouthwest = makeCoordinate(_southwestXdouble, _southwestYdouble);
        self.mi.missionReferencePoint = makeCoordinate(_referencePointXdouble, _referencePointYdouble);
        self.mi.missionReferencePointAltitude = self.referencePointAltdouble;
        
        
        // get destination view controller
        MissionControlViewController *vc = [segue destinationViewController];
        
        // add item
        [vc.missionArray addObject:self.mi];
    }
}

// delegate function: every time we successfully cache a map tile, run this
- (void)tileCache:(RMTileCache *)tileCache didBackgroundCacheTile:(RMTile)tile withIndex:(int)tileIndex ofTotalTileCount:(int)totalTileCount
{
    NSLog(@"Caching Tile %i", tileIndex);
}

// delegate function: for when background caching is completed
- (void)tileCacheDidFinishBackgroundCache:(RMTileCache *)tileCache
{
    self.doneButton.enabled = YES;
    self.cached = YES;
    [self.progressSpinner stopAnimating];
}

// constructor for 2d coordinate for cache system
CLLocationCoordinate2D makeCoordinate (double longitude_i, double latitude_i)
{
    CLLocationCoordinate2D coord_i;
    coord_i.longitude = longitude_i;
    coord_i.latitude = latitude_i;
    return coord_i;
}

@end
