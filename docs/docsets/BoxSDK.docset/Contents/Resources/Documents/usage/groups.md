Groups
======

Groups contain a set of users and can be used in place of users in some operations such as collaborations.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


  - [Create Group](#create-group)
  - [Update Group](#update-group)
  - [Get Group Info](#get-group-info)
  - [Get Enterprise Groups](#get-enterprise-groups)
  - [Delete Group](#delete-group)
- [Group Membership](#group-membership)
  - [Get Group Membership Info](#get-group-membership-info)
  - [Create Group Membership](#create-group-membership)
  - [Update Group Membership](#update-group-membership)
  - [Delete Group Membership](#delete-group-membership)
  - [Get Memberships for Group](#get-memberships-for-group)
  - [Get Memberships for User](#get-memberships-for-user)
  - [Get Collaborations for Group](#get-collaborations-for-group)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Create Group
------------

To create a new group, call [`client.groups.create(name: String, provenance: String?, externalSyncIdentifier: String?, description: String?, invitabilityLevel: GroupInvitabilityLevel?, memberViewabilityLevel: GroupMemberViewabilityLevel, fields: [String]?, completion: @escaping Callback<Group>)`][create_group] with the name of the group you wish to create. You can control which fields are returned in the resulting `Group` object by passing the `fields` parameter.

<!-- sample post_groups -->
```swift
 client.groups.create(name: "Team A", provenance: "Test", externalSyncIdentifier: "Test Sync", description: "Test Description", invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { (result: Result<Group, BoxSDKError>) in
    guard case let .success(group) = result else {
        print("Error creating new group")
        return
    }

    print("Group \(group.name) was created")
 }
```

[create-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC6create4name10provenance22externalSyncIdentifier11description17invitabilityLevel017memberViewabilityM06fields10completionySS_SSSgA2mA017GroupInvitabilityM0OSgAA0r6MemberoM0OSgSaySSGSgys6ResultOyAA0R0CAA0A8SDKErrorCGctF

Update Group
------------

To update an existing group, call [`client.groups.update(groupId: String, name: String?, provenance: NullableParameter<String>?, externalSyncIdentifier: NullableParameter<String>?, description: NullableParameter<String>?, invitabilityLevel: GroupInvitabilityLevel?, memberViewabilityLevel: GroupMemberViewabilityLevel?, fields: [String]?, completion: @escaping Callback<Group>)`][update-group] with the ID of the group. You can control which fields are returned in the resulting `Group` object by passing the
`fields` parameter.

<!-- sample put_groups_id -->
```swift
client.groups.update(groupId: "11111", name: "Team A", provenance: .value("Test"), externalSyncIdentifier: .value("Test Sync"), description: .value("Test Description"), invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { 
(result: Result<Group, BoxSDKError>) in
    guard case let .success(group) = result else {
        print("Error updating the group")
        return
    }

    print("Group \(group.name) was updated with description: \(group.description)")

}
```

[update-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC6update7groupId4name10provenance22externalSyncIdentifier11description17invitabilityLevel017memberViewabilityO06fields10completionySS_SSSgAA17NullableParameterOySSGSgA2rA017GroupInvitabilityO0OSgAA0v6MemberqO0OSgSaySSGSgys6ResultOyAA0V0CAA0A8SDKErrorCGctF

Get Group Info
--------------

To retrieve information about a group, call [`client.groups.get(groupId: String, fields: [String]?, completion: @escaping Callback<Group>)`][get-group] with the ID of the group. You can control which fields are returned in the resulting `Group` object by passing the `fields` parameter.

<!-- sample get_groups_id -->
```swift
client.groups.get(groupId: "12345") {
(result: Result<Group, BoxSDKError>) in
    guard case let .success(group) = result else {
        print("Error getting group information")
        return
    }

    print("Group with name \(group.name) was retrieved.")
}
```

[get-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC3get7groupId6fields10completionySS_SaySSGSgys6ResultOyAA5GroupCAA0A8SDKErrorCGctF

Get Enterprise Groups
---------------------

To retrieve information about the groups within the enterprise, call [`client.groups.listForEnterprise(name: String?, offset: Int?, limit: Int?, fields: [String]?)`][get-enterprise-groups]. You can also pass in a `name` paramter to act as a filter. This method will return an iterator object in the completion, which is used to retrieve groups in the enterprise.

<!-- sample get_groups -->
```swift
client.groups.listForEnterprise() { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(group):
                    print("Group with name \(group.name) retrieved")
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

[get-enterprise-groups]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC17listForEnterprise4name6offset5limit6fields10completionySSSg_SiSgAKSaySSGSgys6ResultOyAA14PagingIteratorCyAA5GroupCGAA0A8SDKErrorCGctF

Delete Group
------------

To delete a group, call [`client.groups.delete(groupId: String, completion: @escaping Callback<Void>)`][delete-group] with the ID of the group to delete.

<!-- sample delete_groups_id -->
```swift
client.groups.delete(groupId: "12345") { 
(result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error deleting group")
        return
    }

    print("Group was successfully deleted.")
}
```

[delete-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC6delete7groupId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Group Membership
================

Get Group Membership Info
-------------------------

To retrieve information about a specified group membership, call [`client.groups.getMembershipInfo(membershipId: String, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][get-membership-info] with the ID of the group membership. You can control which fields are returned on the resulting `Group Membership` object by passing the desired field names in the optional `fields` parameter.

<!-- sample get_group_memberships_id -->
```swift
client.groups.getMembershipInfo(membershipId: "12345") { 
(result: Result<GroupMembership, BoxSDKError>) in
    guard case let .success(membership) = result else {
        print("Error retrieving group membership information")
        return
    }

    print("Group Membership for group \(membership.group?.name) was retrieved")
}
```

[get-membership-info]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC17getMembershipInfo12membershipId6fields10completionySS_SaySSGSgys6ResultOyAA05GroupF0CAA0A8SDKErrorCGctF

Create Group Membership
-----------------------

To create a new group membership, call [`client.groups.createMembership(userId: String, groupId: String, role: GroupRole?, configurablePermission: NullableParameter<ConfigurablePermissionData>?, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][create-membership]. You can control which fields are returned on the resulting `Group Membership` object by passing the desired field names in the optional `fields` parameter.

<!-- sample post_group_memberships -->
```swift
client.createMembership(userId: "54321", groupId: "11111", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { 
(result: Result<GroupMembership, BoxSDKError>) in
    guard case let .success(membership) = result else {
        print("Error creating group membership")
        return
    }

    print("Group membership for group \(membership.group?.name) was created")
}
```

[create-membership]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC16createMembership6userId05groupH04role22configurablePermission6fields10completionySS_SSAA9GroupRoleOSgAA17NullableParameterOyAA012ConfigurableL4DataVGSgSaySSGSgys6ResultOyAA0oF0CAA0A8SDKErrorCGctF

Update Group Membership
-----------------------

To update an existing group membership, call [`client.groups.updateMembership(membershipId: String, role: GroupRole?, configurablePermission: NullableParameter<ConfigurablePermissionData>?, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][update-membership] with the ID of the group membership to update.

<!-- sample put_group_memberships_id -->
```swift
client.groups.updateMembership(membershipId: "12345", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { 
(result: Result<GroupMembership, BoxSDKError>) in
    guard case let .success(membership) = result else {
        print("Error updating group membership")
        return
    }

    print("Group membership with ID \(membership.id) was updated")
}
```

[update-membership]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC16updateMembership12membershipId4role22configurablePermission6fields10completionySS_AA9GroupRoleOSgAA17NullableParameterOyAA012ConfigurableK4DataVGSgSaySSGSgys6ResultOyAA0nF0CAA0A8SDKErrorCGctF

Delete Group Membership
-----------------------

To delete a group membership, call [`client.groups.deleteMembership(membershipId: String, completion: @escaping: Callback<Void>)`][delete-membership] with the ID of the group membership to delete.

<!-- sample delete_group_memberships_id -->
```swift
client.groups.deleteMembership(membershipId: "12345") { 
(result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error deleting group membership")
        return
    }

    print("Group Membership was successfully deleted.")
}
```

[delete-membership]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC16deleteMembership12membershipId10completionySS_ys6ResultOyytAA0A8SDKErrorCGctF

Get Memberships for Group
-------------------------

To retrieve information about the memberships in a group, call [`client.groups.listMemberships(groupID: String, offset: Int?, limit: Int?, fields: [String]?)`][get-memberships-for-group] with the ID of the group to retrieve group memberships for. This method will return an iterator object in the completion, which is used to retrieve the memberships.

<!-- sample get_groups_id_memberships -->
```swift
client.groups.listMembership(groupId: "12345") {
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(membership):
                    print("Group Membership with ID \(membership.id) was retrieved")
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

[get-memberships-for-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC15listMemberships7groupId6offset5limit6fields10completionySS_SiSgAJSaySSGSgys6ResultOyAA14PagingIteratorCyAA15GroupMembershipCGAA0A8SDKErrorCGctF

Get Memberships for User
------------------------

To retrieve information about the group memberships for a given user, call
[`client.groups.listMembershipsForUser(userId: String, offset: Int?, limit: Int?, fields: [String]?)`][get-memberships-for-user] with the ID of the user to retreive group memberships for. This method will return an iterator object in the completion, which is used to retrieve the memberships.

<!-- sample get_users_id_memberships -->
```swift
client.groups.listMembershipsForUser(userId: "12345") {
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(membership):
                    print("Group Membership with ID \(membership.id) was retrieved")
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

[get-memberships-for-user]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC22listMembershipsForUser6userId6offset5limit6fields10completionySS_SiSgAJSaySSGSgys6ResultOyAA14PagingIteratorCyAA15GroupMembershipCGAA0A8SDKErrorCGctF

Get Collaborations for Group
----------------------------

To retrieve all group collaborations for a given group, call [`client.groups.listCollaborations(groupId: String, offset: Int?, limit: Int? fields: [String]?)`][get-collaborations-for-group] with the ID of the group to retrieve collaborations for. This method will return an iterator object in the completion, which is used to retrieve the collaborations.

<!-- sample get_groups_id_collaborations -->
```swift
client.groups.listCollaborations(groupId: "12345") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { (result in
                switch result {
                case let .success(collaboration):
                    print("Collaboration with ID \(collaboration.id) was retrieved")
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

[get-collaborations-for-group]: https://opensource.box.com/box-ios-sdk/Classes/GroupsModule.html#/s:6BoxSDK12GroupsModuleC18listCollaborations7groupId6offset5limit6fields10completionySS_SiSgAJSaySSGSgys6ResultOyAA14PagingIteratorCyAA13CollaborationCGAA0A8SDKErrorCGctF
