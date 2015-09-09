/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/


#import "ResManagerHelp.h"
#import "RCWStarField.h"
#import "SKEmitterNode+RCWExtensions.h"
#import "RCWMyScene.h"





@interface RCWMyScene ()

@property (nonatomic, weak) UITouch  *shipTouch;
@property (nonatomic) NSTimeInterval lastUpdateTime;
@property (nonatomic) NSTimeInterval lastShortFireTime;
@property (nonatomic) CGFloat        shipFireRate;    ///< 子弹发射频率（时间间隔）
@property (nonatomic) CGFloat        shipSpeed;       ///< 飞船移动速度 // points per second

@property (nonatomic, strong) SKAction *shootSound;
@property (nonatomic, strong) SKAction *shipExplodeSound;
@property (nonatomic, strong) SKAction *obstacleExplodeSound;

@end


@implementation RCWMyScene

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
		
		RCWStarField *starField = [RCWStarField node];
		[self addChild:starField];
		
        SKSpriteNode *ship = [self spaceshipSpriteNode];
        ship.position = CGPointMake(size.width/2, size.height/2);
        ship.size = CGSizeMake(40, 40);
		[self addChild:ship];
		
		[self addParticle];
		[self addSounds];
		
		_shipFireRate = 0.3f;
		_shipSpeed = 300;
    }
    return self;
}

- (void)addParticle
{
	SKNode *ship = [self childNodeWithName:kShipNodeName];
	SKEmitterNode *thrust = [ResManagerHelp thrusterEmitter];
	[ship addChild:thrust];
	//...
}

- (void)addSounds
{
	self.shootSound = [self shootSoundAction];
	self.obstacleExplodeSound = [self obstacleExplodeSoundAction];
	self.shipExplodeSound = [self shipExplodeSoundAction];
}

#pragma mark - == 声音
- (SKAction *)shootSoundAction
{
	return [ResManagerHelp shootSoundAction];
}

- (SKAction *)obstacleExplodeSoundAction
{
	return [ResManagerHelp obstacleExplodeSoundAction];
}

- (SKAction *)shipExplodeSoundAction
{
	return [ResManagerHelp shipExplodeSoundAction];
}

#pragma mark - == 纹理
- (SKSpriteNode *)spaceshipSpriteNode
{
	return [ResManagerHelp spaceshipSpriteNode];
}

- (SKSpriteNode *)photonSpriteNode
{
	return [ResManagerHelp photonSpriteNode];
}

- (SKSpriteNode *)obstacleSpriteNode
{
	return [ResManagerHelp obstacleSpriteNode];
}

- (SKSpriteNode *)enemyShipSpriteNode
{
	return [ResManagerHelp enemyShipSpriteNode];
}

- (SKSpriteNode *)powerupSpriteNode
{
	return [ResManagerHelp powerupSpriteNode];
}

//- (SKSpriteNode *)shootingstarSpriteNode
//{
//	return [ResManagerHelp shootingstarSpriteNode];
//}

///< touch Event
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
	
	[self runAction:self.shootSound];
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
	if (dice < 5)
	{
		///< 5% 概率出现能量节点
		[self dropPowerup];
	}
	if (dice < 20)
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
	
	[self enumerateChildNodesWithName:kPowerupNodeName usingBlock:^(SKNode *powerup, BOOL *stop) {
		
		if ([ship intersectsNode:powerup])
		{
			[powerup removeFromParent];
			self.shipFireRate = 0.1;
			
			SKAction *powerdown = [SKAction runBlock:^{
				self.shipFireRate = 0.5;
			}];
			SKAction *wait = [SKAction waitForDuration:5];
			SKAction *waitAndPowerdown = [SKAction sequence:@[wait, powerdown]];
			[ship removeActionForKey:@"waitAndPowerdown"];
			[ship runAction:waitAndPowerdown withKey:@"waitAndPowerdown"];
		}
	}];
	
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
				
				[self runAction:self.obstacleExplodeSound];
				
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
	
	///< add Action; 2. Moving Nodes on a Path
	NSTimeInterval duration = 7;
	CGPathRef shipPath = [self buildEnemyShipMovementPath];
	
	SKAction *followPath = [SKAction followPath:shipPath
									   asOffset:YES
								   orientToPath:YES
									   duration:duration];
	
	SKAction *remove = [SKAction removeFromParent];
	
	SKAction *all = [SKAction sequence:@[followPath, remove]];
	[enemyShip runAction:all];
}

///< The Path an enemy ship travels
- (CGPathRef)buildEnemyShipMovementPath
{
	UIBezierPath* bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint: CGPointMake(0.5, -0.5)];
	[bezierPath addCurveToPoint: CGPointMake(-2.5, -59.5)
				  controlPoint1: CGPointMake(0.5, -0.5)
				  controlPoint2: CGPointMake(4.55, -29.48)];
	[bezierPath addCurveToPoint: CGPointMake(-27.5, -154.5)
				  controlPoint1: CGPointMake(-9.55, -89.52)
				  controlPoint2: CGPointMake(-43.32, -115.43)];
	[bezierPath addCurveToPoint: CGPointMake(30.5, -243.5)
				  controlPoint1: CGPointMake(-11.68, -193.57)
				  controlPoint2: CGPointMake(17.28, -186.95)];
	[bezierPath addCurveToPoint: CGPointMake(-52.5, -379.5)
				  controlPoint1: CGPointMake(43.72, -300.05)
				  controlPoint2: CGPointMake(-47.71, -335.76)];
	[bezierPath addCurveToPoint: CGPointMake(54.5, -449.5)
				  controlPoint1: CGPointMake(-57.29, -423.24)
				  controlPoint2: CGPointMake(-8.14, -482.45)];
	[bezierPath addCurveToPoint: CGPointMake(-5.5, -348.5)
				  controlPoint1: CGPointMake(117.14, -416.55)
				  controlPoint2: CGPointMake(52.25, -308.62)];
	[bezierPath addCurveToPoint: CGPointMake(10.5, -494.5)
				  controlPoint1: CGPointMake(-63.25, -388.38)
				  controlPoint2: CGPointMake(-14.48, -457.43)];
	[bezierPath addCurveToPoint: CGPointMake(0.5, -559.5)
				  controlPoint1: CGPointMake(23.74, -514.16)
				  controlPoint2: CGPointMake(6.93, -537.57)];
	[bezierPath addCurveToPoint: CGPointMake(-2.5, -644.5)
				  controlPoint1: CGPointMake(-5.2, -578.93)
				  controlPoint2: CGPointMake(-2.5, -644.5)];
	
	return bezierPath.CGPath;
}

- (void)dropPowerup
{
	CGFloat sideSize = 30;
	CGFloat startX = arc4random_uniform(self.size.width-60) + 30;
	CGFloat startY = self.size.height + sideSize;
	CGFloat endY = 0 - sideSize;
	
	SKSpriteNode *powerup = [self powerupSpriteNode];
	powerup.size = CGSizeMake(sideSize, sideSize);
	powerup.position = CGPointMake(startX, startY);
	[self addChild:powerup];
	
	SKAction *move = [SKAction moveTo:CGPointMake(startX, endY) duration:6];
	SKAction *spin = [SKAction rotateByAngle:-1 duration:1];
	SKAction *remove = [SKAction removeFromParent];
	
	SKAction *spinForever = [SKAction repeatActionForever:spin];
	SKAction *travelAndRemove = [SKAction sequence:@[move, remove]];
	SKAction *all = [SKAction group:@[spinForever, travelAndRemove]];
	[powerup runAction:all];
}

@end
