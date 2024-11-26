class User {
  String username;
  late String profileImgPath;

  User(this.username) {
    profileImgPath = "https://api.dicebear.com/9.x/shapes/svg?seed=$username";
  }

}