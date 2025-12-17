import Foundation
import BoxSdkGen
import XCTest

class MetadataTaxonomiesManagerTests: RetryableTestCase {
    var client: BoxClient!

    override func setUp() async throws {
        client = CommonsManager().getDefaultClient()
    }

    public func testMetadataTaxonomiesCrud() async throws {
        await runWithRetryAsync {
            let namespace: String = "\("enterprise_")\(Utils.getEnvironmentVariable(name: "ENTERPRISE_ID"))"
            let uuid: String = Utils.getUUID()
            let taxonomyKey: String = "\("geography")\(uuid)"
            let displayName: String = "\("Geography Taxonomy")\(uuid)"
            let createdTaxonomy: MetadataTaxonomy = try await client.metadataTaxonomies.createMetadataTaxonomy(requestBody: CreateMetadataTaxonomyRequestBody(displayName: displayName, namespace: namespace, key: taxonomyKey))
            XCTAssertTrue(createdTaxonomy.displayName == displayName)
            XCTAssertTrue(createdTaxonomy.namespace == namespace)
            let taxonomies: MetadataTaxonomies = try await client.metadataTaxonomies.getMetadataTaxonomies(namespace: namespace)
            XCTAssertTrue(taxonomies.entries!.count > 0)
            XCTAssertTrue(taxonomies.entries![0].namespace == namespace)
            let updatedDisplayName: String = "\("Geography Taxonomy UPDATED")\(uuid)"
            let updatedTaxonomy: MetadataTaxonomy = try await client.metadataTaxonomies.updateMetadataTaxonomy(namespace: namespace, taxonomyKey: taxonomyKey, requestBody: UpdateMetadataTaxonomyRequestBody(displayName: updatedDisplayName))
            XCTAssertTrue(updatedTaxonomy.displayName == updatedDisplayName)
            XCTAssertTrue(updatedTaxonomy.namespace == namespace)
            XCTAssertTrue(updatedTaxonomy.id == createdTaxonomy.id)
            let getTaxonomy: MetadataTaxonomy = try await client.metadataTaxonomies.getMetadataTaxonomyByKey(namespace: namespace, taxonomyKey: taxonomyKey)
            XCTAssertTrue(getTaxonomy.displayName == updatedDisplayName)
            XCTAssertTrue(getTaxonomy.namespace == namespace)
            XCTAssertTrue(getTaxonomy.id == createdTaxonomy.id)
            try await client.metadataTaxonomies.deleteMetadataTaxonomy(namespace: namespace, taxonomyKey: taxonomyKey)
            await XCTAssertThrowsErrorAsync(try await client.metadataTaxonomies.getMetadataTaxonomyByKey(namespace: namespace, taxonomyKey: taxonomyKey))
        }
    }

    public func testMetadataTaxonomiesNodes() async throws {
        await runWithRetryAsync {
            let namespace: String = "\("enterprise_")\(Utils.getEnvironmentVariable(name: "ENTERPRISE_ID"))"
            let uuid: String = Utils.getUUID()
            let taxonomyKey: String = "\("geography")\(uuid)"
            let displayName: String = "\("Geography Taxonomy")\(uuid)"
            let createdTaxonomy: MetadataTaxonomy = try await client.metadataTaxonomies.createMetadataTaxonomy(requestBody: CreateMetadataTaxonomyRequestBody(displayName: displayName, namespace: namespace, key: taxonomyKey))
            XCTAssertTrue(createdTaxonomy.displayName == displayName)
            XCTAssertTrue(createdTaxonomy.namespace == namespace)
            let taxonomyLevels: MetadataTaxonomyLevels = try await client.metadataTaxonomies.createMetadataTaxonomyLevel(namespace: namespace, taxonomyKey: taxonomyKey, requestBody: [MetadataTaxonomyLevel(displayName: "Continent", description: "Continent Level"), MetadataTaxonomyLevel(displayName: "Country", description: "Country Level")])
            XCTAssertTrue(taxonomyLevels.entries!.count == 2)
            XCTAssertTrue(taxonomyLevels.entries![0].displayName == "Continent")
            XCTAssertTrue(taxonomyLevels.entries![1].displayName == "Country")
            let taxonomyLevelsAfterAddition: MetadataTaxonomyLevels = try await client.metadataTaxonomies.addMetadataTaxonomyLevel(namespace: namespace, taxonomyKey: taxonomyKey, requestBody: AddMetadataTaxonomyLevelRequestBody(displayName: "Region", description: "Region Description"))
            XCTAssertTrue(taxonomyLevelsAfterAddition.entries!.count == 3)
            XCTAssertTrue(taxonomyLevelsAfterAddition.entries![2].displayName == "Region")
            let taxonomyLevelsAfterDeletion: MetadataTaxonomyLevels = try await client.metadataTaxonomies.deleteMetadataTaxonomyLevel(namespace: namespace, taxonomyKey: taxonomyKey)
            XCTAssertTrue(taxonomyLevelsAfterDeletion.entries!.count == 2)
            XCTAssertTrue(taxonomyLevelsAfterDeletion.entries![0].displayName == "Continent")
            XCTAssertTrue(taxonomyLevelsAfterDeletion.entries![1].displayName == "Country")
            let continentNode: MetadataTaxonomyNode = try await client.metadataTaxonomies.createMetadataTaxonomyNode(namespace: namespace, taxonomyKey: taxonomyKey, requestBody: CreateMetadataTaxonomyNodeRequestBody(displayName: "Europe", level: 1))
            XCTAssertTrue(continentNode.displayName == "Europe")
            XCTAssertTrue(continentNode.level == 1)
            let countryNode: MetadataTaxonomyNode = try await client.metadataTaxonomies.createMetadataTaxonomyNode(namespace: namespace, taxonomyKey: taxonomyKey, requestBody: CreateMetadataTaxonomyNodeRequestBody(displayName: "Poland", level: 2, parentId: continentNode.id))
            XCTAssertTrue(countryNode.displayName == "Poland")
            XCTAssertTrue(countryNode.level == 2)
            XCTAssertTrue(countryNode.parentId == continentNode.id)
            try await Utils.delayInSeconds(seconds: 5)
            let allNodes: MetadataTaxonomyNodes = try await client.metadataTaxonomies.getMetadataTaxonomyNodes(namespace: namespace, taxonomyKey: taxonomyKey)
            XCTAssertTrue(allNodes.entries!.count == 2)
            let updatedCountryNode: MetadataTaxonomyNode = try await client.metadataTaxonomies.updateMetadataTaxonomyNode(namespace: namespace, taxonomyKey: taxonomyKey, nodeId: countryNode.id, requestBody: UpdateMetadataTaxonomyNodeRequestBody(displayName: "Poland UPDATED"))
            XCTAssertTrue(updatedCountryNode.displayName == "Poland UPDATED")
            XCTAssertTrue(updatedCountryNode.level == 2)
            XCTAssertTrue(updatedCountryNode.parentId == countryNode.parentId)
            XCTAssertTrue(updatedCountryNode.id == countryNode.id)
            let getCountryNode: MetadataTaxonomyNode = try await client.metadataTaxonomies.getMetadataTaxonomyNodeById(namespace: namespace, taxonomyKey: taxonomyKey, nodeId: countryNode.id)
            XCTAssertTrue(getCountryNode.displayName == "Poland UPDATED")
            XCTAssertTrue(getCountryNode.id == countryNode.id)
            try await client.metadataTaxonomies.deleteMetadataTaxonomyNode(namespace: namespace, taxonomyKey: taxonomyKey, nodeId: countryNode.id)
            try await client.metadataTaxonomies.deleteMetadataTaxonomyNode(namespace: namespace, taxonomyKey: taxonomyKey, nodeId: continentNode.id)
            try await Utils.delayInSeconds(seconds: 5)
            let allNodesAfterDeletion: MetadataTaxonomyNodes = try await client.metadataTaxonomies.getMetadataTaxonomyNodes(namespace: namespace, taxonomyKey: taxonomyKey)
            XCTAssertTrue(allNodesAfterDeletion.entries!.count == 0)
            try await client.metadataTaxonomies.deleteMetadataTaxonomy(namespace: namespace, taxonomyKey: taxonomyKey)
        }
    }
}
