import 'package:order_it_2/models/addon.dart';
import 'package:order_it_2/services/supabase_api.dart';

class AddonController {
  final SupabaseApi supabaseApi = SupabaseApi();

  Future<List<Addon>> fetchAddons() async {
    try {
      final List<Map<String, dynamic>> addonData = 
          await supabaseApi.getAddons();

      final List<Addon> addons = addonData.map((addonData) =>
        Addon
        .fromJson(addonData))
        .toList();

      return addons;
    } catch (e) {
      throw Exception('Error al traer los complementos: $e');
    }
  }
}