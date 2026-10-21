// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Italian Words: Learn & Play';

  @override
  String get tabSearch => 'Cari';

  @override
  String get tabToday => 'Hari ini';

  @override
  String get tabQuiz => 'Kuis';

  @override
  String get tabTopics => 'Topik';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get myWords => 'Kata saya';

  @override
  String get back => 'Kembali';

  @override
  String get next => 'Berikutnya';

  @override
  String get done => 'Selesai';

  @override
  String get close => 'Tutup';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get retry => 'Coba lagi';

  @override
  String get listen => 'Dengarkan';

  @override
  String get listenSlow => 'Lambat';

  @override
  String get explanation => 'Penjelasan';

  @override
  String get exampleLabel => 'Contoh';

  @override
  String get typeNoun => 'Kata benda';

  @override
  String get typeVerb => 'Kata kerja';

  @override
  String get typeAdjective => 'Kata sifat';

  @override
  String get typePhrase => 'Frasa';

  @override
  String get searchHint => 'Italia, Inggris, اردو, বাংলা…';

  @override
  String wordsAndPhrases(int words, int phrases) {
    return '$words kata · $phrases frasa';
  }

  @override
  String get recentSearches => 'Pencarian terbaru';

  @override
  String get clearRecent => 'Hapus';

  @override
  String get noResults => 'Kata tidak ditemukan';

  @override
  String get didYouMean => 'Maksud Anda…?';

  @override
  String get searchOnline => 'Cari online';

  @override
  String get searchingOnline => 'Mencari online…';

  @override
  String get offlineNotice =>
      'Anda offline. Semua kata di aplikasi tetap bisa dipakai.';

  @override
  String get onlineResultTitle => 'Dari Wiktionary';

  @override
  String get addToMyWords => 'Tambah ke kata saya';

  @override
  String get removeFromMyWords => 'Hapus dari kata saya';

  @override
  String get myWordsEmpty =>
      'Belum ada kata tersimpan. Gunakan “Tambah ke kata saya” di Cari.';

  @override
  String get quizOnMyWords => 'Kuis kata saya';

  @override
  String get todayTitle => 'Kata hari ini';

  @override
  String todayProgress(int n, int total) {
    return 'Kata $n dari $total';
  }

  @override
  String streakDays(int n) {
    return '$n hari berturut-turut';
  }

  @override
  String get miniQuizCta => 'Kuis mini kata hari ini';

  @override
  String get learnedToday => 'Dilihat hari ini';

  @override
  String get todayDone => 'Semua 10 kata sudah dilihat. Kembali besok!';

  @override
  String get quizPickCategory => 'Pilih kategori';

  @override
  String get mixOfAll => 'Campuran semua';

  @override
  String quizProgress(int n, int total) {
    return 'Soal $n dari $total';
  }

  @override
  String get quizQuestionPrompt => 'Apakah kata ini sesuai dengan gambar?';

  @override
  String get vero => 'VERO';

  @override
  String get falso => 'FALSO';

  @override
  String get veroHint => 'benar';

  @override
  String get falsoHint => 'salah';

  @override
  String get answerCorrect => 'Benar!';

  @override
  String get answerWrong => 'Salah';

  @override
  String get correctAnswerIs => 'Kata yang benar:';

  @override
  String get quizResultTitle => 'Hasil Anda';

  @override
  String scoreOutOf(int score, int total) {
    return '$score / $total';
  }

  @override
  String get passed => 'LULUS';

  @override
  String get notPassed => 'TIDAK LULUS';

  @override
  String get passRule => 'Lulus dengan maksimal 2 kesalahan';

  @override
  String mistakesCount(int n) {
    return '$n kesalahan';
  }

  @override
  String get noMistakes => 'Tanpa kesalahan. Sempurna!';

  @override
  String get repeatMistakes => 'Ulangi kesalahan';

  @override
  String get newQuiz => 'Kuis baru';

  @override
  String bestScoreValue(int score, int total) {
    return 'Terbaik: $score/$total';
  }

  @override
  String get quizNotEnoughWords =>
      'Kategori ini butuh lebih banyak kata untuk kuis.';

  @override
  String get topicsSubtitle => 'Belajar per kategori';

  @override
  String nWords(int n) {
    return '$n kata';
  }

  @override
  String nLearned(int n) {
    return '$n dipelajari';
  }

  @override
  String get flashcards => 'Kartu';

  @override
  String get quiz20 => 'Kuis 20';

  @override
  String get flashcardTapToFlip => 'Sentuh kartu untuk melihat terjemahan';

  @override
  String get interfaceLanguage => 'Bahasa aplikasi';

  @override
  String get audioSpeed => 'Kecepatan audio';

  @override
  String get dailyReminder => 'Pengingat harian';

  @override
  String get reminderTime => 'Waktu pengingat';

  @override
  String get reminderBody => '10 kata Italia baru menunggu Anda.';

  @override
  String get darkMode => 'Mode gelap';

  @override
  String get resetProgress => 'Reset kemajuan';

  @override
  String get resetProgressConfirm => 'Hapus streak, skor, dan kata tersimpan?';

  @override
  String get resetDone => 'Kemajuan direset';

  @override
  String get privacy => 'Privasi';

  @override
  String get about => 'Tentang & kredit';

  @override
  String get adsConsentChange => 'Ubah izin iklan';

  @override
  String get removeAds => 'Hapus iklan';

  @override
  String get removeAdsBody =>
      'Sekali bayar, tanpa iklan selamanya. Semua kata, topik, dan kuis tetap gratis.';

  @override
  String get buy => 'Beli';

  @override
  String get restorePurchases => 'Pulihkan pembelian';

  @override
  String get adsRemoved => 'Iklan dihapus. Terima kasih!';

  @override
  String get purchasePending => 'Pembayaran diproses…';

  @override
  String get purchaseError => 'Pembelian tidak berhasil.';

  @override
  String get nothingToRestore => 'Tidak ada pembelian sebelumnya.';

  @override
  String get webPurchaseNotice =>
      'Pembelian tersedia di aplikasi Android dan iPhone.';

  @override
  String get storeUnavailable => 'Toko tidak tersedia saat ini.';

  @override
  String get voiceHelpTitle => 'Pasang suara Italia';

  @override
  String get voiceHelpBody =>
      'Ponsel Anda belum memiliki suara Italia. Buka Pengaturan › Sistem › Bahasa › Teks ke ucapan, pilih mesin Google dan pasang bahasa Italia. Membaca kata tetap bisa.';

  @override
  String get privacyBody =>
      'Aplikasi ini bekerja offline dan tanpa login. Kemajuan, kata tersimpan, dan pengaturan Anda hanya tersimpan di ponsel. Kami tidak pernah mengumpulkan nama, e-mail, atau lokasi. Iklan berasal dari Google AdMob dan hanya tampil setelah Anda setuju pada formulir izin; Anda dapat mengubahnya di Pengaturan. “Cari online” hanya mengirim kata yang Anda tulis ke Wiktionary. Untuk usia 13+.';

  @override
  String get aboutBody =>
      'Aplikasi kecil dan jujur untuk Anda yang tinggal di Italia: cari sebuah kata, pelajari sepuluh kata baru setiap hari, dan uji diri seperti tes SIM. Semua bekerja offline, tanpa akun.';

  @override
  String get creditsBody =>
      'Terjemahan dan contoh kalimat ditulis serta diperiksa secara manual untuk aplikasi ini. Daftar kata dibandingkan dengan sumber terbuka: Wiktionary dan Wikizionario (CC BY-SA 4.0), kalimat Tatoeba (CC BY 2.0 FR), dan Open Multilingual Wordnet. Gambar memakai Google Noto Emoji (Apache 2.0). Pelafalan Italia memakai teks-ke-ucapan ponsel Anda.';

  @override
  String get dataCoverage => 'Daftar kata di versi ini';

  @override
  String get mascotCheer => 'Hebat!';

  @override
  String get mascotTryAgain => 'Terus semangat!';

  @override
  String get adsTestIdsNotice =>
      'Perlu disiapkan: iklan masih memakai id uji Google. Tempel id AdMob asli agar menghasilkan.';

  @override
  String get demoBadge => 'Konten demo';

  @override
  String get topicGreetings => 'Sapaan & dasar';

  @override
  String get topicNumbers => 'Angka';

  @override
  String get topicColors => 'Warna';

  @override
  String get topicTime => 'Hari, bulan & waktu';

  @override
  String get topicFamily => 'Keluarga';

  @override
  String get topicBody => 'Tubuh';

  @override
  String get topicHealth => 'Kesehatan & dokter';

  @override
  String get topicPharmacy => 'Apotek';

  @override
  String get topicFood => 'Makanan';

  @override
  String get topicFruit => 'Buah';

  @override
  String get topicVegetables => 'Sayuran';

  @override
  String get topicDrinks => 'Minuman';

  @override
  String get topicCooking => 'Memasak';

  @override
  String get topicShopping => 'Supermarket & belanja';

  @override
  String get topicMoney => 'Uang & bank';

  @override
  String get topicHouse => 'Rumah';

  @override
  String get topicKitchen => 'Dapur';

  @override
  String get topicBathroom => 'Kamar mandi';

  @override
  String get topicClothes => 'Pakaian & sepatu';

  @override
  String get topicWeather => 'Cuaca & musim';

  @override
  String get topicCity => 'Kota & tempat';

  @override
  String get topicTransport => 'Transportasi & arah';

  @override
  String get topicWork => 'Pekerjaan';

  @override
  String get topicJobs => 'Profesi';

  @override
  String get topicOffices => 'Kantor & dokumen';

  @override
  String get topicSchool => 'Sekolah';

  @override
  String get topicAnimals => 'Hewan';

  @override
  String get topicNature => 'Alam';

  @override
  String get topicSport => 'Olahraga & waktu luang';

  @override
  String get topicFeelings => 'Perasaan';

  @override
  String get topicVerbs => 'Kata kerja umum';

  @override
  String get topicAdjectives => 'Kata sifat umum';

  @override
  String get topicPhrases => 'Frasa berguna';

  @override
  String get langEn => 'English';

  @override
  String get langUr => 'اردو';

  @override
  String get langPaArab => 'پنجابی (شاہ مکھی)';

  @override
  String get langPa => 'ਪੰਜਾਬੀ (ਗੁਰਮੁਖੀ)';

  @override
  String get langBn => 'বাংলা';

  @override
  String get langSi => 'සිංහල';

  @override
  String get langZh => '简体中文';

  @override
  String get langFr => 'Français';

  @override
  String get langEs => 'Español (España)';

  @override
  String get langEs419 => 'Español (Latinoamérica)';

  @override
  String get langIt => 'Italiano';

  @override
  String get langPt => 'Português (Brasil)';

  @override
  String get langDe => 'Deutsch';

  @override
  String get langHi => 'हिन्दी';

  @override
  String get langAr => 'العربية';

  @override
  String get langId => 'Bahasa Indonesia';

  @override
  String get langRu => 'Русский';

  @override
  String get moreLanguages => 'Bahasa lain';

  @override
  String get languageNoteWordTranslations =>
      'Terjemahan kata tersedia dalam sepuluh bahasa utama; bahasa antarmuka lain memakai bahasa Inggris.';

  @override
  String get bigPreparing => 'Preparing the dictionary…';

  @override
  String bigPlural(String plural) {
    return 'Plural: $plural';
  }

  @override
  String bigInEnglish(String gloss) {
    return 'In English: $gloss';
  }

  @override
  String get bigSource => 'From the big dictionary (Wiktionary)';

  @override
  String get bigLearnedSource => 'Learned from the online dictionary';

  @override
  String get bigSearching => 'Searching the big dictionary…';

  @override
  String get posAdverb => 'Adverb';

  @override
  String get posArticle => 'Article';

  @override
  String get posConjunction => 'Conjunction';

  @override
  String get posDeterminer => 'Determiner';

  @override
  String get posInterjection => 'Interjection';

  @override
  String get posNumeral => 'Number';

  @override
  String get posParticle => 'Particle';

  @override
  String get posPreposition => 'Preposition';

  @override
  String get posPronoun => 'Pronoun';

  @override
  String get posOther => 'Word';

  @override
  String get bigDictTitle => 'Big dictionary';

  @override
  String get bigDictCredits =>
      'The big dictionary of Italian words (over 100,000 words when complete) comes from Wiktionary, through kaikki.org, under the CC BY-SA 4.0 licence. The meanings in the ten languages were prepared for this app from the Wiktionary definitions.';
}
