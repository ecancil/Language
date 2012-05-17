//
//  CreateWord.h
//  Language
//
//  Created by Eric Cancil on 4/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagedObjectsDao.h"
#import "IBAFormViewController.h"
#import "FormsBaseViewController.h"

@interface CreateWord : FormsBaseViewController <UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UILabel *language1Label;
@property (strong, nonatomic) IBOutlet UILabel *language2Label;
@property (strong, nonatomic) IBOutlet UILabel *language2supplementalLabel;
@property (strong, nonatomic) IBOutlet UIImageView *theImageView;
- (IBAction)onChooseOrTakePhoto:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *language1Input;
@property (strong, nonatomic) IBOutlet UITextField *language2Input;
@property (strong, nonatomic) IBOutlet UITextField *language2supplementalInput;
@property (strong, nonatomic) UIImage *imageToAttach;

@property (nonatomic, retain) ManagedObjectsDao *moDao;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isClone;

- (id)initEditorWithFormDataSource:(IBAFormDataSource *)formDataSource andIsEditor:(BOOL)isAnEditor;
-(void)didAddExample;
-(void)forceAddSaveButton;
@end
