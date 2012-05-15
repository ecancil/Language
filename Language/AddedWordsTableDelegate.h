//
//  AddedWordsTableDelegate.h
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLWord.h"

@interface AddedWordsTableDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *addedWords;
    UITableView *tableView;
}
@property(nonatomic, retain) NSMutableArray *addedWords;
@property(nonatomic, retain) UITableView *tableView;

-(id)initWithTable:(UITableView *)table;
-(void)addWord:(SQLWord *)word;
-(void)removeWord:(SQLWord *)word;
@end
