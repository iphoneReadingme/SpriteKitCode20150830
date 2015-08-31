/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWPullHintNode.h"

@implementation RCWPullHintNode

+ (instancetype)pullHint
{
    RCWPullHintNode *hint = [self node];

    SKSpriteNode *animation = [SKSpriteNode node];
    animation.name = @"animation";
    [hint addChild:animation];

    animation.size = CGSizeMake(12, 62);

    NSArray *frames = @[[SKTexture textureWithImageNamed:@"pull-hint-0"],
                        [SKTexture textureWithImageNamed:@"pull-hint-1"],
                        [SKTexture textureWithImageNamed:@"pull-hint-2"],
                        [SKTexture textureWithImageNamed:@"pull-hint-3"],
                        [SKTexture textureWithImageNamed:@"pull-hint-4"]];
    SKAction *play = [SKAction animateWithTextures:frames timePerFrame:0.2];
    SKAction *playForever = [SKAction repeatActionForever:play];
    [animation runAction:playForever];

    return hint;
}

- (void)showHint
{
    if (self.alpha == 1 || [self actionForKey:@"showAction"]) {
        return;
    }

    [self removeActionForKey:@"hideAction"];

    SKAction *fadeIn = [SKAction fadeAlphaTo:1 duration:0.6];
    SKAction *slide = [SKAction moveToY:0 duration:0.2];
    SKAction *slideChild = [SKAction runAction:slide onChildWithName:@"animation"];
    SKAction *zoom = [SKAction scaleTo:1 duration:0.2];
    SKAction *zoomChild = [SKAction runAction:zoom onChildWithName:@"animation"];

    SKAction *showAction = [SKAction group:@[slideChild, zoomChild, fadeIn]];
    [self runAction:showAction withKey:@"showAction"];
}

- (void)hideHint
{
    if (self.alpha == 0 || [self actionForKey:@"hideAction"]) {
        return;
    }

    [self removeActionForKey:@"showAction"];

    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:0.1];
    SKAction *slide = [SKAction moveToY:30 duration:0.2];
    SKAction *slideChild = [SKAction runAction:slide onChildWithName:@"animation"];
    SKAction *zoom = [SKAction scaleTo:1.3 duration:0.2];
    SKAction *zoomChild = [SKAction runAction:zoom onChildWithName:@"animation"];

    SKAction *hideAction = [SKAction group:@[fadeOut, slideChild, zoomChild]];
    [self runAction:hideAction withKey:@"hideAction"];
}

@end
