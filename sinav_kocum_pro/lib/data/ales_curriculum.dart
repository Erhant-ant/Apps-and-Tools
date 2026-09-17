import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';

class AlesCurriculum {
  static final List<Subject> subjects = [
    Subject(
      id: 'ales_say',
      name: 'Sayısal',
      emoji: '📐',
      color: Colors.blue.shade700,
      questionCount: 50,
      topics: [
        Topic(id: 'ales_say_1', name: 'Temel Kavramlar', order: 1),
        Topic(id: 'ales_say_2', name: 'Rasyonel Sayılar', order: 2),
        Topic(id: 'ales_say_3', name: 'Üslü ve Köklü Sayılar', order: 3),
        Topic(id: 'ales_say_4', name: 'Basit Eşitsizlikler ve Mutlak Değer', order: 4),
        Topic(id: 'ales_say_5', name: 'Çarpanlara Ayırma', order: 5),
        Topic(id: 'ales_say_6', name: 'Oran Orantı', order: 6),
        Topic(id: 'ales_say_7', name: 'Denklem Çözme', order: 7),
        Topic(id: 'ales_say_8', name: 'Kümeler', order: 8),
        Topic(id: 'ales_say_9', name: 'Fonksiyonlar', order: 9),
        Topic(id: 'ales_say_10', name: 'İşlem, Modüler Aritmetik', order: 10),
        Topic(id: 'ales_say_11', name: 'Permütasyon, Kombinasyon, Olasılık', order: 11),
        Topic(id: 'ales_say_12', name: 'Sayı Problemleri', order: 12),
        Topic(id: 'ales_say_13', name: 'Kesir Problemleri', order: 13),
        Topic(id: 'ales_say_14', name: 'Yaş Problemleri', order: 14),
        Topic(id: 'ales_say_15', name: 'İşçi - Havuz Problemleri', order: 15),
        Topic(id: 'ales_say_16', name: 'Hız Problemleri', order: 16),
        Topic(id: 'ales_say_17', name: 'Yüzde, Kar-Zarar, Faiz, Karışım Problemleri', order: 17),
        Topic(id: 'ales_say_18', name: 'Geometri Temelleri', order: 18),
        Topic(id: 'ales_say_19', name: 'Sayısal Mantık', order: 19),
      ],
    ),
    Subject(
      id: 'ales_soz',
      name: 'Sözel',
      emoji: '📚',
      color: Colors.red.shade700,
      questionCount: 50,
      topics: [
        Topic(id: 'ales_soz_1', name: 'Sözcükte Anlam', order: 1),
        Topic(id: 'ales_soz_2', name: 'Cümlede Anlam', order: 2),
        Topic(id: 'ales_soz_3', name: 'Paragrafta Anlam', order: 3),
        Topic(id: 'ales_soz_4', name: 'Sözel Mantık', order: 4),
        Topic(id: 'ales_soz_5', name: 'Anlatım Bozuklukları', order: 5),
      ],
    ),
  ];
}
