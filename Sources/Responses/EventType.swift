//
//  EventType.swift
//  BoxSDK-iOS
//
//  Created by Martina Stremenova on 01/08/2019.
//  Copyright © 2019 box. All rights reserved.
//

import Foundation

// Defines user or enterprise event type
public enum EventType: BoxEnum {

    // MARK: - User events

    /// A folder or file was created.
    case itemCreated
    /// A folder or file was uploaded.
    case itemUploaded
    /// A comment was created on a folder, file, or other comment.
    case commentCreated
    /// A comment was deleted on folder, file, or other comment.
    case commentDeleted
    /// A file or folder was downloaded.
    case itemDownloaded
    /// A file was previewed.
    case itemPreviewed
    /// A file or folder was moved.
    case itemMoved
    /// A file or folder was copied.
    case itemCopied
    /// A task was assigned.
    case taskAssigned
    /// A task was created.
    case taskCreated
    /// A file was locked.
    case fileLocked
    /// A file was unlocked. If a locked file is deleted, the source file will be null.
    case fileUnlocked
    /// A file or folder was marked as deleted.
    case itemDeleted
    /// A file or folder was recovered out of the trash.
    case itemRecovered
    /// A collaborator was added to a folder.
    case collaboratorAdded
    /// A collaborator had their role changed.
    case collaboratorRoleChanged
    /// A collaborator was invited on a folder.
    case collaboratorInvited
    /// A collaborator was removed from a folder.
    case collaboratorRemoved
    /// A folder was marked for sync.
    case itemSync
    /// A folder was un-marked for sync.
    case itemUnsync
    /// A file or folder was renamed.
    case itemRenamed
    /// A file or folder was enabled for sharing.
    case itemEnabledForSharing
    /// A file or folder was disabled for sharing.
    case itemDisabledForSharing
    /// A folder was shared.
    case itemShared
    /// A previous version of a file was promoted to the current version.
    case itemMadeCurrentVersion
    /// A Tag was added to a file or folder.
    case tagAdded
    /// 2 factor authentication enabled by user.
    case twoFactorEnabled
    /// Free user accepts invitation to become a managed user.
    case masterInviteAccepted
    /// Free user rejects invitation to become a managed user.
    case masterInviteRejected
    /// Granted Box access to account.
    case accessGranted
    /// Revoke Box access to account.
    case accessRevoked
    /// Added user to group.
    case addedUserToGroup
    /// Removed user from group.
    case removedUserFromGroup

    // MARK: - Enterprise-only events

    /// Created user.
    case createdUser
    /// Created new group.
    case createdGroup
    /// Deleted group.
    case deletedGroup
    /// Deleted user.
    case deletedUser
    /// Edited group.
    case editedGroup
    /// Edited user.
    case editedUser
    /// Admin login
    case adminLogin
    /// Added device association
    case addedDeviceAssocation
    /// Edit the permissions on a folder
    case changeFolderPermission
    /// Failed login
    case failedLogin
    /// Login
    case login
    /// Removed device association
    case removedDeviceAssociation
    /// Device Trust check failed
    case deviceTrustCheckFailed
    /// Accepted terms
    case termsOfServiceAccepted
    /// Rejected terms
    case termsOfServiceRejected
    /// Virus found on a file. Event is only received by enterprises that have opted in to be notified.
    case fileMarkedMalicious
    /// Copied
    case copied
    /// Deleted
    case deleted
    /// Downloaded
    case downloaded
    /// Edited
    case edited
    /// Locked
    case locked
    /// Moved
    case moved
    /// Previewed
    case previewed
    /// A file or folder name or description is changed.
    case renamed
    /// Set file auto-delete
    case storageExpiration
    /// Undeleted
    case undeleted
    /// Unlocked
    case unlocked
    /// Uploaded
    case uploaded
    /// Enabled shared links
    case shareEnabled
    /// Share links settings updated
    case itemShareUpdated
    /// Extend shared link expiration
    case shareExpirationUpdated
    /// Set shared link expiration
    case shareExpiration
    /// Unshared shared link
    case unshared
    /// Accepted invites
    case collaborationAccepted
    /// Changed user roles
    case collaborationRoleChanged
    /// Extend collaborator expiration
    case collaborationExpirationExtended
    /// Removed collaborators
    case collaborationRemoved
    /// Invited
    case invitedToCollaboration
    /// Set collaborator expiration
    case collaborationExpiration
    /// A user is logging in from a device we haven’t seen before.
    case loginActivityDeviceAdded
    /// We invalidated a user session associated with an app.
    case loginActivityDeviceRemoved
    /// An OAuth 2.0 access token has been created
    case userOAuth2AccessTokenCreated
    /// When an admin role changes for a user
    case userAdminRoleChanged
    /// A collaborator violated an admin-set upload policy
    case contentWorkflowUploadPolicyViolated
    // Creation of metadata instance.
    case metadataInstanceCreated
    /// Update of metadata instance.
    case matadataInstanceUpdated
    /// Deletion of metadata instance.
    case matadataInstanceDeleted
    /// Update of a task assignment.
    case taskAssignmentUpdated
    /// A task assignment is deleted.
    case taskAssignmentDeleted
    /// A task's comment was edited.
    case taskUpdated
    /// An item is added to a group.
    case itemAddedToGroup
    /// Retention is removed.
    case dataRetentionRemoved
    /// Retention is created.
    case dataRetentionCreated
    /// A retention policy assignment is added.
    case dataRetentionPolicyAssignmentAdded
    /// A legal hold assignment is created.
    case legalHoldAssignmentCreated
    /// A legal hold assignment is deleted.
    case legalHoldAssignmentDeleted
    /// A legal hold policy is created.
    case legalHoldPolicyCreated
    /// A legal hold policy is updated.
    case legalHoldPolicyUpdated
    /// A legal hold policy is deleted.
    case legalHoldPolicyDeleted
    /// There is a sharing policy violation.
    case sharingPolicyViolation
    /// An application public key is added.
    case applicationPublicKeyAdded
    /// An application public key is deleted.
    case applicationPublicKeyDeleted
    /// A new application was created in the Box developer console.
    case applicationCreated
    /// A content policy is added.
    case contentPolicyAdded
    /// An automation is added.
    case automationAdded
    /// An automation is deleted.
    case automationDeleted
    /// A user email alias is confirmed.
    case userEmailAliasConfirmed
    /// A user email alias is removed.
    case userEmailAliasRemoved
    /// A watermark is added to a file.
    case watermarkAdded
    /// A watermark is removed from a file.
    case watermarkRemoved
    /// Creation of metadata template instance.
    case metadataTemplateCreated
    /// Update of metadata template instance.
    case metadataTemplateUpdated
    /// Deletion of metadata template instance.
    case metadataTemplateDeleted
    /// Item was opened.
    case itemOpened
    /// Item was modified.
    case itemModified
    /// When a policy set in the Admin console is triggered.
    case abnormalDownloadActivity
    /// Folders were removed from a group in the Admin console.
    case itemsRemovedFromGroup
    /// Folders were added to a group in the Admin console.
    case itemsAddedToGroup
    /// A watermarked file was downloaded.
    case watermarkedFileDownloaded

    // MARK: - Custom value

    /// Custom event type, that is not yet implemented in this SDK version.
    case customValue(String)

    // swiftlint:disable cyclomatic_complexity
    // swiftlint:disable function_body_length
    /// Initializer
    /// - Parameter value: The string value of the event type
    public init(_ value: String) {
        switch value {
        case "ITEM_CREATE":
            self = .itemCreated
        case "ITEM_UPLOAD":
            self = .itemUploaded
        case "COMMENT_CREATE":
            self = .commentCreated
        case "COMMENT_DELETE":
            self = .commentDeleted
        case "ITEM_DOWNLOAD":
            self = .itemDownloaded
        case "ITEM_PREVIEW":
            self = .itemPreviewed
        case "ITEM_MOVE":
            self = .itemMoved
        case "ITEM_COPY":
            self = .itemCopied
        case "TASK_ASSIGNMENT_CREATE":
            self = .taskAssigned
        case "TASK_CREATE":
            self = .taskCreated
        case "LOCK_CREATE":
            self = .fileLocked
        case "LOCK_DESTROY":
            self = .fileUnlocked
        case "ITEM_TRASH":
            self = .itemDeleted
        case "ITEM_UNDELETE_VIA_TRASH":
            self = .itemRecovered
        case "COLLAB_ADD_COLLABORATOR":
            self = .collaboratorAdded
        case "COLLAB_ROLE_CHANGE":
            self = .collaboratorRoleChanged
        case "COLLAB_INVITE_COLLABORATOR":
            self = .collaboratorInvited
        case "COLLAB_REMOVE_COLLABORATOR":
            self = .collaboratorRemoved
        case "ITEM_SYNC":
            self = .itemSync
        case "ITEM_UNSYNC":
            self = .itemUnsync
        case "ITEM_RENAME":
            self = .itemRenamed
        case "ITEM_SHARED_CREATE":
            self = .itemEnabledForSharing
        case "ITEM_SHARED_UNSHARE":
            self = .itemDisabledForSharing
        case "ITEM_SHARED":
            self = .itemShared
        case "ITEM_MAKE_CURRENT_VERSION":
            self = .itemMadeCurrentVersion
        case "TAG_ITEM_CREATE":
            self = .tagAdded
        case "ENABLE_TWO_FACTOR_AUTH":
            self = .twoFactorEnabled
        case "MASTER_INVITE_ACCEPT":
            self = .masterInviteAccepted
        case "MASTER_INVITE_REJECT":
            self = .masterInviteRejected
        case "ACCESS_GRANTED":
            self = .accessGranted
        case "ACCESS_REVOKED":
            self = .accessRevoked
        case "GROUP_ADD_USER":
            self = .addedUserToGroup
        case "GROUP_REMOVE_USER":
            self = .removedUserFromGroup
        case "NEW_USER":
            self = .createdUser
        case "FILE_MARKED_MALICIOUS":
            self = .fileMarkedMalicious
        case "COPY":
            self = .copied
        case "DELETE":
            self = .deleted
        case "EDIT":
            self = .edited
        case "LOCK":
            self = .locked
        case "MOVE":
            self = .moved
        case "PREVIEW":
            self = .previewed
        case "RENAME":
            self = .renamed
        case "STORAGE_EXPIRATION":
            self = .storageExpiration
        case "UNDELETE":
            self = .undeleted
        case "UNLOCK":
            self = .unlocked
        case "UPLOAD":
            self = .uploaded
        case "SHARE":
            self = .shareEnabled
        case "ITEM_SHARED_UPDATE":
            self = .itemShareUpdated
        case "UPDATE_SHARE_EXPIRATION":
            self = .shareExpirationUpdated
        case "SHARE_EXPIRATION":
            self = .shareExpiration
        case "UNSHARE":
            self = .unshared
        case "COLLABORATION_ACCEPT":
            self = .collaborationAccepted
        case "COLLABORATION_ROLE_CHANGE":
            self = .collaborationRoleChanged
        case "UPDATE_COLLABORATION_EXPIRATION":
            self = .collaborationExpirationExtended
        case "COLLABORATION_REMOVE":
            self = .collaborationRemoved
        case "COLLABORATION_INVITE":
            self = .invitedToCollaboration
        case "COLLABORATION_EXPIRATION":
            self = .collaborationExpiration
        case "ADD_LOGIN_ACTIVITY_DEVICE":
            self = .loginActivityDeviceAdded
        case "REMOVE_LOGIN_ACTIVITY_DEVICE":
            self = .loginActivityDeviceRemoved
        case "USER_AUTHENTICATE_OAUTH2_ACCESS_TOKEN_CREATE":
            self = .userOAuth2AccessTokenCreated
        case "CHANGE_ADMIN_ROLE":
            self = .userAdminRoleChanged
        case "CONTENT_WORKFLOW_UPLOAD_POLICY_VIOLATION":
            self = .contentWorkflowUploadPolicyViolated
        case "METADATA_INSTANCE_CREATE":
            self = .metadataInstanceCreated
        case "METADATA_INSTANCE_UPDATE":
            self = .matadataInstanceUpdated
        case "METADATA_INSTANCE_DELETE":
            self = .matadataInstanceDeleted
        case "TASK_ASSIGNMENT_UPDATE":
            self = .taskAssignmentUpdated
        case "TASK_ASSIGNMENT_DELETE":
            self = .taskAssignmentDeleted
        case "TASK_UPDATE":
            self = .taskUpdated
        case "GROUP_ADD_ITEM":
            self = .itemAddedToGroup
        case "DATA_RETENTION_REMOVE_RETENTION":
            self = .dataRetentionRemoved
        case "DATA_RETENTION_CREATE_RETENTION":
            self = .dataRetentionCreated
        case "RETENTION_POLICY_ASSIGNMENT_ADD":
            self = .dataRetentionPolicyAssignmentAdded
        case "LEGAL_HOLD_ASSIGNMENT_CREATE":
            self = .legalHoldAssignmentCreated
        case "LEGAL_HOLD_ASSIGNMENT_DELETE":
            self = .legalHoldAssignmentDeleted
        case "LEGAL_HOLD_POLICY_CREATE":
            self = .legalHoldPolicyCreated
        case "LEGAL_HOLD_POLICY_UPDATE":
            self = .legalHoldPolicyUpdated
        case "LEGAL_HOLD_POLICY_DELETE":
            self = .legalHoldPolicyDeleted
        case "CONTENT_WORKFLOW_SHARING_POLICY_VIOLATION":
            self = .sharingPolicyViolation
        case "APPLICATION_PUBLIC_KEY_ADDED":
            self = .applicationPublicKeyAdded
        case "APPLICATION_PUBLIC_KEY_DELETED":
            self = .applicationPublicKeyDeleted
        case "APPLICATION_CREATED":
            self = .applicationCreated
        case "CONTENT_WORKFLOW_POLICY_ADD":
            self = .contentPolicyAdded
        case "CONTENT_WORKFLOW_AUTOMATION_ADD":
            self = .automationAdded
        case "CONTENT_WORKFLOW_AUTOMATION_DELETE":
            self = .automationDeleted
        case "EMAIL_ALIAS_CONFIRM":
            self = .userEmailAliasConfirmed
        case "EMAIL_ALIAS_REMOVE":
            self = .userEmailAliasRemoved
        case "WATERMARK_LABEL_CREATE":
            self = .watermarkAdded
        case "WATERMARK_LABEL_DELETE":
            self = .watermarkRemoved
        case "METADATA_TEMPLATE_CREATE":
            self = .metadataTemplateCreated
        case "METADATA_TEMPLATE_UPDATE":
            self = .metadataTemplateUpdated
        case "METADATA_TEMPLATE_DELETE":
            self = .metadataTemplateDeleted
        case "ITEM_OPEN":
            self = .itemOpened
        case "ITEM_MODIFY":
            self = .itemModified
        case "CONTENT_WORKFLOW_ABNORMAL_DOWNLOAD_ACTIVITY":
            self = .abnormalDownloadActivity
        case "GROUP_REMOVE_ITEM":
            self = .itemsRemovedFromGroup
        case "FILE_WATERMARKED_DOWNLOAD":
            self = .watermarkedFileDownloaded
        default:
            self = .customValue(value)
        }
    }

    // swiftlint:enable function_body_length

    /// String representation of sync state.
    public var description: String {
        switch self {
        case .itemCreated:
            return "ITEM_CREATE"
        case .itemUploaded:
            return "ITEM_UPLOAD"
        case .commentCreated:
            return "COMMENT_CREATE"
        case .commentDeleted:
            return "COMMENT_DELETE"
        case .itemDownloaded:
            return "ITEM_DOWNLOAD"
        case .itemPreviewed:
            return "ITEM_PREVIEW"
        case .itemMoved:
            return "ITEM_MOVE"
        case .itemCopied:
            return "ITEM_COPY"
        case .taskAssigned:
            return "TASK_ASSIGNMENT_CREATE"
        case .taskCreated:
            return "TASK_CREATE"
        case .fileLocked:
            return "LOCK_CREATE"
        case .fileUnlocked:
            return "LOCK_DESTROY"
        case .itemDeleted:
            return "ITEM_TRASH"
        case .itemRecovered:
            return "ITEM_UNDELETE_VIA_TRASH"
        case .collaboratorAdded:
            return "COLLAB_ADD_COLLABORATOR"
        case .collaboratorRoleChanged:
            return "COLLAB_ROLE_CHANGE"
        case .collaboratorInvited:
            return "COLLAB_INVITE_COLLABORATOR"
        case .collaboratorRemoved:
            return "COLLAB_REMOVE_COLLABORATOR"
        case .itemSync:
            return "ITEM_SYNC"
        case .itemUnsync:
            return "ITEM_UNSYNC"
        case .itemRenamed:
            return "ITEM_RENAME"
        case .itemEnabledForSharing:
            return "ITEM_SHARED_CREATE"
        case .itemDisabledForSharing:
            return "ITEM_SHARED_UNSHARE"
        case .itemShared:
            return "ITEM_SHARED"
        case .itemMadeCurrentVersion:
            return "ITEM_MAKE_CURRENT_VERSION"
        case .tagAdded:
            return "TAG_ITEM_CREATE"
        case .twoFactorEnabled:
            return "ENABLE_TWO_FACTOR_AUTH"
        case .masterInviteAccepted:
            return "MASTER_INVITE_ACCEPT"
        case .masterInviteRejected:
            return "MASTER_INVITE_REJECT"
        case .accessGranted:
            return "ACCESS_GRANTED"
        case .accessRevoked:
            return "ACCESS_REVOKED"
        case .addedUserToGroup:
            return "GROUP_ADD_USER"
        case .removedUserFromGroup:
            return "GROUP_REMOVE_USER"
        case .createdUser:
            return "NEW_USER"
        case .createdGroup:
            return "GROUP_CREATION"
        case .deletedGroup:
            return "GROUP_DELETION"
        case .deletedUser:
            return "DELETE_USER"
        case .editedGroup:
            return "GROUP_EDITED"
        case .editedUser:
            return "EDIT_USER"
        case .adminLogin:
            return "ADMIN_LOGIN"
        case .addedDeviceAssocation:
            return "ADD_DEVICE_ASSOCIATION"
        case .changeFolderPermission:
            return "CHANGE_FOLDER_PERMISSION"
        case .failedLogin:
            return "FAILED_LOGIN"
        case .login:
            return "LOGIN"
        case .removedDeviceAssociation:
            return "REMOVE_DEVICE_ASSOCIATION"
        case .deviceTrustCheckFailed:
            return "DEVICE_TRUST_CHECK_FAILED"
        case .termsOfServiceAccepted:
            return "TERMS_OF_SERVICE_ACCEPT"
        case .termsOfServiceRejected:
            return "TERMS_OF_SERVICE_REJECT"
        case .fileMarkedMalicious:
            return "FILE_MARKED_MALICIOUS"
        case .copied:
            return "COPY"
        case .deleted:
            return "DELETE"
        case .downloaded:
            return "DOWNLOAD"
        case .edited:
            return "EDIT"
        case .locked:
            return "LOCK"
        case .moved:
            return "MOVE"
        case .previewed:
            return "PREVIEW"
        case .renamed:
            return "RENAME"
        case .storageExpiration:
            return "STORAGE_EXPIRATION"
        case .undeleted:
            return "UNDELETE"
        case .unlocked:
            return "UNLOCK"
        case .uploaded:
            return "UPLOAD"
        case .shareEnabled:
            return "SHARE"
        case .itemShareUpdated:
            return "ITEM_SHARED_UPDATE"
        case .shareExpirationUpdated:
            return "UPDATE_SHARE_EXPIRATION"
        case .shareExpiration:
            return "SHARE_EXPIRATION"
        case .unshared:
            return "UNSHARE"
        case .collaborationAccepted:
            return "COLLABORATION_ACCEPT"
        case .collaborationRoleChanged:
            return "COLLABORATION_ROLE_CHANGE"
        case .collaborationExpirationExtended:
            return "UPDATE_COLLABORATION_EXPIRATION"
        case .collaborationRemoved:
            return "COLLABORATION_REMOVE"
        case .invitedToCollaboration:
            return "COLLABORATION_INVITE"
        case .collaborationExpiration:
            return "COLLABORATION_EXPIRATION"
        case .loginActivityDeviceAdded:
            return "ADD_LOGIN_ACTIVITY_DEVICE"
        case .loginActivityDeviceRemoved:
            return "REMOVE_LOGIN_ACTIVITY_DEVICE"
        case .userOAuth2AccessTokenCreated:
            return "USER_AUTHENTICATE_OAUTH2_ACCESS_TOKEN_CREATE"
        case .userAdminRoleChanged:
            return "CHANGE_ADMIN_ROLE"
        case .contentWorkflowUploadPolicyViolated:
            return "CONTENT_WORKFLOW_UPLOAD_POLICY_VIOLATION"
        case .metadataInstanceCreated:
            return "METADATA_INSTANCE_CREATE"
        case .matadataInstanceUpdated:
            return "METADATA_INSTANCE_UPDATE"
        case .matadataInstanceDeleted:
            return "METADATA_INSTANCE_DELETE"
        case .taskAssignmentUpdated:
            return "TASK_ASSIGNMENT_UPDATE"
        case .taskAssignmentDeleted:
            return "TASK_ASSIGNMENT_DELETE"
        case .taskUpdated:
            return "TASK_UPDATE"
        case .dataRetentionRemoved:
            return "DATA_RETENTION_REMOVE_RETENTION"
        case .dataRetentionCreated:
            return "DATA_RETENTION_CREATE_RETENTION"
        case .dataRetentionPolicyAssignmentAdded:
            return "RETENTION_POLICY_ASSIGNMENT_ADD"
        case .legalHoldAssignmentCreated:
            return "LEGAL_HOLD_ASSIGNMENT_CREATE"
        case .legalHoldAssignmentDeleted:
            return "LEGAL_HOLD_ASSIGNMENT_DELETE"
        case .legalHoldPolicyCreated:
            return "LEGAL_HOLD_POLICY_CREATE"
        case .legalHoldPolicyUpdated:
            return "LEGAL_HOLD_POLICY_UPDATE"
        case .legalHoldPolicyDeleted:
            return "LEGAL_HOLD_POLICY_DELETE"
        case .sharingPolicyViolation:
            return "CONTENT_WORKFLOW_SHARING_POLICY_VIOLATION"
        case .applicationPublicKeyAdded:
            return "APPLICATION_PUBLIC_KEY_ADDED"
        case .applicationPublicKeyDeleted:
            return "APPLICATION_PUBLIC_KEY_DELETED"
        case .applicationCreated:
            return "APPLICATION_CREATED"
        case .contentPolicyAdded:
            return "CONTENT_WORKFLOW_POLICY_ADD"
        case .automationAdded:
            return "CONTENT_WORKFLOW_AUTOMATION_ADD"
        case .automationDeleted:
            return "CONTENT_WORKFLOW_AUTOMATION_DELETE"
        case .userEmailAliasConfirmed:
            return "EMAIL_ALIAS_CONFIRM"
        case .userEmailAliasRemoved:
            return "EMAIL_ALIAS_REMOVE"
        case .watermarkAdded:
            return "WATERMARK_LABEL_CREATE"
        case .watermarkRemoved:
            return "WATERMARK_LABEL_DELETE"
        case .metadataTemplateCreated:
            return "METADATA_TEMPLATE_CREATE"
        case .metadataTemplateUpdated:
            return "METADATA_TEMPLATE_UPDATE"
        case .metadataTemplateDeleted:
            return "METADATA_TEMPLATE_DELETE"
        case .itemOpened:
            return "ITEM_OPEN"
        case .itemModified:
            return "ITEM_MODIFY"
        case .abnormalDownloadActivity:
            return "CONTENT_WORKFLOW_ABNORMAL_DOWNLOAD_ACTIVITY"
        case .itemsRemovedFromGroup:
            return "GROUP_REMOVE_ITEM"
        case .itemsAddedToGroup:
            return "GROUP_ADD_ITEM"
        case .watermarkedFileDownloaded:
            return "FILE_WATERMARKED_DOWNLOAD"
        case .itemAddedToGroup:
            return "GROUP_ADD_ITEM"
        case let .customValue(value):
            return value
        }
    }

    // swiftlint:enable cyclomatic_complexity
}
