//Class that stores information about each card in the database
class Card {

  //Database id that is unique to each card, used to identify a card in the database
  final int id;

  //Variables inputted by the user
  final String name;
  final String number;
  final String expirationDate;
  final String securityCode;

  static String table = 'database';

  Card({this.id, this.name, this.number, this.expirationDate, this.securityCode});


  //Maps each variable to the name of its correspondent column in the data base
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': name,
      'number': number,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
    };

    if(id != null){
      map['id'] = id;
    }

    return map;
  }

  //Return a card from the data base, given its variables
  static Card fromMap(Map<String, dynamic> map) {
    return Card(
        id: map['id'],
        name: map['name'],
        number: map['number'],
        expirationDate: map['expirationDate'],
        securityCode: map['securityCode']
    );
  }
}