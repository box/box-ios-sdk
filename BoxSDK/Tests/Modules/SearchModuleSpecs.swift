//
//  SearchModuleSpecs
//  BoxSDK
//
//  Created by Matt Willer on 5/3/2019.
//  Copyright © 2019 Box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import OHHTTPStubs
import Quick

class SearchModuleSpecs: QuickSpec {

    override class func spec() {

        describe("SearchModule") {
            var client: BoxClient!

            beforeEach {
                client = BoxSDK.getClient(token: "asdf")
            }

            afterEach {
                HTTPStubs.removeAllStubs()
            }

            context("query()") {

                it("should make request with simple search query when only query is provided") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["query": "test"])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = client.search.query(query: "test")
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let item = page.entries[0]
                                guard case let .file(file) = item else {
                                    fail("Expected test item to be a file")
                                    done()
                                    return
                                }
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal("11111"))
                                expect(file.name).to(equal("test file.txt"))
                                expect(file.description).to(equal(""))
                                expect(file.size).to(equal(16))

                            case let .failure(error):
                                fail("Expected search request to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make request with metadata search filters with greater than relation") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && compareComplexQueryParam("mdfilters", ["\"filters\":{\"date\":{\"gt\":\"2019-07-24T12:00:00Z\"}}",
                                                                      "\"templateKey\":\"marketingCollateral\"",
                                                                      "\"scope\":\"global\""
                                ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "date", fieldValue: "2019-07-24T12:00:00Z", scope: MetadataScope.global, relation: MetadataFilterBound.greaterThan)
                        let iterator = client.search.query(query: nil, metadataFilter: searchFilter)
                        iterator.next { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Error with: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make request with metadata search filters with less than relation") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && compareComplexQueryParam("mdfilters", ["\"filters\":{\"date\":{\"lt\":\"2019-07-24T12:00:00Z\"}}",
                                                                      "\"templateKey\":\"marketingCollateral\"",
                                                                      "\"scope\":\"enterprise\""
                                ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "date", fieldValue: "2019-07-24T12:00:00Z", scope: MetadataScope.enterprise, relation: MetadataFilterBound.lessThan)
                        let iterator = client.search.query(query: nil, metadataFilter: searchFilter)
                        iterator.next { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Error with: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make request with metadata search filters with enterprise scope.") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && compareComplexQueryParam("mdfilters", ["\"filters\":{\"documentType\":\"dataSheet\"}",
                                                                      "\"templateKey\":\"marketingCollateral\"",
                                                                      "\"scope\":\"enterprise\""
                                ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "documentType", fieldValue: "dataSheet", scope: MetadataScope.enterprise)
                        let iterator = client.search.query(query: nil, metadataFilter: searchFilter)
                        iterator.next { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Error with: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make request with metadata search filters with global scope.") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && compareComplexQueryParam("mdfilters", ["\"filters\":{\"documentType\":\"dataSheet\"}",
                                                                      "\"templateKey\":\"marketingCollateral\"",
                                                                      "\"scope\":\"global\""
                                ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "documentType", fieldValue: "dataSheet", scope: MetadataScope.global)
                        let iterator = client.search.query(query: nil, metadataFilter: searchFilter)
                        iterator.next { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Error with: \(error)")
                            }
                            done()
                        }
                    }
                }

                it("should make request with query parameters populated when optional parameters are provided") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams([
                                "query": "test",
                                "scope": "user_content",
                                "file_extensions": "pdf,docx",
                                "created_at_range": "2019-05-15T21:52:15Z,2019-05-15T21:53:00Z",
                                "updated_at_range": "2019-05-15T21:53:27Z,2019-05-15T21:53:44Z",
                                "size_range": "1024,4096",
                                "owner_user_ids": "11111,22222",
                                "ancestor_folder_ids": "33333,44444",
                                "content_types": "name,description,comments,file_content,tags",
                                "type": "file",
                                "trash_content": "non_trashed_only"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "Search200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = client.search.query(
                            query: "test",
                            scope: .user,
                            fileExtensions: ["pdf", "docx"],
                            createdAfter: Date(timeIntervalSince1970: 1_557_957_135), // 2019-05-15T21:52:15Z
                            createdBefore: Date(timeIntervalSince1970: 1_557_957_180), // 2019-05-15T21:53:00Z
                            updatedAfter: Date(timeIntervalSince1970: 1_557_957_207), // 2019-05-15T21:53:27Z
                            updatedBefore: Date(timeIntervalSince1970: 1_557_957_224), // 2019-05-15T21:53:44Z
                            sizeAtLeast: 1024,
                            sizeAtMost: 4096,
                            ownerUserIDs: ["11111", "22222"],
                            ancestorFolderIDs: ["33333", "44444"],
                            searchIn: [.name, .description, .comments, .fileContents, .tags],
                            itemType: .file,
                            searchTrash: false
                        )
                        iterator.next { result in
                            switch result {
                            case .success:
                                break
                            case let .failure(error):
                                fail("Expected request to succeed, but instead got \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("queryWithSharedLinks()") {

                it("should make request with simple search query and shared links query parameter when only query is provided") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams([
                                "query": "test",
                                "created_at_range": "2019-05-15T21:52:15Z,2019-05-15T21:53:00Z",
                                "updated_at_range": "2019-05-15T21:53:27Z,2019-05-15T21:53:44Z",
                                "size_range": "1024,4096",
                                "include_recent_shared_links": "true"
                            ])
                    ) { _ in
                        HTTPStubsResponse(
                            fileAtPath: TestAssets.path(forResource: "SearchResult200.json")!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: .seconds(10)) { done in
                        let iterator = client.search.queryWithSharedLinks(
                            query: "test",
                            createdAfter: Date(timeIntervalSince1970: 1_557_957_135), // 2019-05-15T21:52:15Z
                            createdBefore: Date(timeIntervalSince1970: 1_557_957_180), // 2019-05-15T21:53:00Z
                            updatedAfter: Date(timeIntervalSince1970: 1_557_957_207), // 2019-05-15T21:53:27Z
                            updatedBefore: Date(timeIntervalSince1970: 1_557_957_224), // 2019-05-15T21:53:44Z
                            sizeAtLeast: 1024,
                            sizeAtMost: 4096
                        )
                        iterator.next { result in
                            switch result {
                            case let .success(page):
                                let searchResult = page.entries[0]
                                let item = searchResult.item
                                guard case let .file(file) = item else {
                                    fail("Expected test item to be a file")
                                    done()
                                    return
                                }
                                expect(file).toNot(beNil())
                                expect(file.id).to(equal("11111"))
                                expect(file.name).to(equal("test file.txt"))
                                expect(file.description).to(equal(""))
                                expect(file.size).to(equal(16))
                                expect(searchResult.accessibleViaSharedLink?.absoluteString).to(equal("https://www.box.com/s/vspke7y05sb214wjokpk"))

                            case let .failure(error):
                                fail("Expected search request to succeed, but it failed: \(error)")
                            }
                            done()
                        }
                    }
                }
            }

            context("SearchScope") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(SearchScope.user).to(equal(SearchScope(SearchScope.user.description)))
                        expect(SearchScope.enterprise).to(equal(SearchScope(SearchScope.enterprise.description)))
                        expect(SearchScope.customValue("custom value")).to(equal(SearchScope("custom value")))
                    }
                }
            }

            context("SearchContentType") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(SearchContentType.name).to(equal(SearchContentType(SearchContentType.name.description)))
                        expect(SearchContentType.description).to(equal(SearchContentType(SearchContentType.description.description)))
                        expect(SearchContentType.fileContents).to(equal(SearchContentType(SearchContentType.fileContents.description)))
                        expect(SearchContentType.comments).to(equal(SearchContentType(SearchContentType.comments.description)))
                        expect(SearchContentType.tags).to(equal(SearchContentType(SearchContentType.tags.description)))
                        expect(SearchContentType.customValue("custom value")).to(equal(SearchContentType("custom value")))
                    }
                }
            }

            context("SearchItemType") {

                describe("init()") {

                    it("should correctly create an enum value from it's string representation") {
                        expect(SearchItemType.file).to(equal(SearchItemType(SearchItemType.file.description)))
                        expect(SearchItemType.folder).to(equal(SearchItemType(SearchItemType.folder.description)))
                        expect(SearchItemType.webLink).to(equal(SearchItemType(SearchItemType.webLink.description)))
                        expect(SearchItemType.customValue("custom value")).to(equal(SearchItemType("custom value")))
                    }
                }
            }
        }
    }
}
