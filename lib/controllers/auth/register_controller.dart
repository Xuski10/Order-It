import 'package:flutter/material.dart';
import 'package:order_it_2/services/snackbar_helper.dart';
import 'package:order_it_2/services/supabase_api.dart';

class RegisterController {

  register(BuildContext context, String email, String password) async {
    SupabaseApi supabaseApi = SupabaseApi();
    bool success = await supabaseApi.register(email, password);

    if(context.mounted){
      if(success){
        SnackbarHelper.showSnackbar(context, 'Confirme su registro en el correo que le hemos enviado', backgroundColor: Colors.green);
      } else {
        SnackbarHelper.showSnackbar(context, 'Ha surgido un error, inténtelo de nuevo', backgroundColor: Colors.red);
      }
    }
  }
}