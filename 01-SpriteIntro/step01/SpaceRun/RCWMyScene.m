/***
 * Excerpted from "Build iOS Games with Sprite Kit",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/pssprite for more book information.
***/
#import "RCWMyScene.h"


@interface RCWMyScene()

@property (nonatomic, weak) UITouch *shipTouch;
@property (nonatomic, assign) NSTimeInterval lastUpdateTime;

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
	_shipTouch = [touches anyObject];
}

- (void)update:(NSTimeInterval)currentTime
{
	if (_lastUpdateTime == 0)
	{
		_lastUpdateTime = currentTime;
	}
	
	if (_shipTouch)
	{
		CGPoint touchPoint = [_shipTouch locationInNode:self];
		
		[self moveShipTowardPoint:touchPoint byTimeDelta:currentTime - _lastUpdateTime];
	}
	
	_lastUpdateTime = currentTime;
}

- (void)moveShipTowardPoint:(CGPoint)point byTimeDelta:(NSTimeInterval)timeDelta
{
	CGFloat shipSpeed = 130; ///< points per second
	SKNode *ship = [self childNodeWithName:@"ship"];
	
	CGFloat distanceLeft = sqrt(pow(ship.position.x - point.x, 2) +
								pow(ship.position.y - point.y, 2));
	if (distanceLeft > 4)
	{
		CGFloat distanceToTravel = timeDelta * shipSpeed;
		CGFloat angle = atan2(point.y - ship.position.y,
							  point.x - ship.position.x);
		CGFloat yOffset = distanceToTravel * sin(angle);
		CGFloat xOffset = distanceToTravel * cos(angle);
		
		CGPoint pt = ship.position;
		pt.x += xOffset;
		pt.y += yOffset;
		ship.position = pt;
	}
}

@end
