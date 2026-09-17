import '../models/exam_model.dart';

class ExamDatabase {
  static final List<ExamModel> allExams = [
    ExamModel(
      id: 'tyt_2027',
      name: 'Temel Yeterlilik Testi (TYT)',
      shortName: 'YKS - TYT 2027',
      examDate: DateTime(2027, 6, 20),
      description: 'Zorunlu oturum: Tüm adayların katılması gereken ilk sınav (165 dk, 120 soru).',
    ),
    ExamModel(
      id: 'ayt_2027',
      name: 'Alan Yeterlilik Testi (AYT)',
      shortName: 'YKS - AYT 2027',
      examDate: DateTime(2027, 6, 21),
      description: 'Alan oturumu: Sayısal, EA veya Sözel puanlar için (180 dk, 160 soru).',
    ),
    ExamModel(
      id: 'ydt_2027',
      name: 'Yabancı Dil Testi (YDT)',
      shortName: 'YKS - YDT 2027',
      examDate: DateTime(2027, 6, 21),
      description: 'Dil oturumu: Yabancı dil puanıyla tercih yapacaklar için (120 dk, 80 soru).',
    ),
    ExamModel(
      id: 'kpss_lisans_2027',
      name: 'KPSS Lisans (Genel Yetenek - Genel Kültür)',
      shortName: 'KPSS Lisans 2027',
      examDate: DateTime(2027, 9, 5), // 2026'da 6 Eylül, 2027 tahmini
      description: 'Üniversite mezunları için Kamu Personel Seçme Sınavı',
    ),
    ExamModel(
      id: 'ekpss_2027',
      name: 'Engelli Kamu Personeli Seçme Sınavı (E-KPSS)',
      shortName: 'E-KPSS 2027',
      // Genelde Nisan ayında yapılır
      examDate: DateTime(2027, 4, 18), 
      description: 'Engelli vatandaşlarımız için memuriyet sınavı',
    ),
    ExamModel(
      id: 'yds_2_2026',
      name: 'Yabancı Dil Bilgisi Seviye Tespit Sınavı 2 (YDS/2)',
      shortName: 'YDS/2',
      examDate: DateTime(2026, 11, 22), // Kesinleşmiş 2026 sonbahar tarihi
      description: 'Yabancı dil tazminatı, akademik kadro başvuruları vb. için Sonbahar dönemi sınavı (180 dk, 80 soru).',
    ),
    ExamModel(
      id: 'yds_1_2027',
      name: 'Yabancı Dil Bilgisi Seviye Tespit Sınavı 1 (YDS/1)',
      shortName: 'YDS/1',
      examDate: DateTime(2027, 4, 18), // Tahmini ilkbahar tarihi
      description: 'Yabancı dil tazminatı, akademik kadro başvuruları vb. için İlkbahar dönemi sınavı (180 dk, 80 soru).',
    ),
    ExamModel(
      id: 'dgs_2027',
      name: 'Dikey Geçiş Sınavı (DGS)',
      shortName: 'DGS 2027',
      examDate: DateTime(2027, 7, 4), // Tahmini yaz tarihi
      description: 'Önlisans mezunları için lisans tamamlama sınavı (135 dk, 100 soru).',
    ),
    ExamModel(
      id: 'ales_2027',
      name: 'Akademik Personel ve Lisansüstü Eğitimi Giriş Sınavı (ALES)',
      shortName: 'ALES 2027',
      examDate: DateTime(2027, 4, 18), // ALES/1 Tahmini ilkbahar tarihi
      description: 'Lisansüstü eğitim ve akademik personel kadroları için sınav (150 dk, 100 soru).',
    ),
    ExamModel(
      id: 'tus_2027',
      name: 'Tıpta Uzmanlık Eğitimi Giriş Sınavı (TUS)',
      shortName: 'TUS 2027',
      examDate: DateTime(2027, 3, 21), // Tahmini ilkbahar tarihi
      description: 'Tıp fakültesi mezunları için uzmanlık sınavı (Temel: 100 soru, Klinik: 100 soru).',
    ),
    // İleride eklenebilecek diğer sınavlar:
    // YDUS, vb.
  ];

  static ExamModel? getExamById(String id) {
    try {
      return allExams.firstWhere((exam) => exam.id == id);
    } catch (e) {
      return null;
    }
  }
}
