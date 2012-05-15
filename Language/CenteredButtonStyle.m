//
//  CenteredButtonStyle.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CenteredButtonStyle.h"
#import "IBAFormFieldStyle.h"

@implementation CenteredButtonStyle : IBAFormFieldStyle

- (id)init {
	if (self = [super init]) {
		self.labelTextColor = [UIColor colorWithRed:0.318 green:0.400 blue:0.569 alpha:1.0];
		self.labelFont = [UIFont boldSystemFontOfSize:14];
		self.labelFrame = CGRectMake(10, 8, 300, 30);
		self.labelTextAlignment = UITextAlignmentCenter;
		self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
	}
	
	return self;
}

@end
