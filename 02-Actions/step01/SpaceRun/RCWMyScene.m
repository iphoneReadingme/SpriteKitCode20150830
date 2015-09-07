/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/


#import "RCWMyScene.h"


#define kShipNodeName          @"ship"
#define kPhotonNodeName        @"photon"
#define kObstacleNodeName      @"Obstacle"
#define kEnemyNodeName         @"enemy"


@interface RCWMyScene ()

@property (nonatomic, weak) UITouch  *shipTouch;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval lastShortFireTime;
@property (nonatomic) CGFloat        shipFireRate;    ///< 子弹发射频率（时间间隔）
@property (nonatomic) CGFloat        shipSpeed;       ///< 飞船移动速度 // points per second
@end


@implementation RCWMyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
		
        SKSpriteNode *ship = [self spaceshipSpriteNode];
        ship.position = CGPointMake(size.width/2, size.height/2);
        ship.size = CGSizeMake(40, 40);
		
        [self addChild:ship];
		
		_shipFireRate = 0.3f;
		_shipSpeed = 300;
    }
    return self;
}

- (SKSpriteNode *)spaceshipSpriteNode
{
	SKSpriteNode * spaceship = [SKSpriteNode spriteNodeWithImageNamed:@"Resource/Spaceship.png"];
	spaceship.name = kShipNodeName;
	
	return spaceship;
}

- (SKSpriteNode *)photonSpriteNode
{
	SKSpriteNode * photon = [SKSpriteNode spriteNodeWithImageNamed:@"Resource/photon.png"];
	photon.name = kPhotonNodeName;
	
	return photon;
}

- (SKSpriteNode *)obstacleSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"Resource/asteroid.png"];
	obstacle.name = kObstacleNodeName;
	
	return obstacle;
}

- (SKSpriteNode *)enemyShipSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:@"Resource/enemy.png"];
	obstacle.name = kEnemyNodeName;
	
	return obstacle;
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

        if (currentTime - _lastShortFireTime > _shipFireRate)
		{
            [self shoot];
            _lastShortFireTime = currentTime;
        }
    }
	
	[self randomLoadObstacle];
	[self checkCollisions];
	
    self.lastUpdateTime = currentTime;
}

- (void)moveShipTowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta
{
    SKNode *ship = [self childNodeWithName:kShipNodeName];
    CGFloat distanceLeft = sqrt(pow(ship.position.x - point.x, 2) +
                                pow(ship.position.y - point.y, 2));

    if (distanceLeft > 4) {
        CGFloat distanceToTravel = timeDelta * _shipSpeed;

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
    SKNode *ship = [self childNodeWithName:kShipNodeName];

    SKSpriteNode *photon = [self photonSpriteNode];
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
	NSInteger randomValue = arc4random_uniform(1000);
	if (randomValue < 15)
	{
		[self dropThing];
	}
}

- (void)dropThing
{
	///< 骰子
	NSInteger dice = arc4random_uniform(100);
	if (dice < 15)
	{
		///< 15% 概率出现乱舰
		[self dropEnemyShip];
	}
	else
	{
		[self dropAsteroid];
	}
}

- (void)dropAsteroid
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

- (void)dropObstacle:(CGFloat)obstacleSize from:(CGPoint)startPt to:(CGPoint)endPt
{
	SKSpriteNode * obstacle = [self obstacleSpriteNode];
	obstacle.size = CGSizeMake(obstacleSize, obstacleSize);
	obstacle.position = startPt;
	
	[self addChild:obstacle];
	
	///< drop action
	NSTimeInterval duration = arc4random_uniform(4) + 3;
	SKAction *moveDown = [SKAction moveTo:endPt duration:duration];
	SKAction *remove = [SKAction removeFromParent];
	SKAction *travelAndRemove = [SKAction sequence:@[moveDown, remove]];
	//[obstacle runAction:travelAndRemove];
	
	obstacleSize = 2*obstacleSize;
	SKAction *zoomIn = [SKAction resizeToWidth:obstacleSize height:obstacleSize duration:duration];
	SKAction *zoomAction = [SKAction sequence:@[zoomIn]];
	//[obstacle runAction:zoomAction];
	
	///< rotate action
	duration = arc4random_uniform(2) + 1;
	SKAction *spin = [SKAction rotateByAngle:3 duration:duration];
	SKAction *spinForever = [SKAction repeatActionForever:spin];
	
	///< action group
	SKAction *groupAction = [SKAction group:@[spinForever, zoomAction, travelAndRemove]];
	[obstacle runAction:groupAction];
}

///< 碰撞检测
- (void)checkCollisions
{
	SKNode *ship = [self childNodeWithName:kShipNodeName];
	
	[self enumerateChildNodesWithName:kObstacleNodeName usingBlock:^(SKNode *obstacle, BOOL *stop){
		
		[self enumerateChildNodesWithName:kPhotonNodeName usingBlock:^(SKNode *photon, BOOL *stop){
			
//			if ([ship intersectsNode:obstacle])
//			{
//				self.shipTouch = nil;
//				[ship removeFromParent];
//				[obstacle removeFromParent];
//			}
			
			if ([photon intersectsNode:obstacle])
			{
				[photon removeFromParent];
				[obstacle removeFromParent];
				*stop = YES;
			}
		}];
		obstacle = nil;
	}];
	
	ship = nil;
}

- (void)dropEnemyShip
{
	CGFloat sizeValue = 30;
	CGPoint startPt = CGPointZero;   ///< Enemy ship starts here
	CGPoint endPt = CGPointZero;
	startPt.y = self.size.height + sizeValue;
	endPt.y = 0 - sizeValue;
	
	CGFloat maxX = self.size.width; ///< value of the scene
	CGFloat offsetX = 20.0f;   ///< maxX / 4
	startPt.x = arc4random_uniform(maxX + 2*offsetX) - offsetX;  ///< [-offsetX, maxX + offsetX]
	endPt.x = arc4random_uniform(maxX);
	
	[self dropEnemyShip:sizeValue from:startPt to:endPt];
}

- (void)dropEnemyShip:(CGFloat)sizeValue from:(CGPoint)startPt to:(CGPoint)endPt
{
	SKSpriteNode *enemyShip = [self enemyShipSpriteNode];
	enemyShip.size = CGSizeMake(sizeValue, sizeValue);
	enemyShip.position = startPt;
	
	[self addChild:enemyShip];
	
	///< add Action
	NSTimeInterval duration = 7;
	SKAction *moveDown = [SKAction moveTo:endPt duration:duration];
	SKAction *remove = [SKAction removeFromParent];
	SKAction *sequence = [SKAction sequence:@[moveDown, remove]];
	[enemyShip runAction:sequence];
}

@end
