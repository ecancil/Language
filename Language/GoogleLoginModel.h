//
//  GoogleLoginModel.h
//  Language
//
//  Created by Eric Cancil on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleLoginModel : NSObject
+(GoogleLoginModel *)getInstance;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *password;
@end
