Retention Policies
======

A retention policy blocks permanent deletion of content for a specified amount of time. Admins can create retention policies and then later assign them to specific folders or their entire enterprise. To use this feature, you must have the manage retention policies scope enabled for your API key via your application management console.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Create Retention Policy](#create-retention-policy)
- [Update Retention Policy](#update-retention-policy)
- [Get Retention Policy](#get-retention-policy)
- [Get Retention Policies](#get-retention-policies)
- [Create Retention Policy Assignment](#create-retention-policy-assignment)
- [Get Retention Policy Assignment](#get-retention-policy-assignment)
- [Get Retention Policy Assignments](#get-retention-policy-assignments)
- [Delete Retention Policy Assignment](#delete-retention-policy-assignment)
- [Get File Version Retention](#get-file-version-retention)
- [Get File Version Retentions](#get-file-version-retentions) (will be deprecated in the future, use [Get Files Under Retention For Assignment](#get-files-under-retention-for-assignment) and [Get File Version Under Retention For Assignment](#get-file-versions-under-retention-for-assignment) instead)
- [Get Files Under Retention For Assignment](#get-files-under-retention-for-assignment)
- [Get File Version Under Retention For Assignment](#get-file-versions-under-retention-for-assignment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Create Retention Policy

To create a retention policy, call
[`client.retentionPolicy.create(name:type:length:dispositionAction:canOwnerExtendRetention:areOwnersNotified:customNotificationRecipients:retentionType:completion:)`][create-retention-policy].

You can create either a `indefinite` retention policy, or a `finite`.
To create a `indefinite` retention policy, you must set a `type` to `.indefinite` and a `dispositionAction` to `.removeRetention`.

<!-- sample post_retention_policies -->
```swift
client.retentionPolicy.create(
    name: "Test Indefinite Policy Name",
    type: .indefinite,
    dispositionAction: .removeRetention
) { result in
    guard case let .success(retentionPolicy) = result else {
        print("Error creating retention policy")
        return
    }
    
    print("Retention policy: \(retentionPolicy.id) was created")
}
```

To create a `finite` retention policy, you must set `type` to `.finite`,
set amount of time in days to apply the retention policy (`length`) and a `dispositionAction`.
The disposition action can be `.permanentlyDelete` or `.removeRetention`.

```swift
client.retentionPolicy.create(
    name: "Test Finite Policy Name",
    type: .finite,
    length: 60,
    dispositionAction: .permanentlyDelete
) { result in
    guard case let .success(retentionPolicy) = result else {
        print("Error creating retention policy")
        return
    }
    
    print("Retention policy: \(retentionPolicy.id) was created")
}
```

[create-retention-policy]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC6create4name4type6length17dispositionAction014canOwnerExtendC017areOwnersNotified28customNotificationRecipients13retentionType10completionySS_AA0c6PolicyV0OSiSgAA011DispositionK0OSbSgASSayAA4UserCGSgAA0cV0OSgys6ResultOyAA0cX0CAA0A8SDKErrorCGctF

## Update Retention Policy

To update a retention policy, call
[`client.retentionPolicy.update(policyId:name:dispositionAction:status:setRetentionTypeToNonModifiable:length:completion:)`][update-retention-policy].

<!-- sample put_retention_policies_id -->
```swift
client.retentionPolicy.update(policyId: "1234", name: "New Policy Name") { result in
    guard case let .success(retentionPolicy) = result else {
        print("Error updating a retention policy")
        return
    }
    
    print("Updated retention policy: \(retentionPolicy.id)")
}
```

[update-retention-policy]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC6update8policyId4name17dispositionAction6status03setC19TypeToNonModifiable6length10completionySS_SSSgAA011DispositionK0OSgAA0C12PolicyStatusOSgSbSiSgys6ResultOyAA0cU0CAA0A8SDKErrorCGctF

## Get Retention Policy

To retrieve information about a retention policy, call
[`client.retentionPolicy.get(policyId:completion:)`][get-retention-policy] with the ID of the retention policy.

<!-- sample get_retention_policies_id -->
```swift
client.retentionPolicy.get(policyId: "1234") { result  in
    guard case let .success(retentionPolicy) = result else {
        print("Error getting retention policy")
        return
    }

    print("Retention policy: \(retentionPolicy.id)")
}
```

[get-retention-policy]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC3get8policyId10completionySS_ys6ResultOyAA0C6PolicyCAA0A8SDKErrorCGctF

## Get Retention Policies

To retrieve all retention policies for an enterprise, call
[`client.retentionPolicy.list(name:type:createdByUserId:marker:limit:)`][get-retention-policies]. This method will return an iterator, which is used to get the policies. As you can see in the method signature, it is possible to specify filter for the name, type and created user of the retention policy. All of mentioned fields are optional and if not set, all retention policies will be returned. You can also set a number of items per single response by setting a limit. 

<!-- sample get_retention_policies --> 
```swift
let iterator = client.retentionPolicy.list(type: .indefinite)
iterator.next { results in
    switch results {
    case let .success(page):
        for policy in page.entries {
            print("Retention policy \(policy.id)")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

[get-retention-policies]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC4list4name4type15createdByUserId6marker5limitAA14PagingIteratorCyAA0C11PolicyEntryCGSSSg_AA0cQ4TypeOSgA2OSiSgtF

## Create Retention Policy Assignment

To create new retention policy assignment call [`client.retentionPolicy.assign(policyId:assignedContentId:assignContentType:filterFields:completion:)`][create-assignment] method to assign the policy. Retention policy can be assigned to a specific folder, to a metadata template or to the entire enterprise.

<!-- sample post_retention_policy_assignments -->
```swift
client.retentionPolicy.assign(policyId: "12345",  assignedContentId: "1111", assignContentType: .folder) { result in
    guard case let .success(retentionPolicyAssignment) = result else {
        print("Error creating retention policy assignment")
        return
    }
    
    print("Retention policy assignment: \(retentionPolicyAssignment.id) was created")
}
```

[create-assignment]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC6assign8policyId015assignedContentH00fJ4Type12filterFields10completionySS_SSAA0c20PolicyAssignmentItemK0OSayAA19MetadataFieldFilterVGSgys6ResultOyAA0coP0CAA0A8SDKErrorCGctF

## Get Retention Policy Assignment

To retrieve information about a retention policy assignment, call
[`client.retentionPolicy.getAssignment(assignmentId:completion:)`][get-assignment] with the ID of the assignment.

<!-- sample get_retention_policy_assignments_id -->
```swift
client.retentionPolicy.getAssignment(assignmentId: "123456")  { result in
    guard case let .success(retentionPolicyAssignment) = result else {
        print("Error getting retention policy assignment")
        return
    }
    
    print("Retention policy assignment: \(retentionPolicyAssignment.id)")
}
```

[get-assignment]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC13getAssignment12assignmentId10completionySS_ys6ResultOyAA0c6PolicyG0CAA0A8SDKErrorCGctF

## Get Retention Policy Assignments

To get a list of all retention policy assignments associated with a specified retention policy, call
[`client.retentionPolicy.listAssignments(policyId:type:marker:limit:fields)`][get-all-assignments].
This method will return an iterator, which is used to get the assignments.

<!-- sample get_retention_policies_id_assignments -->
```swift
let iterator = client.retentionPolicy.listAssignments(policyId:"12345")
iterator.next { results in
    switch results {
    case let .success(page):
        for assignment in page.entries {
            print("Retention policy assignment\(assignment.id)")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

You can also filter assignments by setting `type` parameter to one of values: `.folder`, `.metadataTemplate` or `.enterprise`:

```swift
let iterator = client.retentionPolicy.listAssignments(policyId:"12345", type: .folder)
iterator.next { results in
    switch results {
    case let .success(page):
        for assignment in page.entries {
            print("Retention policy assignment\(assignment.id)")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

[get-all-assignments]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC15listAssignments8policyId4type6marker5limit6fieldsAA14PagingIteratorCyAA0C16PolicyAssignmentCGSS_AA0cpQ8ItemTypeOSgSSSgSiSgSaySSGSgtF

## Delete Retention Policy Assignment

To remove a retention policy assignment applied to content, call
[`client.retentionPolicy.deleteAssignment(assignmentId:completion:)`][delete-assignment] with the ID of the assignment.

<!-- sample delete_retention_policy_assignments_id -->
```swift
client.retentionPolicy.deleteAssignment(assignmentId: "123456")  { result in
    guard case let .success = result else {
        print("Error deleting retention policy assignment")
        return
    }
    
    print("Retention policy assignment was deleted")
}
```

[delete-assignment]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC16deleteAssignment12assignmentId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

## Get File Version Retention

A file version retention is a record for a retained file version. To get information for a specific file version retention record, call
[`client.files.getVersionRetention(retentionId:completion:)`][get-file-version-retention] with the ID of the file version retention.


<!-- sample get_file_version_retentions_id -->
```swift
client.files.getVersionRetention(retentionId: "123456"){ result in
    guard case let .success(retention) = result else {
        print("Error getting file version retention")
        return
    }
    
    print("File version retention: \(retention.id)")
}
```

[get-file-version-retention]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC19getVersionRetention11retentionId10completionySS_ys6ResultOyAA04FilefG0CAA0A8SDKErrorCGctF

## Get File Version Retentions

To retrieves all file version retentions for the given enterprise, call
[`client.files.listVersionRetentions(fileId:fileVersionId:policyId:dispositionAction:dispositionBefore:dispositionAfter:limit:marker:)`][get-all-file-version-retentions].
This method will return an iterator, which is used to get the file version retentions.

<!-- sample get_file_version_retentions -->
```swift
let iterator = client.files.listVersionRetentions()
iterator.next { results in
    switch results {
    case let .success(page):
        for retention in page.entries {
            print("File version retention \(retention.id)")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

[get-all-file-version-retentions]: https://opensource.box.com/box-ios-sdk/Classes/FilesModule.html#/s:6BoxSDK11FilesModuleC21listVersionRetentions6fileId0hfI006policyI017dispositionAction0K6Before0K5After5limit6markerAA14PagingIteratorCyAA04FileF9RetentionCGSSSg_A2rA011DispositionL0OSg10Foundation4DateVSgAYSiSgARtF

## Get Files Under Retention For Assignment

To get all files under retention for assignment
policy, call the [`client.retentionPolicy.listFilesUnderRetentionForAssignment(retentionPolicyAssignmentId:limit:marker:)`][get-files-under-retention-for-assignment] method.
This method will return an iterator, which is used to get the [`File`][file] objects under retention.

<!-- sample get_retention_policy_assignments_id_files_under_retention -->
```swift
let iterator = client.retentionPolicy.listFilesUnderRetentionForAssignment(retentionPolicyAssignmentId: "123456")
iterator.next { results in
    switch results {
    case let .success(page):
        for file in page.entries {
            print("File \(file.name ?? "")")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

[get-files-under-retention-for-assignment]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC014listFilesUnderC13ForAssignment015retentionPolicyJ2Id5limit6markerAA14PagingIteratorCyAA4FileCGSS_SiSgSSSgtF
[file]: https://opensource.box.com/box-ios-sdk/Classes/File.html

Get File Versions Under Retention For Assignment
------------------------------------------------

To get all file versions under retention placed in the file objects for a retention policy assignment, call the 
[`client.retentionPolicy.listFileVersionsUnderRetentionForAssignment(retentionPolicyAssignmentId:limit:marker:)`][get-file-versions-under-retention-for-assignment] method.
This method will return an iterator, which is used to get the [`FileVersion`][file-version] object nested in [`File`][file] object.


<!-- sample get_retention_policy_assignments_id_file_versions_under_retention -->
```swift
let iterator = client.retentionPolicy.listFileVersionsUnderRetentionForAssignment(retentionPolicyAssignmentId: "123456")
iterator.next { results in
    switch results {
    case let .success(page):
        for file in page.entries {
            print("File version \(file.fileVersion?.id ?? "")")
        }
        
    case let .failure(error):
        print(error)
    }
}
```

[get-file-versions-under-retention-for-assignment]: https://opensource.box.com/box-ios-sdk/Classes/RetentionPoliciesModule.html#/s:6BoxSDK23RetentionPoliciesModuleC021listFileVersionsUnderC13ForAssignment015retentionPolicyK2Id5limit6markerAA14PagingIteratorCyAA0G0CGSS_SiSgSSSgtF
[file-version]: https://opensource.box.com/box-ios-sdk/Classes/FileVersion.html
[file]: https://opensource.box.com/box-ios-sdk/Classes/File.html