//
//  CreateWord.m
//  Language
//
//  Created by Eric Cancil on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CreateWord.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "SaveTypes.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateWordDataSource.h"
#import "AddExamplesToWordController.h"
#import "AddWordModel.h"
#import "CreateWordDataSource.h"
#import "SpecialIdentifiers.h"
#import "AppDelegate.h"
#import "FlickrResults.h"


@interface CreateWord ()
-(void)resetInset;
-(void)makeFlickrImagePicker;
-(void)makePhotoImagePicker;
-(void)makePhotoTakerImagePicker;
-(void)setupInputs;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
-(CreateWordDataSource *)getTypedDataSource;
@property(nonatomic, assign) BOOL isShowingButton;
@property (nonatomic, assign) BOOL isEditor;
@end
@implementation CreateWord
@synthesize language1Input;
@synthesize language2Input;
@synthesize language2supplementalInput;
@synthesize language2Label;
@synthesize language2supplementalLabel;
@synthesize theImageView;
@synthesize language1Label;
@synthesize imagePickerController;
@synthesize moDao;
@synthesize tableView;
@synthesize imageToAttach;
@synthesize isEditor;
@synthesize isShowingButton;
@synthesize isClone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initEditorWithFormDataSource:(IBAFormDataSource *)formDataSource andIsEditor:(BOOL)isAnEditor {
    if([self initWithFormDataSource:formDataSource]){
        isEditor = isAnEditor;
    }
	return self;
}

-(CreateWordDataSource *)getTypedDataSource{
    return (CreateWordDataSource *)self.formDataSource;
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
    
    [self getTypedDataSource].viewDelegate = self;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIStatusBarStyleBlackTranslucent];
    
    
    moDao = [ManagedObjectsDao getInstance];
    
    AddWordModel *model = [AddWordModel getInstance];
    if (model.word && model.word.image) {
        self.theImageView.image = model.word.image;
    }
    
    if(self.isEditor)return;
    
    [self.tableView setScrollEnabled:NO];
    
    [self.formDataSource addObserver:self forKeyPath:@"shouldShowSaveButton" options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)dealloc{
    if(self.isEditor)return;
    [self.formDataSource removeObserver:self forKeyPath:@"shouldShowSaveButton"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(isEditor)return;
    CreateWordDataSource *typedDataSource = (CreateWordDataSource *)self.formDataSource;
    if(typedDataSource.shouldShowSaveButton){
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
        
        if(!self.isShowingButton)[self.navigationItem setRightBarButtonItem:saveButton animated:YES];
        self.isShowingButton = YES;
    }else{
        [self.navigationItem  setRightBarButtonItem:nil];
        self.isShowingButton = NO;
    }
}

-(void)forceAddSaveButton{
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    [self.navigationItem setRightBarButtonItem:saveButton animated:YES];
    self.isShowingButton = YES;
}

-(void)didAddExample{
    AddExamplesToWordController *addExamples = [[AddExamplesToWordController alloc] initWithNibName:@"AddExamplesToWordController" bundle:nil];
    [self.navigationController pushViewController:addExamples animated:YES];
}



-(void)setupInputs{
    
}


-(void)save:(id)sender{
    AddWordModel *model = [AddWordModel getInstance];
    if(isClone){
        [self.daoInteractor addUserCreatedWordWithLanguage1:[model language1] andLanguage2:[model language2] andlanguage2supplemental:[model language2Supplemental] andExampleSentences:[model examples] andImage:imageToAttach != nil ? imageToAttach : nil createOnly:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaved:) name:WORD_SAVED object:self.moDao];
        return;
    }
    if(model.word && model.word.uniqueID > 0){
        //[moDao updateUserCreatedWordByWord:model.word forDelete:NO];
        [model updateWordWithValuesAndImage:imageToAttach];
        [self.daoInteractor saveWithSaveType:WORD_SAVED];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaved:) name:WORD_SAVED object:self.moDao];
    }else{
    
        [self.daoInteractor addUserCreatedWordWithLanguage1:[model language1] andLanguage2:[model language2] andlanguage2supplemental:[model language2Supplemental] andExampleSentences:[model examples] andImage:imageToAttach != nil ? imageToAttach : nil createOnly:NO];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaved:) name:WORD_SAVED object:self.moDao];
    }
}

-(void)onSaved:(id)sender{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    AddWordModel *model = [AddWordModel getInstance];
    if(isEditor && model.word && !isClone){    
        [model updateWordWithValuesAndImage:imageToAttach];
    }
}

- (void)viewDidUnload
{
    AddWordModel *model = [AddWordModel getInstance];
    if(isEditor && model.word){    
        [model updateWordWithValuesAndImage:imageToAttach];
    }
    
    [self setLanguage1Label:nil];
    [self setLanguage2Label:nil];
    [self setLanguage2supplementalLabel:nil];
    [self setTheImageView:nil];
    [self setLanguage1Input:nil];
    [self setLanguage2Input:nil];
    [self setLanguage2supplementalInput:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onChooseOrTakePhoto:(id)sender {
    UIActionSheet *actionSheet;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES){
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Search Flickr", @"Choose photo", @"Take photo", nil];
    }else{
       actionSheet = [[UIActionSheet alloc] initWithTitle:@"Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Search Flickr", @"Choose photo", nil]; 
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self makeFlickrImagePicker];
            break;
        case 1:
            [self makePhotoImagePicker];
            break;
        case 2:
           if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == YES)[self makePhotoTakerImagePicker];
            break;
    }
}

-(void)makeFlickrImagePicker{
    FlickrResults *flickrResults = [[FlickrResults alloc] init];
    [self.navigationController pushViewController:flickrResults animated:YES];
}

-(void)makePhotoImagePicker{
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = NO;
    imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentModalViewController:imagePickerController animated:YES];
}
-(void)makePhotoTakerImagePicker{
    imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = NO;
    imagePickerController.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self presentModalViewController:imagePickerController animated:YES];
}

/*
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_2_0,__IPHONE_3_0);
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
 - (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
 - (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
 */
- (void)imagePickerController:(UIImagePickerController *)picker 
didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self resetInset];
    [self dismissModalViewControllerAnimated:YES];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        UIImage *image = imageToAttach = [info objectForKey:UIImagePickerControllerOriginalImage];
        image = imageToAttach = [UIImage imageWithData:UIImageJPEGRepresentation(image, .1)];
        if(image){
            
            self.theImageView.layer.masksToBounds = NO;
            /*self.theImageView.layer.masksToBounds = NO;
            self.theImageView.layer.cornerRadius = 8; // if you like rounded corners
            self.theImageView.layer.shadowOffset = CGSizeMake(5, 5);
            self.theImageView.layer.shadowRadius = 5;
            self.theImageView.layer.shadowOpacity = 0.5;*/

            [theImageView setAlpha:0];
            UIImage *borderedImage = [self imageWithBorderFromImage:image];
            [theImageView setImage:borderedImage];
            [UIView animateWithDuration:2 animations:^{
                theImageView.alpha = 1;
            }];
            
            
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self resetInset];
    [self dismissModalViewControllerAnimated:YES];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale); {
        CGContextSetShadowWithColor(UIGraphicsGetCurrentContext(), CGSizeMake(10, 10), 1, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1].CGColor);
        [image drawAtPoint:CGPointZero];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

-(void)resetInset{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.stackedController setLeftInset:50 animated:YES];

}
@end
