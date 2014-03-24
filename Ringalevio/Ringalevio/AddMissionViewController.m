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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

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
    self.missionName.text = @"HerpDerp";
    self.missionHealthURL.text = @"Archaic";
    self.missionLatitude.text = @"30";
    self.missionLongitude.text = @"30";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.doneButton) return;
    if (self.missionName.text.length > 0 && self.missionHealthURL.text.length > 0) {
        self.mi = [[MissionItem alloc] init];
        self.mi.missionName = self.missionName.text;
        self.mi.missionHealthURL = self.missionHealthURL.text;
//        self.toDoItem.itemName = self.textField.text;
//        self.toDoItem.completed = NO;
        
    }
}

@end
