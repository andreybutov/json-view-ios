# JSONView for iOS

An iOS control to display JSON and/or NSDictionary data in a friendly format.

## Installation

Just drop the source files into your project.

## Usage Example

The following code, placed in the `viewDidLoad` method of a `UIViewController`, displays the *JSONView* that is in the screenshot below.

```objective-c
// sample json
NSString* jsonString =
    @"{"
        "\"id\":12345,"
        "\"company\":\"ACME\","
        "\"departments\":[\"Marketing\", \"Development\", \"Sales\"],"
        "\"founder\":{"
            "\"name\" : {"
                "\"first\" : \"John\","
                "\"last\" : \"Doe\","
            "},"
            "\"email\" : \"johndoe@acme.com\""
        "}"
    "}"
    ;

// parse the json string into a dictionary
NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:
    [jsonString
        dataUsingEncoding:NSUTF8StringEncoding]
        options:NSJSONReadingMutableContainers
        error:nil];

// initialize a JSONView, giving it the JSON data dictionary
JSONView* jsonView = [[JSONView alloc] initWithData:jsonData];

// optional
jsonView.layer.borderColor = [self colorWithHexString:@"808080"].CGColor;
jsonView.layer.borderWidth = 1.0f;

[self.view addSubview:jsonView];

// you provide the width constraints, but the JSONView will set its own height
[jsonView performLayoutWithWidth:self.view.frame.size.width - 40];

// set the position
[jsonView setFrame:CGRectMake(20, 100, jsonView.frame.size.width, jsonView.frame.size.height)];
```

### Special thanks!

I originally wrote this control as part of the implementation of the [Honeybadger](https://www.honeybadger.io/) iOS app. This open-source port of the control is made available with permission.
