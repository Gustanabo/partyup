class PhoneConverter {
  String formatarTelefone(String numero) {
    numero = numero.replaceAll(RegExp(r'\D'), '');

    String ddd = numero.substring(0, 2);
    String parte1 = numero.substring(2, 7);
    String parte2 = numero.substring(7, 11);

    return "($ddd) $parte1-$parte2";
  }
}
