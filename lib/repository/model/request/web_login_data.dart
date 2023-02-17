
class WebLoginRequest {
  String? email;
  String? password;
  String? code;

  WebLoginRequest({this.email, this.password,this.code}); // now create converter



  WebLoginRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    code = json['code'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['code'] = this.code;

    return data;
  }
}
