//
//  StyledTableCell.h
//  Language
//
//  Created by Eric Cancil on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADVPercentProgressBar.h"

@interface StyledTableCell : UITableViewCell

@property(nonatomic, retain) ADVPercentProgressBar *progress;
-(void)showProgress;
-(void)hideProgress;
-(void)setProgressPercent:(float)progress;
@end
