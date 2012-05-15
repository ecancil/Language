//
//  AddExamplesToWordController.m
//  Language
//
//  Created by Eric Cancil on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddExamplesToWordController.h"
#import "NSString+NSString_HTML_Utilities.h"
#import "AddExamplesToWordPreviewController.h"

@interface AddExamplesToWordController ()
@property float originalW;
@property float originalH;
@property CGRect originalFrame;
-(void)updateTextWithCode:(NSString *)toEnter;
@end
@implementation AddExamplesToWordController
@synthesize addExamplesInstructionsLabel;
@synthesize examplesInput;
@synthesize theScrollView;
@synthesize keyboardVisible;
@synthesize offset;

@synthesize originalH;
@synthesize originalW;
@synthesize addWordModel;
@synthesize lineBreakButton;
@synthesize boldButton;
@synthesize colorButton;
@synthesize hruleButton;
@synthesize underlineButton;
@synthesize originalFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [lineBreakButton setAction:@selector(onLineBreak:)];
    [boldButton setAction:@selector(onBold:)];
    [colorButton setAction:@selector(onColor:)];
    [hruleButton setAction:@selector(onHrule:)];
    [underlineButton setAction:@selector(onUnderline:)];
        
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(onPreview:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    addWordModel = [AddWordModel getInstance];
    
    if (addWordModel && addWordModel.examples) {
        self.examplesInput.text = addWordModel.examples;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
    [self.examplesInput setDelegate:self];
    
    [self.examplesInput becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

-(void)onPreview:(id)sender{
    AddExamplesToWordPreviewController *preview = [[AddExamplesToWordPreviewController alloc] initWithNibName:@"AddExamplesToWordPreviewController" bundle:nil];
    [self.navigationController pushViewController:preview animated:YES];
}


-(void)keyboardDidShow:(NSNotification *)notification{
    if(self.keyboardVisible){
        //return;
    }
    NSDictionary *info = notification.userInfo;
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    originalFrame = self.theScrollView.frame;
    
    self.offset = self.theScrollView.contentOffset;
    
    CGRect viewFrame = self.theScrollView.frame;
    viewFrame.size.height = self.view.bounds.size.height + self.navigationController.navigationBar.frame.size.height - keyboardSize.height + 10; //keyboardSize2.height - self.navigationController.navigationBar.frame.size.height;
    
    
    [UIView animateWithDuration:.5 animations:^{
        self.theScrollView.frame = viewFrame;
    }];
    
    self.keyboardVisible = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif 
{
    if (!keyboardVisible) 
    {
        return;
    }
    
   // self.theScrollView.frame = CGRectMake(0, 0, originalW, originalH);
    
    // Reset the scrollview to previous location
    self.theScrollView.contentOffset = offset;
    
    // Keyboard is no longer visible
    keyboardVisible = NO;	
}

- (void)viewDidUnload
{
    [self setAddExamplesInstructionsLabel:nil];
    [self setExamplesInput:nil];
    [self setTheScrollView:nil];
    [self setLineBreakButton:nil];
    [self setBoldButton:nil];
    [self setColorButton:nil];
    [self setHruleButton:nil];
    [self setUnderlineButton:nil];
    [self setUnderlineButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)textViewDidChange:(UITextView *)textView{
    //NSString *htmlText = [textView.text htmlFromMarkup];
    //NSLog(htmlText);
    [addWordModel setExamples:textView.text];
}


-(void)updateTextWithCode:(NSString *)toEnter{
    NSMutableString *theCopy = self.examplesInput.text.mutableCopy;
    NSUInteger index = [self.examplesInput selectedRange].location;

    [theCopy insertString:toEnter atIndex:index];
    self.examplesInput.text = theCopy;
    [self.examplesInput setSelectedRange:NSMakeRange(index + [toEnter length], 0)]; 
}
-(void)onLineBreak:(id)sender{
   NSString *toEnter = @"[br]";
    [self updateTextWithCode:toEnter];
}



-(void)onBold:(id)sender{
    NSInteger openOccurences = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[b]"];
    NSInteger closedOccurences = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[/b]"];
    if(openOccurences > closedOccurences){
        NSString *toEnter = @"[/b]";
        [self updateTextWithCode:toEnter];
//      self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[/b]"]; 
        
    }else{
        NSString *toEnter = @"[b]";
        [self updateTextWithCode:toEnter];
      //  self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[b]"];
    }
}

-(void)onUnderline:(id)sender{
    NSInteger openOccurences = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[ul]"];
    NSInteger closedOccurences = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[/ul]"];
    if(openOccurences > closedOccurences){
        NSString *toEnter = @"[/ul]";
        [self updateTextWithCode:toEnter];
        //      self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[/b]"]; 
        
    }else{
        NSString *toEnter = @"[ul]";
        [self updateTextWithCode:toEnter];
        //  self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[b]"];
    }
}

-(void)onColor:(id)sender{
    NSUInteger redTotal = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[red]"];
    NSUInteger blueTotal = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[blue]"];
    NSUInteger greenTotal = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[green]"];
    NSUInteger yellowTotal = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[yellow]"];
    NSUInteger cumulativeTotal = redTotal + blueTotal + greenTotal + yellowTotal;
    NSUInteger closedTotal = [self.examplesInput.text returnNumberOfInstancesOfSubstring:@"[/color]"];
    if(cumulativeTotal > closedTotal){
        NSString *toEnter = @"[/color]";
        [self updateTextWithCode:toEnter];
        //self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[/color]"]; 
    }else{
        //NSUInteger currentLength = self.examplesInput.text.length;
        NSUInteger currentLength = [self.examplesInput selectedRange].location;
        NSString *toEnter = @"[color]";
        [self updateTextWithCode:toEnter];
       // self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[color]"]; 
        UITextPosition *beginning = [self.examplesInput beginningOfDocument];
        UITextPosition *start = [self.examplesInput positionFromPosition:beginning offset:currentLength + 1];
        UITextPosition *end = [self.examplesInput positionFromPosition:beginning offset:currentLength + 6];
                                     
        [self.examplesInput setSelectedTextRange:[self.examplesInput textRangeFromPosition:start toPosition:end]];
    }
    
}

-(void)onHrule:(id)sender{
    NSString *toEnter = @"[line]";
    [self updateTextWithCode:toEnter];
       // self.examplesInput.text = [self.examplesInput.text stringByAppendingString:@"[line]"];
}

@end
