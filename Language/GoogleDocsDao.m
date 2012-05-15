//
//  GoogleDocsDao.m
//  Language
//
//  Created by Eric Cancil on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GoogleDocsDao.h"
#import "GDataDocs.h"
#import "GDataServiceGoogleSpreadsheet.h"
#import "GDataFeedSpreadsheet.h"
#import "GDataEntrySpreadsheet.h"
#import "GoogleDocsDaoResponder.h"
#import "GDataFeedWorksheet.h"
#import "GDataEntryWorksheet.h"
#import "GDataServiceGoogle.h"


#define CLIENT_ID @"478644798937.apps.googleusercontent.com"
#define CLIENT_SECRET @"uZA6quEx6ZiehBknUZ6IkeY-"
#define REDIRECT_URI @"urn:ietf:wg:oauth:2.0:oob"
@interface GoogleDocsDao ()
- (GDataServiceGoogleSpreadsheet *)spreadsheetService;
@property (nonatomic, retain)id<GoogleDocsDaoResponder> responder;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@end
@implementation GoogleDocsDao
@synthesize responder;
@synthesize username;
@synthesize password;
+(void)setup{
   
}



-(id)initWithResponder:(id<GoogleDocsDaoResponder>)theResponder andUsername:(NSString *)theUsername andPassword:(NSString *)thePassword{
    if([self init]){
        self.responder = theResponder;
        self.username = theUsername;
        self.password = thePassword;
    }
    return self; 
}

-(void)loginWithName:(NSString *)name password:(NSString *)password{
    GDataServiceGoogleSpreadsheet *as = [self spreadsheetService];
    [as setUserCredentialsWithUsername:name password:password];
    [as authenticateWithDelegate:self didAuthenticateSelector:@selector(ticket:authenticatedWithError:)];
}
   

- (void)ticket:(GDataServiceTicket *)ticket authenticatedWithError:(NSError *)error{
    if (error) {
        [self.responder loginDidReturnError];
    }else{
        [self.responder didLogin];
    }
} 


-(GDataServiceGoogleSpreadsheet *)spreadsheetService {
    
    static GDataServiceGoogleSpreadsheet* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleSpreadsheet alloc] init];
        
        [service setShouldCacheResponseData:YES];
        [service setServiceShouldFollowNextLinks:YES];
    }
    
    // username/password may change
  //  NSString *username = @"eric@appdivision.com";
    //NSString *password = @"Ec@ncil111";
    
    [service setUserCredentialsWithUsername:self.username
                                   password:self.password];
    
    return service;
}

- (void)fetchFeedOfSpreadsheets{
    
    
    GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
    NSURL *feedURL = [NSURL URLWithString:kGDataGoogleSpreadsheetsPrivateFullFeed];
    [service fetchFeedWithURL:feedURL
                     delegate:self
            didFinishSelector:@selector(feedTicket:finishedWithFeed:error:)];
}

- (void)feedTicket:(GDataServiceTicket *)ticket
  finishedWithFeed:(GDataFeedSpreadsheet *)feed
             error:(NSError *)error {
    NSArray *entries = [feed entries];
    [self.responder didFetchSpreadsheets:entries];
    
}

- (void)fetchSpreadsheet:(GDataEntrySpreadsheet *)spreadsheet{
    
    if (spreadsheet) {
        
        NSURL *feedURL = [spreadsheet worksheetsFeedURL];
        if (feedURL) {
            GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
            [service fetchFeedWithURL:feedURL
                             delegate:self
                    didFinishSelector:@selector(worksheetsTicket:finishedWithFeed:error:)];
        }
    }
}

- (void)worksheetsTicket:(GDataServiceTicket *)ticket
        finishedWithFeed:(GDataFeedWorksheet *)feed
                   error:(NSError *)error {
    NSArray *entries = [feed entries];
    [self.responder didFetchWorksheets:entries];
}

- (void)fetchWorksheet:(GDataEntryWorksheet *)worksheet{
    
    if (worksheet) {
        
        // the segmented control lets the user retrieve cell entries (position 0)
        // or list entries (position 1)
        //int segmentIndex = [mFeedSelectorSegments selectedSegment];
        NSURL *feedURL;
        
       // feedURL = [[worksheet cellsLink] URL];
        feedURL = [worksheet listFeedURL];
        
        
        if (feedURL) {

            GDataServiceGoogleSpreadsheet *service = [self spreadsheetService];
            [service fetchFeedWithURL:feedURL
                             delegate:self
                    didFinishSelector:@selector(entriesTicket:finishedWithFeed:error:)];
        }
    }
}

- (void)entriesTicket:(GDataServiceTicket *)ticket
     finishedWithFeed:(GDataFeedBase *)feed
                error:(NSError *)error {
    NSArray *entries = [feed entries];
    [self.responder didFetchEntries:entries];
}

@end
