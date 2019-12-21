import BoxSDK

// let client = BoxSDK.getClient(token: "LBa8BIRy8FpqVTsGD8nZkcTHKg1rKozo")
//
// client.events.getUserEvents(streamPosition: StreamPosition.customValue("15764172459727153")) { results in
//    switch results {
//    case let .success(iterator):
//        for i in 1...4 {
//            iterator.next { result in
//                switch result {
//                case let .success(item):
//                    print(item.eventType)
//                case let .failure(error):
//                    print(error)
//                }
//            }
//        }
//    case let .failure(error):
//        print(error)
//    }
// }

// var url = FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
// print("File Path: \(url.path)")

let client = BoxSDK.getClient(token: "HXGTaPE9hneQIyQ3QeSd0IEFJn5i93Mn")

client.folders.get(folderId: "0") { result in
    switch result {
    case let .success(folder):
        print(folder.name!)
    case let .failure(error):
        print(error)
    }
}

client.folders.get(folderId: "86079431597") { result in
    switch result {
    case let .success(folder):
        print(folder.name!)
    case let .failure(error):
        print(error)
    }
}

 var url = URL(string: "file:///Users/sgarlanka/Library/Developer/XCPGDevices/9EB8C6C5-F497-410C-A023-59BE7EC0C174/data/Containers/Data/Application/52E41421-1664-45B1-84AD-074EF65C1710/Documents/space.jpg")!

 client.files.download(fileId: "576640170630", destinationURL: url, progress: { progress in
    print(progress.fractionCompleted)
 }) { result in
    switch result {
    case .success:
        print("File downloaded successfully")
    case let .failure(error):
        print(error.error)
    }
 }

var urlUpload = URL(string: "file:///Users/sgarlanka/Library/Developer/XCPGDevices/9EB8C6C5-F497-410C-A023-59BE7EC0C174/data/Containers/Data/Application/52E41421-1664-45B1-84AD-074EF65C1710/Documents/test.jpg")!
let urlPath = urlUpload.path
// let fileExists = FileManager.default.fileExists(atPath: urlPath)

var fileSize: Int = 0

do {
    let attribute = try FileManager.default.attributesOfItem(atPath: urlPath)
    if let size = attribute[FileAttributeKey.size] as? Int {
        fileSize = size
    }
}
catch {
    print(error)
}

let stream = InputStream(fileAtPath: urlPath)!

client.files.streamUpload(stream: stream, fileSize: fileSize, name: "john.jpg", parentId: "89730145249", progress: { progress in
    print(progress.fractionCompleted)
}) { result in
    switch result {
    case let .success(file):
        print(file.name)
    case let .failure(error):
        print(error)
    }
}

