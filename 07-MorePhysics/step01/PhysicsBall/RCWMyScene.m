/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWMyScene.h"
#import "RCWPinballNode.h"
#import "RCWPlungerNode.h"
#import "RCWTableNode.h"
#import "RCWPaddleNode.h"

@interface RCWMyScene ()
@property (nonatomic, weak) UITouch *plungerTouch;
@end

@implementation RCWMyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [self setUpScene];
    }
    return self;
}

- (void)setUpScene
{
    self.backgroundColor = [SKColor whiteColor];

    self.physicsWorld.gravity = CGVectorMake(0, -3.8);

    RCWTableNode *table = [RCWTableNode table];
    table.name = @"table";
    table.position = CGPointMake(0, 0);
    [self addChild:table];

    RCWPlungerNode *plunger = [RCWPlungerNode plunger];
    plunger.name = @"plunger";
    plunger.position = CGPointMake(self.size.width - plunger.size.width/2 - 4,
                                   plunger.size.height / 2);
    [table addChild:plunger];

    RCWPinballNode *ball = [RCWPinballNode ball];
    ball.name = @"ball";
    ball.position = CGPointMake(plunger.position.x,
                                plunger.position.y + plunger.size.height);
    [table addChild:ball];

    RCWPaddleNode *leftPaddle = [RCWPaddleNode paddleForSide:RCWPaddleLeftSide];
    leftPaddle.name = @"leftPaddle";
    leftPaddle.position = CGPointMake(9, 100);
    [table addChild:leftPaddle];

    RCWPaddleNode *rightPaddle = [RCWPaddleNode paddleForSide:RCWPaddleRightSide];
    rightPaddle.name = @"rightPaddle";
    rightPaddle.position = CGPointMake(plunger.position.x -
                                       plunger.size.width - 1, 100);
    [table addChild:rightPaddle];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    RCWPinballNode *ball = (id)[self childNodeWithName:@"//ball"];
    RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];

    if (self.plungerTouch == nil && [plunger isInContactWithBall:ball]) {
        UITouch *touch = [touches anyObject];
        self.plungerTouch = touch;
        [plunger grabWithTouch:touch holdingBall:ball inWorld:self.physicsWorld];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches containsObject:self.plungerTouch]) {
        RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
        [plunger letGoAndLaunchBallInWorld:self.physicsWorld];
    }
}

- (void)didSimulatePhysics
{
    RCWTableNode *table = (id)[self childNodeWithName:@"table"];
    RCWPinballNode *ball = (id)[table childNodeWithName:@"ball"];
    RCWPlungerNode *plunger = (id)[table childNodeWithName:@"plunger"];

    if (self.plungerTouch) {
        [plunger translateToTouch:self.plungerTouch];
    }

    [table followPositionOfBall:ball];

    if (ball.position.y < -500) {
        ball.position = CGPointMake(plunger.position.x,
                                    plunger.position.y + plunger.size.height);
        ball.physicsBody.velocity = CGVectorMake(0, 0);
        ball.physicsBody.angularVelocity = 0;
    }
}

@end
