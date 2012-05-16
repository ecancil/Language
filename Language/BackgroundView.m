//
//  BackgroundView.m
//  Language
//
//  Created by Eric Cancil on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BackgroundView.h"
#import "AssetConstants.h"
@interface BackgroundView ()
-(void)addBackground;
@end
@implementation BackgroundView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addBackground];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self addBackground];
    }
    return self;
}

-(void)addBackground{
    self.backgroundColor = [UIColor colorWithPatternImage:VIEW_BACKGROUND];
    return;
    UIImageView *background = [[UIImageView alloc] initWithImage:VIEW_BACKGROUND];
    [self addSubview:background];
    [self sendSubviewToBack:background];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
