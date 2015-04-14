Collaborations
==============

###### <i>Collaborations is a sophisticated mechanism for managing access to to folders. If you would like to give your users the ability to manage collaborations, we recommend using the Share SDK rather than trying to call these methods yourself. The Share SDK contains UIViewControllers that allow users to manage folder collaborations.</i>

View Collaborators in a Folder
------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXFolderCollaborationsRequest *folderCollaborationsRequest = [contentClient collaborationsRequestForFolderWithID:@"folder-id"];
[folderCollaborationsRequest performRequestWithCompletion:^(NSArray *collaborations, NSError *error) {
	// If successful, collaborations will be non-nil and contain BOXCollaboration model objects; otherwise, error will be non-nil.
}];
```

Add a Collaborator to a Folder
------------------------------
Add a collaborator by email address:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationCreateRequest *collaborationCreateRequest = [contentClient collaborationAddRequestToFolderWithID:@"folder-id" userLogin:@"test@user.com" role:BOXCollaborationRoleEditor];
[collaborationCreateRequest performRequestWithCompletion:^(BOXCollaboration *collaboration, NSError *error) {
	// If successful, collaboration will be non-nil; otherwise, error will be non-nil.
}];
```
Add a collaborator by Box user-id:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationCreateRequest *collaborationCreateRequest = [contentClient collaborationAddRequestToFolderWithID:@"folder-id" userID:@"user-id" role:BOXCollaborationRoleEditor];
[collaborationCreateRequest performRequestWithCompletion:^(BOXCollaboration *collaboration, NSError *error) {
	// If successful, collaboration will be non-nil; otherwise, error will be non-nil.
}];
```
Add a group:
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationCreateRequest *collaborationCreateRequest = [contentClient collaborationAddRequestToFolderWithID:@"folder-id" groupID:@"group-id" role:BOXCollaborationRoleEditor];
[collaborationCreateRequest performRequestWithCompletion:^(BOXCollaboration *collaboration, NSError *error) {
	// If successful, collaboration will be non-nil; otherwise, error will be non-nil.
}];
```

Remove a Collaborator from a Folder
------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationRemoveRequest *collaborationRemoveRequest = [contentClient collaborationDeleteRequestWithID:@"collaboration-id"];
[collaborationRemoveRequest performRequestWithCompletion:^(NSError *error) {
	// If successful, error will be nil.
}];
```

Update an existing Collaboration
--------------------------------
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationUpdateRequest *collaborationUpdateRequest = [contentClient collaborationUpdateRequestWithID:@"collaboration-id"];

// Update the role
collaborationUpdateRequest.role = BOXCollaborationRoleViewerUploader;

[collaborationUpdateRequest performRequestWithCompletion:^(NSError *error) {
	// If successful, error will be nil.
}];
```

View Pending Collaborations for the Current User
---------------------------------------
<i>A "Pending Collaboration" represents a user who has not yet accepted the invitation to join a folder as a collaborator. Most users auto-accept invitations, but some do not. This method retrieves the collaboration invitations that the current user has not yet accepted.</i>
```objectivec
BOXContentClient *contentClient = [BOXContentClient defaultClient];
BOXCollaborationPendingRequest *pendingCollaborationsRequest = [contentClient pendingCollaborationsRequest];
[pendingCollaborationsRequest performRequestWithCompletion:^(NSArray *collaborations, NSError *error) {
	// If successful, collaborations will be non-nil and contain BOXCollaboration model objects; otherwise, error will be non-nil.
}];
```
