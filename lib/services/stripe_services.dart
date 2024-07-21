import 'dart:convert';

import 'package:http/http.dart' as http;

class StripeService {
  final prueba = "asd";
  static String secretKey =
      "sk_test_51PRMsUDNItGpGPanSipjoAS5aaf0OyH3Yr0MgPNkqMP3CSmxFYyht6ypDU6N9bctRwgOdIxNykZlfu1uY56yRpwn00FK0Esa9f";
  static String publishableKey =
      "pk_test_51PRMsUDNItGpGPanTb1ysM18Z2iMUyjZ2SH3j08759KsOr7USkADaLLoziMQ2IL0FswP66v5BMQGfB8W24dSFn29001ag2hXNB";

  static Future<dynamic> createCheckoutSession(
    List<dynamic> productItems,
    totalAmount,
  ) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");

    String lineItems = "";
    int index = 0;

    for (var val in productItems) {
      num precioAddons = 0;

      for (var addon in val.addons) {
        if (addon != null) {
          precioAddons += addon.price;
        }
      }

      var productPrice =
          (((val.food.price * val.quantity) + precioAddons) * 100)
              .round()
              .toString();

      lineItems +=
          "&line_items[$index][price_data][product_data][name]=${val.food.name}";
      lineItems +=
          "&line_items[$index][price_data][unit_amount]=${productPrice.toString()}";
      lineItems += "&line_items[$index][price_data][currency]=EUR";
      lineItems += "&line_items[$index][quantity]=${val.quantity.toString()}";
      index++;
    }

    final response = await http.post(url,
        body:
            'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });

    return json.decode(response.body)["id"];
  }

  static Future<dynamic> stripePaymentCheckout(
    productItems,
    total,
    context,
    mounted, {
    onSuccess,
    onCancel,
    onError,
  }) async {
    final String sessionId = await createCheckoutSession(
      productItems,
      total,
    );

    final result = await redirectToCheckout(
      context: context,
      sessionId: sessionId,
      publishableKey: publishableKey,
      successUrl: "https://checkout.stripe.dev/success",
      canceledUrl: "https://checkout.stripe.dev/cancel",
    );

    if (mounted) {
      final text = result.when(
        redirected: () => 'Redirected Successfuly',
        success: () => onSuccess(),
        canceled: () => onCancel(),
        error: (e) => onError(e),
      );

      return text;
    }
  }
}