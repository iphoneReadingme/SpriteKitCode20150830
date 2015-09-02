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
@property (nonatomic) NSTimeInterval lastShortFireTime;
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
    if (self.shipTouch)
	{
		NSTimeInterval timeDelta = currentTime - _lastUpdateTime;
		CGPoint touchPoint = [_shipTouch locationInNode:self];
		
        [self moveShipTowardPoint:touchPoint byTimeDelta:timeDelta];

        if (currentTime - _lastShortFireTime > 0.5)
		{
            [self shoot];
            _lastShortFireTime = currentTime;
        }
		
		[self randomLoadObstacle];
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
		
		CGPoint pt = ship.position;
		pt.x += xOffset;
		pt.y += yOffset;
		ship.position = pt;
    }
}

- (void)shoot
{
    SKNode *ship = [self childNodeWithName:@"ship"];

    SKSpriteNode *photon = [SKSpriteNode spriteNodeWithImageNamed:@"photon"];
    photon.name = @"photon";
    photon.position = ship.position;
    [self addChild:photon];

    SKAction *fly = [SKAction moveByX:0 y:self.size.height+photon.size.height duration:0.5];
	SKAction *remove = [SKAction removeFromParent]; ///< 使用完成后删除节点，清除内存空间
	SKAction *fireAndRemove = [SKAction sequence:@[fly, remove]];
    [photon runAction:fireAndRemove];
}

#pragma mark - == 随机掉落、出现障碍物
- (void)randomLoadObstacle
{
	///< 随机值[0, 999];
	CGFloat randomValue = arc4random_uniform(1000);
	if (randomValue < 15)
	{
		CGFloat sizeValue = arc4random_uniform(30) + 15; ///< [15, 44]
		CGPoint startPt = CGPointZero;
		CGPoint endPt = CGPointZero;
		startPt.y = self.size.height + sizeValue;
		endPt.y = 0 - sizeValue;
		
		CGFloat maxX = self.size.width; ///< value of the scene
		CGFloat offsetX = maxX * 0.25f;   ///< maxX / 4
		startPt.x = arc4random_uniform(maxX + 2*offsetX) - offsetX;  ///< [-offsetX, maxX + offsetX]
		endPt.x = arc4random_uniform(maxX);
		
		[self dropObstacle:sizeValue from:startPt to:endPt];
	}
}

- (void)dropObstacle:(CGFloat)obstacleSize from:(CGPoint)startPt to:(CGPoint)endPt
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid.png"];
	obstacle.name = @"obstacle";
	obstacle.size = CGSizeMake(obstacleSize, obstacleSize);
	obstacle.position = startPt;
	
	[self addChild:obstacle];
	
	///< drop action
	NSTimeInterval duration = arc4random_uniform(4) + 3;
	SKAction *moveDown = [SKAction moveTo:endPt duration:duration];
	SKAction *remove = [SKAction removeFromParent];
	SKAction *travelAndRemove = [SKAction sequence:@[moveDown, remove]];
	
	///< rotate action
	duration = arc4random_uniform(2) + 1;
	SKAction *spin = [SKAction rotateByAngle:3 duration:duration];
	SKAction *spinForever = [SKAction repeatActionForever:spin];
	
	///< action group
	SKAction *groupAction = [SKAction group:@[spinForever, travelAndRemove]];
	[obstacle runAction:groupAction];
}

@end
