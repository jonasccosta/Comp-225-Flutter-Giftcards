/// Class that stores information about the user in the user's database.
class UserInfo {

  /// Database id that is unique to each card, used to identify the user
  /// in the database.
  final int id;

  /// Variables inputted by the user when they create an account.
  String username;
  String password;
  String passwordHintQuestion;
  String passwordHintAnswer;

  /// Name of the table containing the data in the database.
  static String table = 'database';

  UserInfo({this.id, this.username, this.password, this.passwordHintQuestion, this.passwordHintAnswer});

  /// Converts a [UserInfo] into a Map<String, dynamic>.
  ///
  /// The keys are the name of the columns in the database and the values are
  /// the correspondent variables from the [UserInfo].
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'username': username,
      'password': password,
      'passwordHintQuestion': passwordHintQuestion,
      'passwordHintAnswer': passwordHintAnswer,
    };

    if(id != null){
      map['id'] = id;
    }

    return map;
  }

  /// Converts a Map<String, dynamic> into a [UserInfo] object.
  ///
  /// Each variable in the [UserInfo] object is retrieved from its correspondent
  /// column in the [Database].
  static UserInfo fromMap(Map<String, dynamic> map) {
    return UserInfo(
        id: map['id'],
        username: map['username'],
        password: map['password'],
        passwordHintQuestion: map['passwordHintQuestion'],
        passwordHintAnswer: map['passwordHintAnswer'],

    );
  }
}