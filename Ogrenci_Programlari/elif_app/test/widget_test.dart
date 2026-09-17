import 'package:flutter_test/flutter_test.dart';
import 'package:elif_ders_programi/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Yeni kullanıcı ilk açılışta onboarding ekranını görür', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ElifSinavKocu());

    // Uygulama açılışında asenkron yerel veri yüklenir. Sürekli animasyonu
    // olan yükleme göstergesi nedeniyle pumpAndSettle kullanılmaz.
    for (var i = 0; i < 250; i++) {
      await tester.pump();
      if (find.textContaining('Hoş Geldin').evaluate().isNotEmpty) break;
    }

    expect(find.textContaining('Hoş Geldin'), findsOneWidget);
  });
}
