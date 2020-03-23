import BoxSDK

// var url = FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
// url.appendPathComponent("testFile")
// print("File Path: \(url.path)")

let client = BoxSDK.getClient(token: "")

var url = URL(string: "")!

var task: BoxTask?
task = client.files.download(
    fileId: "576640170630", destinationURL: url,
    //    task: { _ in
    //        task = task1
    //        print(task)
//    },
    progress: { progress in
        if progress.fractionCompleted > 0.5 {
            task!.cancel()
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

//task!.cancel()
