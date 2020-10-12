//Class that stores information about each card in the database
class UserInfo {

  //Database id that is unique to each card, used to identify a card in the database
  final int id;

  //Variables inputted by the user
  String username;
  String password;
  String passwordHintQuestion;
  String passwordHintAnswer;

  static String table = 'database';

  UserInfo({this.id, this.username, this.password, this.passwordHintQuestion, this.passwordHintAnswer});


  //Maps each variable to the name of its correspondent column in the data base
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
  //Return a user from the data base, given its variables
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