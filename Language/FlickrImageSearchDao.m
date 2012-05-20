//
//  FlickrImageSearchDao.m
//  Language
//
//  Created by Eric Cancil on 5/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define KEY @"0f76353becf107addf69ed1225c07dad"
#define SECRET @"6d38c26b2c0f7be7"

#import "FlickrImageSearchDao.h"
#import "FlickrPhoto.h"
@interface FlickrImageSearchDao ()
-(FlickrPhoto *)returnFlickrPhotoFromFarmID:(NSString *)farmID andServerID:(NSString *)serverID andID:(NSString *)ID andSecret:(NSString *)secret;
@property(nonatomic, retain)id<FlickrImageSearchResponder> responder;
@property(nonatomic, retain) NSMutableArray *photos;
@property(nonatomic, retain) NSMutableDictionary *dataDictionary;
@end
@implementation FlickrImageSearchDao
@synthesize responder;
@synthesize photos;
@synthesize dataDictionary;

-(void)dealloc{
    dataDictionary = nil;
    photos = nil;
    responder = nil;
}

-(id)initWithResponder:(id<FlickrImageSearchResponder>)theResponder{
    if([self init]){
        dataDictionary = [[NSMutableDictionary alloc] init];
        self. photos = [[NSMutableArray alloc] init];
        self.responder  = theResponder;
    }
    return self;
}

-(void)searchForImagesByString:(NSString *)searchString{
    NSString *url = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&text=%@&format=rest",KEY, searchString, searchString];
    
    url = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    [dataDictionary setObject:[[NSMutableData alloc] init] forKey:request];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSMutableData *imageData = [dataDictionary objectForKey:connection.originalRequest];
    [imageData appendData:data];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSMutableData *imageData = [dataDictionary objectForKey:connection.originalRequest];
    NSString *stringData = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding]; 
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:imageData];
    [parser setDelegate:self];
    [parser parse];
}
                         
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.responder imagesDidLoad:photos];
}

/*
 //    <photo id="7217826526" owner="78449950@N02" secret="5eecf32e43" server="5450" farm="6" title="_MG_1049" ispublic="1" isfriend="0" isfamily="0" />
 //http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}.jpg
*/
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([elementName isEqualToString:@"photo"]) {
        NSString *farmID = [attributeDict objectForKey:@"farm"];
        NSString *serverID = [attributeDict objectForKey:@"server"];
        NSString *ID = [attributeDict objectForKey:@"id"];
        NSString *secret = [attributeDict objectForKey:@"secret"];
        [photos addObject:[self returnFlickrPhotoFromFarmID:farmID andServerID:serverID andID:ID andSecret:secret]];
    }
}

-(FlickrPhoto *)returnFlickrPhotoFromFarmID:(NSString *)farmID andServerID:(NSString *)serverID andID:(NSString *)ID andSecret:(NSString *)secret{
    NSString *thumbSize = @"s";
    NSString *fullSize = @"m";
    
    NSString *thumbURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farmID, serverID, ID, secret, thumbSize];
    NSString *fullURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@_%@.jpg", farmID, serverID, ID, secret, fullSize];
    FlickrPhoto *flickrPhoto = [[FlickrPhoto alloc] init];
    flickrPhoto.thumbnail = thumbURL;
    flickrPhoto.fullSizePhoto = fullURL;
    
    return flickrPhoto;
}

@end
