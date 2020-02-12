Storage Policies
=======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Storage Policy Info](#get-storage-policy-info)
- [Get Storage Policies](#get-storage-policies)
- [Get Storage Policy Assignment Info](#get-storage-policy-assignment-info)
- [Get Storage Policy Assignments](#get-storage-policy-assignments)
- [Create Storage Policy Assignment](#create-storage-policy-assignment)
- [Assign Storage Policy](#assign-storage-policy)
- [Update Storage Policy Assignment](#update-storage-policy-assignment)
- [Delete Storage Policy Assignment](#delete-storage-policy-assignment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Storage Policy Info
---------------

To retrieve information about a storage policy, call
[`client.storagePolicies.get(storagePolicyId: String, fields: [String]?, completion: @escaping Callback<StoragePolicy>)`][get-storage-policy-info]
with the ID of the storage policy.  You can control which fields are returned in the resulting `Storage Policy` object by passing the
`fields` parameter.

<!-- sample get_storage_policies_id -->   
```swift
client.storagePolicies.get(storagePolicyId: "22222") { (result: Result<StoragePolicy, BoxSDKError>) in
    guard case let .success(policy) = result else {
        print("Error getting storage policy")
        return
    }
    print("Policy ID is \(policy.id)")
}
```

[get-storage-policy-info]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC3get15storagePolicyId6fields10completionySS_SaySSGSgys6ResultOyAA0cH0CAA0A8SDKErrorCGctF

Get Storage Policies
--------------------

To retrieve the storage policies in an enterprise, call
[`client.storagePolicies.list(marker: String?, limit: Int?, fields: [String]?)`][get-storage-policies].  This method will return an iterator in the completion, which is used to get the policies.

<!-- sample get_storage_policies -->   
```swift
client.storagePolicies.list() { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(policy):
                    print("Storage policy \(policy.id)")
                case let .failure(error):
                    print(error)
                }
            }
        }
    case let .failure(error):
        print(error)
    }
}
```

[get-storage-policies]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC17listForEnterprise6marker5limit6fields10completionySSSg_SiSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0C6PolicyCGAA0A8SDKErrorCGctF

Get Storage Policy Assignment Info
----------------------------------

To get storage policy assignment, call
[`client.storagePolicies.getAssignment(storagePolicyAssignmentId: String, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][get-storage-policy-assignment-info]
with the id of a storage policy assignment.

<!-- sample get_storage_policy_assignments_id -->   
```swift
client.storagePolicy.getAssignment(storagePolicyAssignmentId: "1234") { (result: Result<StoragePolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error getting storage policy assignment")
        return
    }
    print("Storage policy assignment ID \(assignment.id)")
}
```
[get-storage-policy-assignment-info]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC13getAssignment013storagePolicyG2Id6fields10completionySS_SaySSGSgys6ResultOyAA0ciG0CAA0A8SDKErrorCGctF

Get Storage Policy Assignments
------------------------------

To get storage policy assignments for a user or enterprise, call
[`client.storagePolicies.listAssignments(resolvedForType: String, resolvedForId: String, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][get-storage-policy-assignments]. This always returns a single storage policy assignment.

<!-- sample get_storage_policy_assignments -->   
```swift
client.storagePolicy.listAssignments(resolvedForType: "user", resolvedForId: "1234") { (result: Result<StoragePolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error getting storage policy assignment")
        return
    }
    print("Storage policy assignment for user \(assignment.assignedTo?.id) is \(assignment.id)")
}
```

[get-storage-policy-assignments]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC15listAssignments15resolvedForType0hI2Id6fields10completionySS_SSSaySSGSgys6ResultOyAA0C16PolicyAssignmentCAA0A8SDKErrorCGctF

Assign Storage Policy
--------------------------------

To assign a storage policy, call
[`client.storagePolicies.assign(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][assign-storage-policy].

<!-- sample post_storage_policy_assignments -->   
```swift
client.storagePolicy.assign(storagePolicyId: "1234", assignedToType: "user", assignedToId: "123") { (result: Result<StoragePolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error assigning a storage policy")
        return
    }
    print("Created storage policy assignment ID is \(assignment.id). The ID of the user it is assigned to \(assignment.assignedTo?.id)")
}
```

[assign-storage-policy]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC6assign15storagePolicyId14assignedToType0jkI06fields10completionySS_S2SSaySSGSgys6ResultOyAA0cH10AssignmentCAA0A8SDKErrorCGctF

Force Assign Storage Policy
---------------------

To assign a storage policy, call
[`client.storagePolicies.forceAssign(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][force-assign-storage-policy]. The difference between this call and the createPolicyAssignment() above is that this method will guarantee an update to the assignee's policy. If an assignee already has a policy assigned to it, the createPolicyAssignment() will return a 409 Conflict error. assignPolicy() will instead make an additional updatePolicyAssignment() call to replace the existing policy with the new policy for a policy assignment.

<!-- sample post_storage_policy_assignments force -->   
```swift
client.storagePolicy.forceAssign(storagePolicyId: "1234", assignedToType: "user", assignedToId: "123") { (result: Result<StoragePolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error assigning a storage policy")
        return
    }
    print("Created storage policy assignment ID is \(assignment.id). The ID of the user it is assigned to \(assignment.assignedTo?.id)")
}
```

[force-assign-storage-policy]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC11forceAssign15storagePolicyId14assignedToType0klJ06fields10completionySS_S2SSaySSGSgys6ResultOyAA0cI10AssignmentCAA0A8SDKErrorCGctF

Update Storage Policy Assignment
--------------------------------

To update storage policy assignment, call
[`client.storagePolicies.updateAssignment(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][update-storage-policy-assignment].

<!-- sample put_storage_policy_assignments_id -->   
```swift
client.storagePolicy.updateAssignment(storagePolicyAssignmentId: "1234", storagePolicyId: "123") { (result: Result<StoragePolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error updating a storage policy assignment")
        return
    }
    print("Updated storage policy assignment \(assignment.id)")
}
```

[update-storage-policy-assignment]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC16updateAssignment013storagePolicyG2Id0hiJ06fields10completionySS_SSSgSaySSGSgys6ResultOyAA0ciG0CAA0A8SDKErrorCGctF

Delete Storage Policy Assignment
--------------------------------

To delete a storage policy assignment, call
[`client.folders.deleteAssignment(storagePolicyAssignmentId: String, completion: @escaping Callback<Void>`][delete-storage-policy-assignment]
with the ID of the storage policy to delete.

<!-- sample delete_storage_policy_assignments_id -->   
```swift
client.storagePolicies.deleteAssignment(storagePolicyAssignmentId: "22222") { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting storage policy assignment")
        return
    }
    print("Storage policy assignment is successfully deleted.")
}
```

[delete-storage-policy-assignment]: https://opensource.box.com/box-ios-sdk/Classes/StoragePoliciesModule.html#/s:6BoxSDK21StoragePoliciesModuleC16deleteAssignment013storagePolicyG2Id10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF