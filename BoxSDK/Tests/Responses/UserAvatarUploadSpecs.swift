//
//  UserAvatarUploadSpecs.swift
//  BoxSDKTests-iOS
//
//  Created by Artur Jankowski on 12/07/2022.
//  Copyright © 2022 box. All rights reserved.
//

@testable import BoxSDK
import Nimble
import Quick

class UserAvatarUploadSpecs: QuickSpec {

    override class func spec() {
        describe("UserAvatarUpload") {

            describe("init()") {
                it("should correctly deserialize from full JSON representation") {
                    guard let filepath = TestAssets.path(forResource: "UploadUserAvatar.json") else {
                        fail("Could not find fixture file.")
                        return
                    }

                    do {
                        let contents = try String(contentsOfFile: filepath)
                        let jsonDict = try JSONSerialization.jsonObject(with: contents.data(using: .utf8)!) as! [String: Any]
                        let userAvatarUpload = try UserAvatarUpload(json: jsonDict)

                        expect(userAvatarUpload.picUrls.large).to(equal("https://app.box.com/index.php?rm=pic_storage_auth&pic=euks pac3kv01!lipGQlQQOtCTCoB6zCOArUjVWLFJtLr5tn6aOZMCybhRx0NNuFQbVI36nw jtEk5YjUUz1KVdVuvU2yDhu_ftK_bvxeKP1Ffrx9vKGVvJ-UJc1z32p6n2CmFzzpc gSoX4pnPhFgydAL-u9jDspXUGElr-htDG_HPMiE9DZjqDueOxXHy8xe22wbaPAheC ao1emv8r_fmufaUgSndeMYmyZj-KqOYsLBrBNgdeiK5tZmPOQggAEUmyQPkrd8W92TQ6sSlIp0r"))
                        expect(userAvatarUpload.picUrls.small).to(equal("https://app.box.com/index.php?rm=pic_storage_auth&pic=euks! pac3kv01!7B6R5cZLmurEV_xB-KkycPk8Oi7oENUX2O_qUtIuO4342CG IldyCto9hqiQP7uxqYU5V2w63Ft4ln4UVVLDtDZu903OqzkflY2O-Lq00 ubA29xU-RJ6b_KzJEWRYgUhX1zEl3dzWo12g8eWRE2rStf123DF7AYahNqM 1BmLmviL_nODc7SDQHedTXPAjxURUAra5BvtLe7B05AizbNXdPlCNp-LNh _S-eZ_RjDXcGO-MkRWd_3BOMHnvjf450t5BfKoJ15WhEfiMlfXH1tmouHXrsC 66cT6-pzF9E40Iir_zThqSlrFxzP_xcmXzHapr_k-0E2qr2TXp4iC396TSlEw"))
                        expect(userAvatarUpload.picUrls.preview).to(equal("https://app.box.com/index.php?rm=pic_storage_auth&pic=euks! pac3kv01!8UcNPweOOAWj2DtHk_dCQB4wJpzyPkl7mT5nHj5ZdjY92ejYCBBZc95--403b29CW k-8hSo_uBjh5h9QG42Ihu-cOZ-816sej1kof3SOm5gjn7qjMAx89cHjUaNK-6XasRqSNboenjZ 04laZuV9vSH12BZGAYycIZvvQ5R66Go8xG5GTMARf2nBU84c4H_SL5iws-HeBS4oQJWOJh6FBl sSJDSTI74LGXqeZb3EY_As34VFC95F10uozoTOSubZmPYylPlaKXoKWk2f9wYQso1ZTN7sh-Gc 9Kp43zMLhArIWhok0Im6FlRAuWOQ03KYgL-k4L5EZp4Gw6B7uqVRwcBbsTwMIorWq1g"))
                    }
                    catch {
                        fail("Failed with Error: \(error)")
                    }
                }
            }
        }
    }
}
