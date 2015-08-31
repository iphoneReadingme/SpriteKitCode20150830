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
#import "RCWHUDNode.h"
#import "RCWCategoriesMask.h"
#import "RCWTargetNode.h"
#import "RCWPullHintNode.h"
#import "RCWBonusSpinnerNode.h"
#import "SKEmitterNode+RCWExtensions.h"

@interface RCWMyScene ()
<SKPhysicsContactDelegate>
@property (nonatomic, weak) UITouch *plungerTouch;
@property (nonatomic, weak) UITouch *leftPaddleTouch;
@property (nonatomic, weak) UITouch *rightPaddleTouch;

@property (nonatomic, strong) NSArray *bumperSounds;
@property (nonatomic, strong) NSArray *targetSounds;

@property (nonatomic, strong) SKEmitterNode *sparkTemplate;
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
    self.physicsWorld.contactDelegate = self;

    RCWTableNode *table = [RCWTableNode table];
    table.name = @"table";
    table.position = CGPointMake(0, 0);
    [self addChild:table];

    [table loadLayoutNamed:@"layout"];

    RCWPlungerNode *plunger = [RCWPlungerNode plunger];
    plunger.name = @"plunger";
    plunger.position = CGPointMake(self.size.width - plunger.size.width/2 - 4,
                                   plunger.size.height / 2);
    [table addChild:plunger];

    RCWPullHintNode *pullHint = [RCWPullHintNode pullHint];
    pullHint.name = @"pullHint";
    pullHint.position = CGPointMake(plunger.position.x,
                                    plunger.position.y + plunger.size.height + 30);
    [pullHint hideHint];
    [table addChild:pullHint];

    RCWPinballNode *ball = [RCWPinballNode ball];
    ball.name = @"ball";
    ball.position = CGPointMake(plunger.position.x,
                                plunger.position.y + plunger.size.height);
    [table addChild:ball];

    RCWPaddleNode *leftPaddle = [RCWPaddleNode paddleForSide:RCWPaddleLeftSide];
    leftPaddle.name = @"leftPaddle";
    leftPaddle.position = CGPointMake(9, 100);
    [table addChild:leftPaddle];

    [leftPaddle createPinJointInWorld];

    RCWPaddleNode *rightPaddle = [RCWPaddleNode paddleForSide:RCWPaddleRightSide];
    rightPaddle.name = @"rightPaddle";
    rightPaddle.position = CGPointMake(plunger.position.x -
                                       plunger.size.width - 1, 100);
    [table addChild:rightPaddle];

    [rightPaddle createPinJointInWorld];

    RCWHUDNode *hud = [RCWHUDNode hud];
    hud.name = @"hud";
    hud.position = CGPointMake(self.size.width/2, self.size.height/2);
    hud.zPosition = 100;
    [self addChild:hud];
    [hud layoutForScene];

    self.bumperSounds = @[
          [SKAction playSoundFileNamed:@"bump1.aif" waitForCompletion:NO],
          [SKAction playSoundFileNamed:@"bump2.aif" waitForCompletion:NO],
          [SKAction playSoundFileNamed:@"bump3.aif" waitForCompletion:NO]];
    self.targetSounds = @[
          [SKAction playSoundFileNamed:@"target1.aif" waitForCompletion:NO],
          [SKAction playSoundFileNamed:@"target2.aif" waitForCompletion:NO],
          [SKAction playSoundFileNamed:@"target3.aif" waitForCompletion:NO]];

    self.sparkTemplate = [SKEmitterNode rcw_nodeWithFile:@"Spark"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    RCWPinballNode *ball = (id)[self childNodeWithName:@"//ball"];
    RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];

    if (self.plungerTouch == nil && [plunger isInContactWithBall:ball]) {
        UITouch *touch = [touches anyObject];
        self.plungerTouch = touch;
        [plunger grabWithTouch:touch holdingBall:ball inWorld:self.physicsWorld];
    } else {
        for (UITouch *touch in touches) {
            CGPoint where = [touch locationInNode:self];
            if (where.x < self.size.width/2) {
                self.leftPaddleTouch = touch;
            } else {
                self.rightPaddleTouch = touch;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches containsObject:self.plungerTouch]) {
        RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
        [plunger letGoAndLaunchBallInWorld:self.physicsWorld];
    }
}

- (void)update:(NSTimeInterval)currentTime
{
    RCWPinballNode *ball = (id)[self childNodeWithName:@"//ball"];
    RCWPlungerNode *plunger = (id)[self childNodeWithName:@"//plunger"];
    RCWPullHintNode *hint = (id)[self childNodeWithName:@"//pullHint"];
    if ([plunger isInContactWithBall:ball]) {
        [hint showHint];
    } else {
        [hint hideHint];
    }

    if (self.leftPaddleTouch) {
        RCWPaddleNode *leftPaddle = (id)[self childNodeWithName:@"//leftPaddle"];
        [leftPaddle flip];
    }

    if (self.rightPaddleTouch) {
        RCWPaddleNode *rightPaddle = (id)[self childNodeWithName:@"//rightPaddle"];
        [rightPaddle flip];
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

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == RCWCategoryBall) {
        [self ballBody:contact.bodyA didContact:contact withBody:contact.bodyB];
    } else if (contact.bodyB.categoryBitMask == RCWCategoryBall) {
        [self ballBody:contact.bodyB didContact:contact withBody:contact.bodyA];
    }
}

- (void)ballBody:(SKPhysicsBody *)ballBody
      didContact:(SKPhysicsContact *)contact
        withBody:(SKPhysicsBody *)otherBody
{
    if (otherBody.categoryBitMask == RCWCategoryBumper) {
        [self playRandomBumperSound];
    } else if (otherBody.categoryBitMask == RCWCategoryTarget) {
        [self playRandomTargetSound];
        RCWTargetNode *target = (RCWTargetNode *)otherBody.node;
        [self addPoints:target.pointValue];
    }

    if (otherBody.categoryBitMask & (RCWCategoryBumper | RCWCategoryTarget)) {
        [self capPhysicsBody:ballBody atSpeed:1150];
        [self flashNode:otherBody.node];
        [self playPuffForContact:contact withVelocity:ballBody.velocity];
    }

    if (otherBody.categoryBitMask == RCWCategoryBonusSpinner) {
        RCWBonusSpinnerNode *spinner = (RCWBonusSpinnerNode *)otherBody.node;
        [spinner spin];
    }
}

- (void)addPoints:(NSUInteger)points
{
    RCWHUDNode *hud = (RCWHUDNode *)[self childNodeWithName:@"hud"];
    RCWBonusSpinnerNode *spinner = (id)[self childNodeWithName:@"//spinner"];
    if (spinner.stillSpinning) {
        [hud addPoints:points * 3];
    } else {
        [hud addPoints:points];
    }
}

- (void)playRandomBumperSound
{
    NSInteger soundCount = [self.bumperSounds count];
    NSInteger randomSoundIndex = arc4random_uniform((u_int32_t)soundCount);
    SKAction *sound = self.bumperSounds[randomSoundIndex];
    [self runAction:sound];
}

- (void)playRandomTargetSound
{
    NSInteger soundCount = [self.targetSounds count];
    NSInteger randomSoundIndex = arc4random_uniform((u_int32_t)soundCount);
    SKAction *sound = self.targetSounds[randomSoundIndex];
    [self runAction:sound];
}

- (void)playPuffForContact:(SKPhysicsContact *)contact
              withVelocity:(CGVector)velocity
{
    SKNode *table = [self childNodeWithName:@"table"];

    SKEmitterNode *spark = [self.sparkTemplate copy];

    spark.position = [self convertPoint:contact.contactPoint toNode:table];
    spark.xAcceleration = self.physicsWorld.gravity.dx;
    spark.yAcceleration = self.physicsWorld.gravity.dy;
    spark.emissionAngle = atan2(velocity.dy, velocity.dx);
    spark.particleSpeed = contact.collisionImpulse;

    [spark rcw_dieOutInDuration:0.05];

    [table addChild:spark];
}

- (void)capPhysicsBody:(SKPhysicsBody *)body atSpeed:(CGFloat)maxSpeed
{
    CGFloat speed = sqrt(pow(body.velocity.dx, 2) +
                         pow(body.velocity.dy, 2));

    if (speed > maxSpeed) {
        speed = maxSpeed;
        CGFloat angle = atan2(body.velocity.dy, body.velocity.dx);
        CGVector limitedVelocity = CGVectorMake(speed*cos(angle), speed*sin(angle));
        body.velocity = limitedVelocity;
    }
}

- (void)flashNode:(SKNode *)node
{
    SKAction *scaleUp = [SKAction scaleTo:1.1 duration:0.05];
    SKAction *scaleDown = [SKAction scaleTo:1 duration:0.1];
    SKAction *colorize = [SKAction colorizeWithColor:[SKColor redColor]
                                    colorBlendFactor:200
                                            duration:0];
    SKAction *uncolorize = [SKAction colorizeWithColorBlendFactor:0 duration:0];

    SKAction *all = [SKAction sequence:@[colorize, scaleUp, scaleDown, uncolorize]];

    [node runAction:all];
}

@end
