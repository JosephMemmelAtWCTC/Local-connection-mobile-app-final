class User {
  String username;
  late String profileImgPath;

  User(this.username) {
    profileImgPath = generateUserProfilePath(this.username);
  }

  static String generateUserProfilePath(seed){
    return "https://api.dicebear.com/9.x/shapes/jpg?seed=${seed.replaceAll(".", "_").replaceAll("@", "_")}";
  }

}