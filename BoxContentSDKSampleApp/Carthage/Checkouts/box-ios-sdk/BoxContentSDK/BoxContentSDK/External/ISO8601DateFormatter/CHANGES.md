Several changes to ISO8601DateFormatter were made to incorporate it into BoxContentSDK:

* typedefs, constants, and classes had their names prefixed with "BOX".
* `#define`s had their names prefixed with "BOX_".
* `dateFromString:timeZone:range:` was changed to return nil if an invalid
  date string is given.
* All property definitions were changed to explicitly include `nonatomic` and `readwrite`.
* Bugfix for an issue where formatting a date with a timestamp would use the default timzone
  instead of the given timezone.
* Replaced the iOS 8 deprecated NSGregorianCalendar with NSCalendarIdentifierGregorian

**NOTE**: The library is still not compiled with ARC.

