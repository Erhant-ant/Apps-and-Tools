import '../models/subject.dart';
import '../models/topic.dart';
import '../core/theme/app_theme.dart';

/// KPSS Ortaöğretim Müfredat Verisi
/// Genel Yetenek (60 soru) + Genel Kültür (60 soru) = 120 soru, 130 dakika
class KpssCurriculum {
  KpssCurriculum._();

  static List<Subject> get subjects => [
    // ═══ GENEL YETENEK ═══════════════════════════════════════
    Subject(
      id: 'kpss_turkce',
      name: 'Türkçe',
      emoji: '📚',
      color: AppTheme.turkceColor,
      questionCount: 30,
      topics: [
        Topic(id: 'kpss_turkce_01', name: 'Sözcükte Anlam', order: 1),
        Topic(id: 'kpss_turkce_02', name: 'Cümlede Anlam', order: 2),
        Topic(id: 'kpss_turkce_03', name: 'Paragraf — Ana Düşünce', order: 3),
        Topic(id: 'kpss_turkce_04', name: 'Paragraf — Yardımcı Düşünce', order: 4),
        Topic(id: 'kpss_turkce_05', name: 'Paragraf — Yapı ve Konu', order: 5),
        Topic(id: 'kpss_turkce_06', name: 'Ses Bilgisi', order: 6),
        Topic(id: 'kpss_turkce_07', name: 'Sözcük Türleri', order: 7),
        Topic(id: 'kpss_turkce_08', name: 'Cümle Öğeleri', order: 8),
        Topic(id: 'kpss_turkce_09', name: 'Cümle Türleri', order: 9),
        Topic(id: 'kpss_turkce_10', name: 'Yazım Kuralları', order: 10),
        Topic(id: 'kpss_turkce_11', name: 'Noktalama İşaretleri', order: 11),
        Topic(id: 'kpss_turkce_12', name: 'Anlatım Bozuklukları', order: 12),
        Topic(id: 'kpss_turkce_13', name: 'Sözel Mantık', order: 13),
      ],
    ),

    Subject(
      id: 'kpss_matematik',
      name: 'Matematik',
      emoji: '📐',
      color: AppTheme.matematikColor,
      questionCount: 30,
      topics: [
        Topic(id: 'kpss_mat_01', name: 'Temel Kavramlar ve Doğal Sayılar', order: 1),
        Topic(id: 'kpss_mat_02', name: 'Bölme ve Bölünebilme', order: 2),
        Topic(id: 'kpss_mat_03', name: 'EBOB — EKOK', order: 3),
        Topic(id: 'kpss_mat_04', name: 'Rasyonel Sayılar', order: 4),
        Topic(id: 'kpss_mat_05', name: 'Üslü Sayılar', order: 5),
        Topic(id: 'kpss_mat_06', name: 'Köklü Sayılar', order: 6),
        Topic(id: 'kpss_mat_07', name: 'Sayı Problemleri', order: 7),
        Topic(id: 'kpss_mat_08', name: 'Yaş Problemleri', order: 8),
        Topic(id: 'kpss_mat_09', name: 'Hareket Problemleri', order: 9),
        Topic(id: 'kpss_mat_10', name: 'İşçi — Havuz Problemleri', order: 10),
        Topic(id: 'kpss_mat_11', name: 'Karışım Problemleri', order: 11),
        Topic(id: 'kpss_mat_12', name: 'Yüzde ve Oran — Orantı', order: 12),
        Topic(id: 'kpss_mat_13', name: 'Denklemler', order: 13),
        Topic(id: 'kpss_mat_14', name: 'Grafik Okuma ve Yorumlama', order: 14),
        Topic(id: 'kpss_mat_15', name: 'Sayısal Mantık', order: 15),
        Topic(id: 'kpss_mat_16', name: 'Temel Geometri — Üçgenler', order: 16),
        Topic(id: 'kpss_mat_17', name: 'Temel Geometri — Dörtgenler', order: 17),
        Topic(id: 'kpss_mat_18', name: 'Temel Geometri — Çember', order: 18),
      ],
    ),

    // ═══ GENEL KÜLTÜR ════════════════════════════════════════
    Subject(
      id: 'kpss_tarih',
      name: 'Tarih',
      emoji: '📜',
      color: AppTheme.tarihColor,
      questionCount: 27,
      topics: [
        // İlk Türk Devletleri (1 soru)
        Topic(id: 'kpss_tar_01', name: 'İlk Türk Devletleri', order: 1),
        // Türk-İslam Devletleri (2 soru)
        Topic(id: 'kpss_tar_02', name: 'Türk-İslam Devletleri', order: 2),
        // Osmanlı Devleti (9 soru)
        Topic(id: 'kpss_tar_03', name: 'Osmanlı — Kuruluş Dönemi', order: 3),
        Topic(id: 'kpss_tar_04', name: 'Osmanlı — Yükselme Dönemi', order: 4),
        Topic(id: 'kpss_tar_05', name: 'Osmanlı — Kültür ve Medeniyet', order: 5),
        Topic(id: 'kpss_tar_06', name: 'Osmanlı — Duraklama Dönemi (XVII. yy)', order: 6),
        Topic(id: 'kpss_tar_07', name: 'Osmanlı — Gerileme Dönemi (XVIII. yy)', order: 7),
        Topic(id: 'kpss_tar_08', name: 'Osmanlı — Dağılma Dönemi (XIX. yy)', order: 8),
        Topic(id: 'kpss_tar_09', name: 'Osmanlı — XX. Yüzyıl (I. Dünya Savaşı)', order: 9),
        // Kurtuluş Savaşı (3 soru)
        Topic(id: 'kpss_tar_10', name: 'Kurtuluş Savaşı — Hazırlık Dönemi', order: 10),
        Topic(id: 'kpss_tar_11', name: 'Kurtuluş Savaşı — I. TBMM Dönemi', order: 11),
        Topic(id: 'kpss_tar_12', name: 'Kurtuluş Savaşı — Muharebeler', order: 12),
        Topic(id: 'kpss_tar_13', name: 'Mudanya ve Lozan Barış Antlaşmaları', order: 13),
        // Atatürk İlke ve İnkılapları (9 soru)
        Topic(id: 'kpss_tar_14', name: 'Siyasi Alanda İnkılaplar', order: 14),
        Topic(id: 'kpss_tar_15', name: 'Hukuki Alanda İnkılaplar', order: 15),
        Topic(id: 'kpss_tar_16', name: 'Eğitim ve Kültür İnkılapları', order: 16),
        Topic(id: 'kpss_tar_17', name: 'Toplumsal Alanda İnkılaplar', order: 17),
        Topic(id: 'kpss_tar_18', name: 'Ekonomik Alanda İnkılaplar', order: 18),
        Topic(id: 'kpss_tar_19', name: 'Atatürk İlkeleri', order: 19),
        Topic(id: 'kpss_tar_20', name: 'Atatürk Dönemi İç ve Dış Politika', order: 20),
        // Çağdaş Türk ve Dünya Tarihi (3 soru)
        Topic(id: 'kpss_tar_21', name: 'II. Dünya Savaşı', order: 21),
        Topic(id: 'kpss_tar_22', name: 'Soğuk Savaş Dönemi', order: 22),
        Topic(id: 'kpss_tar_23', name: 'Soğuk Savaş Sonrası Dönem', order: 23),
      ],
    ),

    Subject(
      id: 'kpss_cografya',
      name: 'Coğrafya',
      emoji: '🌍',
      color: AppTheme.cografyaColor,
      questionCount: 18,
      topics: [
        Topic(id: 'kpss_cog_01', name: "Türkiye'nin Coğrafi Konumu", order: 1),
        Topic(id: 'kpss_cog_02', name: "Türkiye'nin Yer Şekilleri", order: 2),
        Topic(id: 'kpss_cog_03', name: 'Akarsular, Göller ve Yeraltı Suları', order: 3),
        Topic(id: 'kpss_cog_04', name: "Türkiye'nin İklimi", order: 4),
        Topic(id: 'kpss_cog_05', name: 'Bitki Örtüsü', order: 5),
        Topic(id: 'kpss_cog_06', name: 'Toprak Tipleri', order: 6),
        Topic(id: 'kpss_cog_07', name: 'Doğal Afetler', order: 7),
        Topic(id: 'kpss_cog_08', name: 'Nüfus ve Göçler', order: 8),
        Topic(id: 'kpss_cog_09', name: 'Yerleşme Tipleri', order: 9),
        Topic(id: 'kpss_cog_10', name: 'Tarım ve Hayvancılık', order: 10),
        Topic(id: 'kpss_cog_11', name: 'Madenler ve Enerji Kaynakları', order: 11),
        Topic(id: 'kpss_cog_12', name: 'Sanayi', order: 12),
        Topic(id: 'kpss_cog_13', name: 'Ulaşım ve Ticaret', order: 13),
        Topic(id: 'kpss_cog_14', name: "Türkiye'nin Coğrafi Bölgeleri", order: 14),
      ],
    ),

    Subject(
      id: 'kpss_vatandaslik',
      name: 'Vatandaşlık',
      emoji: '⚖️',
      color: AppTheme.vatandaslikColor,
      questionCount: 9,
      topics: [
        Topic(id: 'kpss_vat_01', name: 'Hukukun Temel Kavramları', order: 1),
        Topic(id: 'kpss_vat_02', name: 'Hukukun Dalları', order: 2),
        Topic(id: 'kpss_vat_03', name: 'Devlet Biçimleri ve Hükümet Sistemleri', order: 3),
        Topic(id: 'kpss_vat_04', name: 'Türk Anayasa Tarihi', order: 4),
        Topic(id: 'kpss_vat_05', name: '1982 Anayasası — Temel İlkeler', order: 5),
        Topic(id: 'kpss_vat_06', name: 'Temel Hak ve Hürriyetler', order: 6),
        Topic(id: 'kpss_vat_07', name: 'Yasama — TBMM', order: 7),
        Topic(id: 'kpss_vat_08', name: 'Yürütme — Cumhurbaşkanı ve İdare', order: 8),
        Topic(id: 'kpss_vat_09', name: 'Yargı ve Yüksek Mahkemeler', order: 9),
      ],
    ),

    Subject(
      id: 'kpss_guncel',
      name: 'Güncel Bilgiler',
      emoji: '📰',
      color: AppTheme.guncelColor,
      questionCount: 6,
      topics: [
        Topic(id: 'kpss_gun_01', name: 'Türkiye Güncel Olayları', order: 1),
        Topic(id: 'kpss_gun_02', name: 'Dünya Güncel Olayları', order: 2),
        Topic(id: 'kpss_gun_03', name: 'Uluslararası Kuruluşlar', order: 3),
        Topic(id: 'kpss_gun_04', name: 'Temel Kurumlar', order: 4),
      ],
    ),
  ];
}
