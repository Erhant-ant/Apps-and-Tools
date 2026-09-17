import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/topic.dart';

class YdtCurriculum {
  static final List<Subject> subjects = [
    Subject(
      id: 'ydt_ingilizce',
      name: 'İngilizce (YDT)',
      emoji: '🇬🇧',
      color: const Color(0xFFE11D48),
      questionCount: 80,
      topics: [
        Topic(id: 'ydt_ing_1', name: 'Kelime Bilgisi (Vocabulary)', order: 1),
        Topic(id: 'ydt_ing_2', name: 'Dilbilgisi (Grammar)', order: 2),
        Topic(id: 'ydt_ing_3', name: 'Cloze Test', order: 3),
        Topic(id: 'ydt_ing_4', name: 'Cümle Tamamlama (Sentence Completion)', order: 4),
        Topic(id: 'ydt_ing_5', name: 'Çeviri (Translation)', order: 5),
        Topic(id: 'ydt_ing_6', name: 'Okuma Parçaları (Reading Comprehension)', order: 6),
        Topic(id: 'ydt_ing_7', name: 'Diyalog Tamamlama (Dialogue Completion)', order: 7),
        Topic(id: 'ydt_ing_8', name: 'Anlamca En Yakın Cümleyi Bulma (Restatement)', order: 8),
      ],
    ),
  ];
}
