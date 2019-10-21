# Box iOS SDK

Box iOS SDK

- [Getting Started](#getting-started)
- [Release Definitions](#release-definitions)

## Getting Started
Please refer to [docs/usage/getting-started.md](https://github.com/box/box-ios-sdk/blob/limited-beta-release/docs/usage/getting-started.md)


## Release Definitions
Starting Oct 19th, 2019 the Box Swift SDK for iOS will be available for general use. This implies all Box developers will be able to use the SDK to build native iOS applications on Box. Between now and the next couple of months, we will be making frequent updates to the SDK based on feedback from our customers, and this document aims to set expectations with respect to:
1. the various release types you will see over the next few months, what they mean and how to identify them
1. support policy for each of the release types

Between now and the next couple of months, the Box Swift SDK for iOS releases will be one of the following types:
- [Release Candidate (RC)](#release-candidate-rc)
- [Current Release](#current-release)
- [Long Term Support](#long-term-support)

### Release Candidate (RC)
The initial releases of the SDK starting Oct 17th will be Release Candidate (RC). This means (1) the core functionality is present and tested, (2) additional functionality from this point on will be considered improvements or enhancements based on customer feedback. RC releases are usually more frequent (every few weeks), followed shortly by a current release. If you plan to use an RC release, we recommend:
- that you don't use it for production workloads (If that is unavoidable, we recommend upgrading to the Current Release version once it's ready.)
- that you create a plan to keep your application on the latest RC release version at all times (since older RC releases are considered "out of support" as soon as a new RC release is released)

Also, RC releases may carry breaking changes from the previous release and we advise developers to test their application adequately with the new RC release before adopting it.

The idea behind releasing RC releases is to rapidly iterate on the SDK (bug fixes, feature tweaks, etc.) to get it to a production-ready state, and typically we don't expect to have the SDK in the RC phase for more than a month.

> #### Support for RC releases
> A RC release
> - is Considered [Active](#active) when released
> - transitions to [End-of-life](#end-of-life) when the next release becomes Active


### Current Release

A Current Release is considered more stable that a Release Candidate Release and for that reason we expect less frequent releases of a Current Release. We typically expect to refresh Current Releases approximately every 3 months (could be shorter or longer depending on the criticality of the contents of the release).

A new Current Release will usually carry new functionality, bug fixes and may contain breaking changes. We will call out all breaking changes (if any) in the Release Notes section of every Current Release, and we advise developers to test their application adequately before adopting in for production use. 

A Current release is on the leading edge of our SDK development, and is intended for customers who are in active development and want the latest and greatest features.  Current releases are not intended for long-term use, and will only receive enough support after the next release becomes available to allow for a smooth transition to the new version. 


> #### Support for Current Release
> A Current Release
> - is Considered [Active](#active) when released
> - transitions to [Maintenance](#maintenance) 3 months after it becomes Active, or when the next release becomes Active, whichever is later
> - reaches [End-of-life](#end-of-life) 6 months after it becomes Active, or 3 months after the next release becomes Active, whichever is later


### Long Term Support

A Long-Term Support (LTS) release is one which we plan to guarantee compatibility with for an extended period of time.  The public interfaces of the SDK should not be changed in ways that would break customers’ application, and the release should continue to receive at least bug fixes for its entire lifecycle. We expect to refresh Long Term Release version every 18 - 24 months.

For the above reasons, we recommend all developers who do not intend to make frequent updates (~every 6 - 12 months) to their application, only use a Long Term Release version of the SDK. 

> #### Support for Long Term Release
> A Long Term Release
> - is considered [Active](#active) when released
> - transitions to [Maintenance](#maintenance) 1 year after it becomes Active, or when the next release becomes Active, whichever is later
> - reaches [End-of-life](#end-of-life) 2 years after it becomes Active, or 1 year after the next LTS release becomes Active, whichever is later


### Support Phases
#### Active
Once a release is considered ready for release, a new version is cut and the release enters the Active phase.  However, new features may be added to the SDK, including support for new API endpoints. 

#### Maintenance
After a time, the release is no longer under active development, but customers may still be depending on it.  At this time, we consider the release to be in Maintenance phase; generally, only bug fixes will be considered for inclusion in new versions.  We may of course opt to include new functionality based on customer demand, but in general customers should expect that the SDK feature set will be mostly frozen for the remainder of its lifecycle.

#### End-of-life
After a release is no longer being supported by Box, it enters End-of-life (EOL) and no further changes should be expected by customers.  Customers must upgrade to a newer release if they want to receive support.
