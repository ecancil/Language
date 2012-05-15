//
//  SecondaryListModel.h
//  Language
//
//  Created by Eric Cancil on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Section.h"
#import "Word.h"

@interface SecondaryListModel : NSObject{
    NSMutableArray *menuValues;
    Section *activeUserSection;
    
}
@property(nonatomic, retain) NSMutableArray *menuValues;
@property(nonatomic, retain) Section *activeUserSection;


+(SecondaryListModel *)getInstance;
@end
