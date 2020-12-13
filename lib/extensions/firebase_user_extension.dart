part of 'extensions.dart';

extension FirebaseUserExtension on User {
  Users convertToUser({String name = "no name", String profilePicture = ""}) =>
      Users(this.uid, this.email, name: name, profilePicture: profilePicture);
}
