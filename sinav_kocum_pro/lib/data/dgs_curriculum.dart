import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';

class DgsCurriculum {
  static final List<Subject> subjects = [
    Subject(
      id: 'dgs_mat',
      name: 'Matematik',
      emoji: '📐',
      color: Colors.blue.shade700,
      questionCount: 50,
      topics: [
        Topic(id: 'dgs_mat_1', name: 'Temel Kavramlar', order: 1),
        Topic(id: 'dgs_mat_2', name: 'Sayı Sistemleri', order: 2),
        Topic(id: 'dgs_mat_3', name: 'Bölme ve Bölünebilme', order: 3),
        Topic(id: 'dgs_mat_4', name: 'EBOB ve EKOK', order: 4),
        Topic(id: 'dgs_mat_5', name: 'Rasyonel Sayılar', order: 5),
        Topic(id: 'dgs_mat_6', name: 'Basit Eşitsizlikler', order: 6),
        Topic(id: 'dgs_mat_7', name: 'Mutlak Değer', order: 7),
        Topic(id: 'dgs_mat_8', name: 'Üslü Sayılar', order: 8),
        Topic(id: 'dgs_mat_9', name: 'Köklü Sayılar', order: 9),
        Topic(id: 'dgs_mat_10', name: 'Çarpanlara Ayırma', order: 10),
        Topic(id: 'dgs_mat_11', name: 'Oran ve Orantı', order: 11),
        Topic(id: 'dgs_mat_12', name: 'Denklem Çözme', order: 12),
        Topic(id: 'dgs_mat_13', name: 'Problemler', order: 13),
        Topic(id: 'dgs_mat_14', name: 'Kümeler', order: 14),
        Topic(id: 'dgs_mat_15', name: 'Fonksiyonlar', order: 15),
        Topic(id: 'dgs_mat_16', name: 'İşlem ve Modüler Aritmetik', order: 16),
        Topic(id: 'dgs_mat_17', name: 'Permütasyon, Kombinasyon ve Olasılık', order: 17),
        Topic(id: 'dgs_mat_18', name: 'Sayısal Mantık', order: 18),
        Topic(id: 'dgs_mat_geo', name: 'Geometri Temelleri', order: 19),
      ],
    ),
    Subject(
      id: 'dgs_tur',
      name: 'Türkçe',
      emoji: '📚',
      color: Colors.red.shade700,
      questionCount: 50,
      topics: [
        Topic(id: 'dgs_tur_1', name: 'Sözcükte Anlam', order: 1),
        Topic(id: 'dgs_tur_2', name: 'Cümlede Anlam', order: 2),
        Topic(id: 'dgs_tur_3', name: 'Paragrafta Anlam', order: 3),
        Topic(id: 'dgs_tur_4', name: 'Sözel Mantık', order: 4),
        Topic(id: 'dgs_tur_5', name: 'Anlatım Bozuklukları', order: 5),
      ],
    ),
  ];
}
