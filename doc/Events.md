Events
======

Get Events for the Current User
-------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXEventsRequest *eventsRequest = [contentClient eventsRequestForCurrentUser];

// See API documentation for configuring stream position and stream type:
// https://developers.box.com/docs/#events
eventsRequest.streamType = BOXEventsStreamTypeAll;
eventsRequest.streamPosition = @"0";

[eventsRequest performRequestWithCompletion:^(NSArray *events, NSString *nextStreamPosition, NSError *error) {
	// If successful, events will be non-nil; otherwise, error will be non-nil.
	// You will likely want to use nextStreamPosition for your next request.
}];
```
