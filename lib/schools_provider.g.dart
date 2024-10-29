// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schools_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredSchoolsHash() => r'dde871abecbd78b0b9240d5d3b6014811c87f50a';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredSchools].
@ProviderFor(filteredSchools)
const filteredSchoolsProvider = FilteredSchoolsFamily();

/// See also [filteredSchools].
class FilteredSchoolsFamily extends Family<AsyncValue<List<School>>> {
  /// See also [filteredSchools].
  const FilteredSchoolsFamily();

  /// See also [filteredSchools].
  FilteredSchoolsProvider call({
    String? searchQuery,
  }) {
    return FilteredSchoolsProvider(
      searchQuery: searchQuery,
    );
  }

  @override
  FilteredSchoolsProvider getProviderOverride(
    covariant FilteredSchoolsProvider provider,
  ) {
    return call(
      searchQuery: provider.searchQuery,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredSchoolsProvider';
}

/// See also [filteredSchools].
class FilteredSchoolsProvider extends AutoDisposeFutureProvider<List<School>> {
  /// See also [filteredSchools].
  FilteredSchoolsProvider({
    String? searchQuery,
  }) : this._internal(
          (ref) => filteredSchools(
            ref as FilteredSchoolsRef,
            searchQuery: searchQuery,
          ),
          from: filteredSchoolsProvider,
          name: r'filteredSchoolsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$filteredSchoolsHash,
          dependencies: FilteredSchoolsFamily._dependencies,
          allTransitiveDependencies:
              FilteredSchoolsFamily._allTransitiveDependencies,
          searchQuery: searchQuery,
        );

  FilteredSchoolsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.searchQuery,
  }) : super.internal();

  final String? searchQuery;

  @override
  Override overrideWith(
    FutureOr<List<School>> Function(FilteredSchoolsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredSchoolsProvider._internal(
        (ref) => create(ref as FilteredSchoolsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        searchQuery: searchQuery,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<School>> createElement() {
    return _FilteredSchoolsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredSchoolsProvider && other.searchQuery == searchQuery;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, searchQuery.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredSchoolsRef on AutoDisposeFutureProviderRef<List<School>> {
  /// The parameter `searchQuery` of this provider.
  String? get searchQuery;
}

class _FilteredSchoolsProviderElement
    extends AutoDisposeFutureProviderElement<List<School>>
    with FilteredSchoolsRef {
  _FilteredSchoolsProviderElement(super.provider);

  @override
  String? get searchQuery => (origin as FilteredSchoolsProvider).searchQuery;
}

String _$schoolStatsHash() => r'2ad9a9b5d5d24f80af62c4471c2cb5cf971f4110';

/// See also [schoolStats].
@ProviderFor(schoolStats)
final schoolStatsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  schoolStats,
  name: r'schoolStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$schoolStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SchoolStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$schoolsHash() => r'3d752b77ea84b26692050566abd2954609510073';

/// See also [Schools].
@ProviderFor(Schools)
final schoolsProvider =
    AutoDisposeAsyncNotifierProvider<Schools, List<School>>.internal(
  Schools.new,
  name: r'schoolsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$schoolsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Schools = AutoDisposeAsyncNotifier<List<School>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
