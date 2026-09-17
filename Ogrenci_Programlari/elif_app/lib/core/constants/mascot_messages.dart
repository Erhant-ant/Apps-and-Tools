/// Maskot Mesajları — 50 motivasyon mesajı
/// Her gün ilk girişte rastgele bir mesaj gösterilir
class MascotMessages {
  MascotMessages._();

  static const List<String> allMessages = [
    // ─── Motivasyon & İnanç (20 mesaj) ─────────────────────────
    'Elif, ben koçun Sebo! Sana inanıyorum! Sen yaparsın! 💪',
    'Bugün de geldin demek. Hadi bakalım, hedefe bir adım daha! 🎯',
    'Her gün bir adım daha. Sen bunu yapıyorsun! 🌟',
    'Elif, bugün de burada olman harika! Başarı senin hakkın! ✨',
    'Hedefine her gün biraz daha yaklaşıyorsun. Gurur duyuyorum! 🥰',
    'Bugün küçük bir adım at, yarın büyük bir fark göreceksin! 🚀',
    'Elif, sen çok güçlüsün! Hiçbir sınav senden güçlü değil! 💪🔥',
    'Unutma, her usta bir zamanlar çıraktı. Sen de yapacaksın! 🏆',
    'Bugün yapacağın her soru seni hedefe yaklaştırıyor! 📈',
    'Elif, sınav günü geldiğinde hazır olacaksın. Söz! 🤞',
    'Bugün iyi çalış, yarın güzel haberler ver! 🌈',
    'Her şeyin başı sabır ve emek. İkisini de yapıyorsun! 🌻',
    'Elif, yılma! En karanlık an, şafaktan hemen öncedir! 🌅',
    'Başarı bir gece değil, her gece kazanılır. Sen kazanıyorsun! 🌙',
    'Bugün zorlanabilirsin ama yarın teşekkür edeceksin! 🌟',
    'Elif, bu yolculukta yalnız değilsin. Koçun Sebo burada! 💜',
    'Sınav korkutucu mu? Ona korkması gerekeni gösterelim! 😎',
    'Her doğru cevap bir tuğla, sen bir kale inşa ediyorsun! 🏰',
    'Elif, bugün verimli bir gün olacak. Hissediyorum! 🔮',
    'Disiplin her şeydir ve sen onu gösteriyorsun! Tebrikler! 👏',

    // ─── Ünlü Düşünür Sözleri (16 mesaj) ──────────────────────
    '"Başarı, her gün tekrarlanan küçük çabaların toplamıdır."\n— Robert Collier 📖',
    '"Gelecek, bugünden hazırlananlarındır."\n— Malcolm X ✨',
    '"Disiplin, hayal ile başarı arasındaki köprüdür."\n— Jim Rohn 🌉',
    '"Başarının sırrı, henüz hazır olmadığınız zaman başlamaktır."\n— Napoleon Hill 🗝️',
    '"Düşünce değişirse, davranış değişir. Davranış değişirse, sonuç değişir."\n— Lao Tzu 🧘',
    '"Zor zamanlar güçlü insanlar yaratır."\n— Anonim 💎',
    '"Yapabileceğine inanırsan, yarı yoldasın demektir."\n— Theodore Roosevelt 🏔️',
    '"Tek sınır, kendi zihnine koyduğun sınırdır."\n— Napoleon Hill 🧠',
    '"Eğitim, geleceğin pasaportudur. Yarına bugünden hazırlananlar sahip olur."\n— Malcolm X 🎓',
    '"Bin millik yolculuk, tek bir adımla başlar."\n— Lao Tzu 👣',
    '"Başarısız olmaktan korkma. Denemekten vazgeçmekten kork."\n— Michael Jordan 🏀',
    '"Bugünün işini yarına bırakma."\n— Benjamin Franklin ⏰',
    '"Bilgi güçtür."\n— Francis Bacon 📚',
    '"Her başarının arkasında inançla dolu bir kalp vardır."\n— Mevlana 💫',
    '"Kendine güven, başarının ilk şartıdır."\n— Emerson 🪞',
    '"Kızım iyi çalış sonuna kadar arkandayım."\n— Sabahattin Amca  😊', /* Sabahattin benim amcam ve elifin babsı o yüzcen onun sözünü yazdım.*/

    // ─── Esprili & Samimi (15 mesaj) ───────────────────────────
    'Dün kaçtın ama bugün seni yakaladım! 😂',
    'Matematik seni bekliyor... Kaçamazsın! 🏃‍♀️📐',
    'Bugün sadece 3 görev var. Kaçmak yok! 😏',
    'Bugün de mi geldin? Vay be, gurur duydum! 🥹',
    'Elif, bir gün bu günlere gülerek bakacaksın! 😄',
    'Hadi hadi, çay yap gel, konuları bitireceğiz! ☕📖',
    'Tarih seni çağırıyor... Osmanlı bekliyor! 📜👑',
    'Elif, bugün kaç net artırıyoruz? Bahis açıyorum! 🎲',
    'Coğrafya dersen, Türkiye\'nin güzellikleri aslında! 🗺️🌍',
    'Deneme çözeceksin ve netler artacak. Söz mü? 🤝',
    'Elif, biliyorsun bu işin tek yolu çalışmak! Ama eğlenceli çalışmak! 🎵',
    'Vatandaşlık mı? Anayasa\'yı ezbere bileceğiz yakında! ⚖️😄',
    'Son sprint! Az kaldı, hadi son bir gayret! 🏃‍♀️💨',
    'Bugün paragraf günü! Satır aralarında saklanan cevapları bulalım! 🔍',
    'Elif, bugün de bir efsane yazıyoruz! Hazır mısın? 📝✨',
  ];

  /// Bugünün mesajını getir (günde bir mesaj, güne göre sabit)
  static String getTodayMessage() {
    final now = DateTime.now();
    // Gün bazlı deterministik seçim
    final dayIndex = (now.year * 366 + now.month * 31 + now.day) % allMessages.length;
    return allMessages[dayIndex];
  }

  /// Rastgele mesaj getir
  static String getRandomMessage() {
    final index = DateTime.now().millisecondsSinceEpoch % allMessages.length;
    return allMessages[index];
  }

  /// Kategoriye göre mesaj sayısı
  static const int motivationCount = 20;
  static const int quoteCount = 15;
  static const int funnyCount = 15;
}
