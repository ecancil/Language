//
//  StyledTableCell.m
//  Language
//
//  Created by Eric Cancil on 5/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StyledTableCell.h"
#import "UACellBackgroundView.h"
#import "StyledTableCellConstants.h"
#import "ADVPercentProgressBar.h"
@interface StyledTableCell ()
-(CGRect)getProgressFrame;
-(void)setupPosition;
- (void)setPosition:(UACellBackgroundViewPosition)newPosition;
@end

@implementation StyledTableCell
@synthesize progress;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
        
        // Background Image
        self.backgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero andType:BACKGROUND_NOT_SELECTED_TYPE];
        self.selectedBackgroundView = [[UACellBackgroundView alloc] initWithFrame:CGRectZero andType:BACKGROUND_SELECTED_TYPE];
    }
    self.textLabel.backgroundColor = [UIColor redColor];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [self.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    [self.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    [self.textLabel addObserver:self forKeyPath:@"text" options:0 context:nil];
    [self.textLabel addObserver:self forKeyPath:@"bounds" options:0 context:nil];
    [self addObserver:self forKeyPath:@"superview" options:NSKeyValueObservingOptionNew context:nil];
    [self performSelector:@selector(setupPosition) withObject:nil afterDelay:.1];
    return self;	
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{

    [self setNeedsLayout];
    [progress setFrame:[self getProgressFrame]];
   // [self setupPosition];

}

-(void)dealloc{
    [self.textLabel removeObserver:self forKeyPath:@"text"];
    [self.textLabel removeObserver:self forKeyPath:@"bounds"];
    [self removeObserver:self forKeyPath:@"superview"];
}


-(void)setupPosition{
    UITableView *tableView = (UITableView *)self.superview;
    if (tableView) {
        NSIndexPath *path = [tableView indexPathForCell:self];
        int row = path.row;
        int section = path.section;
        int totalInSection = [tableView numberOfRowsInSection:section];
        if(row == 0){
            [self setPosition:UACellBackgroundViewPositionTop];
        }else
            if(row + 1 == totalInSection){
                [self setPosition:UACellBackgroundViewPositionBottom];
            }else{
                [self setPosition:UACellBackgroundViewPositionMiddle];
            }
        if(totalInSection == 1){
            [self setPosition:UACellBackgroundViewPositionSingle];
        }
    }
}

-(void)prepareForReuse{
    [self setupPosition];
    
}


- (void)setPosition:(UACellBackgroundViewPosition)newPosition {	
    [(UACellBackgroundView *)self.backgroundView setPosition:newPosition];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [progress setFrame:[self getProgressFrame]];
}

-(CGRect)getProgressFrame{
    float gap = 15;
    float barHeight = 28;
    float accesoryLocation = 25;
    float margin = 40;
    
    CGFloat iconWidth = 30;
    CGFloat textWidth = [self.textLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]].width;
    CGFloat startX = self.textLabel.frame.origin.x + textWidth + gap;
    if(self.editing)startX += margin;
    CGFloat barWidth = self.bounds.size.width - startX - gap - accesoryLocation - iconWidth;
    if(self.editing) barWidth = 0;
    CGFloat screenWidth = UIScreen.mainScreen.bounds.size.width;
    CGRect frame = CGRectMake(startX, self.bounds.size.height / 2 - barHeight / 2, barWidth, barHeight);
    return frame;
}

-(void)layoutSubviews{
    [progress setFrame:[self getProgressFrame]];
//     NSLog(@"width x %fl", self.progress.frame.size.width);
       
    [super layoutSubviews];
}

-(void)showProgress{
    if(!progress){
        self.progress = [[ADVPercentProgressBar alloc] initWithFrame:[self getProgressFrame] andProgressBarColor:ADVProgressBarBlue];
        //[progress setProgress:.9];
        [self addSubview:progress];
        
    }
    [progress setAlpha:1];
    [self setNeedsLayout];
    [self performSelector:@selector(layoutLater) withObject:nil afterDelay:.1];
}
-(void)layoutLater{
    [progress setFrame:[self getProgressFrame]]; 
}

-(void)hideProgress{
    if(progress){
        [progress setAlpha:0];
    }
}

-(void)setProgressPercent:(float)theProgress{
    if (self.progress) {
        [self.progress setProgress:theProgress];
    }
}
@end
