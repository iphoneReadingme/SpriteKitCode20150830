/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWPlungerNode.h"

@interface RCWPlungerNode ()
@property (nonatomic) CGFloat yTouchDelta;
@property (nonatomic, strong) SKPhysicsJointFixed *jointToBall;
@end

@implementation RCWPlungerNode

+ (instancetype)plunger
{
    RCWPlungerNode *plunger = [self node];
    plunger.size = CGSizeMake(20, 100);

    SKSpriteNode *stick = [SKSpriteNode spriteNodeWithImageNamed:@"plunger.png"];
    stick.name = @"stick";
    stick.size = plunger.size;
    stick.position = CGPointMake(0, 0);

    stick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:plunger.size];
    stick.physicsBody.dynamic = NO;
    stick.physicsBody.restitution = 0;

    [plunger addChild:stick];

    return plunger;
}

- (BOOL)isInContactWithBall:(RCWPinballNode *)ball
{
    SKNode *stick = [self childNodeWithName:@"stick"];
    NSArray *contactedBodies = stick.physicsBody.allContactedBodies;
    return [contactedBodies containsObject:ball.physicsBody];
}

- (void)grabWithTouch:(UITouch *)touch
          holdingBall:(RCWPinballNode *)ball
              inWorld:(SKPhysicsWorld *)world
{
    CGPoint touchPoint = [touch locationInNode:self];
    SKNode *stick = [self childNodeWithName:@"stick"];

    self.yTouchDelta = stick.position.y - touchPoint.y;

    CGPoint jointPoint = [self convertPoint:stick.position toNode:self.scene];

    self.jointToBall = [SKPhysicsJointFixed jointWithBodyA:stick.physicsBody
                                                     bodyB:ball.physicsBody
                                                    anchor:jointPoint];

    [world addJoint:self.jointToBall];
}

- (void)translateToTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInNode:self];
    SKNode *stick = [self childNodeWithName:@"stick"];

    CGFloat newY = point.y + self.yTouchDelta;
    CGFloat plungerHeight = self.size.height;

    CGFloat upperY = 0;
    CGFloat lowerY = upperY - plungerHeight + 30;

    if (newY > upperY) {
        newY = upperY;
    } else if (newY < lowerY) {
        newY = lowerY;
    }

    stick.position = CGPointMake(0, newY);
}

- (void)letGoAndLaunchBallInWorld:(SKPhysicsWorld *)world
{
    SKNode *stick = [self childNodeWithName:@"stick"];

    CGFloat returnY = 0;
    CGFloat distancePulled = returnY - stick.position.y;
    CGFloat forceToApply = MAX(4, distancePulled / 2);

    SKAction *move = [SKAction moveToY:returnY duration:0.02];
    SKAction *launchBall = [SKAction runBlock:^{
        [world removeJoint:self.jointToBall];
        SKPhysicsBody *ballBody = self.jointToBall.bodyB;
        [ballBody applyImpulse:CGVectorMake(0, forceToApply)];
        self.jointToBall = nil;
    }];
    SKAction *all = [SKAction sequence:@[move, launchBall]];
    [stick runAction:all];
}

@end
