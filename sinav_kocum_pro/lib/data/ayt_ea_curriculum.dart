import '../models/subject.dart';
import '../models/topic.dart';
import '../core/theme/app_theme.dart';

/// AYT — Eşit Ağırlık (EA) Müfredat Verisi
/// Matematik + Türk Dili ve Edebiyatı-Sosyal Bilimler 1
class AytEaCurriculum {
  AytEaCurriculum._();

  static List<Subject> get subjects => [
    Subject(
      id: 'ayt_matematik',
      name: 'Matematik',
      emoji: '📐',
      color: AppTheme.matematikColor,
      questionCount: 40,
      topics: [
        Topic(id: 'ayt_mat_01', name: 'Fonksiyonlar (İleri)', order: 1),
        Topic(id: 'ayt_mat_02', name: 'Polinomlar', order: 2),
        Topic(id: 'ayt_mat_03', name: 'İkinci Dereceden Denklemler', order: 3),
        Topic(id: 'ayt_mat_04', name: 'Eşitsizlikler', order: 4),
        Topic(id: 'ayt_mat_05', name: 'Parabol', order: 5),
        Topic(id: 'ayt_mat_06', name: 'Trigonometri — Temel Kavramlar', order: 6),
        Topic(id: 'ayt_mat_07', name: 'Trigonometri — Dönüşüm Formülleri', order: 7),
        Topic(id: 'ayt_mat_08', name: 'Trigonometri — Uygulamalar', order: 8),
        Topic(id: 'ayt_mat_09', name: 'Logaritma', order: 9),
        Topic(id: 'ayt_mat_10', name: 'Diziler — Aritmetik Dizi', order: 10),
        Topic(id: 'ayt_mat_11', name: 'Diziler — Geometrik Dizi', order: 11),
        Topic(id: 'ayt_mat_12', name: 'Limit', order: 12),
        Topic(id: 'ayt_mat_13', name: 'Türev — Temel Kavramlar', order: 13),
        Topic(id: 'ayt_mat_14', name: 'Türev — Uygulamalar', order: 14),
      ],
    ),

    Subject(
      id: 'ayt_edebiyat',
      name: 'Türk Dili ve Edebiyatı',
      emoji: '📖',
      color: AppTheme.edebiyatColor,
      questionCount: 24,
      topics: [
        Topic(id: 'ayt_edb_01', name: 'Şiir Bilgisi', order: 1),
        Topic(id: 'ayt_edb_02', name: 'Edebi Akımlar', order: 2),
        Topic(id: 'ayt_edb_03', name: 'İslamiyet Öncesi Türk Edebiyatı', order: 3),
        Topic(id: 'ayt_edb_04', name: 'İslami Dönem Türk Edebiyatı', order: 4),
        Topic(id: 'ayt_edb_05', name: 'Halk Edebiyatı', order: 5),
        Topic(id: 'ayt_edb_06', name: 'Divan Edebiyatı', order: 6),
        Topic(id: 'ayt_edb_07', name: 'Tanzimat Edebiyatı — I. Dönem', order: 7),
        Topic(id: 'ayt_edb_08', name: 'Tanzimat Edebiyatı — II. Dönem', order: 8),
        Topic(id: 'ayt_edb_09', name: 'Servet-i Fünun Edebiyatı', order: 9),
        Topic(id: 'ayt_edb_10', name: 'Fecr-i Ati Edebiyatı', order: 10),
        Topic(id: 'ayt_edb_11', name: 'Milli Edebiyat Dönemi', order: 11),
        Topic(id: 'ayt_edb_12', name: 'Cumhuriyet Dönemi — Şiir', order: 12),
        Topic(id: 'ayt_edb_13', name: 'Cumhuriyet Dönemi — Roman', order: 13),
        Topic(id: 'ayt_edb_14', name: 'Cumhuriyet Dönemi — Hikâye', order: 14),
        Topic(id: 'ayt_edb_15', name: 'Cumhuriyet Dönemi — Tiyatro', order: 15),
      ],
    ),

    Subject(
      id: 'ayt_tarih1',
      name: 'Tarih-1',
      emoji: '📜',
      color: AppTheme.tarihColor,
      questionCount: 10,
      topics: [
        Topic(id: 'ayt_tar_01', name: 'Osmanlı Siyasi Yapısı (Detay)', order: 1),
        Topic(id: 'ayt_tar_02', name: 'Osmanlı Sosyal Yapısı', order: 2),
        Topic(id: 'ayt_tar_03', name: 'Osmanlı Ekonomik Yapısı', order: 3),
        Topic(id: 'ayt_tar_04', name: 'Tanzimat ve Islahat', order: 4),
        Topic(id: 'ayt_tar_05', name: 'I. ve II. Meşrutiyet', order: 5),
        Topic(id: 'ayt_tar_06', name: 'Fikir Akımları', order: 6),
        Topic(id: 'ayt_tar_07', name: 'I. Dünya Savaşı (Detay)', order: 7),
        Topic(id: 'ayt_tar_08', name: 'Kurtuluş Savaşı (Detay)', order: 8),
        Topic(id: 'ayt_tar_09', name: 'İnkılap Tarihi — Siyasi ve Hukuki', order: 9),
        Topic(id: 'ayt_tar_10', name: 'İnkılap Tarihi — Toplumsal ve Ekonomik', order: 10),
        Topic(id: 'ayt_tar_11', name: 'Atatürk Dönemi Dış Politika', order: 11),
        Topic(id: 'ayt_tar_12', name: 'Çok Partili Dönem', order: 12),
      ],
    ),

    Subject(
      id: 'ayt_cografya1',
      name: 'Coğrafya-1',
      emoji: '🌍',
      color: AppTheme.cografyaColor,
      questionCount: 6,
      topics: [
        Topic(id: 'ayt_cog_01', name: 'Ekosistemler ve Biyomlar', order: 1),
        Topic(id: 'ayt_cog_02', name: 'Ekonomik Faaliyetler ve Kalkınma', order: 2),
        Topic(id: 'ayt_cog_03', name: 'Doğal Kaynaklar', order: 3),
        Topic(id: 'ayt_cog_04', name: 'Ulaşım Sistemleri', order: 4),
        Topic(id: 'ayt_cog_05', name: 'Şehirleşme ve Göç', order: 5),
        Topic(id: 'ayt_cog_06', name: 'Çevre Sorunları', order: 6),
      ],
    ),
  ];
}
