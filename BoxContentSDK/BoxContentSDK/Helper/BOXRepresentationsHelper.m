//
//  BOXRepresentationsHelper.m
//  BoxContentSDK
//
//  Created by Prithvi Jutur on 8/24/18.
//  Copyright © 2018 Box. All rights reserved.
//

#import "BOXRepresentationsHelper.h"

@interface BOXRepresentationsHelper()
@property (nonatomic, readwrite, copy) NSArray<NSNumber *> *representationsRequested;
@end

@implementation BOXRepresentationsHelper

- (void)setRepresentationRequestOptions:(NSArray *)representationOptions
{
    self.representationsRequested = representationOptions;
}

- (NSString *) getRepresentationsFieldString {
    NSMutableArray<NSNumber *> *reps = self.representationsRequested.mutableCopy;
    NSString *fieldString = @"";
    if ([reps containsObject:@(BOXRepresentationRequestOriginal)]) {
        [reps removeObject:@(BOXRepresentationRequestOriginal)];
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyAuthenticatedDownloadURL];
    }
    if (reps.count > 0) {
        // Include information for the original content URL in any request for file representations
        fieldString = [fieldString stringByAppendingFormat:@",%@", BOXAPIObjectKeyRepresentations];
    }
    return fieldString;
}

- (NSString *)formatRepresentationRequestHeader
{
    NSMutableArray<NSNumber *> *reps = self.representationsRequested.mutableCopy;

    // Only process valid API options.
    [reps removeObject:@(BOXRepresentationRequestOriginal)];

    if (reps.count == 0) {
        return nil;
    }

    NSMutableArray<NSString *> *repsStrings = [NSMutableArray arrayWithCapacity:reps.count];
    if ([reps containsObject:@(BOXRepresentationRequestAllRepresentations)]) {
        [repsStrings addObject:@"[jpg?dimensions=320x320&paged=false][jpg?dimensions=1024x1024&paged=false][pdf,hls,mp4,mp3,jpg]"];
        [reps removeObject:@(BOXRepresentationRequestAllRepresentations)];
    }

    for (NSNumber *n in reps) {
        NSString *rep = [self hintStringForRepresentation:n.unsignedIntegerValue];
        if (rep) {
            [repsStrings addObject:[NSString stringWithFormat:@"[%@]", rep]];
        }
    }

    return [repsStrings componentsJoinedByString:@""];
}

- (NSString *)hintStringForRepresentation:(BOXRepresentationRequestOptions)rep
{
    switch (rep) {
    case BOXRepresentationRequestHighDefinitionVideo:
        return BOXRepresentationTypeHLS;
    case BOXRepresentationRequestMP3Representation:
        return BOXRepresentationTypeMP3;
    case BOXRepresentationRequestMP4Representation:
        return BOXRepresentationTypeMP4;
    case BOXRepresentationRequestThumbnailRepresentation:
        return [NSString stringWithFormat:@"%@?dimensions=%@&paged=false", BOXRepresentationTypeJPG, BOXRepresentationImageDimensionsJPG320];
    case BOXRepresentationRequestLargeThumbnailRepresentation:
    case BOXRepresentationRequestJPGRepresentation:
        return [NSString stringWithFormat:@"%@?dimensions=%@&paged=false", BOXRepresentationTypeJPG, BOXRepresentationImageDimensions1024];
    case BOXRepresentationRequestPDFRepresentation:
        return BOXRepresentationTypePDF;
    case BOXRepresentationRequesteExtractedTextRepresentation:
        return BOXRepresentationTypeExtractedText;
    default:
        return nil;
    }
}

@end
