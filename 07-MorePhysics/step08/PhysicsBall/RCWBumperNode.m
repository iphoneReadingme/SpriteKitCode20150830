/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWBumperNode.h"
#import "RCWCategoriesMask.h"

@implementation RCWBumperNode

+ (instancetype)bumperWithSize:(CGSize)size
{
    RCWBumperNode *bumper = [self spriteNodeWithImageNamed:@"bumper"];
    bumper.size = size;

    bumper.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    bumper.physicsBody.categoryBitMask = RCWCategoryBumper;
    bumper.physicsBody.contactTestBitMask = RCWCategoryBall;
    bumper.physicsBody.dynamic = NO;
    bumper.physicsBody.restitution = 2;

    return bumper;
}

@end
