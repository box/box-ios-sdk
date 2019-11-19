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
    var client: BoxClient!

    override func spec() {
        describe("SearchModule") {
            beforeEach {
                self.client = BoxSDK.getClient(token: "asdf")
            }

            afterEach {
                OHHTTPStubs.removeAllStubs()
            }

            context("query()") {

                it("should make request with simple search query when only query is provided") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["query": "test"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.client.search.query(query: "test") { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case let .success(item):
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
                            case let .failure(error):
                                fail("Expected search request to succeed, but it failed: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should make request with metadata search filters with greater than relation") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["mdfilters": "[{\"scope\":\"global\",\"templateKey\":\"marketingCollateral\",\"filters\":{\"date\":{\"gt\":\"2019-07-24T12:00:00Z\"}}}]"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "date", fieldValue: "2019-07-24T12:00:00Z", scope: MetadataScope.global, relation: MetadataFilterBound.greaterThan)
                        self.client.search.query(query: nil, metadataFilter: searchFilter) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case .success:
                                        break
                                    case let .failure(error):
                                        fail("Error with: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Error with: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should make request with metadata search filters with less than relation") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["mdfilters": "[{\"scope\":\"enterprise\",\"templateKey\":\"marketingCollateral\",\"filters\":{\"date\":{\"lt\":\"2019-07-24T12:00:00Z\"}}}]"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "date", fieldValue: "2019-07-24T12:00:00Z", scope: MetadataScope.enterprise, relation: MetadataFilterBound.lessThan)
                        self.client.search.query(query: nil, metadataFilter: searchFilter) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case .success:
                                        break
                                    case let .failure(error):
                                        fail("Error with: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Error with: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should make request with metadata search filters with enterprise scope.") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["mdfilters": "[{\"scope\":\"enterprise\",\"templateKey\":\"marketingCollateral\",\"filters\":{\"documentType\":\"dataSheet\"}}]"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "documentType", fieldValue: "dataSheet", scope: MetadataScope.enterprise)
                        self.client.search.query(query: nil, metadataFilter: searchFilter) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case .success:
                                        break
                                    case let .failure(error):
                                        fail("Error with: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Error with: \(error)")
                                done()
                            }
                        }
                    }
                }

                it("should make request with metadata search filters with global scope.") {
                    stub(
                        condition:
                        isHost("api.box.com") && isPath("/2.0/search")
                            && containsQueryParams(["mdfilters": "[{\"scope\":\"global\",\"templateKey\":\"marketingCollateral\",\"filters\":{\"documentType\":\"dataSheet\"}}]"])
                    ) { _ in
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        let searchFilter = MetadataSearchFilter()
                        searchFilter.addFilter(templateKey: "marketingCollateral", fieldKey: "documentType", fieldValue: "dataSheet", scope: MetadataScope.global)
                        self.client.search.query(query: nil, metadataFilter: searchFilter) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case .success:
                                        break
                                    case let .failure(error):
                                        fail("Error with: \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Error with: \(error)")
                                done()
                            }
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
                        OHHTTPStubsResponse(
                            fileAtPath: OHPathForFile("Search200.json", type(of: self))!,
                            statusCode: 200, headers: ["Content-Type": "application/json"]
                        )
                    }

                    waitUntil(timeout: 10) { done in
                        self.client.search.query(
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
                        ) { results in
                            switch results {
                            case let .success(iterator):
                                iterator.next { result in
                                    switch result {
                                    case .success:
                                        break
                                    case let .failure(error):
                                        fail("Expected request to succeed, but instead got \(error)")
                                    }
                                    done()
                                }
                            case let .failure(error):
                                fail("Expected request to succeed, but instead got \(error)")
                                done()
                            }
                        }
                    }
                }
            }
        }
    }
}
