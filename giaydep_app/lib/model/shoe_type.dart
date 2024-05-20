
enum ShoeType { ca_phe, tra_sua, nuoc_ep, soda, khac }

extension ParseToString on ShoeType {
  String toShortString() {
    return toString().split('.').last;
  }
}
