//
//  AddMissionViewController.m
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import "AddMissionViewController.h"

@interface AddMissionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *missionName;
@property (weak, nonatomic) IBOutlet UITextField *missionHealthURL;
@property (weak, nonatomic) IBOutlet UITextField *missionLatitude;
@property (weak, nonatomic) IBOutlet UITextField *missionLongitude;

@end

@implementation AddMissionViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
