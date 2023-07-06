// Copyright © Luka S (JaffaKetchup) under GPL-v3
// A full license can be found at .\LICENSE

part of flutter_map_tile_caching;

/// A generalized category for [TileEventResult]
enum TileEventResultCategory {
  /// The associated tile has been successfully downloaded and cached
  ///
  /// Independent category for [TileEventResult.success] only.
  cached,

  /// The associated tile may have been downloaded, but was not cached
  /// intentionally
  ///
  /// This may be because it:
  /// - already existed & `skipExistingTiles` was `true`:
  /// [TileEventResult.alreadyExisting]
  /// - was a sea tile & `skipSeaTiles` was `true`: [TileEventResult.isSeaTile]
  skipped,

  /// The associated tile was not successfully downloaded, potentially for a
  /// variety of reasons.
  ///
  /// Category for [TileEventResult.negativeFetchResponse],
  /// [TileEventResult.noConnectionDuringFetch], and
  /// [TileEventResult.unknownFetchException].
  failed;
}

/// The result of attempting to cache the associated tile/[TileEvent]
enum TileEventResult {
  /// The associated tile was successfully downloaded and cached
  success(TileEventResultCategory.cached),

  /// The associated tile was not downloaded (intentionally), becuase it already
  /// existed & `skipExistingTiles` was `true`
  alreadyExisting(TileEventResultCategory.skipped),

  /// The associated tile was downloaded, but was not cached (intentionally),
  /// because it was a sea tile & `skipSeaTiles` was `true`
  isSeaTile(TileEventResultCategory.skipped),

  /// The associated tile was not successfully downloaded because the tile server
  /// responded with a status code other than HTTP 200 OK
  negativeFetchResponse(TileEventResultCategory.failed),

  /// The associated tile was not successfully downloaded because a connection
  /// could not be made to the tile server
  noConnectionDuringFetch(TileEventResultCategory.failed),

  /// The associated tile was not successfully downloaded because of an unknown
  /// exception when fetching the tile from the tile server
  unknownFetchException(TileEventResultCategory.failed);

  /// The result of attempting to cache the associated tile/[TileEvent]
  const TileEventResult(this.category);

  /// A generalized category for this event
  final TileEventResultCategory category;
}

/// The raw result of a tile download during bulk downloading
///
/// Does not contain information about the download as a whole, that is
/// [DownloadProgress]' responsibility.
class TileEvent {
  /// The status of this event, the result of attempting to cache this tile
  ///
  /// See [TileEventResult.category] ([TileEventResultCategory]) for
  /// categorization of this result into 3 categories:
  ///
  /// - [TileEventResultCategory.cached] (tile was downloaded and cached)
  /// - [TileEventResultCategory.skipped] (tile was not cached, but intentionally)
  /// - [TileEventResultCategory.failed] (tile was not cached, due to an error)
  final TileEventResult result;

  /// The URL used to request the tile
  final String url;

  /// The raw bytes that were fetched from the [url], if available
  ///
  /// Not available if the result category is [TileEventResultCategory.failed].
  final Uint8List? tileImage;

  /// The raw [http.Response] from the [url], if available
  ///
  /// Not available if [result] is [TileEventResult.noConnectionDuringFetch],
  /// [TileEventResult.unknownFetchException], or
  /// [TileEventResult.alreadyExisting].
  final http.Response? fetchResponse;

  /// The raw error thrown when fetching from the [url], if available
  ///
  /// Only available if [result] is [TileEventResult.noConnectionDuringFetch] or
  /// [TileEventResult.unknownFetchException].
  final Object? fetchError;

  final bool _wasBufferReset;

  TileEvent._(
    this.result, {
    required this.url,
    this.tileImage,
    this.fetchResponse,
    this.fetchError,
    bool wasBufferReset = false,
  }) : _wasBufferReset = wasBufferReset;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileEvent &&
          result == other.result &&
          url == other.url &&
          tileImage == other.tileImage &&
          fetchResponse == other.fetchResponse &&
          fetchError == other.fetchError &&
          _wasBufferReset == other._wasBufferReset);

  @override
  int get hashCode => Object.hashAllUnordered([
        result,
        url,
        tileImage,
        fetchResponse,
        fetchError,
        _wasBufferReset,
      ]);
}
