

#import "ResManagerHelp.h"



#define kImageResourceDir            @"Resource/Images"
#define kSoundsResourceDir           @"Resource/Sounds"



@implementation ResManagerHelp


+ (NSString *)getImagePathWith:(NSString *)fileName
{
	return [NSString stringWithFormat:@"%@/%@", kImageResourceDir, fileName];
}

+ (SKSpriteNode *)spaceshipSpriteNode
{
	SKSpriteNode * spaceship = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"Spaceship.png"]];
	spaceship.name = kShipNodeName;
	
	return spaceship;
}

+ (SKSpriteNode *)photonSpriteNode
{
	SKSpriteNode * photon = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"photon.png"]];
	photon.name = kPhotonNodeName;
	
	return photon;
}

+ (SKSpriteNode *)obstacleSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"asteroid.png"]];
	obstacle.name = kObstacleNodeName;
	
	return obstacle;
}

+ (SKSpriteNode *)enemyShipSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"enemy.png"]];
	obstacle.name = kEnemyNodeName;
	
	return obstacle;
}

#pragma mark - == 声音资源
+ (NSString *)getSoundPathWith:(NSString *)fileName
{
	return [NSString stringWithFormat:@"%@/%@", kSoundsResourceDir, fileName];
}

+ (SKAction *)shootSoundAction
{
	return [SKAction playSoundFileNamed:[self getSoundPathWith:@"shoot.m4a"] waitForCompletion:NO];
}

+ (SKAction *)obstacleExplodeSoundAction
{
	return [SKAction playSoundFileNamed:[self getSoundPathWith:@"obstacleExplode.m4a"] waitForCompletion:NO];
}

+ (SKAction *)shipExplodeSoundAction
{
	return [SKAction playSoundFileNamed:[self getSoundPathWith:@"shipExplode.m4a"] waitForCompletion:NO];
}

@end
