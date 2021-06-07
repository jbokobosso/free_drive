class UserModel {
  String displayName;
  String email;
  String phoneNumber;
  String address;

  UserModel(this.displayName, this.email,this.phoneNumber, this.address);

  toMap() {
    return {
      "displayName": this.displayName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "address": this.address
    };
  }

  static fromMap(String displayName, String email, String phoneNumber, String address) {
    return new UserModel(displayName, email, phoneNumber, address);
  }
}