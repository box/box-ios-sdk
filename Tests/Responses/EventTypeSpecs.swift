//
//  EventTypeSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 22/09/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class EventTypeSpecs: QuickSpec {

    override func spec() {
        describe("EventType") {

            describe("init()") {

                it("should correctly create an enum value from it's string representation") {
                    expect(EventType.itemCreated).to(equal(EventType(EventType.itemCreated.description)))
                    expect(EventType.itemUploaded).to(equal(EventType(EventType.itemUploaded.description)))
                    expect(EventType.commentCreated).to(equal(EventType(EventType.commentCreated.description)))
                    expect(EventType.commentDeleted).to(equal(EventType(EventType.commentDeleted.description)))
                    expect(EventType.itemDownloaded).to(equal(EventType(EventType.itemDownloaded.description)))
                    expect(EventType.itemPreviewed).to(equal(EventType(EventType.itemPreviewed.description)))
                    expect(EventType.itemMoved).to(equal(EventType(EventType.itemMoved.description)))
                    expect(EventType.itemCopied).to(equal(EventType(EventType.itemCopied.description)))
                    expect(EventType.taskAssigned).to(equal(EventType(EventType.taskAssigned.description)))
                    expect(EventType.taskCreated).to(equal(EventType(EventType.taskCreated.description)))
                    expect(EventType.fileLocked).to(equal(EventType(EventType.fileLocked.description)))
                    expect(EventType.fileUnlocked).to(equal(EventType(EventType.fileUnlocked.description)))
                    expect(EventType.itemDeleted).to(equal(EventType(EventType.itemDeleted.description)))
                    expect(EventType.itemRecovered).to(equal(EventType(EventType.itemRecovered.description)))
                    expect(EventType.collaboratorAdded).to(equal(EventType(EventType.collaboratorAdded.description)))
                    expect(EventType.collaboratorRoleChanged).to(equal(EventType(EventType.collaboratorRoleChanged.description)))
                    expect(EventType.collaboratorInvited).to(equal(EventType(EventType.collaboratorInvited.description)))
                    expect(EventType.collaboratorRemoved).to(equal(EventType(EventType.collaboratorRemoved.description)))
                    expect(EventType.itemSync).to(equal(EventType(EventType.itemSync.description)))
                    expect(EventType.itemUnsync).to(equal(EventType(EventType.itemUnsync.description)))
                    expect(EventType.itemRenamed).to(equal(EventType(EventType.itemRenamed.description)))
                    expect(EventType.itemEnabledForSharing).to(equal(EventType(EventType.itemEnabledForSharing.description)))
                    expect(EventType.itemDisabledForSharing).to(equal(EventType(EventType.itemDisabledForSharing.description)))
                    expect(EventType.itemShared).to(equal(EventType(EventType.itemShared.description)))
                    expect(EventType.itemMadeCurrentVersion).to(equal(EventType(EventType.itemMadeCurrentVersion.description)))
                    expect(EventType.tagAdded).to(equal(EventType(EventType.tagAdded.description)))
                    expect(EventType.twoFactorEnabled).to(equal(EventType(EventType.twoFactorEnabled.description)))
                    expect(EventType.adminInviteAccepted).to(equal(EventType(EventType.adminInviteAccepted.description)))
                    expect(EventType.adminInviteRejected).to(equal(EventType(EventType.adminInviteRejected.description)))
                    expect(EventType.accessGranted).to(equal(EventType(EventType.accessGranted.description)))
                    expect(EventType.accessRevoked).to(equal(EventType(EventType.accessRevoked.description)))
                    expect(EventType.addedUserToGroup).to(equal(EventType(EventType.addedUserToGroup.description)))
                    expect(EventType.removedUserFromGroup).to(equal(EventType(EventType.removedUserFromGroup.description)))
                    expect(EventType.createdUser).to(equal(EventType(EventType.createdUser.description)))
                    expect(EventType.createdGroup).to(equal(EventType(EventType.createdGroup.description)))
                    expect(EventType.deletedGroup).to(equal(EventType(EventType.deletedGroup.description)))
                    expect(EventType.deletedUser).to(equal(EventType(EventType.deletedUser.description)))
                    expect(EventType.editedGroup).to(equal(EventType(EventType.editedGroup.description)))
                    expect(EventType.editedUser).to(equal(EventType(EventType.editedUser.description)))
                    expect(EventType.adminLogin).to(equal(EventType(EventType.adminLogin.description)))
                    expect(EventType.addedDeviceAssocation).to(equal(EventType(EventType.addedDeviceAssocation.description)))
                    expect(EventType.changeFolderPermission).to(equal(EventType(EventType.changeFolderPermission.description)))
                    expect(EventType.failedLogin).to(equal(EventType(EventType.failedLogin.description)))
                    expect(EventType.login).to(equal(EventType(EventType.login.description)))
                    expect(EventType.removedDeviceAssociation).to(equal(EventType(EventType.removedDeviceAssociation.description)))
                    expect(EventType.deviceTrustCheckFailed).to(equal(EventType(EventType.deviceTrustCheckFailed.description)))
                    expect(EventType.termsOfServiceAccepted).to(equal(EventType(EventType.termsOfServiceAccepted.description)))
                    expect(EventType.termsOfServiceRejected).to(equal(EventType(EventType.termsOfServiceRejected.description)))
                    expect(EventType.fileMarkedMalicious).to(equal(EventType(EventType.fileMarkedMalicious.description)))
                    expect(EventType.copied).to(equal(EventType(EventType.copied.description)))
                    expect(EventType.deleted).to(equal(EventType(EventType.deleted.description)))
                    expect(EventType.downloaded).to(equal(EventType(EventType.downloaded.description)))
                    expect(EventType.edited).to(equal(EventType(EventType.edited.description)))
                    expect(EventType.locked).to(equal(EventType(EventType.locked.description)))
                    expect(EventType.moved).to(equal(EventType(EventType.moved.description)))
                    expect(EventType.previewed).to(equal(EventType(EventType.previewed.description)))
                    expect(EventType.renamed).to(equal(EventType(EventType.renamed.description)))
                    expect(EventType.storageExpiration).to(equal(EventType(EventType.storageExpiration.description)))
                    expect(EventType.undeleted).to(equal(EventType(EventType.undeleted.description)))
                    expect(EventType.unlocked).to(equal(EventType(EventType.unlocked.description)))
                    expect(EventType.uploaded).to(equal(EventType(EventType.uploaded.description)))
                    expect(EventType.shareEnabled).to(equal(EventType(EventType.shareEnabled.description)))
                    expect(EventType.itemShareUpdated).to(equal(EventType(EventType.itemShareUpdated.description)))
                    expect(EventType.shareExpirationUpdated).to(equal(EventType(EventType.shareExpirationUpdated.description)))
                    expect(EventType.shareExpiration).to(equal(EventType(EventType.shareExpiration.description)))
                    expect(EventType.unshared).to(equal(EventType(EventType.unshared.description)))
                    expect(EventType.collaborationAccepted).to(equal(EventType(EventType.collaborationAccepted.description)))
                    expect(EventType.collaborationRoleChanged).to(equal(EventType(EventType.collaborationRoleChanged.description)))
                    expect(EventType.collaborationExpirationExtended).to(equal(EventType(EventType.collaborationExpirationExtended.description)))
                    expect(EventType.collaborationRemoved).to(equal(EventType(EventType.collaborationRemoved.description)))
                    expect(EventType.invitedToCollaboration).to(equal(EventType(EventType.invitedToCollaboration.description)))
                    expect(EventType.collaborationExpiration).to(equal(EventType(EventType.collaborationExpiration.description)))
                    expect(EventType.loginActivityDeviceAdded).to(equal(EventType(EventType.loginActivityDeviceAdded.description)))
                    expect(EventType.loginActivityDeviceRemoved).to(equal(EventType(EventType.loginActivityDeviceRemoved.description)))
                    expect(EventType.userOAuth2AccessTokenCreated).to(equal(EventType(EventType.userOAuth2AccessTokenCreated.description)))
                    expect(EventType.userAdminRoleChanged).to(equal(EventType(EventType.userAdminRoleChanged.description)))
                    expect(EventType.contentWorkflowUploadPolicyViolated).to(equal(EventType(EventType.contentWorkflowUploadPolicyViolated.description)))
                    expect(EventType.metadataInstanceCreated).to(equal(EventType(EventType.metadataInstanceCreated.description)))
                    expect(EventType.matadataInstanceUpdated).to(equal(EventType(EventType.matadataInstanceUpdated.description)))
                    expect(EventType.matadataInstanceDeleted).to(equal(EventType(EventType.matadataInstanceDeleted.description)))
                    expect(EventType.taskAssignmentUpdated).to(equal(EventType(EventType.taskAssignmentUpdated.description)))
                    expect(EventType.taskAssignmentDeleted).to(equal(EventType(EventType.taskAssignmentDeleted.description)))
                    expect(EventType.taskUpdated).to(equal(EventType(EventType.taskUpdated.description)))
                    expect(EventType.itemAddedToGroup).to(equal(EventType(EventType.itemAddedToGroup.description)))
                    expect(EventType.dataRetentionRemoved).to(equal(EventType(EventType.dataRetentionRemoved.description)))
                    expect(EventType.dataRetentionCreated).to(equal(EventType(EventType.dataRetentionCreated.description)))
                    expect(EventType.dataRetentionPolicyAssignmentAdded).to(equal(EventType(EventType.dataRetentionPolicyAssignmentAdded.description)))
                    expect(EventType.legalHoldAssignmentCreated).to(equal(EventType(EventType.legalHoldAssignmentCreated.description)))
                    expect(EventType.legalHoldAssignmentDeleted).to(equal(EventType(EventType.legalHoldAssignmentDeleted.description)))
                    expect(EventType.legalHoldPolicyCreated).to(equal(EventType(EventType.legalHoldPolicyCreated.description)))
                    expect(EventType.legalHoldPolicyUpdated).to(equal(EventType(EventType.legalHoldPolicyUpdated.description)))
                    expect(EventType.legalHoldPolicyDeleted).to(equal(EventType(EventType.legalHoldPolicyDeleted.description)))
                    expect(EventType.sharingPolicyViolation).to(equal(EventType(EventType.sharingPolicyViolation.description)))
                    expect(EventType.applicationPublicKeyAdded).to(equal(EventType(EventType.applicationPublicKeyAdded.description)))
                    expect(EventType.applicationPublicKeyDeleted).to(equal(EventType(EventType.applicationPublicKeyDeleted.description)))
                    expect(EventType.applicationCreated).to(equal(EventType(EventType.applicationCreated.description)))
                    expect(EventType.contentPolicyAdded).to(equal(EventType(EventType.contentPolicyAdded.description)))
                    expect(EventType.automationAdded).to(equal(EventType(EventType.automationAdded.description)))
                    expect(EventType.automationDeleted).to(equal(EventType(EventType.automationDeleted.description)))
                    expect(EventType.userEmailAliasConfirmed).to(equal(EventType(EventType.userEmailAliasConfirmed.description)))
                    expect(EventType.userEmailAliasRemoved).to(equal(EventType(EventType.userEmailAliasRemoved.description)))
                    expect(EventType.watermarkAdded).to(equal(EventType(EventType.watermarkAdded.description)))
                    expect(EventType.watermarkRemoved).to(equal(EventType(EventType.watermarkRemoved.description)))
                    expect(EventType.metadataTemplateCreated).to(equal(EventType(EventType.metadataTemplateCreated.description)))
                    expect(EventType.metadataTemplateUpdated).to(equal(EventType(EventType.metadataTemplateUpdated.description)))
                    expect(EventType.metadataTemplateDeleted).to(equal(EventType(EventType.metadataTemplateDeleted.description)))
                    expect(EventType.itemOpened).to(equal(EventType(EventType.itemOpened.description)))
                    expect(EventType.itemModified).to(equal(EventType(EventType.itemModified.description)))
                    expect(EventType.abnormalDownloadActivity).to(equal(EventType(EventType.abnormalDownloadActivity.description)))
                    expect(EventType.itemsRemovedFromGroup).to(equal(EventType(EventType.itemsRemovedFromGroup.description)))
                    expect(EventType.watermarkedFileDownloaded).to(equal(EventType(EventType.watermarkedFileDownloaded.description)))
                    expect(EventType.customValue("custom value")).to(equal(EventType("custom value")))

                    // These case items are obsoleted and will be removed in v5.0
                    // expect(EventType.masterInviteAccepted).to(equal(EventType(EventType.masterInviteAccepted.description))) -> adminInviteAccepted
                    // expect(EventType.masterInviteRejected).to(equal(EventType(EventType.masterInviteRejected.description))) -> adminInviteRejected
                    // expect(EventType.itemsAddedToGroup).to(equal(EventType(EventType.itemsAddedToGroup.description))) -> itemAddedToGroup
                }
            }
        }
    }
}
