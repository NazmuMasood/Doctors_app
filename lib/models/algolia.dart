import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'U48GPF81T6', //ApplicationID
    apiKey: '8df02b8e1c4bfa3d7cd33f3029b220d1', //search-only api key in flutter code
  );
}