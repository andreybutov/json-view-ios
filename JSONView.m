//
// JSONView.m
//
// Andrey Butov
// https://andreybutov.com
// https://github.com/andreybutov/json-view-ios
//



#import "JSONView.h"




@interface JSONView ()

@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) int height;
@property (nonatomic) UIColor* generalLabelColor;

@end



@implementation JSONView

- (id) initWithData:(NSDictionary*)dictionary
{
	self = [super init];

	if ( self )
	{
		self.backgroundColor = UIColor.blackColor;
		
		_generalLabelColor = UIColor.whiteColor;
	
		_scrollView = [[UIScrollView alloc] init];
		[self addSubview:_scrollView];

		UIView* keyValueView = [self viewWithKey:@""
			value:dictionary
			level:1
			lastValue:TRUE];
		
		_height = keyValueView.frame.size.height;

		[_scrollView addSubview:keyValueView];

		_scrollView.contentSize = CGSizeMake(
			keyValueView.frame.size.width,
			keyValueView.frame.size.height
		);
	}

	return self;
}



- (void) performLayoutWithWidth:(int)width
{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, _height);

	_scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, self.frame.size.width, self.frame.size.height);
}



- (UIView*) viewWithKey:(NSString*)key value:(id)value level:(int)level lastValue:(BOOL)lastValue
{
	UIView* view = [[UIView alloc] init];

	int lineGap = 3;
	int keyValueGap = 2;
	int width = 0;
	int height = 0;
	int indentationLevel = 20 * level;

	UILabel* keyLbl = (key && key.length > 0) ?
		[self labelWithText:key color:UIColor.yellowColor] :
		nil;

	UILabel* pointerLbl = keyLbl ?
		[self labelWithText:@"=>" color:_generalLabelColor] : nil;

	if ( keyLbl )
	{
		[view addSubview:keyLbl];
		keyLbl.frame = CGRectMake(0, 0, keyLbl.frame.size.width, keyLbl.frame.size.height);

		[view addSubview:pointerLbl];
		pointerLbl.frame = CGRectMake(keyLbl.frame.origin.x + keyLbl.frame.size.width + keyValueGap, keyLbl.frame.origin.y, pointerLbl.frame.size.width, pointerLbl.frame.size.height);

		width = pointerLbl.frame.origin.x + pointerLbl.frame.size.width;
		height = MAX(keyLbl.frame.size.height, pointerLbl.frame.size.height);
	}
	

	BOOL complexValueType = ( [value isKindOfClass:[NSDictionary class]] ||
						 	  [value isKindOfClass:[NSArray class]] );


	if ( complexValueType )
	{
		//
		// Complete key => value type where value is a dictionary or an array.
		///

		BOOL isDictionary = [value isKindOfClass:[NSDictionary class]];
		BOOL isArray = isDictionary ? FALSE : [value isKindOfClass:[NSArray class]];

		if ( !isDictionary && !isArray ) {
			NSLog(@"JSONView Error: complex type is neither dictionary nor array: %@", [[value class] description]);
			return nil;
		}

		NSString* openingScopeChar = isDictionary ? @"{" : @"[";
		NSString* closingScopeChar = isDictionary ? @"}" : @"]";

		if ( !lastValue ) {
			closingScopeChar = [NSString stringWithFormat:@"%@,", closingScopeChar];
		}

		UILabel* openingLbl = [self
			labelWithText:[NSString stringWithFormat:@"%@\n", openingScopeChar]
			color:_generalLabelColor];

		[view addSubview:openingLbl];
		openingLbl.frame = CGRectMake(pointerLbl ? pointerLbl.frame.origin.x + pointerLbl.frame.size.width + keyValueGap : 0, 0, openingLbl.frame.size.width, openingLbl.frame.size.height);

		width = (openingLbl.frame.origin.x + openingLbl.frame.size.width);
		height = MAX(height, openingLbl.frame.size.height);

		NSDictionary* dict = isDictionary ? (NSDictionary*)value : nil;
		NSArray* childKeys = dict ? dict.allKeys : nil;
		NSArray* array = isArray ? (NSArray*)value : nil;
		int childCount = (int)(dict ? dict.count : array.count);

		for ( int i = 0 ; i < childCount ; ++i )
		{
			NSString* childKey = childKeys ? childKeys[i] : @"";
			id childValue = dict ? dict[childKey] : array[i];

			UIView* childView = [self viewWithKey:childKey
				value:childValue
				level:level + 1
				lastValue:(i == childCount - 1)];

			if ( childView )
			{
				[view addSubview:childView];

				childView.frame = CGRectMake(indentationLevel, height, childView.frame.size.width, childView.frame.size.height);

				width = MAX(width, (childView.frame.origin.x + childView.frame.size.width));
				height += childView.frame.size.height + lineGap;
			}
		}

		UILabel* closingLbl = [self
            labelWithText:[NSString stringWithFormat:@"%@", closingScopeChar]
            color:_generalLabelColor
        ];
		
		[view addSubview:closingLbl];
		
		width = MAX(width, closingLbl.frame.size.width);
		
		closingLbl.frame = CGRectMake(keyLbl ? keyLbl.frame.origin.x : openingLbl.frame.origin.x, height, closingLbl.frame.size.width, closingLbl.frame.size.height);

		height = closingLbl.frame.origin.y + closingLbl.frame.size.height;
	}
	else
	{
		//
		// Simple key => value type where value is a
		// string, number, or equivalent.
		//

		NSString* valueStr = @"";

		if ( [value isKindOfClass:[NSString class]] ) {
			valueStr = [NSString stringWithFormat:@"\"%@\"", value];
		} else if ( [value isKindOfClass:[NSNumber class]] ) {
			valueStr = [((NSNumber*)value) stringValue];
		}
		else {
			valueStr = [value description];
		}

		if ( !lastValue ) {
			valueStr = [NSString stringWithFormat:@"%@,", valueStr];
		}

		UILabel* valueLbl = [self labelWithText:valueStr color:_generalLabelColor];
		[view addSubview:valueLbl];

		valueLbl.frame = CGRectMake((pointerLbl ? pointerLbl.frame.origin.x + pointerLbl.frame.size.width + keyValueGap : 0), (pointerLbl ? pointerLbl.frame.origin.y : 0), valueLbl.frame.size.width, valueLbl.frame.size.height);

		width = (valueLbl.frame.origin.x + valueLbl.frame.size.width);
		height = MAX(keyLbl.frame.size.height, valueLbl.frame.size.height);
	}

	view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height);

	return view;
}



- (UILabel*) labelWithText:(NSString*)text color:(UIColor*)color
{
	UILabel* lbl = [[UILabel alloc] init];
	lbl.font = [UIFont monospacedDigitSystemFontOfSize:15 weight:UIFontWeightSemibold];
	lbl.textColor = color;
	lbl.text = text;
	lbl.numberOfLines = 0;
	lbl.lineBreakMode = NSLineBreakByWordWrapping;
	
	[lbl sizeToFit];
	if ( lbl.frame.size.width > 300 ) {
		lbl.frame = CGRectMake(lbl.frame.origin.x, lbl.frame.origin.y, 300, lbl.frame.size.height);
	}
	
	return lbl;
}

@end
