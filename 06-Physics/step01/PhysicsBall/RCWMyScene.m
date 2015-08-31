/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWMyScene.h"

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
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"pinball.png"];
    ball.position = CGPointMake(self.size.width/2, self.size.height/2);
    ball.size = CGSizeMake(20, 20);
    [self addChild:ball];

    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:10];
}

@end
