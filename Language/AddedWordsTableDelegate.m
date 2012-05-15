//
//  AddedWordsTableDelegate.m
//  Language
//
//  Created by Eric Cancil on 4/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddedWordsTableDelegate.h"
#import "StyledTableCell.h"

@implementation AddedWordsTableDelegate
@synthesize tableView;
@synthesize addedWords;


-(void)addWord:(SQLWord *)word{
    if(![addedWords containsObject:word]){
        [addedWords addObject:word];
        [self.tableView reloadData];
    }
}
-(void)removeWord:(SQLWord *)word{
    if([addedWords containsObject:word]){
        [addedWords removeObject:word];
    }
}

-(id)initWithTable:(UITableView *)table{
    if([super init]){
        self.tableView = table;
        self.addedWords = [[NSMutableArray alloc] init];
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];
       [self.tableView setEditing:YES animated:YES];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [addedWords count]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    //static NSString *CellIdentifier = @"DefaultGradientCell";
    
    StyledTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //DefaultGradientCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StyledTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell = [[DefaultGradientCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    int row = indexPath.row;
    SQLWord *sqlWord = [addedWords objectAtIndex:row];
    
    if (sqlWord) {
        cell.textLabel.text = sqlWord.language1;
        cell.detailTextLabel.text = sqlWord.language2;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    SQLWord *word = [addedWords objectAtIndex:indexPath.row];
    [self removeWord:word];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"Removed_Added_Word" object:self];
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Removed_Added_Word" object:self userInfo:[NSDictionary dictionaryWithObject:word forKey:@"removedWord"]];
}

@end
