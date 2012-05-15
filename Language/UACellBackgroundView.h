
#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef enum  {
    UACellBackgroundViewPositionSingle = 0,
    UACellBackgroundViewPositionTop, 
    UACellBackgroundViewPositionBottom,
    UACellBackgroundViewPositionMiddle
} UACellBackgroundViewPosition;

@interface UACellBackgroundView : UIView {
    UACellBackgroundViewPosition position;
}
-(id)initWithFrame:(CGRect)frame andType:(NSString *)type;

@property(nonatomic, retain) NSString *type;
@property(nonatomic) UACellBackgroundViewPosition position;
@property(nonatomic, assign) int defaultMargin;
@end
