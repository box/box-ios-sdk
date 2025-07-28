import Foundation
import BoxSdkGen

public class CommonsManager {
    public init() {
    }

    public func getCcgAuth() -> BoxCCGAuth {
        let ccgConfig: CCGConfig = CCGConfig(clientId: Utils.getEnvironmentVariable(name: "CLIENT_ID"), clientSecret: Utils.getEnvironmentVariable(name: "CLIENT_SECRET"), enterpriseId: Utils.getEnvironmentVariable(name: "ENTERPRISE_ID"))
        let auth: BoxCCGAuth = BoxCCGAuth(config: ccgConfig)
        return auth
    }

    public func getDefaultClientWithUserSubject(userId: String) -> BoxClient {
        let auth: BoxCCGAuth = getCcgAuth()
        let authUser: BoxCCGAuth = auth.withUserSubject(userId: userId)
        return BoxClient(auth: authUser)
    }

    public func getDefaultClient() -> BoxClient {
        let client: BoxClient = BoxClient(auth: getCcgAuth())
        return client
    }

    public func createNewFolder() async throws -> FolderFull {
        let client: BoxClient = CommonsManager().getDefaultClient()
        let newFolderName: String = Utils.getUUID()
        return try await client.folders.createFolder(requestBody: CreateFolderRequestBody(name: newFolderName, parent: CreateFolderRequestBodyParentField(id: "0")))
    }

    public func uploadNewFile() async throws -> FileFull {
        let client: BoxClient = CommonsManager().getDefaultClient()
        let newFileName: String = "\(Utils.getUUID())\(".pdf")"
        let fileContentStream: InputStream = Utils.generateByteStream(size: 1024 * 1024)
        let uploadedFiles: Files = try await client.uploads.uploadFile(requestBody: UploadFileRequestBody(attributes: UploadFileRequestBodyAttributesField(name: newFileName, parent: UploadFileRequestBodyAttributesParentField(id: "0")), file: fileContentStream))
        return uploadedFiles.entries![0]
    }

    public func getOrCreateTermsOfServices() async throws -> TermsOfService {
        let client: BoxClient = CommonsManager().getDefaultClient()
        let tos: TermsOfServices = try await client.termsOfServices.getTermsOfService()
        let numberOfTos: Int = tos.entries!.count
        if numberOfTos >= 1 {
            let firstTos: TermsOfService = tos.entries![0]
            if Utils.Strings.toString(value: firstTos.tosType) == "managed" {
                return firstTos
            }

        }

        if numberOfTos >= 2 {
            let secondTos: TermsOfService = tos.entries![1]
            if Utils.Strings.toString(value: secondTos.tosType) == "managed" {
                return secondTos
            }

        }

        return try await client.termsOfServices.createTermsOfService(requestBody: CreateTermsOfServiceRequestBody(status: CreateTermsOfServiceRequestBodyStatusField.disabled, text: "Test TOS", tosType: CreateTermsOfServiceRequestBodyTosTypeField.managed))
    }

    public func getOrCreateClassification(classificationTemplate: ClassificationTemplate) async throws -> ClassificationTemplateFieldsOptionsField {
        let client: BoxClient = CommonsManager().getDefaultClient()
        let classifications: [ClassificationTemplateFieldsOptionsField] = classificationTemplate.fields[0].options
        let currentNumberOfClassifications: Int = classifications.count
        if currentNumberOfClassifications == 0 {
            let classificationTemplateWithNewClassification: ClassificationTemplate = try await client.classifications.addClassification(requestBody: [AddClassificationRequestBody(data: AddClassificationRequestBodyDataField(key: Utils.getUUID(), staticConfig: AddClassificationRequestBodyDataStaticConfigField(classification: AddClassificationRequestBodyDataStaticConfigClassificationField(classificationDefinition: "Some description", colorId: Int64(3)))))])
            return classificationTemplateWithNewClassification.fields[0].options[0]
        }

        return classifications[0]
    }

    public func getOrCreateClassificationTemplate() async throws -> ClassificationTemplate {
        let client: BoxClient = CommonsManager().getDefaultClient()
        do {
            return try await client.classifications.getClassificationTemplate()
        } catch {
            return try await client.classifications.createClassificationTemplate(requestBody: CreateClassificationTemplateRequestBody(fields: [CreateClassificationTemplateRequestBodyFieldsField(options: [])]))
        }

    }

    public func getOrCreateShieldInformationBarrier(client: BoxClient, enterpriseId: String) async throws -> ShieldInformationBarrier {
        let barriers: ShieldInformationBarriers = try await client.shieldInformationBarriers.getShieldInformationBarriers()
        let numberOfBarriers: Int = barriers.entries!.count
        if numberOfBarriers == 0 {
            return try await client.shieldInformationBarriers.createShieldInformationBarrier(requestBody: CreateShieldInformationBarrierRequestBody(enterprise: EnterpriseBase(id: enterpriseId)))
        }

        return barriers.entries![numberOfBarriers - 1]
    }

}
