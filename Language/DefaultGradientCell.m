//
//  DefaultGradientCell.m
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultGradientCell.h"


@interface DefaultGradientCell (private)
-(void) drawLinearGradient:(CGContextRef) context withRect:(CGRect)rect andStartColor:(CGColorRef)startColor andEndColor:(CGColorRef)endColor;
-(void) drawGlossAndGradient:(CGContextRef) context inRect:(CGRect) rect withStartColor:(CGColorRef) startColor andEndColor:(CGColorRef)endColor;
@end
@implementation DefaultGradientCell



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)drawRect:(CGRect)rect{
    self.backgroundColor  = [UIColor clearColor];
    
    self.opaque = NO;
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    
    CGColorRef whiteColor = [UIColor colorWithRed:1.0 green:1.0 
                                             blue:1.0 alpha:1.0].CGColor;
    
    CGColorRef lightColor = [UIColor colorWithRed:105.0f/255.0f green:179.0f/255.0f 
                                             blue:216.0f/255.0f alpha:1.0].CGColor;
    
    CGColorRef darkColor = [UIColor colorWithRed:21.0/255.0 green:92.0/255.0 
                                            blue:136.0/255.0 alpha:1.0].CGColor;
    
    CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 
                                              blue:0.2 alpha:0.5].CGColor;  
    
    CGContextSetFillColorWithColor(context, lightColor);
    
    CGContextFillRect(context, self.bounds);
    
    [self drawGlossAndGradient:context inRect:rect withStartColor:lightColor andEndColor:darkColor];
    
}

//void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 

-(void) drawLinearGradient:(CGContextRef) context withRect:(CGRect)rect andStartColor:(CGColorRef)startColor andEndColor:(CGColorRef)endColor{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
                           
}

//void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, 
//                          CGColorRef endColor) {

-(void) drawGlossAndGradient:(CGContextRef) context inRect:(CGRect) rect withStartColor:(CGColorRef) startColor andEndColor:(CGColorRef)endColor{
    [self drawLinearGradient:context withRect:rect andStartColor:startColor andEndColor:endColor];
    /*
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.35].CGColor;

    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 
                                              blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, 
                                rect.size.width, rect.size.height/2);
    
    [self drawLinearGradient:context withRect:topHalf andStartColor:glossColor1 andEndColor:glossColor2];*/
}
                              

@end
