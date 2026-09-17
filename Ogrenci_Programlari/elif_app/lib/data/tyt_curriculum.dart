import '../models/subject.dart';
import '../models/topic.dart';
import '../core/theme/app_theme.dart';

/// TYT — Temel Yeterlilik Testi Müfredat Verisi
/// 120 soru, 165 dakika
class TytCurriculum {
  TytCurriculum._();

  static List<Subject> get subjects => [
    Subject(
      id: 'tyt_turkce',
      name: 'Türkçe',
      emoji: '📚',
      color: AppTheme.turkceColor,
      questionCount: 40,
      topics: [
        Topic(id: 'tyt_turkce_01', name: 'Sözcükte Anlam', order: 1),
        Topic(id: 'tyt_turkce_02', name: 'Söz Sanatları', order: 2),
        Topic(id: 'tyt_turkce_03', name: 'Deyim ve Atasözleri', order: 3),
        Topic(id: 'tyt_turkce_04', name: 'Cümlede Anlam', order: 4),
        Topic(id: 'tyt_turkce_05', name: 'Paragraf — Ana Düşünce', order: 5),
        Topic(id: 'tyt_turkce_06', name: 'Paragraf — Yardımcı Düşünce', order: 6),
        Topic(id: 'tyt_turkce_07', name: 'Paragraf — Yapı', order: 7),
        Topic(id: 'tyt_turkce_08', name: 'Paragraf — Anlatım Teknikleri', order: 8),
        Topic(id: 'tyt_turkce_09', name: 'Ses Bilgisi', order: 9),
        Topic(id: 'tyt_turkce_10', name: 'Yapım Ekleri', order: 10),
        Topic(id: 'tyt_turkce_11', name: 'Çekim Ekleri', order: 11),
        Topic(id: 'tyt_turkce_12', name: 'Sözcük Türleri', order: 12),
        Topic(id: 'tyt_turkce_13', name: 'Fiiller ve Fiil Çatısı', order: 13),
        Topic(id: 'tyt_turkce_14', name: 'Cümle Öğeleri', order: 14),
        Topic(id: 'tyt_turkce_15', name: 'Cümle Türleri', order: 15),
        Topic(id: 'tyt_turkce_16', name: 'Anlatım Bozuklukları', order: 16),
        Topic(id: 'tyt_turkce_17', name: 'Yazım Kuralları', order: 17),
        Topic(id: 'tyt_turkce_18', name: 'Noktalama İşaretleri', order: 18),
      ],
    ),

    Subject(
      id: 'tyt_matematik',
      name: 'Matematik',
      emoji: '📐',
      color: AppTheme.matematikColor,
      questionCount: 40,
      topics: [
        Topic(id: 'tyt_mat_01', name: 'Temel Kavramlar', order: 1),
        Topic(id: 'tyt_mat_02', name: 'Sayılar ve Basamak Kavramı', order: 2),
        Topic(id: 'tyt_mat_03', name: 'Bölme ve Bölünebilme', order: 3),
        Topic(id: 'tyt_mat_04', name: 'EBOB — EKOK', order: 4),
        Topic(id: 'tyt_mat_05', name: 'Rasyonel Sayılar', order: 5),
        Topic(id: 'tyt_mat_06', name: 'Basit Eşitsizlikler', order: 6),
        Topic(id: 'tyt_mat_07', name: 'Mutlak Değer', order: 7),
        Topic(id: 'tyt_mat_08', name: 'Üslü Sayılar', order: 8),
        Topic(id: 'tyt_mat_09', name: 'Köklü Sayılar', order: 9),
        Topic(id: 'tyt_mat_10', name: 'Çarpanlara Ayırma', order: 10),
        Topic(id: 'tyt_mat_11', name: 'Oran — Orantı', order: 11),
        Topic(id: 'tyt_mat_12', name: 'Denklem Çözme', order: 12),
        Topic(id: 'tyt_mat_13', name: 'Problemler — Sayı', order: 13),
        Topic(id: 'tyt_mat_14', name: 'Problemler — Yaş', order: 14),
        Topic(id: 'tyt_mat_15', name: 'Problemler — Hareket', order: 15),
        Topic(id: 'tyt_mat_16', name: 'Problemler — İşçi-Havuz', order: 16),
        Topic(id: 'tyt_mat_17', name: 'Problemler — Karışım', order: 17),
        Topic(id: 'tyt_mat_18', name: 'Yüzde Problemleri', order: 18),
        Topic(id: 'tyt_mat_19', name: 'Kümeler', order: 19),
        Topic(id: 'tyt_mat_20', name: 'Fonksiyonlar', order: 20),
        Topic(id: 'tyt_mat_21', name: 'Veri Analizi', order: 21),
        Topic(id: 'tyt_mat_22', name: 'Permütasyon', order: 22),
        Topic(id: 'tyt_mat_23', name: 'Kombinasyon', order: 23),
        Topic(id: 'tyt_mat_24', name: 'Olasılık', order: 24),
        Topic(id: 'tyt_mat_25', name: 'Temel Geometri', order: 25),
      ],
    ),

    Subject(
      id: 'tyt_sosyal',
      name: 'Sosyal Bilimler',
      emoji: '🏛️',
      color: AppTheme.sosyalColor,
      questionCount: 20,
      topics: [
        // Tarih (5 soru)
        Topic(id: 'tyt_sos_01', name: 'İlk Türk Devletleri', order: 1),
        Topic(id: 'tyt_sos_02', name: 'Türk-İslam Devletleri', order: 2),
        Topic(id: 'tyt_sos_03', name: 'Osmanlı Devleti', order: 3),
        Topic(id: 'tyt_sos_04', name: 'Kurtuluş Savaşı', order: 4),
        Topic(id: 'tyt_sos_05', name: 'Atatürk İlke ve İnkılapları', order: 5),
        // Coğrafya (5 soru)
        Topic(id: 'tyt_sos_06', name: 'Harita Bilgisi', order: 6),
        Topic(id: 'tyt_sos_07', name: 'Dünya ve İklim', order: 7),
        Topic(id: 'tyt_sos_08', name: 'Nüfus ve Yerleşme', order: 8),
        Topic(id: 'tyt_sos_09', name: "Türkiye'nin Fiziki Coğrafyası", order: 9),
        Topic(id: 'tyt_sos_10', name: "Türkiye'nin Beşeri Coğrafyası", order: 10),
        // Felsefe (5 soru)
        Topic(id: 'tyt_sos_11', name: 'Felsefeye Giriş', order: 11),
        Topic(id: 'tyt_sos_12', name: 'Bilgi Felsefesi', order: 12),
        Topic(id: 'tyt_sos_13', name: 'Varlık Felsefesi', order: 13),
        Topic(id: 'tyt_sos_14', name: 'Ahlak Felsefesi', order: 14),
        // Din Kültürü (5 soru)
        Topic(id: 'tyt_sos_15', name: 'İslam ve İbadet', order: 15),
        Topic(id: 'tyt_sos_16', name: 'Hz. Muhammed ve Hayatı', order: 16),
        Topic(id: 'tyt_sos_17', name: 'Kur\'an ve Yorumu', order: 17),
      ],
    ),

    Subject(
      id: 'tyt_fen',
      name: 'Fen Bilimleri',
      emoji: '🔬',
      color: AppTheme.fenColor,
      questionCount: 20,
      topics: [
        // Fizik (7 soru)
        Topic(id: 'tyt_fen_01', name: 'Fizik — Kuvvet ve Hareket', order: 1),
        Topic(id: 'tyt_fen_02', name: 'Fizik — Enerji', order: 2),
        Topic(id: 'tyt_fen_03', name: 'Fizik — Isı ve Sıcaklık', order: 3),
        Topic(id: 'tyt_fen_04', name: 'Fizik — Optik', order: 4),
        Topic(id: 'tyt_fen_05', name: 'Fizik — Elektrik', order: 5),
        // Kimya (7 soru)
        Topic(id: 'tyt_fen_06', name: 'Kimya — Atom ve Periyodik Tablo', order: 6),
        Topic(id: 'tyt_fen_07', name: 'Kimya — Kimyasal Bağlar', order: 7),
        Topic(id: 'tyt_fen_08', name: 'Kimya — Madde ve Özellikleri', order: 8),
        Topic(id: 'tyt_fen_09', name: 'Kimya — Asit-Baz', order: 9),
        // Biyoloji (6 soru)
        Topic(id: 'tyt_fen_10', name: 'Biyoloji — Hücre', order: 10),
        Topic(id: 'tyt_fen_11', name: 'Biyoloji — Canlı Sınıflandırma', order: 11),
        Topic(id: 'tyt_fen_12', name: 'Biyoloji — Ekosistem', order: 12),
      ],
    ),
  ];
}
