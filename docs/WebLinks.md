# WebLinksManager


- [Create web link](#create-web-link)
- [Get web link](#get-web-link)
- [Update web link](#update-web-link)
- [Remove web link](#remove-web-link)

## Create web link

Creates a web link object within a folder.

This operation is performed by calling function `createWebLink`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/post-web-links/).

<!-- sample post_web_links -->
```
try await client.webLinks.createWebLink(requestBody: CreateWebLinkRequestBody(url: "https://www.box.com", parent: CreateWebLinkRequestBodyParentField(id: parent.id), name: Utils.getUUID(), description: "Weblink description"))
```

### Arguments

- requestBody `CreateWebLinkRequestBody`
  - Request body of createWebLink method
- headers `CreateWebLinkHeaders`
  - Headers of createWebLink method


### Returns

This function returns a value of type `WebLink`.

Returns the newly created web link object.


## Get web link

Retrieve information about a web link.

This operation is performed by calling function `getWebLinkById`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/get-web-links-id/).

<!-- sample get_web_links_id -->
```
try await client.webLinks.getWebLinkById(webLinkId: weblink.id)
```

### Arguments

- webLinkId `String`
  - The ID of the web link. Example: "12345"
- headers `GetWebLinkByIdHeaders`
  - Headers of getWebLinkById method


### Returns

This function returns a value of type `WebLink`.

Returns the web link object.


## Update web link

Updates a web link object.

This operation is performed by calling function `updateWebLinkById`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/put-web-links-id/).

<!-- sample put_web_links_id -->
```
try await client.webLinks.updateWebLinkById(webLinkId: weblink.id, requestBody: UpdateWebLinkByIdRequestBody(name: updatedName, sharedLink: UpdateWebLinkByIdRequestBodySharedLinkField(access: UpdateWebLinkByIdRequestBodySharedLinkAccessField.open, password: password)))
```

### Arguments

- webLinkId `String`
  - The ID of the web link. Example: "12345"
- requestBody `UpdateWebLinkByIdRequestBody`
  - Request body of updateWebLinkById method
- headers `UpdateWebLinkByIdHeaders`
  - Headers of updateWebLinkById method


### Returns

This function returns a value of type `WebLink`.

Returns the updated web link object.


## Remove web link

Deletes a web link.

This operation is performed by calling function `deleteWebLinkById`.

See the endpoint docs at
[API Reference](https://developer.box.com/reference/delete-web-links-id/).

<!-- sample delete_web_links_id -->
```
try await client.webLinks.deleteWebLinkById(webLinkId: webLinkId)
```

### Arguments

- webLinkId `String`
  - The ID of the web link. Example: "12345"
- headers `DeleteWebLinkByIdHeaders`
  - Headers of deleteWebLinkById method


### Returns

This function returns a value of type ``.

An empty response will be returned when the web link
was successfully deleted.


