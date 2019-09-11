//
//  Copyright (c) 2019 Open Whisper Systems. All rights reserved.
//

#import "OWSDisappearingMessagesConfiguration.h"
#import <SignalCoreKit/NSDate+OWS.h>
#import <SignalCoreKit/NSString+OWS.h>
#import <SignalServiceKit/SignalServiceKit-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface OWSDisappearingMessagesConfiguration ()

@property (nonatomic, getter=isEnabled) BOOL enabled;
@property (nonatomic) uint32_t durationSeconds;

@end

#pragma mark -

@implementation OWSDisappearingMessagesConfiguration

- (nullable instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];

    return self;
}

- (instancetype)initWithThreadId:(NSString *)threadId enabled:(BOOL)isEnabled durationSeconds:(uint32_t)seconds
{
    OWSAssertDebug(threadId.length > 0);

    // Thread id == configuration id.
    self = [super initWithUniqueId:threadId];
    if (!self) {
        return self;
    }

    _enabled = isEnabled;
    _durationSeconds = seconds;

    return self;
}

// --- CODE GENERATION MARKER

// This snippet is generated by /Scripts/sds_codegen/sds_generate.py. Do not manually edit it, instead run
// `sds_codegen.sh`.

// clang-format off

- (instancetype)initWithUniqueId:(NSString *)uniqueId
                 durationSeconds:(unsigned int)durationSeconds
                         enabled:(BOOL)enabled
{
    self = [super initWithUniqueId:uniqueId];

    if (!self) {
        return self;
    }

    _durationSeconds = durationSeconds;
    _enabled = enabled;

    return self;
}

// clang-format on

// --- CODE GENERATION MARKER

+ (nullable instancetype)fetchWithThread:(TSThread *)thread transaction:(SDSAnyReadTransaction *)transaction
{
    return [self fetchWithThreadId:thread.uniqueId transaction:transaction];
}

+ (instancetype)fetchOrBuildDefaultWithThread:(TSThread *)thread transaction:(SDSAnyReadTransaction *)transaction
{
    return [self fetchOrBuildDefaultWithThreadId:thread.uniqueId transaction:transaction];
}

+ (nullable instancetype)fetchWithThreadId:(NSString *)threadId transaction:(SDSAnyReadTransaction *)transaction
{
    // Thread id == configuration id.
    return [self anyFetchWithUniqueId:threadId transaction:transaction];
}

+ (instancetype)fetchOrBuildDefaultWithThreadId:(NSString *)threadId transaction:(SDSAnyReadTransaction *)transaction
{
    OWSDisappearingMessagesConfiguration *_Nullable configuration = [self fetchWithThreadId:threadId
                                                                                transaction:transaction];
    if (configuration != nil) {
        return configuration;
    }

    return [[self alloc] initWithThreadId:threadId
                                  enabled:NO
                          durationSeconds:OWSDisappearingMessagesConfigurationDefaultExpirationDuration];
}

+ (NSArray<NSNumber *> *)validDurationsSeconds
{
    return @[
        @(5 * kSecondInterval),
        @(10 * kSecondInterval),
        @(30 * kSecondInterval),
        @(1 * kMinuteInterval),
        @(5 * kMinuteInterval),
        @(30 * kMinuteInterval),
        @(1 * kHourInterval),
        @(6 * kHourInterval),
        @(12 * kHourInterval),
        @(24 * kHourInterval),
        @(1 * kWeekInterval)
    ];
}

+ (uint32_t)maxDurationSeconds
{
    static uint32_t max;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        max = [[self.validDurationsSeconds valueForKeyPath:@"@max.intValue"] unsignedIntValue];

        // It's safe to update this assert if we add a larger duration
        OWSAssertDebug(max == 1 * kWeekInterval);
    });

    return max;
}

- (NSUInteger)durationIndex
{
    return [[self.class validDurationsSeconds] indexOfObject:@(self.durationSeconds)];
}

- (NSString *)durationString
{
    return [NSString formatDurationSeconds:self.durationSeconds useShortFormat:NO];
}

- (BOOL)hasChangedWithTransaction:(SDSAnyReadTransaction *)transaction
{
    OWSAssertDebug(transaction != nil);

    // Thread id == configuration id.
    OWSDisappearingMessagesConfiguration *oldConfiguration =
        [OWSDisappearingMessagesConfiguration fetchOrBuildDefaultWithThreadId:self.uniqueId transaction:transaction];

    return (self.isEnabled != oldConfiguration.isEnabled || self.durationSeconds != oldConfiguration.durationSeconds);
}

- (instancetype)copyWithIsEnabled:(BOOL)isEnabled
{
    OWSDisappearingMessagesConfiguration *newInstance = [self copy];
    newInstance.enabled = isEnabled;
    return newInstance;
}

- (instancetype)copyWithDurationSeconds:(uint32_t)durationSeconds
{
    OWSDisappearingMessagesConfiguration *newInstance = [self copy];
    newInstance.durationSeconds = durationSeconds;
    return newInstance;
}

- (instancetype)copyAsEnabledWithDurationSeconds:(uint32_t)durationSeconds
{
    OWSDisappearingMessagesConfiguration *newInstance = [self copy];
    newInstance.enabled = YES;
    newInstance.durationSeconds = durationSeconds;
    return newInstance;
}

- (instancetype)copyAsDisabled
{
    OWSDisappearingMessagesConfiguration *newInstance = [self copy];
    newInstance.enabled = NO;
    newInstance.durationSeconds = OWSDisappearingMessagesConfigurationDefaultExpirationDuration;
    return newInstance;
}

@end

NS_ASSUME_NONNULL_END
