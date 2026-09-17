/// Maskot Mesajları — 50 motivasyon mesajı
/// Her gün ilk girişte rastgele bir mesaj gösterilir
class MascotMessages {
  MascotMessages._();

  static const List<String> allMessages = [
    // ─── Motivasyon & İnanç (20 mesaj) ─────────────────────────
    '{name}, ben koçun Sebo! Sana inanıyorum! Sen yaparsın! 💪',
    'Bugün de geldin demek. Hadi bakalım, hedefe bir adım daha! 🎯',
    'Her gün bir adım daha. Sen bunu yapıyorsun! 🌟',
    '{name}, bugün de burada olman harika! Başarı senin hakkın! ✨',
    'Hedefine her gün biraz daha yaklaşıyorsun. Gurur duyuyorum! 🥰',
    'Bugün küçük bir adım at, yarın büyük bir fark göreceksin! 🚀',
    '{name}, sen çok güçlüsün! Hiçbir sınav senden güçlü değil! 💪🔥',
    'Unutma, her usta bir zamanlar çıraktı. Sen de yapacaksın! 🏆',
    'Bugün yapacağın her soru seni hedefe yaklaştırıyor! 📈',
    '{name}, sınav günü geldiğinde hazır olacaksın. Söz! 🤞',
    'Bugün iyi çalış, yarın güzel haberler ver! 🌈',
    'Her şeyin başı sabır ve emek. İkisini de yapıyorsun! 🌻',
    '{name}, yılma! En karanlık an, şafaktan hemen öncedir! 🌅',
    'Başarı bir gece değil, her gece kazanılır. Sen kazanıyorsun! 🌙',
    'Bugün zorlanabilirsin ama yarın teşekkür edeceksin! 🌟',
    '{name}, bu yolculukta yalnız değilsin. Koçun Sebo burada! 💜',
    'Sınav korkutucu mu? Ona korkması gerekeni gösterelim! 😎',
    'Her doğru cevap bir tuğla, sen bir kale inşa ediyorsun! 🏰',
    '{name}, bugün verimli bir gün olacak. Hissediyorum! 🔮',
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
    '"Kızım iyi çalış sonuna kadar arkandayım."\n— Sabahattin Amca  😊',

    // ─── Esprili & Samimi (15 mesaj) ───────────────────────────
    'Dün kaçtın ama bugün seni yakaladım! 😂',
    'Matematik seni bekliyor... Kaçamazsın! 🏃‍♀️📐',
    'Bugün sadece 3 görev var. Kaçmak yok! 😏',
    'Bugün de mi geldin? Vay be, gurur duydum! 🥹',
    '{name}, bir gün bu günlere gülerek bakacaksın! 😄',
    'Hadi hadi, çay yap gel, konuları bitireceğiz! ☕📖',
    'Tarih seni çağırıyor... Osmanlı bekliyor! 📜👑',
    '{name}, bugün kaç net artırıyoruz? Bahis açıyorum! 🎲',
    'Coğrafya dersen, Türkiye\'nin güzellikleri aslında! 🗺️🌍',
    'Deneme çözeceksin ve netler artacak. Söz mü? 🤝',
    '{name}, biliyorsun bu işin tek yolu çalışmak! Ama eğlenceli çalışmak! 🎵',
    'Vatandaşlık mı? Anayasa\'yı ezbere bileceğiz yakında! ⚖️😄',
    'Son sprint! Az kaldı, hadi son bir gayret! 🏃‍♀️💨',
    'Bugün paragraf günü! Satır aralarında saklanan cevapları bulalım! 🔍',
    '{name}, bugün de bir efsane yazıyoruz! Hazır mısın? 📝✨',
  ];

  static const List<String> examInfoMessages = [
    // TYT Information
    'Biliyor musun {name}, TYT sınavında 120 soru var ve toplam 165 dakika süren var. Stratejini iyi kurmalısın! ⏱️',
    'TYT (Temel Yeterlilik Testi) tüm adayların katılmak zorunda olduğu ilk oturumdur. Türkçe, Matematik, Sosyal ve Fen içerir. Sen halledersin! 📚',
    'TYT\'de zaman yönetimi çok önemlidir. Soru başına yaklaşık 1.3 dakika düşüyor. Hızlı ve dikkatli ol {name}! ⚡',

    // AYT Information
    '{name}, AYT (Alan Yeterlilik Testi) 180 dakika sürüyor ve 160 soru var. Alan bilgini konuşturma vakti! 🧠',
    'TYT\'den 180 ve üzeri puan alman, AYT\'de elini güçlendirecek. Unutma {name}! 🎯',

    // YDT Information
    'YDT (Yabancı Dil Testi) 120 dakika sürüyor ve 80 sorudan oluşuyor {name}. Dilin gücünü göster! 🌍',

    // YKS General Information
    'YKS (Yükseköğretim Kurumları Sınavı) soruları ÖSYM uzman komisyonları tarafından yüksek güvenlikle hazırlanıyor {name}. 🔒',
    'Mezuna kaldığında eğer bir önceki yıl tercih yapıp yerleştiysen OBP yarıya düşer, yerleşmediysen tam puan gelir {name}. Bunu hesaba kat! 📊',

    // KPSS Information
    '{name}, KPSS Lisans Genel Yetenek-Genel Kültür testinde başarılı olmak, düzenli güncel bilgiler takibinden geçer. 📰',
    'E-KPSS için her yıl nisan ayında hedeflerimizi taze tutmalıyız. {name}, sen bir adım öndesin! 🏅'
  ];

  /// Bugünün mesajını getir (günde bir mesaj, güne göre sabit)
  static String getTodayMessage(String userName) {
    final now = DateTime.now();
    // Gün bazlı deterministik seçim
    final dayIndex = (now.year * 366 + now.month * 31 + now.day) % allMessages.length;
    return allMessages[dayIndex].replaceAll('{name}', userName);
  }

  /// Sınava özel hap bilgi mesajı getir
  static String getExamInfoMessage(List<String> selectedExamIds, String userName) {
    List<String> relevantMessages = [];
    
    for (String examId in selectedExamIds) {
      if (examId.startsWith('tyt_')) {
        relevantMessages.add(examInfoMessages[0]);
        relevantMessages.add(examInfoMessages[1]);
        relevantMessages.add(examInfoMessages[2]);
        relevantMessages.add(examInfoMessages[6]); // General YKS
        relevantMessages.add(examInfoMessages[7]); // General YKS OBP
      } else if (examId.startsWith('ayt_')) {
        relevantMessages.add(examInfoMessages[3]);
        relevantMessages.add(examInfoMessages[4]);
      } else if (examId.startsWith('ydt_')) {
        relevantMessages.add(examInfoMessages[5]);
      } else if (examId.contains('kpss')) {
        relevantMessages.add(examInfoMessages[8]);
        if (examId.contains('ekpss')) relevantMessages.add(examInfoMessages[9]);
      }
    }

    if (relevantMessages.isEmpty) {
      return getTodayMessage(userName);
    }

    final index = DateTime.now().millisecondsSinceEpoch % relevantMessages.length;
    return relevantMessages[index].replaceAll('{name}', userName);
  }

  /// Rastgele mesaj getir
  static String getRandomMessage(String userName) {
    final index = DateTime.now().millisecondsSinceEpoch % allMessages.length;
    return allMessages[index].replaceAll('{name}', userName);
  }

  /// Kategoriye göre mesaj sayısı
  static const int motivationCount = 20;
  static const int quoteCount = 15;
  static const int funnyCount = 15;
}
