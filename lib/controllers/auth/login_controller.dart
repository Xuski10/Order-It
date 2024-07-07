import 'package:flutter/material.dart';
import 'package:order_it_2/pages/first_page.dart';
import 'package:order_it_2/pages/waiter.dart';
import 'package:order_it_2/services/snackbar_helper.dart';
import 'package:order_it_2/services/supabase_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController {

  SupabaseApi supabaseApi = SupabaseApi();
  Supabase supabase = Supabase.instance;

  Future<String> getUserID() async {
    UserResponse user = await supabase.client.auth.getUser();
    String userID = user.user!.id;
    return userID;
  }

  login(BuildContext context, String email, String password) async {

    bool success = await supabaseApi.login(email, password, context);
    int? rol = await supabaseApi.getUserRole(email);
    String? userId = await supabaseApi.getUserUUID(email);

    if (context.mounted) {
      if (success) {
        if (rol == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Waiter())
          );
        } else if (rol == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FirstPage())
          );
        }
      } else {
        SnackbarHelper.showSnackbar(context, 'Usuario o contraseña incorrectos', backgroundColor: Colors.red);
      }
    }
  }
}