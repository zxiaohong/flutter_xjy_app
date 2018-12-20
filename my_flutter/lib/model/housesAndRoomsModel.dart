class HousesAndRooms{
  final List<House> houses;
  HousesAndRooms({this.houses});

  factory HousesAndRooms.fromJson(List<dynamic> json){
    List<House> houses = new List<House>();
    houses = json.map((i)=>House.fromJson(i)).toList();

    return new HousesAndRooms(
      houses: houses
     );
  }
}

class House{
  final int houseId;
  final String houseName;
  final HouseAddress houseAddress;
  final List<Room> rooms;

  House({this.houseId, this.houseName, this.houseAddress, this.rooms});

  factory House.fromJson(Map<String, dynamic> json){
    var list = json['rooms'] as List;
    List<Room> roomsList = list.map((room) => Room.fromJson(room)).toList();
    return House(
      houseId: json['house_id'],
      houseName: json['house_name'],
      houseAddress: HouseAddress.fromJson(json['house_address']),
      rooms: roomsList
    );
  }
}


class HouseAddress{
  final String province;
  final String city;
  final String distinct;
  HouseAddress({this.province, this.city, this.distinct});

  factory HouseAddress.fromJson(Map<String, dynamic> json){
    return HouseAddress(
      province: json['province'],
      city: json['city'],
      distinct: json['distinct']
    );
  }
}

class Room{
  final int roomId;
  final String roomName;
  Room({this.roomId, this.roomName});

  factory Room.fromJson(Map<String, dynamic> json){
    return Room(
      roomId: json['room_id'],
      roomName: json['room_name']
    );
  }
}