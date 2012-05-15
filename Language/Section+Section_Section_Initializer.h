//
//  Section+Section_Section_Initializer.h
//  Language
//
//  Created by Eric Cancil on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Section.h"
#import "SQLSection.h"

@interface Section (Section_Section_Initializer)
-(id)initWithSqlSection:(SQLSection *) sqlSection;
-(id)initWithTitle:(NSString *) title;
@end
