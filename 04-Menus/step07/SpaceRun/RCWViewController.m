/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWViewController.h"
#import "RCWMyScene.h"
#import "RCWOpeningScene.h"

@implementation RCWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;

    SKScene *blackScene = [[SKScene alloc] initWithSize:skView.bounds.size];
    blackScene.backgroundColor = [SKColor blackColor];
    [skView presentScene:blackScene];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    SKView *skView = (SKView *)self.view;

    RCWOpeningScene *scene = [RCWOpeningScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [skView presentScene:scene transition:transition];

    __weak RCWViewController *weakSelf = self;
    scene.sceneEndCallback = ^{
        RCWMyScene *scene = [RCWMyScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.easyMode = weakSelf.easyMode;

        scene.endGameCallback = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };

        SKTransition *transition = [SKTransition fadeWithColor:[SKColor blackColor]
                                                      duration:1];
        [skView presentScene:scene transition:transition];
    };
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
