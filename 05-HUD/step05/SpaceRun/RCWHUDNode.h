/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import <SpriteKit/SpriteKit.h>

@interface RCWHUDNode : SKNode
- (void)layoutForScene;

- (void)addPoints:(NSInteger)points;
- (void)startGame;
- (void)endGame;

- (void)showPowerupTimer:(NSTimeInterval)time;

@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSInteger score;
@end
