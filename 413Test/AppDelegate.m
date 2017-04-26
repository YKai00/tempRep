//
//  AppDelegate.m
//  413Test
//
//  Created by KYU on 13/04/2017.
//  Copyright © 2017 KYU. All rights reserved.
//

#import "AppDelegate.h"
#import "MYContentView.h"
#import <QuartzCore/QuartzCore.h>
#import "DrawLayer.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSView *customView;
@property (retain) MYContentView *myContentView;
@property (retain) CAShapeLayer *myLayer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
//    _myContentView = [[MYContentView alloc] initWithFrame:NSMakeRect(0, 0, _customView.frame.size.width, _customView.frame.size.height)];
//    [_myContentView setWantsLayer:YES];
//    _myContentView.layer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
//    [_customView addSubview:_myContentView];
    
//    DrawLayer *layer = [DrawLayer layer];
//    [_customView setWantsLayer:YES];
//    [layer setBackgroundColor:[NSColor windowBackgroundColor].CGColor];
//    [layer setNeedsDisplay];
//    [_customView setLayer:layer];
    
    _myLayer = [CAShapeLayer layer];
    _myLayer.backgroundColor = [NSColor windowBackgroundColor].CGColor;
    [_customView setWantsLayer:YES];
    [_customView.layer addSublayer:_myLayer];
}

- (IBAction)startAnimation:(id)sender
{
    NSBezierPath *path = [NSBezierPath bezierPath];
//    [path appendBezierPathWithRect:NSMakeRect(50, 50, 200, 200)];
//    [path moveToPoint:NSMakePoint(50, 50)];
//    [path appendBezierPathWithArcFromPoint:NSMakePoint(50, 50) toPoint:NSMakePoint(300, 50) radius:-M_PI_2];
//    [path closePath];
    NSBezierPath *linePath = [NSBezierPath bezierPath];
    [linePath moveToPoint:NSMakePoint(50, 50)];
    [linePath lineToPoint:NSMakePoint(300, 50)];
    
    [path appendBezierPath:linePath];
    
    _myLayer.path = [self quartzPath:path];
    _myLayer.strokeColor = [NSColor redColor].CGColor;
//    _myLayer.fillColor = [NSColor clearColor].CGColor;
    _myLayer.strokeStart = 0;
    _myLayer.strokeEnd = 1.0;
    _myLayer.lineWidth = 2.0;
    _myLayer.position = NSMakePoint(0, 0);
    
    CAKeyframeAnimation *theAnim = [CAKeyframeAnimation animationWithKeyPath:@"strokeEnd"];
    theAnim.values = @[@(0), @(1.0)];
    theAnim.duration = 5.0;
    
    [_myLayer addAnimation:theAnim forKey:@"animation"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void) windowWillClose:(NSNotification *) notification
{
    [NSApp terminate:nil];
}

- (CGPathRef)quartzPath:(NSBezierPath *) bezierPath
{
    NSInteger i, numElements;
    
    // Need to begin a path here.
    CGPathRef           immutablePath = NULL;
    
    // Then draw the path elements.
    numElements = [bezierPath elementCount];
    if (numElements > 0)
    {
        CGMutablePathRef    path = CGPathCreateMutable();
        NSPoint             points[3];
        BOOL                didClosePath = YES;
        
        for (i = 0; i < numElements; i++)
        {
            switch ([bezierPath elementAtIndex:i associatedPoints:points])
            {
                case NSMoveToBezierPathElement:
                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
                    break;
                    
                case NSLineToBezierPathElement:
                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
                    didClosePath = NO;
                    break;
                    
                case NSCurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
                                          points[1].x, points[1].y,
                                          points[2].x, points[2].y);
                    didClosePath = NO;
                    break;
                    
                case NSClosePathBezierPathElement:
                    CGPathCloseSubpath(path);
                    didClosePath = YES;
                    break;
            }
        }
        
        // Be sure the path is closed or Quartz may not do valid hit detection.
        if (!didClosePath)
            CGPathCloseSubpath(path);
        
        immutablePath = CGPathCreateCopy(path);
        CGPathRelease(path);
    }
    
    return immutablePath;
}

@end

//@implementation NSBezierPath (BezierPathQuartzUtilities)
//// This method works only in OS X v10.2 and later.
//- (CGPathRef)quartzPath
//{
//    NSInteger i, numElements;
//    
//    // Need to begin a path here.
//    CGPathRef           immutablePath = NULL;
//    
//    // Then draw the path elements.
//    numElements = [self elementCount];
//    if (numElements > 0)
//    {
//        CGMutablePathRef    path = CGPathCreateMutable();
//        NSPoint             points[3];
//        BOOL                didClosePath = YES;
//        
//        for (i = 0; i < numElements; i++)
//        {
//            switch ([self elementAtIndex:i associatedPoints:points])
//            {
//                case NSMoveToBezierPathElement:
//                    CGPathMoveToPoint(path, NULL, points[0].x, points[0].y);
//                    break;
//                    
//                case NSLineToBezierPathElement:
//                    CGPathAddLineToPoint(path, NULL, points[0].x, points[0].y);
//                    didClosePath = NO;
//                    break;
//                    
//                case NSCurveToBezierPathElement:
//                    CGPathAddCurveToPoint(path, NULL, points[0].x, points[0].y,
//                                          points[1].x, points[1].y,
//                                          points[2].x, points[2].y);
//                    didClosePath = NO;
//                    break;
//                    
//                case NSClosePathBezierPathElement:
//                    CGPathCloseSubpath(path);
//                    didClosePath = YES;
//                    break;
//            }
//        }
//        
//        // Be sure the path is closed or Quartz may not do valid hit detection.
//        if (!didClosePath)
//            CGPathCloseSubpath(path);
//        
//        immutablePath = CGPathCreateCopy(path);
//        CGPathRelease(path);
//    }
//    
//    return immutablePath;
//}
//@end
