import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {

  Supabase supabase = Supabase.instance;

  Future<String> getUserID() async {
    UserResponse user = await supabase.client.auth.getUser();
    String userID = user.user!.id;
    return userID;
  }

  
}