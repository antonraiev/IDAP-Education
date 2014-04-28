//
//  CMCompass.m
//  Compo
//
//  Created by Anton Rayev on 4/25/14.
//  Copyright (c) 2014 Anton Rayev. All rights reserved.
//

#import "CMCompassCircle.h"

static const CGFloat kCMDefaultThickness = 3.f;
static const CGFloat kCMSmallSerifSize  = 5.f;
static const CGFloat kCMSmallSerifAngle = 6.f;
static const CGFloat kCMLargeSerifSize  = 15.f;
static const CGFloat kCMLargeSerifAngle = 30.f;

@interface CMCompassCircle ()

- (void)strokeSerifsWithSize:(CGFloat)serifSize
				 angleOffset:(CGFloat)angleOffset
					 context:(CGContextRef)context;

- (CGPoint)pointForAngle:(CGFloat)angle inCircle:(CGRect)circleRect;
- (CGRect)circleWithOffset:(CGFloat)offset;
- (CGRect)circleInRect:(CGRect)rect withOffset:(CGFloat)offset;

@end

@implementation CMCompassCircle

@dynamic rect;

#pragma mark -
#pragma mark Initializations and Deallocations

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.thickness = kCMDefaultThickness;
		self.backgroundColor = [UIColor clearColor];
	}
	
    return self;
}

#pragma mark -
#pragma mark Accessors

- (CGRect)rect {
	return [self circleWithOffset:self.thickness / 2];
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextSetLineWidth(context, self.thickness);
	
	CGRect circleRect = self.rect;
	CGContextStrokeEllipseInRect(context, circleRect);
	CGContextFillEllipseInRect(context, circleRect);
	
	[self strokeSerifsWithSize:kCMSmallSerifSize angleOffset:kCMSmallSerifAngle context:context];
	[self strokeSerifsWithSize:kCMLargeSerifSize angleOffset:kCMLargeSerifAngle context:context];
}

- (void)strokeSerifsWithSize:(CGFloat)serifSize
				 angleOffset:(CGFloat)angleOffset
					 context:(CGContextRef)context
{
	static const NSUInteger pointsInSerif = 2;
	NSUInteger pointCount = kCMDegreesInCircle / angleOffset * pointsInSerif;
	CGPoint *pointsOfSerifs = malloc(pointCount * sizeof(CGPoint));
	
	CGRect circleRect = self.rect;
	CGRect innerCircleRect = [self circleWithOffset:serifSize + self.thickness / 2];
	
	for (NSUInteger i = 0; i < pointCount; i += pointsInSerif) {
		CGFloat angle = i / pointsInSerif * angleOffset;
		
		pointsOfSerifs[i] = [self pointForAngle:angle inCircle:circleRect];
		pointsOfSerifs[i + 1] = [self pointForAngle:angle inCircle:innerCircleRect];
	}
	
	CGContextSetLineWidth(context, self.thickness / 2);
	CGContextStrokeLineSegments(context, pointsOfSerifs, pointCount);
	
	free(pointsOfSerifs);
}

#pragma mark -
#pragma mark Private

- (CGPoint)pointForAngle:(CGFloat)angle inCircle:(CGRect)circleRect {
	CGFloat angleInRadians = DEGREES_TO_RADIANS(angle);
	
	CGPoint circleCenter = CGRectGetCenter(circleRect);
	CGFloat circleRadius = CGMidX(circleRect) - CGMinX(circleRect);
	
	CGPoint point;
	point.x = circleCenter.x + circleRadius * cos(angleInRadians);
	point.y = circleCenter.y + circleRadius * sin(angleInRadians);
	
	return point;
}

- (CGRect)circleWithOffset:(CGFloat)offset {
	return [self circleInRect:self.bounds withOffset:offset];
}

- (CGRect)circleInRect:(CGRect)rect withOffset:(CGFloat)offset  {
	CGPoint circleOrigin = {rect.origin.x + offset, rect.origin.y + offset};
	CGSize circleSize = {rect.size.width - 2 * offset, rect.size.height - 2 * offset};
	
	return (CGRect){circleOrigin, circleSize};
}

@end