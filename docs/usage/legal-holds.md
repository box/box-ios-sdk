Legal Holds
=======

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Get Legal Hold Policy Info](#get-legal-hold-policy-info)
- [Create Legal Hold Policy](#create-legal-hold-policy)
- [Update Legal Hold Policy](#update-legal-hold-policy)
- [Delete Legal Hold Policy](#delete-legal-hold-policy)
- [Get Legal Hold Policies](#get-legal-hold-policies)
- [Get Policy Assignment Info](#get-policy-assignment-info)
- [Create Policy Assignment](#create-policy-assignment)
- [Delete Policy Assignment](#delete-policy-assignment)
- [Get Policy Assignments](#get-policy-assignments)
- [Get File Version Legal Hold Info](#get-file-version-legal-hold-info)
- [Get File Version Legal Holds](#get-file-version-legal-holds)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Legal Hold Policy Info
---------------

To retrieve information about a legal hold policy, call
[`client.legalHolds.get(policyId: String, fields: [String]?, completion: @escaping Callback<LegalHoldPolicy>)`][get-legal-hold-policy-info]
with the ID of the policy.  You can control which fields are returned in the resulting `Legal Hold Policy` object by passing the
`fields` parameter.

<!-- sample get_legal_hold_policies_id -->
```swift
client.legalHolds.get(policyId: "22222", fields: ["name", "created_at"]) { (result: Result<LegalHoldPolicy, BoxSDKError>) in
    guard case let .success(policy) = result else {
        print("Error getting policy information")
        return
    }
    print("Legal hold policy \(policy.id) was created at \(policy.createdAt)")
}
```

[get-legal-hold-policy-info]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC3get8policyId6fields10completionySS_SaySSGSgys6ResultOyAA0C10HoldPolicyCAA0A8SDKErrorCGctF

Get Legal Hold Policies
----------------

To retrieve information about the items contained in a folder, call
[`client.legalHolds.listForEnterprise(policyName: String, marker: String?, limit: Int?, fields: [String]?)`][get-legal-hold-policies]
with the ID of the policy.  This method will return an iterator object in the completion, which is used to retrieve policies in the enterprise.

<!-- sample get_legal_hold_policies -->
```swift
client.legalHolds.listForEnterprise(policyName: "policy1") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(policy):
                    print("Legal hold policy \(policy.name)")
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

[get-legal-hold-policies]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC17listForEnterprise10policyName6marker5limit6fields10completionySSSg_AJSiSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0C10HoldPolicyCGAA0A8SDKErrorCGctF

Create Legal Hold Policy
-------------

To create a new legal hold policy, call
[`client.legalHolds.create(policyName: String, description: String? filterStartedAt: Date?, filterEndedAt: Date?, isOngoing: Bool?, fields: [String]?, completion: @escaping Callback<LegalHoldPolicy>`][create-legal-hold-policy]
with a name for the legal hold policy.

<!-- sample post_legal_hold_policies -->
```swift
client.legalHolds.create(name: "New Folder") { (result: Result<LegalHoldPolicy, BoxSDKError>) in
    guard case let .success(policy) = result else {
        print("Error creating legal hold policy")
        return
    }
    print("Created legal hold policy \"\(policy.name)\"")
}
```

[create-legal-hold-policy]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC6create10policyName11description15filterStartedAt0j5EndedL09isOngoing6fields10completionySS_SSSg10Foundation4DateVSgAPSbSgSaySSGSgys6ResultOyAA0C10HoldPolicyCAA0A8SDKErrorCGctF

Update Legal Hold Policy
-------------

To update legal hold policy, call
[`client.legalHolds.update(policyId: String, policyName: String?, description: String?, releaseNotes: String?, fields: [String]?, completion: @escaping Callback<LegalHoldPolicy>`][update-legal-hold-policy].

<!-- sample put_legal_hold_policies_id -->
```swift
client.legalHolds.update(policyId: "1234", policyName: "New Name") { (result: Result<LegalHoldPolicy, BoxSDKError>) in
    guard case let .success(policy) = result else {
        print("Error updating legal hold policy")
        return
    }
    print("Updated legal hold policy name is \"\(policy.name)\"")
}
```

[update-legal-hold-policy]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC6update8policyId0G4Name11description12releaseNotes6fields10completionySS_SSSgA2KSaySSGSgys6ResultOyAA0C10HoldPolicyCAA0A8SDKErrorCGctF

Delete Legal Hold Policy
-------------

To delete a legal hold policy, call
[`client.folders.delete(policyId: String, completion: @escaping Callback<Void>`][delete-legal-hold-policy]
with the ID of the legal hold policy to delete.

<!-- sample delete_legal_hold_policies_id -->
```swift
client.legalHolds.delete() { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting legal hold policy")
        return
    }
    print("Legal hold policy successfully deleted")
}
```

[delete-legal-hold-policy]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC6delete8policyId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Get Policy Assignment Info
---------------

To retrieve information about a legal hold policy assignment, call
[`client.legalHolds.getPolicyAssignment(assignmentId: String, fields: [String]?, completion: @escaping Callback<LegalHoldPolicyAssignment>)`][get-policy-assignment-info]
with the ID of the policy assignment.  You can control which fields are returned in the resulting `Legal Hold Policy Assignment` object by passing the
`fields` parameter.

<!-- sample get_legal_hold_policy_assignments_id -->
```swift
client.legalHolds.getPolicyAssignment(assignmentId: "22222", fields: ["assigned_at"]) { (result: Result<LegalHoldPolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error getting policy assignment info")
        return
    }
    print("Legal hold policy assignment \(assignmnent.id) was created at \(assignment.assignedAt)")
}
```

[get-policy-assignment-info]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC19getPolicyAssignment12assignmentId6fields10completionySS_SaySSGSgys6ResultOyAA0c4HoldgH0CAA0A8SDKErrorCGctF

Get Policy Assignments
----------------

To retrieve legal hold policy assignments, call
[`client.legalHolds.listPolicyAssignments(policyId: String, assignToType: String?, assignToId: String?, marker: String?, limit: String?, fields: [String]?)`][get-policy-assignments]
with the ID of a policy.  This method will return an iterator object in the completion, which is used to retrieve policy assignments for a policy.

<!-- sample get_legal_hold_policy_assignments -->
```swift
client.legalHolds.listPolicyAssignments(policyId: "1234") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(assignment):
                    print("Policy Assignment \(assignment.id)")
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

[get-policy-assignments]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC21listPolicyAssignments8policyId12assignToType0klJ06marker5limit6fields10completionySS_SSSgA2LSiSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0c4HoldG10AssignmentCGAA0A8SDKErrorCGctF

Assign Policy
-------------

To assign a legal hold policy, call
[`client.legalHolds.forceApply(policyId: String, assignToId: String, assignToType: String, fields: [String]?, completion: @escaping Callback<LegalHoldPolicyAssignment>`][assign-policy]
with an ID of a policy, an ID of a file, file version, folder, or user and the type of the box item that the policy is being assigned to.

<!-- sample post_legal_hold_policy_assignments -->
```swift
client.legalHolds.forceApply(policyId: "1234", assignToId: "4568" ,assignToType: "file") { (result: Result<LegalHoldPolicyAssignment, BoxSDKError>) in
    guard case let .success(assignment) = result else {
        print("Error assigning legal hold policy")
        return
    }
    print("Assigned a legal hold policy at \"\(assignment.assignedAt)\"")
}
```

[assign-policy]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC12assignPolicy8policyId0f2ToI00fJ4Type6fields10completionySS_S2SSaySSGSgys6ResultOyAA0c4HoldG10AssignmentCAA0A8SDKErrorCGctF

Delete Policy Assignment
-------------

To delete a legal hold policy assignment, call
[`client.legalHolds.deletePolicyAssignment(policyId: String, completion: @escaping Callback<Void>`][delete-policy-assignment]
with the ID of the policy assignment to delete.

<!-- sample delete_legal_hold_policy_assignments_id -->
```swift
client.legalHolds.deletePolicyAssignment(assignmentId: "1234") { result: Result<Void, BoxSDKError>} in
    guard case .success = result else {
        print("Error deleting legal hold policy assignment")
        return
    }
    print("Legal hold policy assignment successfully deleted")
}
```

[delete-policy-assignment]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC22deletePolicyAssignment12assignmentId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Get File Version Legal Hold Info
---------------

To retrieve information about a file version legal hold, call
[`client.legalHolds.getFileVersionPolicy(legalHoldId: String, fields: [String]?, completion: @escaping Callback<FileVersionLegalHold>)`][get-file-version-legal-hold-info]
with the ID of legal hold.  You can control which fields are returned in the resulting `File Version Legal Hold` object by passing the
`fields` parameter.

<!-- sample get_file_version_legal_holds_id -->
```swift
client.legalHolds.getFileVersionPolicy(legalHoldId: "22222") { (result: Result<FileVersionLegalHold, BoxSDKError>) in
    guard case let .success(legalHold) = result else {
        print("Error getting file version legal hold")
        return
    }
    print("File version legal hold ID is \(legalHold.id)")
}
```

[get-file-version-legal-hold-info]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC20getFileVersionPolicy11legalHoldId6fields10completionySS_SaySSGSgys6ResultOyAA0ghcK0CAA0A8SDKErrorCGctF

Get File Version Legal Holds
----------------

To retrieve all of the non-deleted legal holds for a single legal hold policy, call
[`client.legalHolds.listFileVersionPolicies(policyId: String, marker: String?, limit: String?, fields: [String]?)`][get-file-version-legal-holds]
with the ID of a policy.  This method will return an iterator object in the completion, which is used to retrieve legal holds for a policy.

<!-- sample get_file_version_legal_holds -->
```swift
client.legalHolds.listFileVersionPolicies(policyId: "1234") {
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(hold):
                    print("Legal hold \(hold.id)")
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

[get-file-version-legal-holds]: https://opensource.box.com/box-ios-sdk/Classes/LegalHoldsModule.html#/s:6BoxSDK16LegalHoldsModuleC23listFileVersionPolicies8policyId6marker5limit6fields10completionySS_SSSgSiSgSaySSGSgys6ResultOyAA14PagingIteratorCyAA0ghC4HoldCGAA0A8SDKErrorCGctF