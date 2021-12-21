import '../serialization/serializable.dart';

import 'contact.dart';
import 'license.dart';

class Info extends Serializable {
  Info(String title,
      {required String version,
      String? description,
      String? termsOfService,
      Contact? contact,
      License? license}) {
    this.title = title;
    this.version = version;
    if (description != null) this.description = description;
    if (termsOfService != null) this.termsOfService = termsOfService;
    if (contact != null) this.contact = contact;
    if (license != null) this.license = license;
  }

  set title(String value) => setProp('title', value);
  set version(String value) => setProp('version', value);
  set description(String value) => setProp('description', value);
  set termsOfService(String value) => setProp('termsOfService', value);
  set contact(Contact value) => setProp('contact', value);
  set license(License value) => setProp('license', value);
}
