/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWPinballNode.h"
#import "RCWCategoriesMask.h"

@implementation RCWPinballNode

+ (instancetype)ball
{
    CGFloat sideSize = 20;
    RCWPinballNode *node = [self spriteNodeWithImageNamed:@"pinball.png"];

    node.size = CGSizeMake(sideSize, sideSize);

    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sideSize/2];
    node.physicsBody.categoryBitMask = RCWCategoryBall;
    node.physicsBody.restitution = 0.2;
    node.physicsBody.friction = 0.01;
    node.physicsBody.angularDamping = 0.5;

    return node;
}

@end
