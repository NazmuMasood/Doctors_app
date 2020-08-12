import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'U48GPF81T6', //ApplicationID
    apiKey: '1e09ab5a3b338df9367bd775ed931c1e', //admin api-key
  );
}