import BoxSDK

// var url = FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
// print("File Path: \(url.path)")

let client = BoxSDK.getClient(token: "P9yiKLCtmo1BAMhT11oYo5r8WXO7ceuQ")

// client.folders.get(folderId: "0") { result in
//    switch result {
//    case let .success(folder):
//        print(folder.name!)
//    case let .failure(error):
//        print(error)
//    }
// }
//
// client.folders.get(folderId: "86079431597") { result in
//    switch result {
//    case let .success(folder):
//        print(folder.name!)
//    case let .failure(error):
//        print(error)
//    }
// }

var url = URL(string: "file:///Users/sgarlanka/Library/Developer/XCPGDevices/9EB8C6C5-F497-410C-A023-59BE7EC0C174/data/Containers/Data/Application/52E41421-1664-45B1-84AD-074EF65C1710/Documents/test.jpg")!

client.files.download(fileId: "538281537198", destinationURL: url, progress: { progress in
    print(progress.fractionCompleted)
}) { result in
    switch result {
    case .success:
        print("File downloaded successfully")
    case let .failure(error):
        print(error.error)
    }
}
