class Homestays {
  String? hsId;
  String? userId;
  String? hsName;
  String? hsDesc;
  String? hsPrice;
  String? hsAddress;
  String? hsState;
  String? hsLocal;
  String? hsLat;
  String? hsLng;
  String? hsDate;

  Homestays(
      {this.hsId,
      this.userId,
      this.hsName,
      this.hsDesc,
      this.hsPrice,
      this.hsAddress,
      this.hsState,
      this.hsLocal,
      this.hsLat,
      this.hsLng,
      this.hsDate});

  Homestays.fromJson(Map<String, dynamic> json) {
    hsId = json['hs_id'];
    userId = json['user_id'];
    hsName = json['hs_name'];
    hsDesc = json['hs_desc'];
    hsPrice = json['hs_price'];
    hsAddress = json['hs_address'];
    hsState = json['hs_state'];
    hsLocal = json['hs_local'];
    hsLat = json['hs_lat'];
    hsLng = json['hs_lng'];
    hsDate = json['hs_date'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals, unnecessary_new
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hs_id'] = hsId;
    data['user_id'] = userId;
    data['hs_name'] = hsName;
    data['hs_desc'] = hsDesc;
    data['hs_price'] = hsPrice;
    data['hs_address'] = hsAddress;
    data['hs_state'] = hsState;
    data['hs_local'] = hsLocal;
    data['hs_lat'] = hsLat;
    data['hs_lng'] = hsLng;
    data['hs_date'] = hsDate;
    return data;
  }
}
