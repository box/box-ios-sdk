import BoxSDK

// var url = FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
// url.appendPathComponent("testFile")
// print("File Path: \(url.path)")

let client = BoxSDK.getClient(token: "85Z6XFTHDYWjignwcQGXeqRBpC15VtqQ")

var url = URL(string: "file:///Users/sgarlanka/Library/Developer/XCPGDevices/01F31A0F-5F35-4D01-99FF-A193DE611540/data/Containers/Data/Application/57858B7A-F621-48FC-8E03-CD57593F9E85/Documents/testFile")!

var task: URLSessionTask?

var boxTask = client.files.download(
    fileId: "576640170630", destinationURL: url,
    task: { task1 in
        task = task1
//        task = task1
//        print(task)
    },
    progress: { progress in
        if progress.fractionCompleted > 0.5 {
            task!.suspend()
        }
        print(progress.fractionCompleted)
    }
) { result in
    switch result {
    case .success:
        print("File downloaded successfully")
    case let .failure(error):
        print(error)
    }
}

boxTask.cancel()

//DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//    print("hello")
//    task?.resume()
//}

//task!.cancel()
