/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWBonusSpinnerNode.h"
#import "RCWCategoriesMask.h"

@implementation RCWBonusSpinnerNode

+ (instancetype)bonusSpinnerNode
{
    RCWBonusSpinnerNode *spinner = [self spriteNodeWithImageNamed:@"bonus-spinner"];
    spinner.size = CGSizeMake(6, 40);

    spinner.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spinner.size];
    spinner.physicsBody.affectedByGravity = NO;
    spinner.physicsBody.angularDamping = 0.8;
    spinner.physicsBody.categoryBitMask = RCWCategoryBonusSpinner;
    spinner.physicsBody.contactTestBitMask = RCWCategoryBall;
    spinner.physicsBody.collisionBitMask = 0;

    return spinner;
}

- (void)spin
{
    [self.physicsBody applyAngularImpulse:0.003];
}

- (BOOL)stillSpinning
{
    return self.physicsBody.angularVelocity > 0.9;
}

@end
