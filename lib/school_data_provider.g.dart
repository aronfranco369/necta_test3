// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$schoolDataCacheHash() => r'6bbe0710db242ffcb5685113961b65a9e418f902';

/// See also [SchoolDataCache].
@ProviderFor(SchoolDataCache)
final schoolDataCacheProvider =
    AutoDisposeNotifierProvider<SchoolDataCache, List<School>?>.internal(
  SchoolDataCache.new,
  name: r'schoolDataCacheProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$schoolDataCacheHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SchoolDataCache = AutoDisposeNotifier<List<School>?>;
String _$schoolDataManagerHash() => r'b696f5279edf68d7302339ef1f3a4f26be872129';

/// See also [SchoolDataManager].
@ProviderFor(SchoolDataManager)
final schoolDataManagerProvider =
    AutoDisposeAsyncNotifierProvider<SchoolDataManager, List<School>>.internal(
  SchoolDataManager.new,
  name: r'schoolDataManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$schoolDataManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SchoolDataManager = AutoDisposeAsyncNotifier<List<School>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
