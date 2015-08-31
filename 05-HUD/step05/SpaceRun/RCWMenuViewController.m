/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWMenuViewController.h"
#import "RCWViewController.h"
#import "RCWStarField.h"

@interface RCWMenuViewController ()
@property (nonatomic, strong) IBOutlet UISegmentedControl *difficultyChooser;
@property (nonatomic, strong) SKView *demoView;
@property (nonatomic, strong) IBOutlet UILabel *highScoreLabel;
@end

@implementation RCWMenuViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSNumberFormatter *scoreFormatter = [[NSNumberFormatter alloc] init];
    scoreFormatter.numberStyle = NSNumberFormatterDecimalStyle;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{@"highScore": @0}];
    NSNumber *score = [defaults valueForKey:@"highScore"];
    NSString *scoreText = [NSString stringWithFormat:@"High Score: %@",
                           [scoreFormatter stringFromNumber:score]];

    self.highScoreLabel.text = scoreText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.demoView = [[SKView alloc] initWithFrame:self.view.bounds];

    SKScene *scene = [[SKScene alloc] initWithSize:self.view.bounds.size];

    scene.backgroundColor = [SKColor blackColor];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    SKNode *starField = [RCWStarField node];
    [scene addChild:starField];

    [self.demoView presentScene:scene];

    [self.view insertSubview:self.demoView atIndex:0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.demoView removeFromSuperview];
    self.demoView = nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayGame"]) {
        RCWViewController *gameController = segue.destinationViewController;
        gameController.easyMode = self.difficultyChooser.selectedSegmentIndex == 0;
    } else {
        NSAssert(false, @"Unknown segue identifier %@", segue.identifier);
    }
}

@end
