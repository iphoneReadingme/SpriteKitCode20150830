

#import "SKEmitterNode+RCWExtensions.h"
#import "ResManagerHelp.h"



#define kImageResourceDir            @"Resource/Images"
#define kSoundsResourceDir           @"Resource/Sounds"
#define kParticleResourceDir         @"Resource/SKS"



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

+ (SKSpriteNode *)powerupSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"powerup.png"]];
	obstacle.name = kPowerupNodeName;
	
	return obstacle;
}

+ (SKSpriteNode *)shootingstarSpriteNode
{
	SKSpriteNode * obstacle = [SKSpriteNode spriteNodeWithImageNamed:[self getImagePathWith:@"shootingstar.png"]];
	obstacle.name = kShootingstarNodeName;
	
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

#pragma mark - == praticle Emitter
+ (NSString *)getParticlePathWith:(NSString *)fileName
{
	return [NSString stringWithFormat:@"%@/%@", kParticleResourceDir, fileName];
}

#if    1
+ (SKEmitterNode *)thrusterEmitter
{
	SKEmitterNode *thrust = [SKEmitterNode rcw_nodeWithFile:[self getParticlePathWith:@"thrust.sks"]];
	thrust.position = CGPointMake(0, -20);
	
	return thrust;
}
#else
+ (SKEmitterNode *)thrusterEmitter
{
	///< 最简单的sks文件加载方式
	NSString *filename = [self getParticlePathWith:@"thrust.sks"];
	NSString *basename = [filename stringByDeletingPathExtension];
	NSString *extension = [filename pathExtension];
	if ([extension length] == 0) {
		extension = @"sks";
	}
	NSString *path = [[NSBundle mainBundle] pathForResource:basename ofType:@"sks"];
	SKEmitterNode *thrust = (id)[NSKeyedUnarchiver unarchiveObjectWithFile:path];
	thrust.position = CGPointMake(0, -20);
	return thrust;
}
#endif

@end
