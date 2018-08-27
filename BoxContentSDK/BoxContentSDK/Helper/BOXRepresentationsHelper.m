//
//  BOXRepresentationsHelper.m
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 8/24/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXRepresentationsHelper.h"
#import "BOXContentSDKConstants.h"

@interface BOXRepresentationsHelper()

///**
// Setting a representation or list option will include availability of file with request representation information
// */
//@property (nonatomic, readwrite, strong) NSMutableOrderedSet *representationsRequested;

/**
 Ordered list of representation types, returns first representation type supported by the specified file type
 */
@property (nonatomic, readwrite, assign) BOOL matchSupportedRepresentation;
@end

@implementation BOXRepresentationsHelper

- (void)setRepresentationRequestOptions:(NSArray *)representationOptions
{
    self.representationsRequested = [[NSMutableOrderedSet alloc] initWithArray:representationOptions];
}

- (NSString *)formatRepresentationRequestHeader
{
    // Only process valid API options.
    if ([self.representationsRequested containsObject:@(BOXRepresentationRequestOriginal)]) {
        [self.representationsRequested removeObject:@(BOXRepresentationRequestOriginal)];
    }
    
    if ([self.representationsRequested count] == 0) {
        return nil;
    }
    
    __block NSString *representationFields = @"";
    
    if ([self.representationsRequested containsObject:@(BOXRepresentationRequestAllRepresentations)]) {
        representationFields = @"[jpg?dimensions=320x320&paged=false][jpg?dimensions=1024x1024&paged=false][pdf,hls,mp4,mp3,jpg]";
        [self.representationsRequested removeObject:@(BOXRepresentationRequestAllRepresentations)];
    }
    if ([self.representationsRequested count] == 0) {
        return representationFields;
    }
    
    representationFields = [representationFields stringByAppendingString:@"["];
    
    __block NSString *delimiter = @"],[";
    if (self.matchSupportedRepresentation == YES) {
        delimiter = @",";
    }
    
    [self.representationsRequested enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx == [self.representationsRequested count]) {
            representationFields = [representationFields stringByReplacingCharactersInRange:NSMakeRange([representationFields length]-1, 1) withString:@"]"];
            
            *stop = YES;
        } else {
            if (idx == [self.representationsRequested  count] - 1) {
                delimiter = @"]";
            }
            BOXRepresentationRequestOptions representationOption = (BOXRepresentationRequestOptions) [obj integerValue];
            if (representationOption == BOXRepresentationRequestHighDefinitionVideo) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@%@", BOXRepresentationTypeHLS, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestMP3Representation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@%@", BOXRepresentationTypeMP3, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestMP4Representation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@%@", BOXRepresentationTypeMP4, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestThumbnailRepresentation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@?dimensions=%@&paged=false%@", BOXRepresentationTypeJPG, BOXRepresentationImageDimensionsJPG320, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestLargeThumbnailRepresentation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@?dimensions=%@&paged=false%@", BOXRepresentationTypeJPG, BOXRepresentationImageDimensions1024, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestPDFRepresentation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@%@", BOXRepresentationTypePDF, delimiter]];
            }
            if (representationOption == BOXRepresentationRequestJPGRepresentation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@?dimensions=%@&paged=false%@", BOXRepresentationTypeJPG, BOXRepresentationImageDimensions1024, delimiter]];
            }
            if (representationOption == BOXRepresentationRequesteExtractedTextRepresentation) {
                representationFields = [representationFields stringByAppendingString:[NSString stringWithFormat:@"%@%@", BOXRepresentationTypeExtractedText, delimiter]];
            }
        }
    }];
    
    return representationFields;
}
@end
