//
//  FileModuleIntegrationSpecs.swift
//  BoxSDK-iOS
//
//  Created by Artur Jankowski on 01/12/2021.
//  Copyright © 2021 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class FileModuleIntegrationSpecs: BaseIntegrationSpecs {
    var rootFolder: Folder!

    override func spec() {
        beforeSuite {
            self.createFolder(name: NameGenerator.getUniqueFolderName(for: "FileModule")) { [weak self] createdFolder in self?.rootFolder = createdFolder }
        }

        afterSuite {
            self.deleteFolder(self.rootFolder)
        }

        describe("File Module") {

            context("live cycle") {

                it("should correctly upload get download and delete a file") {
                    let fileName = IntegrationTestResources.smallImage.fileName
                    let fileContent = FileUtil.getFileContent(fileName: fileName)!
                    var file: File?

                    // Upload
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.upload(
                            data: fileContent,
                            name: fileName,
                            parentId: self.rootFolder.id,
                            performPreflightCheck: true
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                file = fileItem
                                expect(fileItem.name).to(equal(fileName))
                                expect(fileItem.size).to(equal(fileContent.count))
                                expect(fileItem.parent?.id).to(equal(self.rootFolder.id))
                            case let .failure(error):
                                fail("Expected upload call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let file = file else { return }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.get(fileId: file.id) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal(fileItem.id))
                                expect(file.name).to(equal(fileItem.name))
                                expect(file.size).to(equal(fileContent.count))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }

                    // Download
                    let destinationUrl = FileUtil.getDestinationUrl(for: IntegrationTestResources.smallImage.fileName)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.download(fileId: file.id, destinationURL: destinationUrl) { result in
                            switch result {
                            case .success:
                                expect(FileManager().fileExists(atPath: destinationUrl.path)).to(equal(true))

                                guard let downloadedContent = try? Data(contentsOf: destinationUrl) else {
                                    fail("Can not read downloaded file")
                                    return
                                }

                                expect(fileContent).to(equal(downloadedContent))
                            case let .failure(error):
                                fail("Expected download call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.delete(fileId: file.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should correctly streamUpload get download and delete a file") {
                    let fileContent = FileUtil.getFileContent(fileName: IntegrationTestResources.smallImage.fileName)!
                    let fileStream = InputStream(data: fileContent)
                    var file: File?

                    // Upload
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.streamUpload(
                            stream: fileStream,
                            fileSize: fileContent.count,
                            name: IntegrationTestResources.smallImage.fileName,
                            parentId: self.rootFolder.id,
                            performPreflightCheck: true
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                file = fileItem
                                expect(fileItem.name).to(equal(IntegrationTestResources.smallImage.fileName))
                                expect(fileItem.size).to(equal(fileContent.count))
                                expect(fileItem.parent?.id).to(equal(self.rootFolder.id))
                            case let .failure(error):
                                fail("Expected upload call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let file = file else { return }

                    // Get
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.get(fileId: file.id) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal(fileItem.id))
                                expect(file.name).to(equal(fileItem.name))
                                expect(file.size).to(equal(fileContent.count))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }

                    // Download
                    let destinationUrl = FileUtil.getDestinationUrl(for: IntegrationTestResources.smallImage.fileName)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.download(fileId: file.id, destinationURL: destinationUrl) { result in
                            switch result {
                            case .success:
                                expect(FileManager().fileExists(atPath: destinationUrl.path)).to(equal(true))

                                guard let downloadedContent = try? Data(contentsOf: destinationUrl) else {
                                    fail("Can not read downloaded file")
                                    return
                                }

                                expect(fileContent).to(equal(downloadedContent))
                            case let .failure(error):
                                fail("Expected download call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.delete(fileId: file.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected delete call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("preflightCheck") {

                it("should succeed if checked against unique file name") {
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.preflightCheck(
                            name: NameGenerator.getUniqueFileName(),
                            parentId: self.rootFolder.id
                        ) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected preflightCheck call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("version") {
                var file: File?
                let versionName1 = NameGenerator.getUniqueFileName()
                let versionContent1 = "First Version"

                beforeEach {
                    self.uploadFile(fileName: versionName1, stringContent: versionContent1, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly operate on file versions") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // Upload data version
                    var fileVersion2: FileVersion?
                    let versionName2 = NameGenerator.getUniqueFileName()
                    let versionContent2 = "Second Version"
                    let versionContentData2 = versionContent2.data(using: .utf8)!
                    let version2ContentModifiedAt = Date().iso8601

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.uploadVersion(
                            forFile: file.id,
                            name: versionName2,
                            contentModifiedAt: version2ContentModifiedAt,
                            data: versionContentData2
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                fileVersion2 = fileItem.fileVersion
                                expect(fileItem.name).to(equal(versionName2))
                                expect(fileItem.size).to(equal(versionContentData2.count))
                                expect(fileItem.contentModifiedAt?.iso8601).to(equal(version2ContentModifiedAt))

                            case let .failure(error):
                                fail("Expected uploadVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Upload stream version
                    var fileVersion3: FileVersion?
                    let versionName3 = NameGenerator.getUniqueFileName()
                    let versionContent3 = "Last third Version"
                    let versionContentData3 = versionContent3.data(using: .utf8)!
                    let version3ContentModifiedAt = Date().iso8601

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.streamUploadVersion(
                            stream: InputStream(data: versionContentData3),
                            fileSize: versionContentData3.count,
                            forFile: file.id,
                            name: versionName3,
                            contentModifiedAt: version3ContentModifiedAt
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                fileVersion3 = fileItem.fileVersion
                                expect(fileItem.name).to(equal(versionName3))
                                expect(fileItem.size).to(equal(versionContentData3.count))
                                expect(fileItem.contentModifiedAt?.iso8601).to(equal(version3ContentModifiedAt))

                            case let .failure(error):
                                fail("Expected streamUploadVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    guard let fileVersion2 = fileVersion2, let fileVersion3 = fileVersion3 else { return }

                    // Download version
                    let destinationUrl = FileUtil.getDestinationUrl(for: versionName2)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.download(fileId: file.id, destinationURL: destinationUrl, version: fileVersion2.id) { result in
                            switch result {
                            case .success:
                                expect(FileManager().fileExists(atPath: destinationUrl.path)).to(equal(true))

                                guard let downloadedContent = try? Data(contentsOf: destinationUrl) else {
                                    fail("Can not read downloaded file")
                                    return
                                }

                                expect(versionContent2.data(using: .utf8)!).to(equal(downloadedContent))
                            case let .failure(error):
                                fail("Expected download call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // List versions
                    let iterator = self.client.files.listVersions(fileId: file.id, offset: 0, limit: 1000)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(2))
                                expect(page.entries[0].id).to(equal(fileVersion2.id))
                                expect(page.entries[0].name).to(equal(versionName2))
                                expect(page.entries[1].id).to(equal(file.fileVersion?.id))
                                expect(page.entries[1].name).to(equal(versionName1))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }
                        }

                        done()
                    }

                    // Get version
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getVersion(fileId: file.id, fileVersionId: fileVersion2.id, fields: ["name"]) { result in
                            switch result {
                            case let .success(fileVersionItem):
                                expect(fileVersionItem.id).to(equal(fileVersion2.id))
                                expect(fileVersionItem.name).to(equal(versionName2))
                            case let .failure(error):
                                fail("Expected getVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Promote version
                    var fileVersion4: FileVersion?

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.promoteVersion(fileId: file.id, fileVersionId: fileVersion2.id) { result in
                            switch result {
                            case let .success(fileVersionItem):
                                fileVersion4 = fileVersionItem
                                expect(fileVersionItem.id).notTo(equal(fileVersion2.id))
                                expect(fileVersionItem.name).to(equal(versionName2))
                            case let .failure(error):
                                fail("Expected promoteVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.get(fileId: file.id) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(fileItem.fileVersion?.id).to(equal(fileVersion4?.id))
                                expect(fileItem.name).to(equal(versionName2))
                            case let .failure(error):
                                fail("Expected get call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // delete version
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.deleteVersion(fileId: file.id, fileVersionId: fileVersion3.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected deleteVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getVersion(fileId: file.id, fileVersionId: fileVersion3.id) { result in
                            switch result {
                            case let .success(fileVersionItem):
                                expect(fileVersionItem.trashedAt).notTo(beNil())
                            case let .failure(error):
                                fail("Expected getVersion call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("update") {
                var file: File?
                var destinationFolder: Folder?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                    self.createFolder(name: NameGenerator.getUniqueFolderName(), parentId: self.rootFolder.id) { createdFolder in destinationFolder = createdFolder }
                }

                afterEach {
                    self.deleteFile(file)
                    self.deleteFolder(destinationFolder)
                }

                it("should correctly update file") {
                    guard let file = file, let destinationFolder = destinationFolder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let changedFileName = NameGenerator.getUniqueFileName()

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.update(
                            fileId: file.id,
                            name: changedFileName,
                            description: "sample description",
                            parentId: destinationFolder.id,
                            tags: ["sample tag 1"],
                            fields: ["name", "description", "tags", "parent"]
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(fileItem.id).to(equal(file.id))
                                expect(fileItem.parent?.id).to(equal(destinationFolder.id))
                                expect(fileItem.name).to(equal(changedFileName))
                                expect(fileItem.description).to(equal("sample description"))
                                expect(fileItem.tags?[0]).to(equal("sample tag 1"))
                            case let .failure(error):
                                fail("Expected update call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("copy") {
                var file: File?
                var destinationFolder: Folder?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                    self.createFolder(name: NameGenerator.getUniqueFolderName(), parentId: self.rootFolder.id) { createdFolder in destinationFolder = createdFolder }
                }

                afterEach {
                    self.deleteFile(file)
                    self.deleteFolder(destinationFolder, recursive: true)
                }

                it("should correctly copy file") {
                    guard let file = file, let destinationFolder = destinationFolder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let changedFileName = NameGenerator.getUniqueFolderName()

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.copy(
                            fileId: file.id,
                            parentId: destinationFolder.id,
                            name: changedFileName,
                            fields: ["name", "description", "tags", "parent"]
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(fileItem.id).notTo(equal(file.id))
                                expect(fileItem.parent?.id).to(equal(destinationFolder.id))
                                expect(fileItem.name).to(equal(changedFileName))
                            case let .failure(error):
                                fail("Expected copy call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("lock") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly create list and delete a lock") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let lockExpiresAt = Date().tomorrow

                    // Lock
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.lock(
                            fileId: file.id,
                            expiresAt: lockExpiresAt,
                            isDownloadPrevented: true,
                            fields: ["name", "lock"]
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(fileItem.id).to(equal(file.id))
                                expect(fileItem.lock).toNot(beNil())
                                expect(fileItem.lock?.isDownloadPrevented).to(equal(true))
                                expect(fileItem.lock?.expiresAt?.iso8601).to(equal(lockExpiresAt.iso8601))
                            case let .failure(error):
                                fail("Expected lock call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Unlock
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.unlock(fileId: file.id, fields: ["name", "lock"]) { result in
                            switch result {
                            case let .success(fileItem):
                                expect(fileItem.id).to(equal(file.id))
                                expect(fileItem.lock).to(beNil())
                            case let .failure(error):
                                fail("Expected unlock call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("watermark") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly apply get remove a watermark") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.applyWatermark(fileId: file.id) { result in
                            switch result {
                            case let .success(watermarkItem):
                                expect(watermarkItem).toNot(beNil())
                            case let .failure(error):
                                fail("Expected applyWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getWatermark(fileId: file.id) { result in
                            switch result {
                            case let .success(watermark):
                                expect(watermark).toNot(beNil())
                            case let .failure(error):
                                fail("Expected getWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.removeWatermark(fileId: file.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected removeWatermark call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("shared link") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly set get delete a shared link") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // Create shared link
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.setSharedLink(
                            forFile: file.id,
                            access: .open,
                            canDownload: true
                        ) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.permissions?.canDownload).to(equal(true))
                                expect(sharedLink.isPasswordEnabled).to(equal(false))
                                expect(sharedLink.vanityName).to(beNil())
                            case let .failure(error):
                                fail("Expected setSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Update shared link
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.setSharedLink(
                            forFile: file.id,
                            vanityName: .value("iOS-SDK-File-VanityName"),
                            access: .open,
                            password: .value("secretPassword"),
                            canDownload: true
                        ) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.permissions?.canDownload).to(equal(true))
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                                expect(sharedLink.vanityName).to(equal("iOS-SDK-File-VanityName"))
                            case let .failure(error):
                                fail("Expected setSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Get shared link
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getSharedLink(forFile: file.id) { result in
                            switch result {
                            case let .success(sharedLink):
                                expect(sharedLink.access).to(equal(.open))
                                expect(sharedLink.permissions?.canDownload).to(equal(true))
                                expect(sharedLink.isPasswordEnabled).to(equal(true))
                                expect(sharedLink.vanityName).to(equal("iOS-SDK-File-VanityName"))
                            case let .failure(error):
                                fail("Expected getSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // Delete shared link
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.deleteSharedLink(forFile: file.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected deleteSharedLink call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("favorites") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly add file to and remove file from favorites") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.addToFavorites(fileId: file.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected addToFavorites call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.removeFromFavorites(fileId: file.id) { result in
                            if case let .failure(error) = result {
                                fail("Expected removeFromFavorites call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("thumbnail") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly get thumbnail image for a file") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getThumbnail(
                            forFile: file.id,
                            extension: .png,
                            minHeight: 256,
                            minWidth: 256,
                            maxHeight: 256,
                            maxWidth: 256
                        ) { result in
                            switch result {
                            case let .success(data):
                                expect(data.count).notTo(equal(0))
                            case let .failure(error):
                                fail("Expected getThumbnail call to suceeded, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("embed link") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly get embed link for a file") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getEmbedLink(forFile: file.id) { result in
                            switch result {
                            case let .success(expiringEmbedLink):
                                expect(expiringEmbedLink.url).notTo(beNil())
                                expect(expiringEmbedLink.token).notTo(beNil())
                            case let .failure(error):
                                fail("Expected getEmbedLink call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("comment") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly add and list a comment for a file") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var comment: Comment?

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.comments.create(itemId: file.id, itemType: "file", message: "sample comment") { result in
                            switch result {
                            case let .success(commentItem):
                                comment = commentItem
                                expect(commentItem.message).to(equal("sample comment"))
                            case let .failure(error):
                                fail("Expected create call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let comment = comment else { return }

                    // list
                    let iterator = self.client.files.listComments(forFile: file.id, offset: 0, limit: 100)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                expect(page.entries[0].id).to(equal(comment.id))
                                expect(page.entries[0].message).to(equal(comment.message))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("collaboration") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly add and list a collaborations for a file") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var collaboration: Collaboration?

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.collaborations.create(
                            itemType: "file",
                            itemId: file.id,
                            role: .editor,
                            accessibleBy: Configuration.shared.collaboratorId,
                            accessibleByType: .user,
                            fields: ["role", "accessible_by"]
                        ) { result in
                            switch result {
                            case let .success(collaborationItem):
                                collaboration = collaborationItem
                                expect(collaborationItem.role).to(equal(.editor))
                                expect(collaborationItem.accessibleByUser?.id).to(equal(Configuration.shared.collaboratorId))
                            case let .failure(error):
                                fail("Expected create call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let collaboration = collaboration else { return }

                    // list
                    let iterator = self.client.files.listCollaborations(forFile: file.id, limit: 100, fields: ["role", "accessible_by"])

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                expect(page.entries[0].id).to(equal(collaboration.id))
                                expect(page.entries[0].role).to(equal(.editor))
                                expect(page.entries[0].accessibleByUser?.id).to(equal(Configuration.shared.collaboratorId))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("task") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly create and list a tasks for a file") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    var task: Task?
                    let dueAtDate = Date().tomorrow

                    // create
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.tasks.create(
                            fileId: file.id,
                            action: .review,
                            message: "sample message",
                            dueAt: dueAtDate,
                            completionRule: .allAssignees,
                            fields: ["item", "action", "message", "due_at"]
                        ) { result in
                            switch result {
                            case let .success(taskItem):
                                task = taskItem
                                expect(taskItem.action).to(equal(.review))
                                expect(taskItem.message).to(equal("sample message"))
                                expect(taskItem.dueAt?.iso8601).to(equal(dueAtDate.iso8601))
                                expect(taskItem.fileItem?.id).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected create call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let task = task else { return }

                    // list
                    let iterator = self.client.files.listTasks(forFile: file.id, fields: ["item", "action", "message", "due_at"])

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).to(equal(1))
                                expect(page.entries[0].id).to(equal(task.id))
                                expect(page.entries[0].action).to(equal(.review))
                                expect(page.entries[0].message).to(equal("sample message"))
                                expect(page.entries[0].dueAt?.iso8601).to(equal(dueAtDate.iso8601))
                                expect(page.entries[0].fileItem?.id).to(equal(file.id))
                            case let .failure(error):
                                fail("Expected list call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("zip") {
                var file: File?
                var childFolder: Folder?

                beforeEach {
                    self.createFolder(name: NameGenerator.getUniqueFolderName(), parentId: self.rootFolder.id) { createdFolder in childFolder = createdFolder }
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                    self.uploadFile(fileName: IntegrationTestResources.smallImage.fileName, toFolder: childFolder?.id) { _ in }
                }

                afterEach {
                    self.deleteFolder(childFolder, recursive: true)
                    self.deleteFile(file)
                }

                it("should correctly download zip file") {
                    guard let file = file, let childFolder = childFolder else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    let zipItems = [
                        ZipDownloadItem(id: file.id, type: "file"),
                        ZipDownloadItem(id: childFolder.id, type: "folder")
                    ]

                    let zipFileName = NameGenerator.getUniqueFileName(withExtension: "zip")
                    let destinationUrl = FileUtil.getDestinationUrl(for: zipFileName)

                    // create & download
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.downloadZip(
                            name: zipFileName,
                            items: zipItems,
                            destinationURL: destinationUrl
                        ) { result in
                            switch result {
                            case let .success(status):
                                expect(FileManager().fileExists(atPath: destinationUrl.path)).to(equal(true))

                                guard let downloadedContent = try? Data(contentsOf: destinationUrl) else {
                                    fail("Can not read downloaded file")
                                    done()
                                    return
                                }

                                expect(downloadedContent.count).notTo(equal(0))
                                expect(status.totalFileCount).to(equal(2))
                                expect(status.state).to(equal("succeeded"))

                            case let .failure(error):
                                fail("Expected downloadZip call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("representation") {
                var file: File?

                beforeEach {
                    self.uploadFile(fileName: IntegrationTestResources.smallPdf.fileName, toFolder: self.rootFolder.id) { uploadedFile in file = uploadedFile }
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly list and get content of representations") {
                    guard let file = file else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.listRepresentations(
                            fileId: file.id,
                            representationHint: .thumbnail
                        ) { result in
                            switch result {
                            case let .success(representations):
                                expect(representations.contains { item in item.representation == "jpg" }).to(be(true))
                            case let .failure(error):
                                fail("Expected listRepresentations call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    let downloadedFileName = NameGenerator.getUniqueFileName(withExtension: "pdf")
                    let destinationUrl = FileUtil.getDestinationUrl(for: downloadedFileName)

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getRepresentationContent(
                            fileId: file.id,
                            representationHint: .imageMedium,
                            destinationURL: destinationUrl
                        ) { result in
                            switch result {
                            case .success:
                                expect(FileManager().fileExists(atPath: destinationUrl.path)).to(equal(true))

                                guard let downloadedContent = try? Data(contentsOf: destinationUrl) else {
                                    fail("Can not read downloaded file")
                                    return
                                }

                                expect(downloadedContent.count).notTo(equal(0))
                            case let .failure(error):
                                fail("Expected getRepresentationContent call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }
                }
            }

            context("chanked upload") {
                let fileContent = FileUtil.getFileContent(fileName: IntegrationTestResources.bigImage.fileName)
                var file: File?

                beforeEach {
                    file = nil
                }

                afterEach {
                    self.deleteFile(file)
                }

                it("should correctly upload and commit a file by using session") {
                    guard let fileContent = fileContent else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // create session
                    var session: UploadSession?

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.createUploadSession(
                            folderId: self.rootFolder.id,
                            fileName: IntegrationTestResources.bigImage.fileName,
                            fileSize: Int32(fileContent.count)
                        ) { result in
                            switch result {
                            case let .success(sessionItem):
                                session = sessionItem
                                expect(sessionItem.numPartsProcessed).to(equal(0))
                                expect(sessionItem.totalParts).notTo(equal(0))
                                expect(sessionItem.partSize).notTo(equal(0))
                                expect(sessionItem.sessionEndpoints.uploadPart).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.listParts).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.commit).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.abort).notTo(beNil())
                            case let .failure(error):
                                fail("Expected createUploadSession call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let session = session else { return }

                    // upload all parts of file
                    var isUploadedSuccessfully: Bool = false

                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        self.uploadParts(in: session, data: fileContent) { isSuccess in
                            isUploadedSuccessfully = isSuccess
                            done()
                        }
                    }
                    guard isUploadedSuccessfully else {
                        fail("Can not upload a file by using uploadPart method")
                        return
                    }

                    // get uploaded parts
                    var uploadedParts: [UploadPartDescription] = []

                    let iterator = self.client.files.listUploadSessionParts(sessionId: session.id, offset: 0, limit: 100)
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).notTo(equal(0))
                                uploadedParts.append(contentsOf: page.entries)
                            case let .failure(error):
                                fail("Expected listUploadSessionParts call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // commit upload session
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.commitUpload(
                            sessionId: session.id,
                            parts: uploadedParts,
                            sha1: CryptographyUtil.sha1(for: fileContent).base64EncodedString()
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                file = fileItem
                                expect(fileItem.name).to(equal(IntegrationTestResources.bigImage.fileName))
                            case let .failure(error):
                                fail("Expected commitUpload call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }
                }

                it("should correctly abort session for upload a file") {
                    guard let fileContent = fileContent else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // create session
                    var session: UploadSession?

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.createUploadSession(
                            folderId: self.rootFolder.id,
                            fileName: IntegrationTestResources.bigImage.fileName,
                            fileSize: Int32(fileContent.count)
                        ) { result in
                            switch result {
                            case let .success(sessionItem):
                                session = sessionItem
                                expect(sessionItem.numPartsProcessed).to(equal(0))
                                expect(sessionItem.totalParts).notTo(equal(0))
                                expect(sessionItem.partSize).notTo(equal(0))
                                expect(sessionItem.sessionEndpoints.uploadPart).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.listParts).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.commit).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.abort).notTo(beNil())
                            case let .failure(error):
                                fail("Expected createUploadSession call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let session = session else { return }

                    // abort session
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.abortUpload(sessionId: session.id) { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected abortUpload call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    // get upload session
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.getUploadSession(sessionId: session.id) { result in
                            switch result {
                            case .success:
                                fail("Expected getUploadSession call to fail, but instead call succeeded.")
                            case let .failure(error):
                                expect(error).notTo(beNil())
                            }

                            done()
                        }
                    }
                }

                it("should correctly upload and commit a file version by using session") {
                    var initialFile: File?
                    self.uploadFile(fileName: IntegrationTestResources.smallImage.fileName, toFolder: self.rootFolder.id) { uploadedFile in initialFile = uploadedFile }

                    guard let initialFile = initialFile, let fileContent = fileContent else {
                        fail("An error occurred during setup initial data")
                        return
                    }

                    // create session
                    var session: UploadSession?

                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.createUploadSessionForNewVersion(
                            ofFile: initialFile.id,
                            fileName: IntegrationTestResources.bigImage.fileName,
                            fileSize: Int32(fileContent.count)
                        ) { result in
                            switch result {
                            case let .success(sessionItem):
                                session = sessionItem
                                expect(sessionItem.numPartsProcessed).to(equal(0))
                                expect(sessionItem.totalParts).notTo(equal(0))
                                expect(sessionItem.partSize).notTo(equal(0))
                                expect(sessionItem.sessionEndpoints.uploadPart).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.listParts).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.commit).notTo(beNil())
                                expect(sessionItem.sessionEndpoints.abort).notTo(beNil())
                            case let .failure(error):
                                fail("Expected createUploadSessionForNewVersion call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }

                    guard let session = session else { return }

                    // upload all parts of file
                    var isUploadedSuccessfully: Bool = false

                    waitUntil(timeout: .seconds(Constants.Timeout.large)) { done in
                        self.uploadParts(in: session, data: fileContent) { isSuccess in
                            isUploadedSuccessfully = isSuccess
                            done()
                        }
                    }

                    guard isUploadedSuccessfully else {
                        fail("Can not upload a file by using uploadPart method")
                        return
                    }

                    // get uploaded parts
                    var uploadedParts: [UploadPartDescription] = []

                    let iterator = self.client.files.listUploadSessionParts(sessionId: session.id, offset: 0, limit: 100)
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                expect(page.entries.count).notTo(equal(0))
                                uploadedParts.append(contentsOf: page.entries)
                            case let .failure(error):
                                fail("Expected listUploadSessionParts call to succeed, but instead got \(error)")
                            }

                            done()
                        }
                    }

                    // commit upload session
                    waitUntil(timeout: .seconds(Constants.Timeout.default)) { done in
                        self.client.files.commitUpload(
                            sessionId: session.id,
                            parts: uploadedParts,
                            sha1: CryptographyUtil.sha1(for: fileContent).base64EncodedString()
                        ) { result in
                            switch result {
                            case let .success(fileItem):
                                file = fileItem
                                expect(fileItem.name).to(equal(IntegrationTestResources.bigImage.fileName))
                            case let .failure(error):
                                fail("Expected commitUpload call to suceeded, but it failed \(error)")
                            }

                            done()
                        }
                    }
                }
            }
        }
    }
}

extension FileModuleIntegrationSpecs {
    func uploadParts(in session: UploadSession, data: Data, part: Int = 0, completion: @escaping (Bool) -> Void) {
        let startPosition = part * session.partSize
        let endPosition = min(data.count, startPosition + session.partSize)
        let chunk = data.subdata(in: startPosition ..< endPosition)

        client.files.uploadPart(
            sessionId: session.id,
            data: chunk,
            offset: startPosition,
            totalSize: data.count
        ) { result in
            switch result {
            case .success:
                if chunk.count < session.partSize {
                    completion(true)
                }
                else {
                    self.uploadParts(in: session, data: data, part: part + 1, completion: completion)
                }
            case let .failure(error):
                fail("Expected uploadPart call to suceeded, but it failed \(error)")
                completion(false)
            }
        }
    }
}
