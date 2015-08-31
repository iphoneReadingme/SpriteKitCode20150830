/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWHUDNode.h"

@interface RCWHUDNode ()
@property (nonatomic, strong) NSNumberFormatter *scoreFormatter;
@end

@implementation RCWHUDNode

+ (instancetype)hud
{
    RCWHUDNode *hud = [self node];
    SKNode *scoreGroup = [SKNode node];
    scoreGroup.name = @"scoreGroup";

    SKLabelNode *scoreTitle =
        [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Medium"];
    scoreTitle.fontSize = 12;
    scoreTitle.fontColor = [SKColor blackColor];
    scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
    scoreTitle.text = @"SCORE";
    scoreTitle.position = CGPointMake(0, 4);
    [scoreGroup addChild:scoreTitle];

    SKLabelNode *scoreValue =
        [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Bold"];
    scoreValue.fontSize = 20;
    scoreValue.fontColor = [SKColor blackColor];
    scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    scoreValue.name = @"scoreValue";
    scoreValue.text = @"0";
    scoreValue.position = CGPointMake(0, -4);
    [scoreGroup addChild:scoreValue];

    [hud addChild:scoreGroup];

    hud.scoreFormatter = [[NSNumberFormatter alloc] init];
    hud.scoreFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    return hud;
}

- (void)layoutForScene
{
    NSAssert(self.scene, @"Cannot be called unless added to a scene");

    CGSize sceneSize = self.scene.size;

    SKNode *scoreGroup = [self childNodeWithName:@"scoreGroup"];
    CGSize groupSize = [scoreGroup calculateAccumulatedFrame].size;
    scoreGroup.position = CGPointMake(0, sceneSize.height/2 - groupSize.height);
}

- (void)addPoints:(NSInteger)points
{
    self.score += points;

    SKLabelNode *scoreValue = (id)[self childNodeWithName:@"scoreGroup/scoreValue"];
    scoreValue.text = [self.scoreFormatter stringFromNumber:@(self.score)];

    SKAction *scale = [SKAction scaleTo:1.5 duration:0.02];
    SKAction *shrink = [SKAction scaleTo:1 duration:0.07];
    SKAction *all = [SKAction sequence:@[scale, shrink]];
    [scoreValue runAction:all];
}

@end
