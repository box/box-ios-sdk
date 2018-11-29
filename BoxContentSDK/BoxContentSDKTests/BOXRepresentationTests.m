//
//  BOXRepresentationTests.m
//  BoxContentSDKTests
//
//  Created by Thuy Nguyen on 11/15/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXModelTestCase.h"
#import "BOXRepresentation.h"

@interface BOXRepresentationTests : BOXModelTestCase

@end

@implementation BOXRepresentationTests

- (void)test_that_representation_jpg_sucess_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"representation_jpg_success"];
    BOXRepresentation *representation = [[BOXRepresentation alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(BOXRepresentationTypeJPG, representation.type);
    XCTAssertEqualObjects(BOXRepresentationStatusSuccess, representation.status);
    XCTAssertNil(representation.statusCode);
    XCTAssertEqualObjects(@"https://api.box.com/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32", representation.infoURL.absoluteString);
    XCTAssertEqualObjects(@"https://dl3.boxcloud.com/api/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32/content/{+asset_path}", representation.templateURLString);
    XCTAssertEqualObjects(@"https://dl3.boxcloud.com/api/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32/content/", representation.contentURL.absoluteString);
    XCTAssertNil(representation.details);
    XCTAssertEqualObjects(BOXRepresentationImageDimensionsJPG32, representation.dimensions);
}

- (void)test_that_JSON_Dictionary_for_representation_jpg_success_is_reconstructed_correctly
{
    BOXRepresentation *representation = [[BOXRepresentation alloc] init];
    representation.type = BOXRepresentationTypeJPG;
    representation.status = BOXRepresentationStatusSuccess;
    representation.statusCode = nil;
    representation.infoURL = [NSURL URLWithString:@"https://api.box.com/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32"];
    representation.templateURLString = @"https://dl3.boxcloud.com/api/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32/content/{+asset_path}";
    representation.details = nil;
    representation.dimensions = BOXRepresentationImageDimensionsJPG32;

    NSDictionary *representationJSONDict = [representation JSONDictionary];
    NSDictionary *dictionary = @{
        @"representation": @"jpg",
        @"properties": @{
            @"dimensions": @"32x32"
        },
        @"info": @{
            @"url": @"https://api.box.com/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32"
        },
        @"status": @{
            @"state": @"success"
        },
        @"content": @{
            @"url_template": @"https://dl3.boxcloud.com/api/2.0/internal_files/269521907606/versions/283776110047/representations/jpg_thumb_32x32/content/{+asset_path}"
        }
    };

    XCTAssertEqualObjects(dictionary, representationJSONDict);
}


- (void)test_that_representation_hls_sucess_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"representation_hls_success"];
    BOXRepresentation *representation = [[BOXRepresentation alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(BOXRepresentationTypeHLS, representation.type);
    XCTAssertEqualObjects(BOXRepresentationStatusSuccess, representation.status);
    XCTAssertNil(representation.statusCode);
    XCTAssertEqualObjects(@"https://api.box.com/2.0/internal_files/125041766103/versions/133811379927/representations/hls", representation.infoURL.absoluteString);
    XCTAssertEqualObjects(@"https://dl.boxcloud.com/api/2.0/internal_files/125041766103/versions/133811379927/representations/hls/content/{+asset_path}", representation.templateURLString);
    XCTAssertEqualObjects(@"https://dl.boxcloud.com/api/2.0/internal_files/125041766103/versions/133811379927/representations/hls/content/master.m3u8", representation.contentURL.absoluteString);
    XCTAssertNil(representation.details);
    XCTAssertNil(representation.dimensions);
}

- (void)test_that_JSON_Dictionary_for_representation_hls_success_is_reconstructed_correctly
{
    BOXRepresentation *representation = [[BOXRepresentation alloc] init];
    representation.type = BOXRepresentationTypeHLS;
    representation.status = BOXRepresentationStatusSuccess;
    representation.statusCode = nil;
    representation.infoURL = [NSURL URLWithString:@"https://api.box.com/2.0/internal_files/125041766103/versions/133811379927/representations/hls"];
    representation.templateURLString = @"https://dl.boxcloud.com/api/2.0/internal_files/125041766103/versions/133811379927/representations/hls/content/{+asset_path}";
    representation.details = nil;
    representation.dimensions = nil;

    NSDictionary *representationJSONDict = [representation JSONDictionary];
    NSDictionary *dictionary = @{
                                     @"representation": @"hls",
                                     @"info": @{
                                         @"url": @"https://api.box.com/2.0/internal_files/125041766103/versions/133811379927/representations/hls"
                                     },
                                     @"content": @{
                                         @"url_template": @"https://dl.boxcloud.com/api/2.0/internal_files/125041766103/versions/133811379927/representations/hls/content/{+asset_path}"
                                     },
                                     @"status": @{
                                         @"state": @"success"
                                     }
                                 };

    XCTAssertEqualObjects(dictionary, representationJSONDict);
}

- (void)test_that_representation_jpg_failed_is_parsed_correctly_from_json
{
    NSDictionary *dictionary = [self dictionaryFromCannedJSON:@"representation_jpg_failed"];
    BOXRepresentation *representation = [[BOXRepresentation alloc] initWithJSON:dictionary];

    XCTAssertEqualObjects(BOXRepresentationTypeJPG, representation.type);
    XCTAssertEqualObjects(BOXRepresentationStatusError, representation.status);
    XCTAssertEqualObjects(@"error_conversion_failed", representation.statusCode);
    XCTAssertEqualObjects(@"https://api.box.com/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320", representation.infoURL.absoluteString);
    XCTAssertEqualObjects(@"https://dl3.boxcloud.com/api/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320/content/{+asset_path}", representation.templateURLString);
    XCTAssertEqualObjects(@"https://dl3.boxcloud.com/api/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320/content/", representation.contentURL.absoluteString);
    XCTAssertNil(representation.details);
    XCTAssertEqualObjects(BOXRepresentationImageDimensionsJPG320, representation.dimensions);
}

- (void)test_that_JSON_Dictionary_for_representation_jpg_failed_is_reconstructed_correctly
{
    BOXRepresentation *representation = [[BOXRepresentation alloc] init];
    representation.type = BOXRepresentationTypeJPG;
    representation.status = BOXRepresentationStatusError;
    representation.statusCode = @"error_conversion_failed";
    representation.infoURL = [NSURL URLWithString:@"https://api.box.com/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320"];
    representation.templateURLString = @"https://dl3.boxcloud.com/api/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320/content/{+asset_path}";
    representation.details = nil;
    representation.dimensions = BOXRepresentationImageDimensionsJPG320;

    NSDictionary *representationJSONDict = [representation JSONDictionary];
    NSDictionary *dictionary = @{
                                     @"content": @{
                                         @"url_template": @"https://dl3.boxcloud.com/api/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320/content/{+asset_path}"
                                     },
                                     @"info": @{
                                         @"url": @"https://api.box.com/2.0/internal_files/339301799730/versions/358254064530/representations/jpg_320x320"
                                     },
                                     @"properties": @{
                                         @"dimensions": @"320x320"
                                     },
                                     @"representation": @"jpg",
                                     @"status": @{
                                         @"code": @"error_conversion_failed",
                                         @"state": @"error"
                                     }
                                 };

    XCTAssertEqualObjects(dictionary, representationJSONDict);
}

@end
