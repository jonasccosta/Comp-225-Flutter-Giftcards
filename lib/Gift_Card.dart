import 'package:sqflite/sqflite.dart';

/// Class that stores information about each card in the database.
class GiftCard {

  /// Database id that is unique to each card, used to identify a card in the database.
  final int id;

  /// Variables inputted by the user in the [CreateNewCardScreen].
  String name;
  String number;
  String expirationDate;
  String securityCode;
  String balance;
  String photo;

  /// Name of the table containing the data in the database.
  static String table = 'database';

  GiftCard({this.id, this.name, this.number, this.expirationDate, this.securityCode, this.balance, this.photo});


  /// Converts a [GiftCard] into a Map<String, dynamic>.
  ///
  /// The keys are the name of the columns in the database and the values are
  /// the correspondent variables from the [GiftCard].
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'number': number,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'balance': balance,
      'photo' : photo
    };

    if(id != null){
      map['id'] = id;
    }

    return map;
  }

  /// Converts a Map<String, dynamic> into a [GiftCard].
  ///
  /// Each variable in the [GiftCard] object is retrieved from its correspondent
  /// column in the [Database].
  static GiftCard fromMap(Map<String, dynamic> map) {
    return GiftCard(
        id: map['id'],
        name: map['name'],
        number: map['number'],
        expirationDate: map['expirationDate'],
        securityCode: map['securityCode'],
        balance: map['balance'],
        photo: map['photo']
    );
  }

}