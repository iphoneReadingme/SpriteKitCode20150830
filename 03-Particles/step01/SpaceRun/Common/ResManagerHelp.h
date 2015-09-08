
/*
 *****************************************************************************
 * Copyright (C) 2005-2013 readbookamazon@126.com. All Rights Reserved
 * File			: ResManagerHelp.h
 *
 * Description	: 资源加载接口
 *
 * Author		: yangfs@ucweb.com
 *
 * Created by yangfs on   2015-07-16.
 * History		: modify: 2015-07-16.
 *
 ******************************************************************************
 **/



#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>


#define kShipNodeName                @"ship"
#define kPhotonNodeName              @"photon"
#define kObstacleNodeName            @"Obstacle"
#define kEnemyNodeName               @"enemy"


@interface ResManagerHelp : NSObject

+ (SKSpriteNode *)spaceshipSpriteNode;

+ (SKSpriteNode *)photonSpriteNode;

+ (SKSpriteNode *)obstacleSpriteNode;

+ (SKSpriteNode *)enemyShipSpriteNode;

+ (SKAction *)shootSoundAction;
+ (SKAction *)obstacleExplodeSoundAction;
+ (SKAction *)shipExplodeSoundAction;

@end
