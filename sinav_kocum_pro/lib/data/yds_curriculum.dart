import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';

class YdsCurriculum {
  static final List<Subject> subjects = [
    Subject(
      id: 'yds_ingilizce',
      name: 'Yabancı Dil (YDS)',
      emoji: '🌍',
      color: const Color(0xFF2B5B5A),
      questionCount: 80,
      topics: [
        Topic(id: 'yds_ing_1', name: 'Kelime Bilgisi (Vocabulary)', order: 1),
        Topic(id: 'yds_ing_2', name: 'Dil Bilgisi (Grammar)', order: 2),
        Topic(id: 'yds_ing_3', name: 'Cloze Test', order: 3),
        Topic(id: 'yds_ing_4', name: 'Cümle Tamamlama', order: 4),
        Topic(id: 'yds_ing_5', name: 'İngilizce - Türkçe Çeviri', order: 5),
        Topic(id: 'yds_ing_6', name: 'Türkçe - İngilizce Çeviri', order: 6),
        Topic(id: 'yds_ing_7', name: 'Okuduğunu Anlama (Reading)', order: 7),
        Topic(id: 'yds_ing_8', name: 'Karşılıklı Konuşma (Diyalog)', order: 8),
        Topic(id: 'yds_ing_9', name: 'Yakın Anlamlı Cümle (Restatement)', order: 9),
        Topic(id: 'yds_ing_10', name: 'Paragraf Tamamlama', order: 10),
        Topic(id: 'yds_ing_11', name: 'Anlam Bütünlüğünü Bozan Cümle', order: 11),
      ],
    ),
  ];
}
