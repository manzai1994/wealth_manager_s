

class ShortcutItem{
  String type;
  String amount;
  String precinout;
  String premethod;
  List<dynamic> settings;

  ShortcutItem({ this.type, this.settings}){
    amount = settings[0];
    precinout = settings[1];
    premethod = settings[2];
  }
}
