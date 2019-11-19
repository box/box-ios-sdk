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

```swift
client.storagePolicies.get(storagePolicyId: "22222") { (result: Result<StoragePolicy, BoxError>) in
    guard case let .success(policy) = result else {
        print("Error getting storage policy")
        return
    }
    print("Policy ID is \(policy.id)")
}
```

Get Storage Policies
--------------------

To retrieve the storage policies in an enterprise, call
[`client.storagePolicies.list(marker: String?, limit: Int?, fields: [String]?)`][get-storage-policies].  This method will return an iterator object you can use to retrieve successive pages of
results, where each page contains some of the policies in the enterprise.

```swift
let storagePolicies = client.storagePolicies.list()
// Get the first page of storage policies
storagePolicies.nextPage() { (result: Result<[StoragePolicy], BoxError>) in
    guard case let .success(policies) = result else {
        print("Error getting storage policies")
        return
    }
    // Print out first page of storage policies in the enterprise
    for policy in policies {
        print("Storage policy \(policy.id)")
    }
}
```

Get Storage Policy Assignment Info
----------------------------------

To get storage policy assignment, call
[`client.storagePolicies.getAssignment(storagePolicyAssignmentId: String, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][get-storage-policy-assignment-info]
with the id of a storage policy assignment.

```swift
client.storagePolicy.getAssignment(storagePolicyAssignmentId: "1234") { (result: Result<StoragePolicyAssignment, BoxError>) in
    guard case let .success(assignment) = result else {
        print("Error getting storage policy assignment")
        return
    }
    print("Storage policy assignment ID \(assignment.id)")
}
```
Get Storage Policy Assignments
------------------------------

To get storage policy assignments for a user or enterprise, call
[`client.storagePolicies.listAssignments(resolvedForType: String, resolvedForId: String, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][get-storage-policy-assignments]. This always returns a single storage policy assignment.

```swift
client.storagePolicy.listAssignments(resolvedForType: "user", resolvedForId: "1234") { (result: Result<StoragePolicyAssignment, BoxError>) in
    guard case let .success(assignment) = result else {
        print("Error getting storage policy assignment")
        return
    }
    print("Storage policy assignment for user \(assignment.assignedTo?.id) is \(assignment.id)")
}
```

Create Storage Policy Assignment
--------------------------------

To assign a storage policy, call
[`client.storagePolicies.assign(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][storage-policy-assignment].

```swift
client.storagePolicy.assign(storagePolicyId: "1234", assignedToType: "user", assignedToId: "123") { (result: Result<StoragePolicyAssignment, BoxError>) in
    guard case let .success(assignment) = result else {
        print("Error assigning a storage policy")
        return
    }
    print("Created storage policy assignment ID is \(assignment.id). The ID of the user it is assigned to \(assignment.assignedTo?.id)")
}
```

Assign Storage Policy
---------------------

To assign a storage policy, call
[`client.storagePolicies.forceAssign(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][assign-storage-policy]. The difference between this call and the createPolicyAssignment() above is that this method will guarantee an update to the assignee's policy. If an assignee already has a policy assigned to it, the createPolicyAssignment() will return a 409 Conflict error. assignPolicy() will instead make an additional updatePolicyAssignment() call to replace the existing policy with the new policy for a policy assignment.

```swift
client.storagePolicy.forceAssign(storagePolicyId: "1234", assignedToType: "user", assignedToId: "123") { (result: Result<StoragePolicyAssignment, BoxError>) in
    guard case let .success(assignment) = result else {
        print("Error assigning a storage policy")
        return
    }
    print("Created storage policy assignment ID is \(assignment.id). The ID of the user it is assigned to \(assignment.assignedTo?.id)")
}
```

Update Storage Policy Assignment
--------------------------------

To update storage policy assignment, call
[`client.storagePolicies.updateAssignment(storagePolicyId: String, assignedToType: String, assignedToId, fields: [String]?, completion: @escaping Callback<StoragePolicyAssignment>`][update-storage-policy-assignment].

```swift
client.storagePolicy.updateAssignment(storagePolicyAssignmentId: "1234", storagePolicyId: "123") { (result: Result<StoragePolicyAssignment, BoxError>) in
    guard case let .success(assignment) = result else {
        print("Error updating a storage policy assignment")
        return
    }
    print("Updated storage policy assignment \(assignment.id)")
}
```

Delete Storage Policy Assignment
--------------------------------

To delete a storage policy assignment, call
[`client.folders.deleteAssignment(storagePolicyAssignmentId: String, completion: @escaping Callback<Void>`][delete-storage-policy-assignment]
with the ID of the storage policy to delete.

```swift
client.storagePolicies.deleteAssignment(storagePolicyAssignmentId: "22222") { result: Result<Void, BoxError>} in
    guard case .success = result else {
        print("Error deleting storage policy assignment")
        return
    }
    print("Storage policy assignment is successfully deleted.")
}
```