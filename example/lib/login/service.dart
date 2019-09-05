class User {
  String name;
  int age;
  User(this.name, this.age);
}

// Service
class RemoteService {
  Future<User> login(String userName, String password) async {
    return Future.delayed(Duration(seconds: 3), () {
      if (DateTime.now().second % 3 == 0) throw "mock error.";
      return User("displayName_${userName}", DateTime.now().second);
    });
  }

  Future<User> findUser(String userName) async {
    return Future.delayed(Duration(seconds: 3),
        () => User("displayName_${userName}", DateTime.now().second));
  }
}
