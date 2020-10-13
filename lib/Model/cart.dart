import 'package:flutter/foundation.dart';
import 'package:memory/Pages/ventes/produits.dart';


class Cart extends ChangeNotifier {
  List<ModelVente> _items = [];
  double _totalPrice = 0.0;


  void add(ModelVente item){
    _items.add(item);
    _totalPrice+=1;
    notifyListeners();
  }

  void remove(ModelVente item){
    _items.remove(item);
  }

  int get count{
    return _items.length;
  }

  double get totalPrice{
    return _totalPrice;
  }
  List<ModelVente> get basketItems{
    return _items;
  }

}