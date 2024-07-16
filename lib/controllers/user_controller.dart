import 'package:order_it_2/models/usuario.dart';
import 'package:order_it_2/services/supabase_api.dart';

class UserController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<User> getUser([String? email]) async {
    try {
      final List<Map<String, dynamic>> userData = 
          await supabaseApi.getUser();

      if (userData.isEmpty) {
        throw Exception('No se encontró usuario con ese email');
      }

      final User user = User.fromJson(userData[0]);
      return user;
    } catch (e) {
     throw Exception('Error al traer al usuario: $e'); 
    }
  }
}