/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWPaddleNode.h"
@interface RCWPaddleNode ()
@property (nonatomic) RCWPaddleSide paddleSide;
@end

CGFloat const PaddleWidth = 120;
CGFloat const PaddleHeight = 20;

@implementation RCWPaddleNode

+ (instancetype)paddleForSide:(RCWPaddleSide)paddleSide
{
    RCWPaddleNode *paddle = [RCWPaddleNode node];
    paddle.paddleSide = paddleSide;
    // ...

    SKSpriteNode *bar = [SKSpriteNode spriteNodeWithImageNamed:@"paddle-box"];
    bar.name = @"bar";
    bar.size = CGSizeMake(PaddleWidth, PaddleHeight);
    [paddle addChild:bar];

    SKSpriteNode *anchor = [SKSpriteNode spriteNodeWithImageNamed:@"paddle-anchor"];
    anchor.name = @"anchor";
    anchor.size = CGSizeMake(PaddleHeight, PaddleHeight);
    [paddle addChild:anchor];

    if (paddle.paddleSide == RCWPaddleRightSide) {
        bar.position = CGPointMake(0-PaddleWidth/2, 0);
        anchor.position = CGPointMake(bar.position.x + bar.size.width/2, 0);
    } else {
        bar.position = CGPointMake(PaddleWidth/2, 0);
        anchor.position = CGPointMake(bar.position.x - bar.size.width/2, 0);
    }

    CGFloat anchorRadius = anchor.size.width/2;
    anchor.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:anchorRadius];
    anchor.physicsBody.dynamic = NO;

    bar.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bar.size];
    bar.physicsBody.mass = 0.05;
    bar.physicsBody.restitution = 0.1;
    bar.physicsBody.angularDamping = 0;
    bar.physicsBody.friction = 0.02;

    return paddle;
}

@end
