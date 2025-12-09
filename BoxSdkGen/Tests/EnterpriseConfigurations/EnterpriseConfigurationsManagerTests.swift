import Foundation
import BoxSdkGen
import XCTest

class EnterpriseConfigurationsManagerTests: RetryableTestCase {
    var adminClient: BoxClient!

    override func setUp() async throws {
        adminClient = CommonsManager().getDefaultClientWithUserSubject(userId: Utils.getEnvironmentVariable(name: "USER_ID"))
    }

    public func testGetEnterpriseConfigurationById() async throws {
        await runWithRetryAsync {
            let enterpriseId: String = Utils.getEnvironmentVariable(name: "ENTERPRISE_ID")
            let enterpriseConfiguration: EnterpriseConfigurationV2025R0 = try await adminClient.enterpriseConfigurations.getEnterpriseConfigurationByIdV2025R0(enterpriseId: enterpriseId, queryParams: GetEnterpriseConfigurationByIdV2025R0QueryParams(categories: ["user_settings", "content_and_sharing", "security", "shield"]))
            XCTAssertTrue(Utils.Strings.toString(value: enterpriseConfiguration.type) == "enterprise_configuration")
            let userSettings: EnterpriseConfigurationUserSettingsV2025R0 = enterpriseConfiguration.userSettings!
            XCTAssertTrue(userSettings.isEnterpriseSsoRequired!.value == false)
            XCTAssertTrue(userSettings.newUserDefaultLanguage!.value == "English (US)")
            XCTAssertTrue(userSettings.newUserDefaultStorageLimit!.value == -1)
            let contentAndSharing: EnterpriseConfigurationContentAndSharingV2025R0 = enterpriseConfiguration.contentAndSharing!
            XCTAssertTrue(contentAndSharing.collaborationPermissions!.value!.isEditorRoleEnabled == true)
            let security: EnterpriseConfigurationSecurityV2025R0 = enterpriseConfiguration.security!
            XCTAssertTrue(security.isManagedUserSignupEnabled!.value! == false)
            let shield: EnterpriseConfigurationShieldV2025R0 = enterpriseConfiguration.shield!
            XCTAssertTrue(shield.shieldRules!.count == 0)
        }
    }
}
