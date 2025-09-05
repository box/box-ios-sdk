# Downloads

Downloads module is used to download files from Box.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Download a File](#download-a-file)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Download a File

To download a file to your device(local disk), call `client.downloads.downloadFile(fileId:downloadDestinationURL:queryParams:headers)` method
with the ID of the file to download and a URL to the location (including name of the file) where the file should be downloaded to.

<!-- sample get_files_id_content -->

```swift
let downloadsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let destinationURL = downloadsDirectoryURL.appendingPathComponent("file.txt")

let url = try await client.downloads.downloadFile(fileId: file.id, downloadDestinationURL: destinationURL)

if let fileContent = try? String(contentsOf: url, encoding: .utf8) {
    print("The content of the file: \(fileContent)")
}
```
