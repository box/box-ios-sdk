Users
=====

Users represent an individual's account on Box.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Current User](#get-current-user)
- [Get User](#get-user)
- [Get User Avatar](#get-user-avatar)
- [Create User](#list-terms-of-services-for-an-enterprise)
- [Create App User](#create-app-user)
- [Update User](#update-user)
- [Change User Login](#change-user-login)
- [Delete User](#delete-user)
- [Get Enterprise Users](#get-enterprise-users)
- [Invite User to Enterprise](#invite-user-to-enterprise)
- [Move User Content](#move-user-content)
- [Get User Email Aliases](#get-user-email-aliases)
- [Add User Email Alias](#add-user-email-alias)
- [Remove User Email Alias](#remove-user-email-alias)
- [Roll User Out of Enterprise](#roll-user-out-of-enterprise)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Current User
----------------

To retrieve information about the currently authenticated user, call
[`client.users.getCurrent(fields:completion:)`][get-current-user].

<!-- sample get_users_me -->
```swift
client.users.getCurrent(fields: ["name", "login"]) { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error getting user information")
        return
    }

    print("Authenticated as \(user.name), with login \(user.login)")
}
```

[get-current-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC10getCurrent6fields10completionySaySSGSg_ys6ResultOyAA4UserCAA0A8SDKErrorCGctF

Get User
--------

To retrieve information about a specific user, call
[`client.users.get(userId:fields:completion:)`][get-user]
with the ID of the user.

<!-- sample get_users_id -->
```swift
client.users.get(userId: "33333", fields: ["name", "login"]) { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error getting user information")
        return
    }

    print("Got user \(user.name), with login \(user.login)")
}
```

[get-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC3get6userId6fields10completionySS_SaySSGSgys6ResultOyAA4UserCAA0A8SDKErrorCGctF

Get User Avatar
---------------

To retrieve the avatar image for a user, call
[`client.users.getAvatar(userId:completion:)`][get-user-avatar]
with the ID of the user.

<!-- sample get_users_id_avatar -->
```swift
client.users.getAvatar(userId: "33333") { (result: Result<Data, BoxSDKError>) in
    guard case let .success(avatarData) = result else {
        print("Error getting user avatar")
        return
    }

    let avatarImage = UIImage(data: avatarData)
}
```

[get-user-avatar]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC9getAvatar6userId10completionySS_ys6ResultOy10Foundation4DataVAA0A8SDKErrorCGctF

Create User
-----------

As an admin user or service account, create a new user in your enterprise by calling
[`client.users.create(login:name:...)`][create-user] with the login email address and name for
the user.

<!-- sample post_users -->
```swift
client.users.create(login: "new.user@example.com", name: "New User") { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error creating user")
        return
    }

    print("Created user \(user.name), with login \(user.login)")
}
```

[create-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC6create5login4name4role8language13isSyncEnabled8jobTitle5phone7address11spaceAmount13trackingCodes013canSeeManagedC08timezone0J24ExternalCollabRestricted0J22ExemptFromDeviceLimits0J27ExemptFromLoginVerification6status6fields10completionySS_SSAA8UserRoleOSgSSSgSbSgA3Zs5Int64VSgSayAA4UserC12TrackingCodeVGSgA_AZA_A_A_AA10UserStatusOSgSaySSGSgys6ResultOyA4_AA0A8SDKErrorCGctF

Create App User
---------------

To create an [app user][app-user], call [`client.users.createAppUser(name:...)`][create-app-user] with the
a name for that user.

<!-- sample post_users app_user -->
```swift
client.users.createAppUser(name: "Doug") { (result: Result<User, BoxSDKError>) in
    guard case let .success(appUser) = result else {
        print("Error creating app user")
        return
    }

    print("Created app user with ID \(appUser.id)")
}
```

[app-user]: https://developer.box.com/docs/user-types#section-app-user
[create-app-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC13createAppUser4name8language8jobTitle8timezone5phone7address11spaceAmount6status26isExternalCollabRestricted013canSeeManagedC06fields10completionySS_SSSgA4Qs5Int64VSgAA0G6StatusOSgSbSgAXSaySSGSgys6ResultOyAA0G0CAA0A8SDKErrorCGctF

Update User
-----------

To update the information on a user, call [`client.users.updateUser(userId:...)`][update-user]
with the ID of the user and the properties to update.  The result is the updated user object.

<!-- sample put_users_id -->
```swift
// Restrict the user from collaborating content externally
client.users.update(userId: "33333", isExternalCollabRestricted: true) { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error updating user")
        return
    }

    print("Updated user \(user.name), with login \(user.login)")
}
```

[update-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC6update6userId5login4name4role8language13isSyncEnabled8jobTitle5phone7address11spaceAmount13trackingCodes013canSeeManagedC08timezone0L24ExternalCollabRestricted0L22ExemptFromDeviceLimits0L27ExemptFromLoginVerification6status6fields10completionySS_SSSgAxA8UserRoleOSgAXSbSgA3Xs5Int64VSgSayAA4UserC12TrackingCodeVGSgA0_AXA0_A0_A0_AA10UserStatusOSgSaySSGSgys6ResultOyA5_AA0A8SDKErrorCGctF

Change User Login
-----------------

> __Note:__ In order to change the user's login email, the new email address must first be added as an email alias
> and the address must be confirmed.

To change a user's login email, call
[`client.users.changeLogin(userId:login:fields:completion:)`][change-login]
with the ID of the user and the new login email.

<!-- sample put_users_id change_login -->
```swift
client.users.changeLogin(userId: "33333", login: "updated.address@example.com") { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error updating user email")
        return
    }

    print("User \(user.name) (ID: \(user.id)) now has login \(user.login)")
}
```

[change-login]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC11changeLogin6userId5login6fields10completionySS_SSSaySSGSgys6ResultOyAA4UserCAA0A8SDKErrorCGctF

Delete User
-----------

To delete a user, which removes their access to Box, call
[`client.users.delete(userId:notify:force:completion:)`][delete-user]
with the ID of the user.  By default, the user will not be deleted if they have any content remaining in their account.
To delete the user and any content that is in their account, set the `force` parameter to `true`.

<!-- sample delete_users_id -->
```swift
client.users.delete(userId: "33333") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error deleting user")
        return
    }

    print("User successfully deleted")
}
```

[delete-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC6delete6userId6notify5force10completionySS_SbSgAIys6ResultOyytAA0A8SDKErrorCGctF

Get Enterprise Users
--------------------

To retrieve the users in an enterprise, call
[`client.users.listForEnterprise(filterTerm:fields:offset:limit:)`][get-enterprise-users].
The method returns an iterator object in the completion, which is used to get the users.

<!-- sample get_users -->
```swift
client.users.listForEnterprise() {
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(user):
                    print("\(user.name) (ID: \(user.id))")
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

[get-enterprise-users]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC17listForEnterprise10filterTerm6fields9usemarker6marker6offset5limit10completionySSSg_SaySSGSgSbSgALSiSgAPys6ResultOyAA14PagingIteratorCyAA4UserCGAA0A8SDKErrorCGctF

Invite User to Enterprise
-------------------------

To invite a user who already has a Box account to join an enterprise, call
[`client.users.inviteToJoinEnterprise(login:enterpriseId:fields:completion:)`][invite-user]
with the login email of the user and the ID of the enterprise.

<!-- sample post_invites -->
```swift
client.users.inviteToJoinEnterprise(
    login: "user@example.com",
    enterpriseId: "12345"
) { (result: Result<Invite, BoxSDKError>) in
    guard case let .success(invite) = result else {
        print("Error inviting user to enterprise")
        return
    }

    print("Invited user \(invite.actionableBy.name) to \(invite.invitedTo.name)")
}
```

[invite-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC22inviteToJoinEnterprise5login12enterpriseId6fields10completionySS_SSSaySSGSgys6ResultOyAA6InviteCAA0A8SDKErrorCGctF

Move User Content
-----------------

Before deleting a user, it is recommended to move all content they own to another user.  This can be done by calling
[`client.users.moveItemsOwnedByUser(withID:toUserWithID:notify:fields:completion:)`][move-user-content]
with the ID of the source and destination users.  The result of this method is a new folder created in the destination
user's root folder, containing all content previously owned by the source user.

<!-- sample put_users_id_folders_id -->
```swift
client.users.moveItemsOwnedByUser(withID: "33333", toUserWithID: "44444") { (result: Result<Folder, BoxSDKError>) in
    guard case let .success(folder) = result else {
        print("Error moving user content")
        return
    }

    print("Folder ID \(folder.id) created with migrated content")
}
```

[move-user-content]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC20moveItemsOwnedByUser6withID02toi4WithK06notify6fields10completionySS_SSSbSgSaySSGSgys6ResultOyAA6FolderCAA0A8SDKErrorCGctF

Get User Email Aliases
----------------------

To retrieve the list of email aliases associated with a user, call
[`client.users.listEmailAliases(userId:completion:)`][get-email-aliases]
with the ID of the user.

<!-- sample get_users_id_email_aliases -->
```swift
client.users.listEmailAliases(userId: "33333") { (result: Result<EntryContainer<User>, BoxSDKError>) in
    guard case let .success(aliasCollection) = result else {
        print("Error retrieving email aliases")
        return
    }

    print("User has \(aliasCollection.totalCount) email aliases:")
    for alias in aliasCollection.entries {
        print("- \(alias.email) (\(alias.isConfirmed ? "Confirmed" : "Not Confirmed"))")
    }
}
```

[get-email-aliases]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC16listEmailAliases6userId10completionySS_ys6ResultOyAA14EntryContainerCyAA0F5AliasCGAA0A8SDKErrorCGctF

Add User Email Alias
--------------------

To associate a new email alias with a user, call
[`client.users.createEmailAlias(userId:email:completion:)`][add-email-alias]
with the ID of the user and the email address to add as an alias.

<!-- sample post_users_id_email_aliases -->
```swift
client.users.createEmailAlias(
    userId: "33333",
    email: "user+alias@example.com"
) { (result: Result<EmailAlias, BoxSDKError>) in
    guard case let .success(alias) = result else {
        print("Error adding email alias")
        return
    }

    print("Added email alias \(alias.email) — user must confirm")
}
```

[add-email-alias]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC23createEmailAliasForUser6userId5email10completionySS_SSys6ResultOyAA0fG0CAA0A5ErrorOGctF

Remove User Email Alias
-----------------------

To remove a user's email alias, call
[`client.users.deleteEmailAlias(userId:emailAliasId:completion:)`][remove-email-alias]
with the ID of the user and the ID of the email alias to remove.

<!-- sample delete_users_id_email_aliases -->
```swift
client.users.deleteEmailAlias(userId: "33333", emailAliasId: "99999") { (result: Result<Void, BoxSDKError>) in
    guard case .success = result else {
        print("Error removing email alias")
        return
    }

    print("Successfully removed email alias")
}
```

[remove-email-alias]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC16deleteEmailAlias6userId05emailgI010completionySS_SSys6ResultOyytAA0A8SDKErrorCGctF

Roll User Out of Enterprise
---------------------------

To roll a user out of an enterprise, converting them to a free user, call
[`client.users.rollOutOfEnterprise(userId:notify:fields:completion:)`][roll-out-user]
with the ID of the user.

<!-- sample delete_users_id -->
```swift
client.users.rollOutOfEnterprise(userId: "33333") { (result: Result<User, BoxSDKError>) in
    guard case let .success(user) = result else {
        print("Error removing user from enterprise")
        return
    }

    print("User \(user.name) successfully removed from enterprise")
}
```

[roll-out-user]: https://opensource.box.com/box-ios-sdk/Classes/UsersModule.html#/s:6BoxSDK11UsersModuleC19rollOutOfEnterprise6userId6notify6fields10completionySS_SbSgSaySSGSgys6ResultOyAA4UserCAA0A8SDKErrorCGctF