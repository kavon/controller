//
//  HealthViewController.m
//  Ringalevio
//
//  Created by Sean Lane on 4/10/14.
//
//

#import "HealthViewController.h"

@interface HealthViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HealthViewController

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
    
    // create URL
    NSString *fullURL = self.mi.missionHealthURL;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    // go to webpage
    [self.webView loadRequest:requestObj];
}

-(void)viewDidAppear:(BOOL)animated
{
    // hide toolbar
    self.navigationController.toolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
