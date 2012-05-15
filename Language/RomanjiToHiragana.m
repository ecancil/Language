//
//  RomanjiToHiragana.m
//  Demo
//
//  Created by Eric Cancil on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RomanjiToHiragana.h"
#import <Foundation/Foundation.h>

@implementation RomanjiToHiragana
@synthesize symbolDict;

-(id)init{
    if([super init]){
        self.symbolDict = [[NSMutableDictionary alloc] init];
        [self.symbolDict setValue:@"あ" forKey:@"a"];
        [self.symbolDict setValue:@"か" forKey:@"ka"];
        [self.symbolDict setValue:@"さ" forKey:@"sa"];
        [self.symbolDict setValue:@"た" forKey:@"ta"];
        [self.symbolDict setValue:@"な" forKey:@"na"];
        [self.symbolDict setValue:@"は" forKey:@"ha"];
        [self.symbolDict setValue:@"ま" forKey:@"ma"];
        [self.symbolDict setValue:@"や" forKey:@"ya"];
        [self.symbolDict setValue:@"わ" forKey:@"wa"];
        [self.symbolDict setValue:@"ら" forKey:@"ra"];
        [self.symbolDict setValue:@"ん" forKey:@"n"];
        [self.symbolDict setValue:@"が" forKey:@"ga"];
        [self.symbolDict setValue:@"ざ" forKey:@"za"];
        [self.symbolDict setValue:@"だ" forKey:@"da"];
        [self.symbolDict setValue:@"ば" forKey:@"ba"];
        [self.symbolDict setValue:@"ぱ" forKey:@"pa"];
        [self.symbolDict setValue:@"きゃ" forKey:@"kya"];
        [self.symbolDict setValue:@"しゃ" forKey:@"sha"];
        [self.symbolDict setValue:@"ちゃ" forKey:@"cha"];
        [self.symbolDict setValue:@"にゃ" forKey:@"nya"];
        [self.symbolDict setValue:@"ひゃ" forKey:@"hya"];
        [self.symbolDict setValue:@"みゃ" forKey:@"mya"];
        [self.symbolDict setValue:@"りゃ" forKey:@"rya"];
        [self.symbolDict setValue:@"ぎゃ" forKey:@"gya"];
        [self.symbolDict setValue:@"じゃ" forKey:@"ja"];
        [self.symbolDict setValue:@"ぢゃ" forKey:@"dya"];
        [self.symbolDict setValue:@"びゃ" forKey:@"bya"];
        [self.symbolDict setValue:@"ぴゃ" forKey:@"pya"];
        [self.symbolDict setValue:@"い" forKey:@"i"];
        [self.symbolDict setValue:@"き" forKey:@"ki"];
        [self.symbolDict setValue:@"し" forKey:@"shi"];
        [self.symbolDict setValue:@"ち" forKey:@"chi"];
        [self.symbolDict setValue:@"に" forKey:@"ni"];
        [self.symbolDict setValue:@"ひ" forKey:@"hi"];
        [self.symbolDict setValue:@"み" forKey:@"mi"];
        [self.symbolDict setValue:@"り" forKey:@"ri"];
        [self.symbolDict setValue:@"ぎ" forKey:@"gi"];
        [self.symbolDict setValue:@"じ" forKey:@"ji"];
        [self.symbolDict setValue:@"ぢ" forKey:@"di"];
        [self.symbolDict setValue:@"び" forKey:@"bi"];
        [self.symbolDict setValue:@"ぴ" forKey:@"pi"];
        [self.symbolDict setValue:@"う" forKey:@"u"];
        [self.symbolDict setValue:@"く" forKey:@"ku"];
        [self.symbolDict setValue:@"す" forKey:@"su"];
        [self.symbolDict setValue:@"つ" forKey:@"tsu"];
        [self.symbolDict setValue:@"ぬ" forKey:@"nu"];
        [self.symbolDict setValue:@"ふ" forKey:@"fu"];
        [self.symbolDict setValue:@"む" forKey:@"mu"];
        [self.symbolDict setValue:@"ゆ" forKey:@"yu"];
        [self.symbolDict setValue:@"る" forKey:@"ru"];
        [self.symbolDict setValue:@"ぐ" forKey:@"gu"];
        [self.symbolDict setValue:@"ず" forKey:@"zu"];
        [self.symbolDict setValue:@"づ" forKey:@"du"];
        [self.symbolDict setValue:@"ぶ" forKey:@"bu"];
        [self.symbolDict setValue:@"ぷ" forKey:@"pu"];
        [self.symbolDict setValue:@"きゅ" forKey:@"kyu"];
        [self.symbolDict setValue:@"しゅ" forKey:@"shu"];
        [self.symbolDict setValue:@"ちゅ" forKey:@"chu"];
        [self.symbolDict setValue:@"にゅ" forKey:@"nyu"];
        [self.symbolDict setValue:@"ひゅ" forKey:@"hyu"];
        [self.symbolDict setValue:@"みゅ" forKey:@"myu"];
        [self.symbolDict setValue:@"りゅ" forKey:@"ryu"];
        [self.symbolDict setValue:@"ぎゅ" forKey:@"gyu"];
        [self.symbolDict setValue:@"じゅ" forKey:@"jyu"];
        [self.symbolDict setValue:@"じゅ" forKey:@"ju"];        
        [self.symbolDict setValue:@"ぢゅ" forKey:@"dyu"];
        [self.symbolDict setValue:@"びゅ" forKey:@"byu"];
        [self.symbolDict setValue:@"ぴゅ" forKey:@"pyu"];
        [self.symbolDict setValue:@"え" forKey:@"e"];
        [self.symbolDict setValue:@"け" forKey:@"ke"];
        [self.symbolDict setValue:@"せ" forKey:@"se"];
        [self.symbolDict setValue:@"て" forKey:@"te"];
        [self.symbolDict setValue:@"ね" forKey:@"ne"];
        [self.symbolDict setValue:@"へ" forKey:@"he"];
        [self.symbolDict setValue:@"め" forKey:@"me"];
        [self.symbolDict setValue:@"れ" forKey:@"re"];
        [self.symbolDict setValue:@"げ" forKey:@"ge"];
        [self.symbolDict setValue:@"ぜ" forKey:@"ze"];
        [self.symbolDict setValue:@"で" forKey:@"de"];
        [self.symbolDict setValue:@"べ" forKey:@"be"];
        [self.symbolDict setValue:@"ぺ" forKey:@"pe"];
        [self.symbolDict setValue:@"お" forKey:@"o"];
        [self.symbolDict setValue:@"こ" forKey:@"ko"];
        [self.symbolDict setValue:@"そ" forKey:@"so"];
        [self.symbolDict setValue:@"と" forKey:@"to"];
        [self.symbolDict setValue:@"の" forKey:@"no"];
        [self.symbolDict setValue:@"ほ" forKey:@"ho"];
        [self.symbolDict setValue:@"も" forKey:@"mo"];
        [self.symbolDict setValue:@"よ" forKey:@"yo"];
        [self.symbolDict setValue:@"ろ" forKey:@"ro"];
        [self.symbolDict setValue:@"を" forKey:@"wo"];
        [self.symbolDict setValue:@"ご" forKey:@"go"];
        [self.symbolDict setValue:@"ぞ" forKey:@"zo"];
        [self.symbolDict setValue:@"ど" forKey:@"do"];
        [self.symbolDict setValue:@"ぼ" forKey:@"bo"];
        [self.symbolDict setValue:@"ぽ" forKey:@"po"];
        [self.symbolDict setValue:@"きょ" forKey:@"kyo"];
        [self.symbolDict setValue:@"しょ" forKey:@"sho"];
        [self.symbolDict setValue:@"ちょ" forKey:@"cho"];
        [self.symbolDict setValue:@"の" forKey:@"nyo"];
        [self.symbolDict setValue:@"ひょ" forKey:@"hyo"];
        [self.symbolDict setValue:@"みょ" forKey:@"myo"];
        [self.symbolDict setValue:@"りょ" forKey:@"ryo"];
        [self.symbolDict setValue:@"ぎょ" forKey:@"gyo"];
        [self.symbolDict setValue:@"じょ" forKey:@"jyo"];
        [self.symbolDict setValue:@"じょ" forKey:@"jo"];
        [self.symbolDict setValue:@"ぢょ" forKey:@"dyo"];
        [self.symbolDict setValue:@"ぴょ" forKey:@"byo"];
        [self.symbolDict setValue:@"ぴょ" forKey:@"pyo"];
        [self.symbolDict setValue:@"っ" forKey:@"smalltsu"];
    }
    return self;
}

- (NSString *)romanjiToKana:(NSString *)romanji{
    NSUInteger length = [romanji length];
    NSString *charCombo;
    NSString *fullWordInKana;
    int i;
    NSMutableArray *characterArray = [[NSMutableArray alloc] initWithCapacity:length];
    for (i = 0; i < length; i ++) {
        unichar character = [romanji characterAtIndex:i];
        NSString *stringChar = [NSString stringWithCharacters:&character length:1];
        [characterArray addObject:stringChar];
    }
    int j;
    fullWordInKana = [NSMutableString stringWithString:@""];
    for (j = 0; j < characterArray.count; j ++) {
        charCombo = nil;
        if(characterArray.count >= j + 2){
            NSString *thisChar = [characterArray objectAtIndex:j];
            NSString *nextChar = [characterArray objectAtIndex: j + 1];
            if([thisChar isEqualToString:nextChar]){
                charCombo = @"smalltsu";
            }
        }
        if(characterArray.count >= j + 3 && charCombo == nil){
            charCombo = [NSString stringWithFormat:@"%@%@%@", [characterArray objectAtIndex:j], [characterArray objectAtIndex: j + 1], [characterArray objectAtIndex:j + 2]];
            if([symbolDict valueForKey:charCombo]){
                j = j + 2;
            }else{
                charCombo = nil;
            }
        }
        if(characterArray.count >= j + 2 && charCombo == nil){
            charCombo = [NSString stringWithFormat:@"%@%@", [characterArray objectAtIndex:j], [characterArray objectAtIndex: j + 1]];
            if ([symbolDict valueForKey:charCombo]) {
                j ++;
            }else{
                charCombo = nil;
            }
        }
            
        if(charCombo == nil && ![charCombo isEqualToString:@"smalltsu"]){
            charCombo = [characterArray objectAtIndex:j];
        }
        NSString *kana = [symbolDict valueForKey:charCombo];
        if(kana != Nil){
            fullWordInKana = [NSString stringWithFormat:@"%@%@", fullWordInKana, kana];
        }
    }
   // NSLog([fullWordInKana copy]);
    NSLog(fullWordInKana);
    return fullWordInKana;
}
@end
