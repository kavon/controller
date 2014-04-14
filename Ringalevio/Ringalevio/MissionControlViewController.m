//
//  MissionControlViewController.m
//  Ringalevio
//
//  Created by Sean Lane on 3/12/14.
//
//

#import "MissionControlViewController.h"
#import "MissionItem.h"
#import "AddMissionViewController.h"
#import "OnlineMapViewController.h"

@interface MissionControlViewController ()

// bool to confirm save occured
@property BOOL saveSuccess;

//Add UI button
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@end



@implementation MissionControlViewController

// custom unwind command to return from a different view
- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    // code here to return to this panel with sent values and such (just reload for now)
    [self.tableView reloadData];
}

// Method for segue preparation (pass data references)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier  isEqual: @"mapSegue"]) {
        
        // Get destination view
        OnlineMapViewController *vc = [segue destinationViewController];
        
        // Get object (or do whatever you need to do here, based on your object)
        MissionItem *selectedItem = self.missionArray[self.tableView.indexPathForSelectedRow.item];
        
        // Pass the information to your destination view
        vc.mi = selectedItem;
    }
    else
        return;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.missionArray = [[NSMutableArray alloc] init];
    
    // restore array from archive
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *fullFileName = [NSString stringWithFormat:@"%@/missionArray", docDir];
    self.missionArray = [NSKeyedUnarchiver unarchiveObjectWithFile:fullFileName];
    
    // prevent initial run save/restore hiccup by making sure the array is allocated somehow at this point
    if (self.missionArray == nil)
    {
        self.missionArray = [[NSMutableArray alloc] init];
    }
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self.tableView reloadData];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [self.missionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    MissionItem *missionItem = [self.missionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = missionItem.missionName;
    
    return cell;
}


// all of the following is auto-generated code we can use as needed

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 

 
}

 */

#pragma mark - Table View Delegate

// click on row controls
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // command to leave table rows unselected
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // table touch "click" code goes here: probably to go to maps (op1)
    //[self performSegueWithIdentifier:@"mapSegue" sender:self];
}

// delegate command on app-close
- (void)applicationDidEnterBackground
{
    do
    {
    // save archive to file using archiver
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSString *fullFileName = [NSString stringWithFormat:@"%@/missionArray", docDir];
        _saveSuccess = [NSKeyedArchiver archiveRootObject:_missionArray toFile:fullFileName];
        
    } while (_saveSuccess != true);
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath { //implement the delegate method
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update data source array here, something like [array removeObjectAtIndex:indexPath.row];
        [self.missionArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

@end
