//
//  BOXRepresentationsHelper.m
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 8/24/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXRepresentationsHelper.h"

@interface BOXRepresentationsHelper()
@property (nonatomic, readwrite, strong) NSMutableOrderedSet *representationsRequested;
@end

@implementation BOXRepresentationsHelper

- (void)setRepresentationRequestOptions:(NSArray *)representationOptions
{
    self.representationsRequested = [[NSMutableOrderedSet alloc] initWithArray:representationOptions];
}

- (NSString *) getRepresentationsFieldString {
    NSString *fieldString = @"";
    if ([self.representationsRequested containsObject:@(BOXRepresentationRequestOriginal)]) {
        [self.representationsRequested removeObject:@(BOXRepresentationRequestOriginal)];
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyAuthenticatedDownloadURL];
    }
    if ([self.representationsRequested count] > 0) {
        // Include information for the original content URL in any request for file representations
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyRepresentations];
    }
    return fieldString;
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
