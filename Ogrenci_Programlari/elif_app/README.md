# 📚 Öğrenci Programları (Student Study Planners)

Bu depo (repository), öğrenciler için özel olarak tasarlanmış ve kişiselleştirilmiş ders çalışma programı uygulamalarını (Flutter) içeren bir monorepo'dur.

## 🌟 Proje Hakkında
Öğrencilerin sınav hazırlık süreçlerini (YKS, KPSS vb.) daha verimli ve organize geçirmelerini sağlamak amacıyla, her öğrencinin kendi ihtiyaçlarına göre özelleştirilmiş mobil uygulamalar geliştirilmektedir. 

Şu anda bu depo içerisinde yer alan projeler:

- **[Elif App](./elif_app)**: Elif için özel olarak hazırlanmış ders programı ve takip uygulaması. (Detaylar uygulamanın kendi klasöründedir.)

## 🏗 Mimari ve Yapı
Bu proje, birden fazla öğrenci uygulamasını tek bir yerde tutmak amacıyla **Monorepo** yapısı kullanılarak düzenlenmiştir. 

- Her klasör (ör. `elif_app`), kendi başına bağımsız bir Flutter projesidir.
- Yeni bir öğrenci için uygulama oluşturulduğunda, bu ana dizine yeni bir proje klasörü (ör. `ahmet_app`) olarak eklenir.

## 🚀 Başlangıç

Projelerden herhangi birini çalıştırmak için o projenin klasörüne gidip Flutter komutlarını kullanabilirsiniz:

```bash
# Örnek olarak Elif'in uygulamasını çalıştırmak için:
cd elif_app
flutter pub get
flutter run
```

## 🛠 Kullanılan Teknolojiler
- **Flutter & Dart:** Çapraz platform (iOS/Android/Web) mobil uygulama geliştirme.
- **Git & GitHub:** Versiyon kontrolü ve monorepo proje yönetimi.
