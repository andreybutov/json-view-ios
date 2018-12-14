//
// JSONView.h
//
// Andrey Butov
// https://andreybutov.com
// https://github.com/andreybutov/json-view-ios
//



#import <UIKit/UIKit.h>



@interface JSONView : UIView

- (id) initWithData:(NSDictionary*)dictionary;
- (void) performLayoutWithWidth:(int)width;

@end
