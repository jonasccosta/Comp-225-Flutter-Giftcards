//Class that stores information about each card in the database
class GiftCard {

  //Database id that is unique to each card, used to identify a card in the database
  final int id;

  //Variables inputted by the user
  String name;
  String number;
  String expirationDate;
  String securityCode;
  String balance;

  static String table = 'database';

  GiftCard({this.id, this.name, this.number, this.expirationDate, this.securityCode, this.balance});


  //Maps each variable to the name of its correspondent column in the data base
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'number': number,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'balance': balance
    };

    if(id != null){
      map['id'] = id;
    }

    return map;
  }
  //Return a card from the data base, given its variables
  static GiftCard fromMap(Map<String, dynamic> map) {
    return GiftCard(
        id: map['id'],
        name: map['name'],
        number: map['number'],
        expirationDate: map['expirationDate'],
        securityCode: map['securityCode'],
        balance: map['balance']
    );
  }


}