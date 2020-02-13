Metadata
========

Metadata allows users and applications to define and store custom data associated with their files/folders. Metadata
consists of key-value pairs that belong to files/folders. For example, an important contract file stored on Box may have key-value pairs of
`"clientNumber":"820183"` and `"clientName":"BioMedical Corp"`.

Metadata that belongs to a file/folder is grouped by templates. Templates allow the metadata service to provide a
multitude of features, such as pre-defining sets of key-value pairs or schema enforcement on specific fields.

Each file/folder can have multiple distinct template instances associated with it, and templates are also grouped by
scopes. Currently, the only scopes support are `enterprise` and `global`. Enterprise scopes are defined on a
per-enterprise basis, whereas global scopes are Box application-wide.

In addition to `enterprise` scoped templates, every file on Box has access to the `global` `properties` template. The
`properties` template contains free-form key-value string pairs, with no additional schema associated with it.
This is recommended for scenarios where applications want to write metadata to file objects in a flexible way,
without pre-defined template structure.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Get Metadata Template](#get-metadata-template)
- [Create Metadata Template](#create-metadata-template)
- [Update Metadata Template](#update-metadata-template)
- [Delete Metadata Template](#delete-metadata-template)
- [List Metadata Templates](#list-metadata-templates)
- [Get All Metadata on File](#get-all-metadata-on-file)
- [Get Metadata Instance on File](#get-metadata-instance-on-file)
- [Add Metadata Instance to File](#add-metadata-instance-to-file)
- [Update Metadata Instance on File](#update-metadata-instance-on-file)
- [Remove Metadata Instance from File](#remove-metadata-instance-from-file)
- [Get All Metadata on Folder](#get-all-metadata-on-folder)
- [Get Metadata Instance on Folder](#get-metadata-instance-on-folder)
- [Add Metadata Instance to Folder](#add-metadata-instance-to-folder)
- [Update Metadata Instance on Folder](#update-metadata-instance-on-folder)
- [Remove Metadata Instance from Folder](#remove-metadata-instance-from-folder)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

Get Metadata Template
---------------------

To retrieve information about a metadata template, call
[`client.metadata.getTemplateByKey(scope:templateKey:completion:)`][get-md-template]
with the scope and key of the template.

<!-- sample get_metadata_templates_id_id_schema -->
```swift
client.metadata.getTemplateByKey(
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<MetadataTemplate, BoxSDKError>) in
    guard case let .success(template) = result {
        print("Error retrieving metadata template")
        return
    }

    print("Metadata template has \(template.fields?.count) fields")
}
```

Alternatively, if you know the ID of the metadata template, you can call
[`client.metadata.getTemplateById(id:completion:)`][get-md-template-id]
with the ID of the template.

<!-- sample get_metadata_templates_id -->
```swift
client.metadata.getTemplateById(
    id: "26004e29-7b94-44a1-8a63-f9aa384c7421"
) { (result: Result<MetadataTemplate, BoxSDKError>) in
    guard case let .success(template) = result {
        print("Error retrieving metadata template")
        return
    }

    print("Metadata template has \(template.fields?.count) fields")
}
```

[get-md-template]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC16getTemplateByKey5scope08templateH010completionySS_SSys6ResultOyAA0cF0CAA0A8SDKErrorCGctF
[get-md-template-id]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC15getTemplateById2id10completionySS_ys6ResultOyAA0cF0CAA0A8SDKErrorCGctF

Create Metadata Template
------------------------

To create a new metadata template, call
[`client.metadata.createTemplate(scope:templateKey:displayName:hidden:fields:completion:)`][create-md-template]
with the scope and name of the template, as well as the fields the template should contain.

<!-- sample post_metadata_templates_schema -->
```swift
var templateFields: [MetadataField] = []
templateFields.append(MetadataField(
    type: "string",
    key: "name",
    displayName: "Full Name"
))
templateFields.append(MetadataField(
    type: "date",
    key: "birthday",
    displayName: "Birthday"
))
templateFields.append(MetadataField(
    type: "enum",
    key: "department",
    displayName: "Department",
    options: [
        ["key": "HR"],
        ["key": "Sales"],
        ["key": "Marketing"],
    ]
))
client.metadata.createTemplate(
    scope: "enterprise",
    templateKey: "personnelRecord",
    displayName: "Personnel Record",
    hidden: false,
    fields: templateFields
) { (result: Result<MetadataTemplate, BoxSDKError>) in
    guard case let .success(template) = result {
        print("Error creating metadata template")
        return
    }

    print("Created metadata template with ID \(template.id)")
}
```

[create-md-template]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC14createTemplate5scope11templateKey11displayName6hidden6fields10completionySS_S2SSbSayAA0C5FieldVGys6ResultOyAA0cF0CAA0A8SDKErrorCGctF

Update Metadata Template
------------------------

To update a metadata template, including to modify its fields, call
[`client.metadata.updateTemplate(scope:templateKey:operation:completion:)`][update-md-template]
with the scope and key of the template to update, as well as the update operation to perform.
In this example, we are updating the metadata template using the ReorderEnumOptions operation.
Other metadata template update operations include: addEnumOption, addField, editTemplate, reorderFields

<!-- sample put_metadata_templates_id_id_schema -->
```swift
client.metadata.updateTemplate(
    scope: "enterprise",
    templateKey: "personnelRecord",
    operation: .reorderEnumOptions(fieldKey: "department", enumOptionKeys: ["Marketing", "Sales", "HR"])
) { (result: Result<MetadataTemplate, BoxSDKError>) in
    guard case let .success(template) = result {
        print("Error updating metadata template")
        return
    }

    print("Updated metadata template with ID \(template.id)")
}
```

[update-md-template]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC14updateTemplate5scope11templateKey9operation10completionySS_SSAA0cF9OperationOys6ResultOyAA0cF0CAA0A8SDKErrorCGctF

Delete Metadata Template
------------------------

To delete a metadata template, call
[`client.metadata.deleteTemplate(scope:templateKey:completion:)`][delete-md-template]
with the scope and key of the template to delete.

<!-- sample delete_metadata_templates_id_id_schema -->
```swift
client.metadata.deleteTemplate(
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<Void, BoxSDKError>) in
    guard case .success = result {
        print("Error deleting metadata template")
        return
    }

    print("Metadata template deleted")
}
```

[delete-md-template]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC14deleteTemplate5scope11templateKey10completionySS_SSys6ResultOyytAA0A8SDKErrorCGctF

List Metadata Templates
-----------------------

To retrieve the collection of available metadata templates in a particular scope, call
[`client.metadata.listEnterpriseTemplates(scope:marker:limit:)`][list-templates]
with the scope. This method will return an iterator object in the completion, which is used to retrieve metadata templates.

<!-- sample get_metadata_templates_enterprise -->
```swift
client.metadata.listEnterpriseTemplates(scope: "enterprise") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(template):
                    print("Template name: \(template.displayName)")
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

Similarly, to get all templates available in the `global` scope.

<!-- sample get_metadata_templates_global -->
```swift
client.metadata.listEnterpriseTemplates(scope: "global") { results in
    switch results {
    case let .success(iterator):
        for i in 1 ... 10 {
            iterator.next { result in
                switch result {
                case let .success(template):
                    print("Template name: \(template.displayName)")
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

[list-templates]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC23listEnterpriseTemplates5scope6marker5limit10completionySS_SSSgSiSgys6ResultOyAA14PagingIteratorCyAA0C8TemplateCGAA0A8SDKErrorCGctF

Get All Metadata on File
------------------------

To retrieve all metadata attached to a file, call
[`client.metadata.list(forFileId:completion:)`][get-all-md-file]
with the ID of the file.

<!-- sample get_files_id_metadata -->
```swift
client.metadata.list(forFileId: "11111") { (result: Result<[MetadataObject], BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error retrieving metadata")
        return
    }

    print("Retrieved \(metadata.count) metadata instances:")
    for instance in metadata {
        print("- \(instance.template)")
    }
}
```

[get-all-md-file]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC4list9forFileId10completionySS_ys6ResultOySayAA0C6ObjectCGAA0A8SDKErrorCGctF

Get Metadata Instance on File
-----------------------------

To retrieve a specific metadata instance attached to a file, call
[`client.metadata.get(forFileWithId:scope:templateKey:completion:)`][get-md-file]
with the file ID, as well as the scope and key of the metadata template of the instance.

<!-- sample get_files_id_metadata_id_id -->
```swift
client.metadata.get(
    forFileWithId: "11111",
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error retrieving metadata")
        return
    }

    print("Found personnel record for \(metadata.keys["name"])")
}
```

[get-md-file]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC3get13forFileWithId5scope11templateKey10completionySS_S2Sys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Add Metadata Instance to File
-----------------------------

To attach a new metadata instance to a file, call
[`client.metadata.create(forFileWithId:scope:templateKey:keys:completion:)`][add-md-file]
with the ID of the file, as well as the scope and key of the metadata template to use and the metadata keys and
values to attach.

<!-- sample post_files_id_metadata_id_id -->   
```swift
let metadata = [
    "name": "John Doe",
    "birthday": "2000-01-01T00:00:00Z",
    "department": "Sales"
]
client.metadata.create(
    forFileWithId: "11111",
    scope: "enterprise",
    templateKey: "personnelRecord",
    keys: metadata
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error adding metadata")
        return
    }

    print("Successfully attached metadata")
}
```

[add-md-file]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6create13forFileWithId5scope11templateKey4keys10completionySS_S2SSDySSypGys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Update Metadata Instance on File
--------------------------------

To update the values in a metadata instance attached to a file, call
[`client.metadata.updateforFileWithId:scope:templateKey:operations:completion:)`][update-md-file]
with the ID of the file, the scope and key of the metadata template associated with the instance, and the
operations to perform on the metadata.

<!-- sample put_files_id_metadata_id_id -->   
```swift
client.metadata.update(
    forFileWithId: "11111",
    scope: "enterprise",
    templateKey: "personnelRecord",
    operations: [
        .test(path: "/department", value: "Sales"),
        .replace(path: "/department", value: "Marketing")
    ]
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error updating metadata")
        return
    }

    print("Employee department updated to \(metadata.keys["department"])")
}
```

[update-md-file]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6update13forFileWithId5scope11templateKey10operations10completionySS_S2SSayAA0gC9OperationOGys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Remove Metadata Instance from File
----------------------------------

To remove a specific metadata instance from a file, call
[`client.metadata.delete(forFileWithId:scope:templateKey:completion:)`][delete-md-file]
with the ID of the file, as well as the scope and key of the metadata template associated with the instance.

<!-- sample delete_files_id_metadata_id_id -->   
```swift
client.metadata.delete(
    forFileWithId: "11111",
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<Void, BoxSDKError>) in
    guard case .success = result {
        print("Error deleting metadata instance")
        return
    }

    print("Metadata instance deleted")
}
```

[delete-md-file]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6delete13forFileWithId5scope11templateKey10completionySS_S2Sys6ResultOyytAA0A8SDKErrorCGctF

Get All Metadata on Folder
--------------------------

To retrieve all metadata attached to a folder, call
[`client.metadata.list(forFolderId:completion:)`][get-all-md-folder]
with the ID of the folder.

<!-- sample get_folders_id_metadata -->   
```swift
client.metadata.list(forFolderId: "22222") { (result: Result<[MetadataObject], BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error retrieving metadata")
        return
    }

    print("Retrieved \(metadata.count) metadata instances:")
    for instance in metadata {
        print("- \(instance.template)")
    }
}
```

[get-all-md-folder]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC4list11forFolderId10completionySS_ys6ResultOySayAA0C6ObjectCGAA0A8SDKErrorCGctF

Get Metadata Instance on Folder
-------------------------------

To retrieve a specific metadata instance attached to a folder, call
[`client.metadata.get(forFolderWithId:scope:templateKey:completion:)`][get-md-folder]
with the folder ID, as well as the scope and key of the metadata template of the instance.

<!-- sample get_folders_id_metadata_id_id -->   
```swift
client.metadata.get(
    forFolderWithId: "22222",
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error retrieving metadata")
        return
    }

    print("Found personnel record for \(metadata.keys["name"])")
}
```

[get-md-folder]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC3get15forFolderWithId5scope11templateKey10completionySS_S2Sys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Add Metadata Instance to Folder
-------------------------------

To attach a new metadata instance to a folder, call
[`client.metadata.create(forFolderWithId:scope:templateKey:keys:completion:)`][add-md-folder]
with the ID of the folder, as well as the scope and key of the metadata template to use and the metadata keys and
values to attach.

<!-- sample post_folders_id_metadata_id_id -->   
```swift
let metadata = [
    "name": "John Doe",
    "birthday": "2000-01-01T00:00:00Z",
    "department": "Sales"
]
client.metadata.create(
    forFolderWithId: "22222",
    scope: "enterprise",
    templateKey: "personnelRecord",
    keys: metadata
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error adding metadata")
        return
    }

    print("Successfully attached metadata")
}
```

[add-md-folder]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6create15forFolderWithId5scope11templateKey4keys10completionySS_S2SSDySSypGys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Update Metadata Instance on Folder
----------------------------------

To update the values in a metadata instance attached to a folder, call
[`client.metadata.update(forFolderWithId:scope:templateKey:operations:completion:)`][update-md-folder]
with the ID of the folder, the scope and key of the metadata template associated with the instance, and the
operations to perform on the metadata.

<!-- sample put_folders_id_metadata_id_id -->   
```swift
client.metadata.update(
    forFolderWithId: "22222",
    scope: "enterprise",
    templateKey: "personnelRecord",
    operations: [
        .test(path: "/department", value: "Sales"),
        .replace(path: "/department", value: "Marketing")
    ]
) { (result: Result<MetadataObject, BoxSDKError>) in
    guard case let .success(metadata) = result {
        print("Error updating metadata")
        return
    }

    print("Employee department updated to \(metadata.keys["department"])")
}
```

[update-md-folder]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6update15forFolderWithId5scope11templateKey10operations10completionySS_S2SSayAA0gC9OperationOGys6ResultOyAA0C6ObjectCAA0A8SDKErrorCGctF

Remove Metadata Instance from Folder
------------------------------------

To remove a specific metadata instance from a folder, call
[`client.metadata.delete(forFolderWithId:scope:templateKey:completion:)`][delete-md-folder]
with the ID of the folder, as well as the scope and key of the metadata template associated with the instance.

<!-- sample delete_folders_id_metadata_id_id -->   
```swift
client.metadata.delete(
    forFolderWithId: "22222",
    scope: "enterprise",
    templateKey: "personnelRecord"
) { (result: Result<Void, BoxSDKError>) in
    guard case .success = result {
        print("Error deleting metadata instance")
        return
    }

    print("Metadata instance deleted")
}
```

[delete-md-folder]: https://opensource.box.com/box-ios-sdk/Classes/MetadataModule.html#/s:6BoxSDK14MetadataModuleC6delete15forFolderWithId5scope11templateKey10completionySS_S2Sys6ResultOyytAA0A8SDKErrorCGctF