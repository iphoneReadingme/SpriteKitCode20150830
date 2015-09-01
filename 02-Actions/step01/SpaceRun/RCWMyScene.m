/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWMyScene.h"

@interface RCWMyScene ()
@property (nonatomic, weak) UITouch *shipTouch;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval lastShotFireTime;
@end

@implementation RCWMyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];

        NSString *name = @"Spaceship.png";
        SKSpriteNode *ship = [SKSpriteNode spriteNodeWithImageNamed:name];
        ship.position = CGPointMake(size.width/2, size.height/2);
        ship.size = CGSizeMake(40, 40);
        ship.name = @"ship";
        [self addChild:ship];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.shipTouch = [touches anyObject];
}

- (void)update:(NSTimeInterval)currentTime
{
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = currentTime;
    }
    NSTimeInterval timeDelta = currentTime - self.lastUpdateTime;

    if (self.shipTouch) {
        [self moveShipTowardPoint:[self.shipTouch locationInNode:self]
                      byTimeDelta:timeDelta];

        if (currentTime - self.lastShotFireTime > 0.5) {
            [self shoot];
            self.lastShotFireTime = currentTime;
        }
    }

    self.lastUpdateTime = currentTime;
}

- (void)moveShipTowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta
{
    CGFloat shipSpeed = 130; // points per second
    SKNode *ship = [self childNodeWithName:@"ship"];
    CGFloat distanceLeft = sqrt(pow(ship.position.x - point.x, 2) +
                                pow(ship.position.y - point.y, 2));

    if (distanceLeft > 4) {
        CGFloat distanceToTravel = timeDelta * shipSpeed;

        CGFloat angle = atan2(point.x - ship.position.x,
                              point.y - ship.position.y);
        CGFloat yOffset = distanceToTravel * cos(angle);
        CGFloat xOffset = distanceToTravel * sin(angle);

        ship.position = CGPointMake(ship.position.x + xOffset,
                                    ship.position.y + yOffset);
    }
}

- (void)shoot
{
    SKNode *ship = [self childNodeWithName:@"ship"];

    SKSpriteNode *photon = [SKSpriteNode spriteNodeWithImageNamed:@"photon"];
    photon.name = @"photon";
    photon.position = ship.position;
    [self addChild:photon];

    SKAction *fly = [SKAction moveByX:0
                                    y:self.size.height+photon.size.height
                             duration:0.5];
    [photon runAction:fly];
}

@end
