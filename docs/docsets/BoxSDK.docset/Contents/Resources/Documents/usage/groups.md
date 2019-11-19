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

```swift
 client.groups.create(name: "Team A", provenance: "Test", externalSyncIdentifier: "Test Sync", description: "Test Description", invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { (result: Result<Group, BoxError>) in
    guard case let .success(group) = result else {
        print("Error creating new group")
        return
    }

    print("Group \(group.name) was created")
 }
```

[create-group]: 

Update Group
------------

To update an existing group, call [`client.groups.update(groupId: String, name: String?, provenance: NullableParameter<String>?, externalSyncIdentifier: NullableParameter<String>?, description: NullableParameter<String>?, invitabilityLevel: GroupInvitabilityLevel?, memberViewabilityLevel: GroupMemberViewabilityLevel?, fields: [String]?, completion: @escaping Callback<Group>)`][update-group] with the ID of the group. You can control which fields are returned in the resulting `Group` object by passing the
`fields` parameter.

```swift
client.groups.update(groupId: "11111", name: "Team A", provenance: .value("Test"), externalSyncIdentifier: .value("Test Sync"), description: .value("Test Description"), invitabilityLevel: .allManagedUsers, memberViewabilityLevel: .allManagedUsers) { 
(result: Result<Group, BoxError>) in
    guard case let .success(group) = result else {
        print("Error updating the group")
        return
    }

    print("Group \(group.name) was updated with description: \(group.description)")

}
```

[update-group]

Get Group Info
--------------

To retrieve information about a group, call [`client.groups.get(groupId: String, fields: [String]?, completion: @escaping Callback<Group>)`][get-group] with the ID of the group. You can control which fields are returned in the resulting `Group` object by passing the `fields` parameter.

```swift
client.groups.get(groupId: "12345") {
(result: Result<Group, BoxError>) in
    guard case let .success(group) = result else {
        print("Error getting group information")
        return
    }

    print("Group with name \(group.name) was retrieved.")
}
```

[get-group]

Get Enterprise Groups
---------------------

To retrieve information about the groups within the enterprise, call [`client.groups.listForEnterprise(name: String?, offset: Int?, limit: Int?, fields: [String]?)`][get-enterprise-groups]. You can also pass in a `name` paramter to act as a filter. This method will return an iterator object you can use to retrieve successive pages of result, where each page contains some of the groups in the enterprise.

```swift
let groupsIterator = client.groups.listForEnterprise()

groupsIterator.getNextItems() { (result: Result<[Groups], BoxError>) in
    guard case let .success(groups) = result else {
        print("Error getting enterprise groups")
        return
    }

    for group in groups {
        print("Group with name \(group.name) retrieved")
    }
}
```

[get-enterprise-groups]

Delete Group
------------

To delete a group, call [`client.groups.delete(groupId: String, completion: @escaping Callback<Void>)`][delete-group] with the ID of the group to delete.

```swift
client.groups.delete(groupId: "12345") { 
(result: Result<Void, BoxError>) in
    guard case .success = result else {
        print("Error deleting group")
        return
    }

    print("Group was successfully deleted.")
}
```

[delete-group]

Group Membership
================

Get Group Membership Info
-------------------------

To retrieve information about a specified group membership, call [`client.groups.getMembershipInfo(membershipId: String, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][get-membership-info] with the ID of the group membership. You can control which fields are returned on the resulting `Group Membership` object by passing the desired field names in the optional `fields` parameter.

```swift
client.groups.getMembershipInfo(membershipId: "12345") { 
(result: Result<GroupMembership, BoxError>) in
    guard case let .success(membership) = result else {
        print("Error retrieving group membership information")
        return
    }

    print("Group Membership for group \(membership.group?.name) was retrieved")
}
```

Create Group Membership
-----------------------

To create a new group membership, call [`client.groups.createMembership(userId: String, groupId: String, role: GroupRole?, configurablePermission: NullableParameter<ConfigurablePermissionData>?, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][create-membership]. You can control which fields are returned on the resulting `Group Membership` object by passing the desired field names in the optional `fields` parameter.

```swift
client.createMembership(userId: "54321", groupId: "11111", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { 
(result: Result<GroupMembership, BoxError>) in
    guard case let .success(membership) = result else {
        print("Error creating group membership")
        return
    }

    print("Group membership for group \(membership.group?.name) was created")
}
```

[create-membership]:

Update Group Membership
-----------------------

To update an existing group membership, call [`client.groups.updateMembership(membershipId: String, role: GroupRole?, configurablePermission: NullableParameter<ConfigurablePermissionData>?, fields: [String]?, completion: @escaping Callback<GroupMembership>)`][update-membership] with the ID of the group membership to update.

```swift
client.groups.updateMembership(membershipId: "12345", role: .admin, configurablePermission: .value(ConfigurablePermissionData(canRunReports: true, canInstantLogin: true, canCreateAccounts: false, canEditAccounts: true))) { 
(result: Result<GroupMembership, BoxError>) in
    guard case let .success(membership) = result else {
        print("Error updating group membership")
        return
    }

    print("Group membership with ID \(membership.id) was updated")
}
```

[update-membership]:

Delete Group Membership
-----------------------

To delete a group membership, call [`client.groups.deleteMembership(membershipId: String, completion: @escaping: Callback<Void>)`][delete-membership] with the ID of the group membership to delete.

```swift
client.groups.deleteMembership(membershipId: "12345") { 
(result: Result<Void, BoxError>) in
    guard case .success = result else {
        print("Error deleting group membership")
        return
    }

    print("Group Membership was successfully deleted.")
}
```

[delete-membership]:

Get Memberships for Group
-------------------------

To retrieve information about the memberships in a group, call [`client.groups.listMemberships(groupID: String, offset: Int?, limit: Int?, fields: [String]?)`][get-memberships-for-group] with the ID of the group to retrieve group memberships for.

```swift
let membershipIterator = client.groups.listMembership(groupId: "12345")

membershipIterator.getNextItems() {
(result: Result<[GroupMembership], BoxError>) in
    guard case let .success(memberships) = result else {
        print("Error getting memberships")
        return
    }

    for membership in memberships {
        print("Group Membership with ID \(membership.id) was retrieved")
    }
}
```

[get-memberships-for-group]: 

Get Memberships for User
------------------------

To retrieve information about the group memberships for a given user, call
[`client.groups.listMembershipsForUser(userId: String, offset: Int?, limit: Int?, fields: [String]?)`][get-memberships-for-user] with the ID of the user to retreive group memberships for.

```swift
let membershipIterator = client.groups.listMembershipsForUser(userId: "12345")

membershipIterator.getNextItems() {
(result: Result<[GroupMembership], BoxError>) in
    guard case let .success(memberships) = result else {
        print("Error getting memberships")
        return
    }

    for membership in memberships {
        print("Group Membership with ID \(membership.id) was retrieved")
    }
}
```

[get-memberships-for-user]:

Get Collaborations for Group
----------------------------

To retrieve all group collaborations for a given group, call [`client.groups.listCollaborations(groupId: String, offset: Int?, limit: Int? fields: [String]?)`][get-collaborations-for-group] with the ID of the group to retrieve collaborations for.

```swift
let collabIterator = client.groups.listCollaborations(groupId: "12345")

collabIterator.getNextItems() {
(result: Result<[Collaboration], BoxError>) in
    guard case let .success(collaborations) = result else {
        print("Error getting collaborations")
        return
    }

    for collaboration in collaborations {
        print("Collaboration with ID \(collaboration.id) was retrieved")
    }
}
```

[get-collaborations-for-group]: 
