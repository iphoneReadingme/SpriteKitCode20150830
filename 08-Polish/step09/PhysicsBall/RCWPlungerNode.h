/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import <SpriteKit/SpriteKit.h>
#import "RCWPinballNode.h"

@interface RCWPlungerNode : SKNode
@property (nonatomic) CGSize size;
+ (instancetype)plunger;

- (BOOL)isInContactWithBall:(RCWPinballNode *)ball;
- (void)grabWithTouch:(UITouch *)touch
          holdingBall:(RCWPinballNode *)ball
              inWorld:(SKPhysicsWorld *)world;
- (void)translateToTouch:(UITouch *)touch;
- (void)letGoAndLaunchBallInWorld:(SKPhysicsWorld *)world;
@end
