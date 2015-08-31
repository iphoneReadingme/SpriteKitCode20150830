/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWTableNode.h"
#import "RCWBumperNode.h"
#import "RCWTargetNode.h"
#import "RCWBonusSpinnerNode.h"

@implementation RCWTableNode

+ (instancetype)table
{
    RCWTableNode *table = [self node];

    SKShapeNode *bounds = [SKShapeNode node];
    bounds.strokeColor = [SKColor blackColor];
    [table addChild:bounds];

    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0.5, -10)];
    [bezierPath addCurveToPoint:CGPointMake(1, 700)
                  controlPoint1:CGPointMake(0.5, -10)
                  controlPoint2:CGPointMake(1, 620)];
    [bezierPath addCurveToPoint:CGPointMake(160.5, 880)
                  controlPoint1:CGPointMake(1, 780)
                  controlPoint2:CGPointMake(45.86, 880)];
    [bezierPath addCurveToPoint:CGPointMake(319, 700)
                  controlPoint1:CGPointMake(275.14, 880)
                  controlPoint2:CGPointMake(319, 780)];
    [bezierPath addCurveToPoint:CGPointMake(319.5, -10)
                  controlPoint1:CGPointMake(319, 620)
                  controlPoint2:CGPointMake(319.5, -10)];

    bounds.path = bezierPath.CGPath;
    bounds.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:bezierPath.CGPath];

    SKSpriteNode *overlay = [SKSpriteNode spriteNodeWithImageNamed:@"table-overlay"];
    overlay.size = CGSizeMake(320, 1246);
    overlay.anchorPoint = CGPointMake(0, 0);
    overlay.position = CGPointMake(0, 0);
    overlay.zPosition = 50;
    [table addChild:overlay];

    return table;
}

- (void)followPositionOfBall:(RCWPinballNode *)ball
{
    CGRect frame = [self calculateAccumulatedFrame];
    CGFloat sceneHeight = self.scene.size.height;
    CGFloat cameraY = ball.position.y - sceneHeight/2;

    CGFloat maxY = frame.size.height - sceneHeight;
    CGFloat minY = 0;

    if (cameraY < minY) { cameraY = minY; }
    else if (cameraY > maxY) { cameraY = maxY; }

    self.position = CGPointMake(0, 0-cameraY);
}

- (void)loadLayoutNamed:(NSString *)name
{
    NSURL *layoutPath = [[NSBundle mainBundle] URLForResource:name
                                                withExtension:@"plist"];
    NSDictionary *layout = [NSDictionary dictionaryWithContentsOfURL:layoutPath];

    for (NSDictionary *bumperConfig in layout[@"bumpers"]) {
        CGSize size = CGSizeMake([bumperConfig[@"width"] floatValue],
                                 [bumperConfig[@"height"] floatValue]);
        CGPoint position = CGPointMake([bumperConfig[@"x"] floatValue],
                                       [bumperConfig[@"y"] floatValue]);
        RCWBumperNode *bumper = [RCWBumperNode bumperWithSize:size];
        bumper.position = position;
        bumper.zRotation = [bumperConfig[@"degrees"] floatValue] * M_PI / 180;
        [self addChild:bumper];
    }

    for (NSDictionary *targetConfig in layout[@"targets"]) {
        CGFloat radius = [targetConfig[@"radius"] floatValue];
        CGPoint position = CGPointMake([targetConfig[@"x"] floatValue],
                                       [targetConfig[@"y"] floatValue]);
        RCWTargetNode *target = [RCWTargetNode targetWithRadius:radius];
        target.position = position;
        target.pointValue = [targetConfig[@"pointValue"] floatValue];
        [self addChild:target];
    }

    NSDictionary *spinnerConfig = layout[@"bonusSpinner"];
    RCWBonusSpinnerNode *spinner = [RCWBonusSpinnerNode bonusSpinnerNode];
    spinner.name = @"spinner";
    spinner.position = CGPointMake([spinnerConfig[@"x"] floatValue],
                                   [spinnerConfig[@"y"] floatValue]);
    [self addChild:spinner];
}

@end
