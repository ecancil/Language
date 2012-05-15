
#define TABLE_CELL_BACKGROUND    { 1, 1, 1, 1, 0.866, 0.866, 0.866, 1}			// #FFFFFF and #DDDDDD
//#define kDefaultMargin           0

#import "UACellBackgroundView.h"
#import "StyledTableCellConstants.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight);

@implementation UACellBackgroundView

@synthesize position;
@synthesize defaultMargin;
@synthesize type;

- (BOOL) isOpaque {
    return NO;
}

-(id)initWithFrame:(CGRect)frame andType:(NSString *)theType{
    if([super initWithFrame:frame]){
        self.type =theType;
    }
    return self;
}



-(void)drawRect:(CGRect)aRect {
    // Drawing code
    
    UITableView *theTable = (UITableView *)self.superview.superview;
    if(theTable.style == UITableViewStyleGrouped){
        defaultMargin = 10;
    }else{
        defaultMargin = 0;
    }


    CGContextRef c = UIGraphicsGetCurrentContext();	

    int lineWidth = 1;
    
    
    
    //CGFloat components[8];
    UIColor *color1;
    UIColor *color2;
    id theColor;
    
    if(type == BACKGROUND_SELECTED_TYPE){
        theColor = (id)[UIColor colorWithRed:245 green:245 blue:245 alpha:1].CGColor;
        color1 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        color2 = [UIColor colorWithRed:105.0f/255.0f green:105.0f/255.0f blue:105.0f/255.0f alpha:1];
    }else if(type == BACKGROUND_NOT_SELECTED_TYPE){
        theColor = (id)[UIColor colorWithRed:220 green:220 blue:220 alpha:1].CGColor;
        color1 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        color2 = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:245.0f/255.0f alpha:1];
    }else if(type == BACKGROUND_RED_TYPE){
        theColor = (id)[UIColor colorWithRed:220 green:220 blue:220 alpha:1].CGColor;
        color1 = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1];
        color2 = [UIColor colorWithRed:213.0f/255.0f green:43.0f/255.0f blue:34.0f/255.0f alpha:1];
    }
    
    CGFloat const *color1rgb = CGColorGetComponents(color1.CGColor);
    CGFloat const *color2rgb = CGColorGetComponents(color2.CGColor);
    CGFloat components[8] = {color1rgb[0], color1rgb[1], color1rgb[2], color1rgb[3], color2rgb[0], color2rgb[1], color2rgb[2], color2rgb[3]};
	
    CGRect rect = [self bounds];	
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    miny -= 1;
	
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = nil;
    //CGFloat components[8] = TABLE_CELL_BACKGROUND;
    CGContextSetStrokeColorWithColor(c, (__bridge CGColorRef)theColor);
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetAllowsAntialiasing(c, YES);
    CGContextSetShouldAntialias(c, YES);
    	
    if (position == UACellBackgroundViewPositionTop) {
		
        miny += 1;
		
	CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, defaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, defaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, maxy);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);		

    } else if (position == UACellBackgroundViewPositionBottom) {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, defaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, defaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, minx, miny);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);

		
    } else if (position == UACellBackgroundViewPositionMiddle) {
		
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, minx, miny);
	CGPathAddLineToPoint(path, NULL, maxx, miny);
	CGPathAddLineToPoint(path, NULL, maxx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, maxy);
	CGPathAddLineToPoint(path, NULL, minx, miny);
	CGPathCloseSubpath(path);
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);
		
    } else if (position == UACellBackgroundViewPositionSingle) {
	miny += 1;
		
	CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, midy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, defaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, defaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, defaultMargin);
        CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, defaultMargin);
	CGPathCloseSubpath(path);
		
		
	// Fill and stroke the path
	CGContextSaveGState(c);
	CGContextAddPath(c, path);
	CGContextClip(c);
		
		
	myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
	CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
		
	CGContextAddPath(c, path);
	CGPathRelease(path);
	CGContextStrokePath(c);
	CGContextRestoreGState(c);	
    }
	
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    return;
}



- (void)setPosition:(UACellBackgroundViewPosition)newPosition {
    if (position != newPosition) {
        position = newPosition;
        [self setNeedsDisplay];
    }
}

@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,float ovalHeight) {
    float fw, fh;
	
    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }
	
    CGContextSaveGState(context);// 2
	
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
                                    CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
	
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 10
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
	
    CGContextRestoreGState(context);// 13
}
