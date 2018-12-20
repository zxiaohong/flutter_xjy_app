
class AllRoomDevices {
  final int houseId;
  final int roomId;
  final List<Room> rooms;

  AllRoomDevices({this.houseId,this.roomId, this.rooms});

  factory AllRoomDevices.fromJson(Map<String, dynamic> json){
    var _roomsList = json['rooms'] as List;
    List<Room> roomsList = _roomsList.map((room) => Room.fromJson(room)).toList();

    return AllRoomDevices(
      houseId: json['house_id'],
      roomId: json['room_id'],
      rooms: roomsList
    );
  }
}

class Room{
  final int roomId;
  final String roomName;
  final List<Device> devices;

  Room({this.roomId, this.roomName, this.devices});
  factory Room.fromJson(Map<String, dynamic> json){
    var list = json['devices'] as List;
    List<Device> devicesList = list.map((device) => Device.fromJson(device)).toList();

    return Room(
      roomId: json['room_id'],
      roomName: json['room_name'],
      devices: devicesList
    );
  }
}

class Device{
  final String deviceId;
  final String deviceName;
  final String appPicUrl;
  final String skillId;
  final String categoryName;
  final String catagoryLogo;
  final String isWeilian;
  int roomId;
  String roomName;

  Device({this.deviceId, this.deviceName, this.appPicUrl, this.skillId, this.categoryName, this.catagoryLogo, this.isWeilian, this.roomId, this.roomName});

  factory Device.fromJson(Map<String, dynamic> json){
    return new Device(
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      appPicUrl: json['app_pic_url'],
      skillId: json['skill_id'],
      categoryName: json['category_name'],
      catagoryLogo: json['category_logo'],
      isWeilian: json['is_weilian'].toString(),
      roomId: null,
      roomName: null
    );
  }
}