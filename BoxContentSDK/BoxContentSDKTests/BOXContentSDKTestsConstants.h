//
//  BOXContentSDKTestsConstants.h
//  BoxContentSDK
//
//  Created by Mina Hattori on 8/2/18.
//  Copyright © 2018 Box. All rights reserved.
//

#ifndef BOXContentSDKTestsConstants_h
#define BOXContentSDKTestsConstants_h

//Request All Fields with Metadata Information
#define expectedItemRequestFieldsStringWithoutMetadata @"type,id,sequence_id,etag,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,permissions,lock,extension,is_package,allowed_shared_link_access_levels,collections,collection_memberships,folder_upload_email,sync_state,has_collaborations,is_externally_owned,can_non_owners_invite,allowed_invitee_roles,default_invitee_role,sha1,watermark_info,version_number,comment_count,url"

#define expectedItemRequestFieldsStringWithMetadata @"type,id,sequence_id,etag,name,description,size,path_collection,created_at,modified_at,trashed_at,purged_at,content_created_at,content_modified_at,created_by,modified_by,owned_by,shared_link,parent,item_status,permissions,lock,extension,is_package,allowed_shared_link_access_levels,collections,collection_memberships,folder_upload_email,sync_state,has_collaborations,is_externally_owned,can_non_owners_invite,allowed_invitee_roles,default_invitee_role,sha1,watermark_info,version_number,comment_count,url,metadata.scope.test"

#endif
