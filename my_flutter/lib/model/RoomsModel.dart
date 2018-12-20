class Rooms{
  final int houseId;
  final List<Room> rooms;

  Rooms({this.houseId, this.rooms});
  factory Rooms.fromJson(Map<String, dynamic> json){
    var list = json['rooms'] as List;
    List<Room> rooms = list.map((i) => Room.fromJson(i)).toList();

    return Rooms(
      houseId: json['house_id'],
      rooms: rooms
    );
  }
}

class Room{
  final int roomId;
  final String roomName;
  final int deviceCnt;

  Room({this.roomId, this.roomName, this.deviceCnt});
  factory Room.fromJson(Map<String, dynamic> json){
    return Room(
      roomId: json['room_id'],
      roomName: json['room_name'],
      deviceCnt: json['device_cnt']
    );
  }
}