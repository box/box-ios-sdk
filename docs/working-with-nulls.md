# Handling null values in Box Swift SDK Gen

While using Box Swift SDK it's important to understand how null values behave. This document provides a general overview of null value behaviour in Box Swift SDK to help developers manage data consistently and predictably.

## Understanding null behaviour

The Box Swift SDK follows a consistent pattern for handling null values in update operations.
This behavior applies to most endpoints that modify resources such as users, files, folders, and metadata.
Fields to be updated are wrapped in a `TriStateField` within the initializer. This allows you to specify whether a field should be sent with a value, sent explicitly as null, or omitted entirely.

### Send field with some value

Since these fields are wrapped in the `TriStateField<T>` enum (where `T` is the original type of the property), you can set them using the .value case, like `.value(yourActualValue)`.
If the original type is a value type such as `String`, `Int`, or `Bool`, you can also assign the value directly without wrapping it in the enum, this will be handled automatically for you.

Let’s take a look at the `RetentionPolicyAssignmentFilterFieldsField` class, whose initializer looks like this:

```swift
public init(field: TriStateField<String> = nil, value: TriStateField<String> = nil) { ...}
```

To initialize an instance of `RetentionPolicyAssignmentFilterFieldsField` with some values, you can do it in two ways:

```swift
let filterField = RetentionPolicyAssignmentFilterFieldsField(field: .value("my_field_name"), value: "my actual value")
```

In the example above, we set two parameters: field and value, using different methods. The field is set with the `.value(..)` case, while value, being a `String` type, is provided directly without wrapping it in the enum.
By filling in these fields, both will be included in the request.

### Send field with null

In some APIs, the `null` value has a different meaning than simply omitting the field.
Setting a field to `null` will remove its current value or disassociate it from the resource on the server side.
This is the reason we use the `TriStateField` enum, which allows you to explicitly set a field to `null`.

To set a field to `null`, you should use the `.null` case of the `TriStateField` enum. This will be translated to `null` in the request body.

### Omit the field

If you want to omit a field, there are three ways to achieve that:

- Omitting the field in the initializer
- Setting it to `nil`
- Setting it to `.unset`

Any of these options will result in the field being omitted from the request body.
For consistency with other cases where fields are optional, setting these fields to nil will be treated the same as omitting them.

## Example Usage

The client.files.createUpdateFile() method demonstrates null handling when modifying the lock field while updating the file:

```c#
public func createUpdateFile(client: BoxClient) async throws {
    let fileId = "12345"

    // Locking the file using .value() wrapper
    let fileWithLock = try await client.files.updateFileById(
        fileId: fileId,
        requestBody: UpdateFileByIdRequestBody(lock: .value(UpdateFileByIdRequestBodyLockField(access: .lock))),
        queryParams: UpdateFileByIdQueryParams(fields: ["lock"])
    )

    // Unlocking the file using the `.null`
    let fileWithoutLock = try await client.files.updateFileById(
        fileId: fileId,
        requestBody: UpdateFileByIdRequestBody(lock: .null),
        queryParams: UpdateFileByIdQueryParams(fields: ["lock"])
    )
}
```

## Summary

To summarize, if you omit the field, set it to `nil`, or set it to `.unset`, the field remains unchanged.
If you set it to `.null`, it clears or removes the value.
If you provide a value by wrapping it in `.value(your_value)`, the field is updated to that specified value.
