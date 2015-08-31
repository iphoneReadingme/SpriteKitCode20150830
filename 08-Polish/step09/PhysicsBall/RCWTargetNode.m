/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWTargetNode.h"
#import "RCWCategoriesMask.h"

@implementation RCWTargetNode

+ (instancetype)targetWithRadius:(CGFloat)radius
{
    RCWTargetNode *target = [self spriteNodeWithImageNamed:@"target"];
    target.size = CGSizeMake(radius*2, radius*2);

    target.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
    target.physicsBody.categoryBitMask = RCWCategoryTarget;
    target.physicsBody.contactTestBitMask = RCWCategoryBall;
    target.physicsBody.dynamic = NO;
    target.physicsBody.restitution = 2;

    return target;
}

@end
