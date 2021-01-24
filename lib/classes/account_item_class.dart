

class AccountItem{
  bool dummy;
  String name;
  String id;
  String amount;
  String imagePath;

  AccountItem({this.dummy, this.name, this.id, this.amount, this.imagePath}){
    if (dummy){
      this.name = "";
      this.id = "";
      this.amount = "";
      this.imagePath = "";
    }
  }

}
