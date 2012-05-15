//
//  AddSectionModel.h
//  Language
//
//  Created by Eric Cancil on 5/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddSectionModel : NSObject
@property(nonatomic, retain) NSString *sectionName;
+(AddSectionModel *)getInstance;
-(void)clear;
@end
