import Foundation

public enum EventEventTypeField: CodableStringEnum {
    case accessGranted
    case accessRevoked
    case addDeviceAssociation
    case addLoginActivityDevice
    case adminLogin
    case applicationCreated
    case applicationPublicKeyAdded
    case applicationPublicKeyDeleted
    case changeAdminRole
    case changeFolderPermission
    case collaborationAccept
    case collaborationExpiration
    case collaborationInvite
    case collaborationRemove
    case collaborationRoleChange
    case collabAddCollaborator
    case collabInviteCollaborator
    case collabRemoveCollaborator
    case collabRoleChange
    case commentCreate
    case commentDelete
    case contentAccess
    case contentWorkflowAbnormalDownloadActivity
    case contentWorkflowAutomationAdd
    case contentWorkflowAutomationDelete
    case contentWorkflowPolicyAdd
    case contentWorkflowSharingPolicyViolation
    case contentWorkflowUploadPolicyViolation
    case copy
    case dataRetentionCreateRetention
    case dataRetentionRemoveRetention
    case delete
    case deleteUser
    case deviceTrustCheckFailed
    case download
    case edit
    case editUser
    case edrCrowdstrikeDeviceDetected
    case edrCrowdstrikeNoBoxTools
    case edrCrowdstrikeBoxToolsOutdated
    case edrCrowdstrikeDriveOutdated
    case edrCrowdstrikeAccessAllowedNoCrowdstrikeDevice
    case edrCrowdstrikeAccessRevoked
    case emailAliasConfirm
    case emailAliasRemove
    case enableTwoFactorAuth
    case enterpriseAppAuthorizationUpdate
    case failedLogin
    case fileMarkedMalicious
    case fileWatermarkedDownload
    case groupAddItem
    case groupAddUser
    case groupCreation
    case groupDeletion
    case groupEdited
    case groupRemoveItem
    case groupRemoveUser
    case itemCopy
    case itemCreate
    case itemDownload
    case itemEmailSend
    case itemMakeCurrentVersion
    case itemModify
    case itemMove
    case itemOpen
    case itemPreview
    case itemRename
    case itemShared
    case itemSharedCreate
    case itemSharedUnshare
    case itemSharedUpdate
    case itemSync
    case itemTrash
    case itemUndeleteViaTrash
    case itemUnsync
    case itemUpload
    case legalHoldAssignmentCreate
    case legalHoldAssignmentDelete
    case legalHoldPolicyCreate
    case legalHoldPolicyDelete
    case legalHoldPolicyUpdate
    case lock
    case lockCreate
    case lockDestroy
    case login
    case masterInviteAccept
    case masterInviteReject
    case metadataInstanceCreate
    case metadataInstanceDelete
    case metadataInstanceUpdate
    case metadataTemplateCreate
    case metadataTemplateDelete
    case metadataTemplateUpdate
    case move
    case newUser
    case preview
    case removeDeviceAssociation
    case removeLoginActivityDevice
    case rename
    case retentionPolicyAssignmentAdd
    case share
    case sharedLinkSend
    case shareExpiration
    case shieldAlert
    case shieldExternalCollabAccessBlocked
    case shieldExternalCollabAccessBlockedMissingJustification
    case shieldExternalCollabInviteBlocked
    case shieldExternalCollabInviteBlockedMissingJustification
    case shieldJustificationApproval
    case shieldSharedLinkAccessBlocked
    case shieldSharedLinkStatusRestrictedOnCreate
    case shieldSharedLinkStatusRestrictedOnUpdate
    case signDocumentAssigned
    case signDocumentCancelled
    case signDocumentCompleted
    case signDocumentConverted
    case signDocumentCreated
    case signDocumentDeclined
    case signDocumentExpired
    case signDocumentSigned
    case signDocumentViewedBySigned
    case signerDownloaded
    case signerForwarded
    case storageExpiration
    case tagItemCreate
    case taskAssignmentCreate
    case taskAssignmentDelete
    case taskAssignmentUpdate
    case taskCreate
    case taskUpdate
    case termsOfServiceAccept
    case termsOfServiceReject
    case undelete
    case unlock
    case unshare
    case updateCollaborationExpiration
    case updateShareExpiration
    case upload
    case userAuthenticateOauth2AccessTokenCreate
    case watermarkLabelCreate
    case watermarkLabelDelete
    case customValue(String)

    public init(rawValue value: String) {
        switch value.lowercased() {
        case "ACCESS_GRANTED".lowercased():
            self = .accessGranted
        case "ACCESS_REVOKED".lowercased():
            self = .accessRevoked
        case "ADD_DEVICE_ASSOCIATION".lowercased():
            self = .addDeviceAssociation
        case "ADD_LOGIN_ACTIVITY_DEVICE".lowercased():
            self = .addLoginActivityDevice
        case "ADMIN_LOGIN".lowercased():
            self = .adminLogin
        case "APPLICATION_CREATED".lowercased():
            self = .applicationCreated
        case "APPLICATION_PUBLIC_KEY_ADDED".lowercased():
            self = .applicationPublicKeyAdded
        case "APPLICATION_PUBLIC_KEY_DELETED".lowercased():
            self = .applicationPublicKeyDeleted
        case "CHANGE_ADMIN_ROLE".lowercased():
            self = .changeAdminRole
        case "CHANGE_FOLDER_PERMISSION".lowercased():
            self = .changeFolderPermission
        case "COLLABORATION_ACCEPT".lowercased():
            self = .collaborationAccept
        case "COLLABORATION_EXPIRATION".lowercased():
            self = .collaborationExpiration
        case "COLLABORATION_INVITE".lowercased():
            self = .collaborationInvite
        case "COLLABORATION_REMOVE".lowercased():
            self = .collaborationRemove
        case "COLLABORATION_ROLE_CHANGE".lowercased():
            self = .collaborationRoleChange
        case "COLLAB_ADD_COLLABORATOR".lowercased():
            self = .collabAddCollaborator
        case "COLLAB_INVITE_COLLABORATOR".lowercased():
            self = .collabInviteCollaborator
        case "COLLAB_REMOVE_COLLABORATOR".lowercased():
            self = .collabRemoveCollaborator
        case "COLLAB_ROLE_CHANGE".lowercased():
            self = .collabRoleChange
        case "COMMENT_CREATE".lowercased():
            self = .commentCreate
        case "COMMENT_DELETE".lowercased():
            self = .commentDelete
        case "CONTENT_ACCESS".lowercased():
            self = .contentAccess
        case "CONTENT_WORKFLOW_ABNORMAL_DOWNLOAD_ACTIVITY".lowercased():
            self = .contentWorkflowAbnormalDownloadActivity
        case "CONTENT_WORKFLOW_AUTOMATION_ADD".lowercased():
            self = .contentWorkflowAutomationAdd
        case "CONTENT_WORKFLOW_AUTOMATION_DELETE".lowercased():
            self = .contentWorkflowAutomationDelete
        case "CONTENT_WORKFLOW_POLICY_ADD".lowercased():
            self = .contentWorkflowPolicyAdd
        case "CONTENT_WORKFLOW_SHARING_POLICY_VIOLATION".lowercased():
            self = .contentWorkflowSharingPolicyViolation
        case "CONTENT_WORKFLOW_UPLOAD_POLICY_VIOLATION".lowercased():
            self = .contentWorkflowUploadPolicyViolation
        case "COPY".lowercased():
            self = .copy
        case "DATA_RETENTION_CREATE_RETENTION".lowercased():
            self = .dataRetentionCreateRetention
        case "DATA_RETENTION_REMOVE_RETENTION".lowercased():
            self = .dataRetentionRemoveRetention
        case "DELETE".lowercased():
            self = .delete
        case "DELETE_USER".lowercased():
            self = .deleteUser
        case "DEVICE_TRUST_CHECK_FAILED".lowercased():
            self = .deviceTrustCheckFailed
        case "DOWNLOAD".lowercased():
            self = .download
        case "EDIT".lowercased():
            self = .edit
        case "EDIT_USER".lowercased():
            self = .editUser
        case "EDR_CROWDSTRIKE_DEVICE_DETECTED".lowercased():
            self = .edrCrowdstrikeDeviceDetected
        case "EDR_CROWDSTRIKE_NO_BOX_TOOLS".lowercased():
            self = .edrCrowdstrikeNoBoxTools
        case "EDR_CROWDSTRIKE_BOX_TOOLS_OUTDATED".lowercased():
            self = .edrCrowdstrikeBoxToolsOutdated
        case "EDR_CROWDSTRIKE_DRIVE_OUTDATED".lowercased():
            self = .edrCrowdstrikeDriveOutdated
        case "EDR_CROWDSTRIKE_ACCESS_ALLOWED_NO_CROWDSTRIKE_DEVICE".lowercased():
            self = .edrCrowdstrikeAccessAllowedNoCrowdstrikeDevice
        case "EDR_CROWDSTRIKE_ACCESS_REVOKED".lowercased():
            self = .edrCrowdstrikeAccessRevoked
        case "EMAIL_ALIAS_CONFIRM".lowercased():
            self = .emailAliasConfirm
        case "EMAIL_ALIAS_REMOVE".lowercased():
            self = .emailAliasRemove
        case "ENABLE_TWO_FACTOR_AUTH".lowercased():
            self = .enableTwoFactorAuth
        case "ENTERPRISE_APP_AUTHORIZATION_UPDATE".lowercased():
            self = .enterpriseAppAuthorizationUpdate
        case "FAILED_LOGIN".lowercased():
            self = .failedLogin
        case "FILE_MARKED_MALICIOUS".lowercased():
            self = .fileMarkedMalicious
        case "FILE_WATERMARKED_DOWNLOAD".lowercased():
            self = .fileWatermarkedDownload
        case "GROUP_ADD_ITEM".lowercased():
            self = .groupAddItem
        case "GROUP_ADD_USER".lowercased():
            self = .groupAddUser
        case "GROUP_CREATION".lowercased():
            self = .groupCreation
        case "GROUP_DELETION".lowercased():
            self = .groupDeletion
        case "GROUP_EDITED".lowercased():
            self = .groupEdited
        case "GROUP_REMOVE_ITEM".lowercased():
            self = .groupRemoveItem
        case "GROUP_REMOVE_USER".lowercased():
            self = .groupRemoveUser
        case "ITEM_COPY".lowercased():
            self = .itemCopy
        case "ITEM_CREATE".lowercased():
            self = .itemCreate
        case "ITEM_DOWNLOAD".lowercased():
            self = .itemDownload
        case "ITEM_EMAIL_SEND".lowercased():
            self = .itemEmailSend
        case "ITEM_MAKE_CURRENT_VERSION".lowercased():
            self = .itemMakeCurrentVersion
        case "ITEM_MODIFY".lowercased():
            self = .itemModify
        case "ITEM_MOVE".lowercased():
            self = .itemMove
        case "ITEM_OPEN".lowercased():
            self = .itemOpen
        case "ITEM_PREVIEW".lowercased():
            self = .itemPreview
        case "ITEM_RENAME".lowercased():
            self = .itemRename
        case "ITEM_SHARED".lowercased():
            self = .itemShared
        case "ITEM_SHARED_CREATE".lowercased():
            self = .itemSharedCreate
        case "ITEM_SHARED_UNSHARE".lowercased():
            self = .itemSharedUnshare
        case "ITEM_SHARED_UPDATE".lowercased():
            self = .itemSharedUpdate
        case "ITEM_SYNC".lowercased():
            self = .itemSync
        case "ITEM_TRASH".lowercased():
            self = .itemTrash
        case "ITEM_UNDELETE_VIA_TRASH".lowercased():
            self = .itemUndeleteViaTrash
        case "ITEM_UNSYNC".lowercased():
            self = .itemUnsync
        case "ITEM_UPLOAD".lowercased():
            self = .itemUpload
        case "LEGAL_HOLD_ASSIGNMENT_CREATE".lowercased():
            self = .legalHoldAssignmentCreate
        case "LEGAL_HOLD_ASSIGNMENT_DELETE".lowercased():
            self = .legalHoldAssignmentDelete
        case "LEGAL_HOLD_POLICY_CREATE".lowercased():
            self = .legalHoldPolicyCreate
        case "LEGAL_HOLD_POLICY_DELETE".lowercased():
            self = .legalHoldPolicyDelete
        case "LEGAL_HOLD_POLICY_UPDATE".lowercased():
            self = .legalHoldPolicyUpdate
        case "LOCK".lowercased():
            self = .lock
        case "LOCK_CREATE".lowercased():
            self = .lockCreate
        case "LOCK_DESTROY".lowercased():
            self = .lockDestroy
        case "LOGIN".lowercased():
            self = .login
        case "MASTER_INVITE_ACCEPT".lowercased():
            self = .masterInviteAccept
        case "MASTER_INVITE_REJECT".lowercased():
            self = .masterInviteReject
        case "METADATA_INSTANCE_CREATE".lowercased():
            self = .metadataInstanceCreate
        case "METADATA_INSTANCE_DELETE".lowercased():
            self = .metadataInstanceDelete
        case "METADATA_INSTANCE_UPDATE".lowercased():
            self = .metadataInstanceUpdate
        case "METADATA_TEMPLATE_CREATE".lowercased():
            self = .metadataTemplateCreate
        case "METADATA_TEMPLATE_DELETE".lowercased():
            self = .metadataTemplateDelete
        case "METADATA_TEMPLATE_UPDATE".lowercased():
            self = .metadataTemplateUpdate
        case "MOVE".lowercased():
            self = .move
        case "NEW_USER".lowercased():
            self = .newUser
        case "PREVIEW".lowercased():
            self = .preview
        case "REMOVE_DEVICE_ASSOCIATION".lowercased():
            self = .removeDeviceAssociation
        case "REMOVE_LOGIN_ACTIVITY_DEVICE".lowercased():
            self = .removeLoginActivityDevice
        case "RENAME".lowercased():
            self = .rename
        case "RETENTION_POLICY_ASSIGNMENT_ADD".lowercased():
            self = .retentionPolicyAssignmentAdd
        case "SHARE".lowercased():
            self = .share
        case "SHARED_LINK_SEND".lowercased():
            self = .sharedLinkSend
        case "SHARE_EXPIRATION".lowercased():
            self = .shareExpiration
        case "SHIELD_ALERT".lowercased():
            self = .shieldAlert
        case "SHIELD_EXTERNAL_COLLAB_ACCESS_BLOCKED".lowercased():
            self = .shieldExternalCollabAccessBlocked
        case "SHIELD_EXTERNAL_COLLAB_ACCESS_BLOCKED_MISSING_JUSTIFICATION".lowercased():
            self = .shieldExternalCollabAccessBlockedMissingJustification
        case "SHIELD_EXTERNAL_COLLAB_INVITE_BLOCKED".lowercased():
            self = .shieldExternalCollabInviteBlocked
        case "SHIELD_EXTERNAL_COLLAB_INVITE_BLOCKED_MISSING_JUSTIFICATION".lowercased():
            self = .shieldExternalCollabInviteBlockedMissingJustification
        case "SHIELD_JUSTIFICATION_APPROVAL".lowercased():
            self = .shieldJustificationApproval
        case "SHIELD_SHARED_LINK_ACCESS_BLOCKED".lowercased():
            self = .shieldSharedLinkAccessBlocked
        case "SHIELD_SHARED_LINK_STATUS_RESTRICTED_ON_CREATE".lowercased():
            self = .shieldSharedLinkStatusRestrictedOnCreate
        case "SHIELD_SHARED_LINK_STATUS_RESTRICTED_ON_UPDATE".lowercased():
            self = .shieldSharedLinkStatusRestrictedOnUpdate
        case "SIGN_DOCUMENT_ASSIGNED".lowercased():
            self = .signDocumentAssigned
        case "SIGN_DOCUMENT_CANCELLED".lowercased():
            self = .signDocumentCancelled
        case "SIGN_DOCUMENT_COMPLETED".lowercased():
            self = .signDocumentCompleted
        case "SIGN_DOCUMENT_CONVERTED".lowercased():
            self = .signDocumentConverted
        case "SIGN_DOCUMENT_CREATED".lowercased():
            self = .signDocumentCreated
        case "SIGN_DOCUMENT_DECLINED".lowercased():
            self = .signDocumentDeclined
        case "SIGN_DOCUMENT_EXPIRED".lowercased():
            self = .signDocumentExpired
        case "SIGN_DOCUMENT_SIGNED".lowercased():
            self = .signDocumentSigned
        case "SIGN_DOCUMENT_VIEWED_BY_SIGNED".lowercased():
            self = .signDocumentViewedBySigned
        case "SIGNER_DOWNLOADED".lowercased():
            self = .signerDownloaded
        case "SIGNER_FORWARDED".lowercased():
            self = .signerForwarded
        case "STORAGE_EXPIRATION".lowercased():
            self = .storageExpiration
        case "TAG_ITEM_CREATE".lowercased():
            self = .tagItemCreate
        case "TASK_ASSIGNMENT_CREATE".lowercased():
            self = .taskAssignmentCreate
        case "TASK_ASSIGNMENT_DELETE".lowercased():
            self = .taskAssignmentDelete
        case "TASK_ASSIGNMENT_UPDATE".lowercased():
            self = .taskAssignmentUpdate
        case "TASK_CREATE".lowercased():
            self = .taskCreate
        case "TASK_UPDATE".lowercased():
            self = .taskUpdate
        case "TERMS_OF_SERVICE_ACCEPT".lowercased():
            self = .termsOfServiceAccept
        case "TERMS_OF_SERVICE_REJECT".lowercased():
            self = .termsOfServiceReject
        case "UNDELETE".lowercased():
            self = .undelete
        case "UNLOCK".lowercased():
            self = .unlock
        case "UNSHARE".lowercased():
            self = .unshare
        case "UPDATE_COLLABORATION_EXPIRATION".lowercased():
            self = .updateCollaborationExpiration
        case "UPDATE_SHARE_EXPIRATION".lowercased():
            self = .updateShareExpiration
        case "UPLOAD".lowercased():
            self = .upload
        case "USER_AUTHENTICATE_OAUTH2_ACCESS_TOKEN_CREATE".lowercased():
            self = .userAuthenticateOauth2AccessTokenCreate
        case "WATERMARK_LABEL_CREATE".lowercased():
            self = .watermarkLabelCreate
        case "WATERMARK_LABEL_DELETE".lowercased():
            self = .watermarkLabelDelete
        default:
            self = .customValue(value)
        }
    }

    public var rawValue: String {
        switch self {
        case .accessGranted:
            return "ACCESS_GRANTED"
        case .accessRevoked:
            return "ACCESS_REVOKED"
        case .addDeviceAssociation:
            return "ADD_DEVICE_ASSOCIATION"
        case .addLoginActivityDevice:
            return "ADD_LOGIN_ACTIVITY_DEVICE"
        case .adminLogin:
            return "ADMIN_LOGIN"
        case .applicationCreated:
            return "APPLICATION_CREATED"
        case .applicationPublicKeyAdded:
            return "APPLICATION_PUBLIC_KEY_ADDED"
        case .applicationPublicKeyDeleted:
            return "APPLICATION_PUBLIC_KEY_DELETED"
        case .changeAdminRole:
            return "CHANGE_ADMIN_ROLE"
        case .changeFolderPermission:
            return "CHANGE_FOLDER_PERMISSION"
        case .collaborationAccept:
            return "COLLABORATION_ACCEPT"
        case .collaborationExpiration:
            return "COLLABORATION_EXPIRATION"
        case .collaborationInvite:
            return "COLLABORATION_INVITE"
        case .collaborationRemove:
            return "COLLABORATION_REMOVE"
        case .collaborationRoleChange:
            return "COLLABORATION_ROLE_CHANGE"
        case .collabAddCollaborator:
            return "COLLAB_ADD_COLLABORATOR"
        case .collabInviteCollaborator:
            return "COLLAB_INVITE_COLLABORATOR"
        case .collabRemoveCollaborator:
            return "COLLAB_REMOVE_COLLABORATOR"
        case .collabRoleChange:
            return "COLLAB_ROLE_CHANGE"
        case .commentCreate:
            return "COMMENT_CREATE"
        case .commentDelete:
            return "COMMENT_DELETE"
        case .contentAccess:
            return "CONTENT_ACCESS"
        case .contentWorkflowAbnormalDownloadActivity:
            return "CONTENT_WORKFLOW_ABNORMAL_DOWNLOAD_ACTIVITY"
        case .contentWorkflowAutomationAdd:
            return "CONTENT_WORKFLOW_AUTOMATION_ADD"
        case .contentWorkflowAutomationDelete:
            return "CONTENT_WORKFLOW_AUTOMATION_DELETE"
        case .contentWorkflowPolicyAdd:
            return "CONTENT_WORKFLOW_POLICY_ADD"
        case .contentWorkflowSharingPolicyViolation:
            return "CONTENT_WORKFLOW_SHARING_POLICY_VIOLATION"
        case .contentWorkflowUploadPolicyViolation:
            return "CONTENT_WORKFLOW_UPLOAD_POLICY_VIOLATION"
        case .copy:
            return "COPY"
        case .dataRetentionCreateRetention:
            return "DATA_RETENTION_CREATE_RETENTION"
        case .dataRetentionRemoveRetention:
            return "DATA_RETENTION_REMOVE_RETENTION"
        case .delete:
            return "DELETE"
        case .deleteUser:
            return "DELETE_USER"
        case .deviceTrustCheckFailed:
            return "DEVICE_TRUST_CHECK_FAILED"
        case .download:
            return "DOWNLOAD"
        case .edit:
            return "EDIT"
        case .editUser:
            return "EDIT_USER"
        case .edrCrowdstrikeDeviceDetected:
            return "EDR_CROWDSTRIKE_DEVICE_DETECTED"
        case .edrCrowdstrikeNoBoxTools:
            return "EDR_CROWDSTRIKE_NO_BOX_TOOLS"
        case .edrCrowdstrikeBoxToolsOutdated:
            return "EDR_CROWDSTRIKE_BOX_TOOLS_OUTDATED"
        case .edrCrowdstrikeDriveOutdated:
            return "EDR_CROWDSTRIKE_DRIVE_OUTDATED"
        case .edrCrowdstrikeAccessAllowedNoCrowdstrikeDevice:
            return "EDR_CROWDSTRIKE_ACCESS_ALLOWED_NO_CROWDSTRIKE_DEVICE"
        case .edrCrowdstrikeAccessRevoked:
            return "EDR_CROWDSTRIKE_ACCESS_REVOKED"
        case .emailAliasConfirm:
            return "EMAIL_ALIAS_CONFIRM"
        case .emailAliasRemove:
            return "EMAIL_ALIAS_REMOVE"
        case .enableTwoFactorAuth:
            return "ENABLE_TWO_FACTOR_AUTH"
        case .enterpriseAppAuthorizationUpdate:
            return "ENTERPRISE_APP_AUTHORIZATION_UPDATE"
        case .failedLogin:
            return "FAILED_LOGIN"
        case .fileMarkedMalicious:
            return "FILE_MARKED_MALICIOUS"
        case .fileWatermarkedDownload:
            return "FILE_WATERMARKED_DOWNLOAD"
        case .groupAddItem:
            return "GROUP_ADD_ITEM"
        case .groupAddUser:
            return "GROUP_ADD_USER"
        case .groupCreation:
            return "GROUP_CREATION"
        case .groupDeletion:
            return "GROUP_DELETION"
        case .groupEdited:
            return "GROUP_EDITED"
        case .groupRemoveItem:
            return "GROUP_REMOVE_ITEM"
        case .groupRemoveUser:
            return "GROUP_REMOVE_USER"
        case .itemCopy:
            return "ITEM_COPY"
        case .itemCreate:
            return "ITEM_CREATE"
        case .itemDownload:
            return "ITEM_DOWNLOAD"
        case .itemEmailSend:
            return "ITEM_EMAIL_SEND"
        case .itemMakeCurrentVersion:
            return "ITEM_MAKE_CURRENT_VERSION"
        case .itemModify:
            return "ITEM_MODIFY"
        case .itemMove:
            return "ITEM_MOVE"
        case .itemOpen:
            return "ITEM_OPEN"
        case .itemPreview:
            return "ITEM_PREVIEW"
        case .itemRename:
            return "ITEM_RENAME"
        case .itemShared:
            return "ITEM_SHARED"
        case .itemSharedCreate:
            return "ITEM_SHARED_CREATE"
        case .itemSharedUnshare:
            return "ITEM_SHARED_UNSHARE"
        case .itemSharedUpdate:
            return "ITEM_SHARED_UPDATE"
        case .itemSync:
            return "ITEM_SYNC"
        case .itemTrash:
            return "ITEM_TRASH"
        case .itemUndeleteViaTrash:
            return "ITEM_UNDELETE_VIA_TRASH"
        case .itemUnsync:
            return "ITEM_UNSYNC"
        case .itemUpload:
            return "ITEM_UPLOAD"
        case .legalHoldAssignmentCreate:
            return "LEGAL_HOLD_ASSIGNMENT_CREATE"
        case .legalHoldAssignmentDelete:
            return "LEGAL_HOLD_ASSIGNMENT_DELETE"
        case .legalHoldPolicyCreate:
            return "LEGAL_HOLD_POLICY_CREATE"
        case .legalHoldPolicyDelete:
            return "LEGAL_HOLD_POLICY_DELETE"
        case .legalHoldPolicyUpdate:
            return "LEGAL_HOLD_POLICY_UPDATE"
        case .lock:
            return "LOCK"
        case .lockCreate:
            return "LOCK_CREATE"
        case .lockDestroy:
            return "LOCK_DESTROY"
        case .login:
            return "LOGIN"
        case .masterInviteAccept:
            return "MASTER_INVITE_ACCEPT"
        case .masterInviteReject:
            return "MASTER_INVITE_REJECT"
        case .metadataInstanceCreate:
            return "METADATA_INSTANCE_CREATE"
        case .metadataInstanceDelete:
            return "METADATA_INSTANCE_DELETE"
        case .metadataInstanceUpdate:
            return "METADATA_INSTANCE_UPDATE"
        case .metadataTemplateCreate:
            return "METADATA_TEMPLATE_CREATE"
        case .metadataTemplateDelete:
            return "METADATA_TEMPLATE_DELETE"
        case .metadataTemplateUpdate:
            return "METADATA_TEMPLATE_UPDATE"
        case .move:
            return "MOVE"
        case .newUser:
            return "NEW_USER"
        case .preview:
            return "PREVIEW"
        case .removeDeviceAssociation:
            return "REMOVE_DEVICE_ASSOCIATION"
        case .removeLoginActivityDevice:
            return "REMOVE_LOGIN_ACTIVITY_DEVICE"
        case .rename:
            return "RENAME"
        case .retentionPolicyAssignmentAdd:
            return "RETENTION_POLICY_ASSIGNMENT_ADD"
        case .share:
            return "SHARE"
        case .sharedLinkSend:
            return "SHARED_LINK_SEND"
        case .shareExpiration:
            return "SHARE_EXPIRATION"
        case .shieldAlert:
            return "SHIELD_ALERT"
        case .shieldExternalCollabAccessBlocked:
            return "SHIELD_EXTERNAL_COLLAB_ACCESS_BLOCKED"
        case .shieldExternalCollabAccessBlockedMissingJustification:
            return "SHIELD_EXTERNAL_COLLAB_ACCESS_BLOCKED_MISSING_JUSTIFICATION"
        case .shieldExternalCollabInviteBlocked:
            return "SHIELD_EXTERNAL_COLLAB_INVITE_BLOCKED"
        case .shieldExternalCollabInviteBlockedMissingJustification:
            return "SHIELD_EXTERNAL_COLLAB_INVITE_BLOCKED_MISSING_JUSTIFICATION"
        case .shieldJustificationApproval:
            return "SHIELD_JUSTIFICATION_APPROVAL"
        case .shieldSharedLinkAccessBlocked:
            return "SHIELD_SHARED_LINK_ACCESS_BLOCKED"
        case .shieldSharedLinkStatusRestrictedOnCreate:
            return "SHIELD_SHARED_LINK_STATUS_RESTRICTED_ON_CREATE"
        case .shieldSharedLinkStatusRestrictedOnUpdate:
            return "SHIELD_SHARED_LINK_STATUS_RESTRICTED_ON_UPDATE"
        case .signDocumentAssigned:
            return "SIGN_DOCUMENT_ASSIGNED"
        case .signDocumentCancelled:
            return "SIGN_DOCUMENT_CANCELLED"
        case .signDocumentCompleted:
            return "SIGN_DOCUMENT_COMPLETED"
        case .signDocumentConverted:
            return "SIGN_DOCUMENT_CONVERTED"
        case .signDocumentCreated:
            return "SIGN_DOCUMENT_CREATED"
        case .signDocumentDeclined:
            return "SIGN_DOCUMENT_DECLINED"
        case .signDocumentExpired:
            return "SIGN_DOCUMENT_EXPIRED"
        case .signDocumentSigned:
            return "SIGN_DOCUMENT_SIGNED"
        case .signDocumentViewedBySigned:
            return "SIGN_DOCUMENT_VIEWED_BY_SIGNED"
        case .signerDownloaded:
            return "SIGNER_DOWNLOADED"
        case .signerForwarded:
            return "SIGNER_FORWARDED"
        case .storageExpiration:
            return "STORAGE_EXPIRATION"
        case .tagItemCreate:
            return "TAG_ITEM_CREATE"
        case .taskAssignmentCreate:
            return "TASK_ASSIGNMENT_CREATE"
        case .taskAssignmentDelete:
            return "TASK_ASSIGNMENT_DELETE"
        case .taskAssignmentUpdate:
            return "TASK_ASSIGNMENT_UPDATE"
        case .taskCreate:
            return "TASK_CREATE"
        case .taskUpdate:
            return "TASK_UPDATE"
        case .termsOfServiceAccept:
            return "TERMS_OF_SERVICE_ACCEPT"
        case .termsOfServiceReject:
            return "TERMS_OF_SERVICE_REJECT"
        case .undelete:
            return "UNDELETE"
        case .unlock:
            return "UNLOCK"
        case .unshare:
            return "UNSHARE"
        case .updateCollaborationExpiration:
            return "UPDATE_COLLABORATION_EXPIRATION"
        case .updateShareExpiration:
            return "UPDATE_SHARE_EXPIRATION"
        case .upload:
            return "UPLOAD"
        case .userAuthenticateOauth2AccessTokenCreate:
            return "USER_AUTHENTICATE_OAUTH2_ACCESS_TOKEN_CREATE"
        case .watermarkLabelCreate:
            return "WATERMARK_LABEL_CREATE"
        case .watermarkLabelDelete:
            return "WATERMARK_LABEL_DELETE"
        case .customValue(let value):
            return value
        }
    }

}
