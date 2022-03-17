

class Place{

  Place({
    this.id,
    required this.name,
    required this.location,
    required this.type,
    this.users
  });

  String? id;
  String name;
  String location;
  String type;
  List<String>? users;

}