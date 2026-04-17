import Foundation

struct QuestionData {
    static let questions: [Question] = [
        // LEVEL 1 - Easy (Başlangıç)
        Question(id: 1, question: "Osmanlı İmparatorluğu'nun kurucusu kimdir?", options: ["Fatih Sultan Mehmet", "Osman Gazi", "Yavuz Sultan Selim", "Kanuni Sultan Süleyman"], correctAnswer: 1, level: 1),
        Question(id: 2, question: "Osmanlı Devleti kaç yılında kuruldu?", options: ["1299", "1453", "1520", "1574"], correctAnswer: 0, level: 1),
        Question(id: 3, question: "İstanbul'un fethi kaç yılında oldu?", options: ["1299", "1453", "1517", "1683"], correctAnswer: 1, level: 1),
        Question(id: 4, question: "Fatih Sultan Mehmet'in lakabı nedir?", options: ["Yavuz", "Kanuni", "Fatih", "Cihan"], correctAnswer: 2, level: 1),
        Question(id: 5, question: "Osmanlı'nın ilk başkenti neresidir?", options: ["İstanbul", "Bursa", "Edirne", "Ankara"], correctAnswer: 1, level: 1),
        Question(id: 6, question: "Osmanlı Devleti'nde 'Padişah' unvanı ne anlama gelir?", options: ["Sultan", "Bey", "Çar", "Kral"], correctAnswer: 0, level: 1),
        Question(id: 7, question: "Hangi Osmanlı Padişahı 'Yavuz' lakabıyla bilinir?", options: ["Suleyman", "Selim I", "Mehmet II", "Abdülaziz"], correctAnswer: 1, level: 1),
        Question(id: 8, question: "Osmanlı Devleti'nin resmi dini nedir?", options: ["Hristiyanlık", "İslam", "Yahudilik", "Budizm"], correctAnswer: 1, level: 1),
        Question(id: 9, question: "Kanuni Sultan Süleyman kaç yılında tahta geçti?", options: ["1520", "1512", "1534", "1540"], correctAnswer: 0, level: 1),
        Question(id: 10, question: "Osmanlı ordusunda 'Yeniçeri' ne demektir?", options: ["Süvari", "Piyade", "Yeni Ordu", "Okçu"], correctAnswer: 2, level: 1),
        Question(id: 11, question: "Topkapı Sarayı kaç yılında inşa edildi?", options: ["1453-1481", "1350-1380", "1500-1520", "1400-1420"], correctAnswer: 0, level: 1),
        Question(id: 12, question: "Hangi deniz Osmanlı'nın en önemli denizidir?", options: ["Akdeniz", "Karadeniz", "Baltık", "Kızıldeniz"], correctAnswer: 0, level: 1),
        Question(id: 13, question: "Osmanlı'da 'Vizier' nedir?", options: ["General", "Bakan", "Vali", "Tüccar"], correctAnswer: 1, level: 1),
        Question(id: 14, question: "Osman Gazi'nin babası kimdir?", options: ["Orhan Gazi", "Ertuğrul Gazi", "Osman Gazi", "Alaeddin Bey"], correctAnswer: 1, level: 1),
        Question(id: 15, question: "İstanbul'un fethinde kullanılan topun adı nedir?", options: ["Şahi", "Mancınık", "Küvet", "Top"], correctAnswer: 0, level: 1),
        
        // LEVEL 2 - Easy
        Question(id: 16, question: "Hangi Padişah 'Muhteşem' sıfatıyla anılır?", options: ["II. Mehmet", "I. Süleyman", "II. Selim", "IV. Murad"], correctAnswer: 1, level: 2),
        Question(id: 17, question: "Osmanlı'da 'Sancağ-ı Şerif' nedir?", options: ["Savaş bayrağı", "Mühür", "Taç", "Kılıç"], correctAnswer: 0, level: 2),
        Question(id: 18, question: "Süleymaniye Camii'ni kim inşa etti?", options: ["Mimar Sinan", "Sedefkar Mehmet", "Koca Mustafa", "Davut Ağa"], correctAnswer: 0, level: 2),
        Question(id: 19, question: "Hangi savaşta Osmanlı ilk kez Avrupa'da toprak kaybetti?", options: ["Çaldıran", "Mohaç", "Viyana", "Preveze"], correctAnswer: 2, level: 2),
        Question(id: 20, question: "Köprülü Mehmet Paşa kimdir?", options: ["Bir Sadrazam", "Bir Sanatçı", "Bir Şair", "Bir Komutan"], correctAnswer: 0, level: 2),
        Question(id: 21, question: "Osmanlı'da 'Harem' nedir?", options: ["Sarayın kadınlar bölümü", "Sarayın mutfağı", "Askeri birlik", "Maliye dairesi"], correctAnswer: 0, level: 2),
        Question(id: 22, question: "Hangi Osmanlı Padişahı şairdi?", options: ["IV. Mehmet", "II. Selim", "I. Ahmed", "Hepsi"], correctAnswer: 3, level: 2),
        Question(id: 23, question: "Osmanlı'da 'Tımarlı Sipahi' neydi?", options: ["Asker", "Toprak sahibi asker", "Tüccar", "Zanaatkâr"], correctAnswer: 1, level: 2),
        Question(id: 24, question: "Hangi savaşta Kanuni Sultan Süleyman öldü?", options: ["Rakka", "Szigetvar", "Irakeyn", "Barak"], correctAnswer: 1, level: 2),
        Question(id: 25, question: "Osmanlı'nın 'Kapıkulu' askerleri arasında hangisi yoktur?", options: ["Yeniçeri", "Sipahi", "Acemi Oğlan", "Deli"], correctAnswer: 1, level: 2),
        
        // LEVEL 3 - Easy
        Question(id: 26, question: "Osmanlı'da 'Sarayburnu' neresidir?", options: ["Beşiktaş", "Sarayın deniz tarafı", "Üsküdar", "Kadıköy"], correctAnswer: 1, level: 3),
        Question(id: 27, question: "Hangi ada Osmanlılar 'Adalar' derdi?", options: ["Kıbrıs", "Girit", "Prens Adaları", "Midilli"], correctAnswer: 2, level: 3),
        Question(id: 28, question: "Osmanlı'da 'Kul' sistemi nedir?", options: ["Köle sistemi", "Devlet adamı yetiştirme", " Vergi sistemi", "Askeri sistem"], correctAnswer: 1, level: 3),
        Question(id: 29, question: "İstanbul'un fethinin sembolik tarihi nedir?", options: ["29 Mayıs", "23 Nisan", "30 Ağustos", "19 Mayıs"], correctAnswer: 0, level: 3),
        Question(id: 30, question: "Hangi Paşa 'Köprülü' ailesinden gelmiştir?", options: ["Sadrazam", "Kaptan-ı Derya", "Şeyhülislam", "Hepsi"], correctAnswer: 3, level: 3),
        
        // LEVEL 4 - Medium
        Question(id: 31, question: "Osmanlı'nın 'Lale Devri' hangi dönemdir?", options: ["I. Abdülhamit", "III. Ahmed", "III. Selim", "II. Mahmud"], correctAnswer: 1, level: 4),
        Question(id: 32, question: "Patrikhane Osmanlı'da neydi?", options: ["Kilise liderliği", "Okul", "Hastane", "Kütüphane"], correctAnswer: 0, level: 4),
        Question(id: 33, question: "Sened-i İttifak nedir?", options: ["Antlaşma", "Vasiyetname", "Kanunname", "Ferman"], correctAnswer: 0, level: 4),
        Question(id: 34, question: "Tanzimat Fermanı kaç yılında ilan edildi?", options: ["1839", "1856", "1876", "1908"], correctAnswer: 0, level: 4),
        Question(id: 35, question: "Osmanlı'da 'Mebusan Meclisi' nedir?", options: ["Askeri meclis", "Temsil meclisi", "Dinî meclis", "Saray meclisi"], correctAnswer: 1, level: 4),
        Question(id: 36, question: "Hangi Osmanlı yenilikçisi 'Modernleşmenin öncüsü' sayılır?", options: ["II. Mahmud", "III. Selim", "II. Abdülaziz", "V. Murad"], correctAnswer: 1, level: 4),
        Question(id: 37, question: "Osmanlı'nın ilk anayasası hangisidir?", options: ["Kanun-ı Esasi", "Meşrutiyet", "Teşkilat-ı Esasiye", "Hürriyet"], correctAnswer: 0, level: 4),
        Question(id: 38, question: "II. Meşrutiyet kaç yılında ilan edildi?", options: ["1876", "1908", "1912", "1914"], correctAnswer: 1, level: 4),
        Question(id: 39, question: "Hangi savaş Osmanlı'nın kesin yenilgisidir?", options: ["1914", "Çanakkale", "1918", "Balkan"], correctAnswer: 2, level: 4),
        Question(id: 40, question: "Osmanlı'da 'Müsadere' sistemi nedir?", options: ["Toprak alma", "Ölümde mallara el koyma", "Vergi toplama", "Asker alma"], correctAnswer: 1, level: 4),
        
        // LEVEL 5 - Medium
        Question(id: 41, question: "Arap isyanları hangi yılda başladı?", options: ["1914", "1916", "1918", "1912"], correctAnswer: 1, level: 5),
        Question(id: 42, question: "Çanakkale Savaşı kaç yılında oldu?", options: ["1912", "1914", "1915", "1917"], correctAnswer: 2, level: 5),
        Question(id: 43, question: "Mondros Ateşkes Antlaşması kaç yılında imzalandı?", options: ["1917", "1918", "1919", "1920"], correctAnswer: 1, level: 5),
        Question(id: 44, question: "Osmanlı'nın son Sadrazamı kimdir?", options: ["Talat Paşa", "Ahmet Tevfik", "Enver Paşa", "Cemal Paşa"], correctAnswer: 1, level: 5),
        Question(id: 45, question: "Küçük Kaynarca Antlaşması kaç yılında imzalandı?", options: ["1718", "1739", "1774", "1791"], correctAnswer: 2, level: 5),
        Question(id: 46, question: "Yavuz Sultan Selim Mısır'ı kaç yılında fethetti?", options: ["1514", "1516", "1517", "1520"], correctAnswer: 2, level: 5),
        Question(id: 47, question: "Kanuni kaç yılında vefat etti?", options: ["1566", "1564", "1570", "1550"], correctAnswer: 0, level: 5),
        Question(id: 48, question: "İstanbul'un fethinde hangi Bizans İmparatoru öldü?", options: ["VIII. Konstantinos", "XI. Konstantinos", "IX. Konstantinos", "VII. Konstantinos"], correctAnswer: 0, level: 5),
        Question(id: 49, question: "Osmanlı'nın en uzun süre tahtta kalan Padişahı kimdir?", options: ["Kanuni", "II. Abdülhamit", "III. Ahmed", "I. Abdülmecit"], correctAnswer: 1, level: 5),
        Question(id: 50, question: "Osmanlı Devleti resmen kaç yılında sona erdi?", options: ["1920", "1922", "1923", "1924"], correctAnswer: 1, level: 5),
        
        // LEVEL 6 - Medium
        Question(id: 51, question: "Lozan Antlaşması kaç yılında imzalandı?", options: ["1920", "1921", "1922", "1923"], correctAnswer: 3, level: 6),
        Question(id: 52, question: "Kurtuluş Savaşı kaç yılında başladı?", options: ["1918", "1919", "1920", "1921"], correctAnswer: 1, level: 6),
        Question(id: 53, question: "Hangi Osmanlı Bankası ülkeyi yönetti?", options: ["Ottoman Bank", "Ziraat Bankası", "Halk Bankası", "Garanti"], correctAnswer: 0, level: 6),
        Question(id: 54, question: "Osmanlı-Rus Savaşları'nın nedeni genellikle neydi?", options: ["Toprak", "Din", " ticaret", "Hepsi"], correctAnswer: 3, level: 6),
        Question(id: 55, question: "Osmanlı'da 'Millet-i Sadıka' hangi topluluktu?", options: ["Kürtler", "Türkmenler", "Araplar", "Rumlar"], correctAnswer: 0, level: 6),
        Question(id: 56, question: "Osmanlı'nın 'Karaordusu' kimin komutasındaydı?", options: ["Serasker", "Kaptan-ı Derya", "Müşir", "Vali"], correctAnswer: 0, level: 6),
        Question(id: 57, question: "Süleyman the Magnificent kaç yaşında tahta geçti?", options: ["26", "20", "30", "35"], correctAnswer: 0, level: 6),
        Question(id: 58, question: "Osmanlı'da 'Karakol' sistemi kim kurdu?", options: ["II. Mahmud", "III. Selim", "II. Abdülaziz", "IV. Murad"], correctAnswer: 0, level: 6),
        Question(id: 59, question: "Osmanlı'nın ilk 'Fuar'ı nerede açıldı?", options: ["İstanbul", "Selanik", "İzmir", "Bursa"], correctAnswer: 2, level: 6),
        Question(id: 60, question: "Hangi devlet Osmanlı'yı 'Düvel-i Muazzama' olarak tanıdı?", options: ["Avusturya", "Rusya", "İngiltere", "Fransa"], correctAnswer: 1, level: 6),
        
        // LEVEL 7 - Hard
        Question(id: 61, question: "Osmanlı'da 'Köprülüler' dönemi kaç yıl sürdü?", options: ["20 yıl", "30 yıl", "50 yıl", "40 yıl"], correctAnswer: 2, level: 7),
        Question(id: 62, question: "Fetihname nedir?", options: ["Fetihname", "Fetih belgesi", "Mektup", "Antlaşma"], correctAnswer: 1, level: 7),
        Question(id: 63, question: "Hangi Osmanlı 'Şehzade' taht için savaştı?", options: ["Şehzade Mustafa", "Şehzade Selim", "Şehzade Bayezid", "Şehzade Cem"], correctAnswer: 3, level: 7),
        Question(id: 64, question: "Osmanlı'da 'Celali İsyanları' neden çıktı?", options: ["Düzensizlik", "Kuraklık", "Aşırı vergi", "Hepsi"], correctAnswer: 3, level: 7),
        Question(id: 65, question: "Osmanlı'nın 'Mısır Seferi' kim yönetti?", options: ["Yavuz Sultan Selim", "Kanuni Sultan Süleyman", "Fatih Sultan Mehmet", "II. Selim"], correctAnswer: 1, level: 7),
        Question(id: 66, question: "Kara Mehmet Paşa kimdir?", options: ["Sadrazam", "Kaptan-ı Derya", "Şeyhülislam", "Mimar"], correctAnswer: 0, level: 7),
        Question(id: 67, question: "Osmanlı'da 'Niyabet-i Hakani' nedir?", options: ["Valilik", "Padişah vekâleti", "Mülkiyet", "Askeri unvan"], correctAnswer: 1, level: 7),
        Question(id: 68, question: "Hangi savaşta Osmanlı ilk kez top kullandı?", options: ["Çaldıran", "Varna", "Mohaç", "İstanbul"], correctAnswer: 2, level: 7),
        Question(id: 69, question: "Osmanlı'da 'Hil'at' nedir?", options: ["Elbise", "Nişan", "Mühr", "Taç"], correctAnswer: 0, level: 7),
        Question(id: 70, question: "Şehzade Mustafa kim tarafından öldürüldü?", options: ["Kanuni", "Hürrem Sultan", "Sadrazam", "Yavuz Sultan Selim"], correctAnswer: 0, level: 7),
        
        // LEVEL 8 - Hard
        Question(id: 71, question: "Osmanlı'da 'Beylerbeyi' ne anlama gelir?", options: ["Beylerin beyi", "Saray görevlisi", "Askeri lider", "Vali"], correctAnswer: 0, level: 8),
        Question(id: 72, question: "Hangi Osmanlı elçisi Avrupa'da ünlü oldu?", options: ["Sokollu Mehmet", "Özdemir Paşa", "Sarı Hızır", "Sofu Rüstem"], correctAnswer: 2, level: 8),
        Question(id: 73, question: "Osmanlı'nın 'Karlofça' yenilgisi kaç yılında?", options: ["1683", "1686", "1699", "1700"], correctAnswer: 2, level: 8),
        Question(id: 74, question: "Osmanlı'da 'Maktu' vergi sistemi nedir?", options: ["Sabit vergi", "Oransal vergi", "Arazi vergisi", "Gelir vergisi"], correctAnswer: 0, level: 8),
        Question(id: 75, question: "Sadrazam 'Köprülü Mehmet' kaç yılında göreve başladı?", options: ["1651", "1653", "1655", "1660"], correctAnswer: 1, level: 8),
        Question(id: 76, question: "Osmanlı'da 'Mühr-ü Hümayun' kime aittir?", options: ["Sadrazam", "Padişah", "Şeyhülislam", "Kaptan-ı Derya"], correctAnswer: 1, level: 8),
        Question(id: 77, question: "Hangi 'Venedik' savaşı en uzun sürdü?", options: ["Kandiye", "Girit", "Kıbrıs", "Preveze"], correctAnswer: 0, level: 8),
        Question(id: 78, question: "Osmanlı'da 'Gulam' sistemi nedir?", options: ["Köle asker", "Saray hizmetkârı", "Yabancı danışman", "Tüccar"], correctAnswer: 1, level: 8),
        Question(id: 79, question: "Kara Mustafa Paşa'nın idam fermanını kim verdi?", options: ["IV. Mehmet", "II. Süleyman", "II. Ahmed", "IV. Ahmed"], correctAnswer: 0, level: 8),
        Question(id: 80, question: "Osmanlı'da 'Müberrat' nedir?", options: ["İsyan", "Vergi muafiyeti", "Mülk belgelemesi", "Askeri terfi"], correctAnswer: 1, level: 8),
        
        // LEVEL 9 - Hard
        Question(id: 81, question: "Hangi Osmanlı 'Coğrafya' eseri ünlüdür?", options: ["Kâtip Çelebi", "Evliya Çelebi", "İbn-i Arabşah", "Hacı Kalfa"], correctAnswer: 1, level: 9),
        Question(id: 82, question: "Osmanlı'da 'İstanbul'un fethi' hangi kaynaklarda geçer?", options: ["Tarih-i Ali", "Fetihname-i İstanbul", "Osmanlı Kronikleri", "Hepsi"], correctAnswer: 3, level: 9),
        Question(id: 83, question: "Saray'da 'Saray-ı Hümayun' kaç odalıydı?", options: ["100", "200", "300", "400"], correctAnswer: 2, level: 9),
        Question(id: 84, question: "Osmanlı'da 'Hilal' neyi temsil eder?", options: ["İslam", "Osmanlı", "Barış", "Savaş"], correctAnswer: 0, level: 9),
        Question(id: 85, question: "Osmanlı'da 'Şeriat' ne anlama gelir?", options: ["Kanun", "Dinî hukuk", "Saray yönetimi", "Askeri yasa"], correctAnswer: 1, level: 9),
        Question(id: 86, question: "Hangi Osmanlı 'Astronomi' ile ilgilendi?", options: ["Taqi al-Din", "Mimar Sinan", "Köprülü Mehmet", "Sarı Hızır"], correctAnswer: 0, level: 9),
        Question(id: 87, question: "Osmanlı'nın 'Baltalimanı' antlaşması kiminle?", options: ["Fransa", "İngiltere", "Rusya", "Avusturya"], correctAnswer: 1, level: 9),
        Question(id: 88, question: "Osmanlı'da 'Menzil' sistemi nedir?", options: ["Posta sistemi", "Askeri birlik", "Tarım sistemi", "Ticaret yolu"], correctAnswer: 0, level: 9),
        Question(id: 89, question: "Köprülü Fazıl Ahmet Paşa kaç yılında öldü?", options: ["1676", "1673", "1679", "1680"], correctAnswer: 0, level: 9),
        Question(id: 90, question: "Hangi Osmanlı 'Mektup' yazışmaları ünlüdür?", options: ["Süleyman-Napoleon", "Kanuni-Safevi", "Fatih-Osman", "Yavuz-İstanbul"], correctAnswer: 0, level: 9),
        
        // LEVEL 10 - Master
        Question(id: 91, question: "Osmanlı'da 'Kapı' sistemi nedir?", options: ["Saray kapısı", "Yönetim birimi", "Ticaret yolu", "Askeri birlik"], correctAnswer: 1, level: 10),
        Question(id: 92, question: "Hangi Osmanlı Padişahı 'Şark Meselesi'ni çözmek istedi?", options: ["II. Abdülaziz", "II. Abdülhamit", "II. Mahmud", "V. Murad"], correctAnswer: 1, level: 10),
        Question(id: 93, question: "Osmanlı'nın 'Hariciye' dairesi ne iş yapar?", options: ["Maliye", "Dışişleri", "İçişleri", "Savunma"], correctAnswer: 1, level: 10),
        Question(id: 94, question: "Küçük Kaynarca sonrası hangi sonuç doğdu?", options: ["Karadeniz Rus gölü", "Kırım bağımsız", "Osmanlı zayıfladı", "Hepsi"], correctAnswer: 3, level: 10),
        Question(id: 95, question: "Osmanlı'da 'Tımâr' sistemi kimleri kapsardı?", options: ["Sadece Türkler", "Sadece Gayrimüslimler", "Tüm halk", "Sadece Müslümanlar"], correctAnswer: 2, level: 10),
        Question(id: 96, question: "İstanbul'un fethi hangi千年'de gerçekleşti?", options: ["14. yüzyıl", "15. yüzyıl", "16. yüzyıl", "17. yüzyıl"], correctAnswer: 1, level: 10),
        Question(id: 97, question: "Osmanlı'nın 'Yeniçeri Ocağı' neden kaldırıldı?", options: ["Başarısızlık", "Isyan tehdidi", "Mali sıkıntı", "Reform"], correctAnswer: 1, level: 10),
        Question(id: 98, question: "Hangi antlaşma 'Osmanlı'yı parçaladı'?", options: ["Berlin", "Sevr", "Lozan", "Parıs"], correctAnswer: 1, level: 10),
        Question(id: 99, question: "Osmanlı'da 'Şehzade' yetiştirme sistemine ne denirdi?", options: [" Enderun", "Saray", "Beylik", "Vilayet"], correctAnswer: 0, level: 10),
        Question(id: 100, question: "Osmanlı İmparatorluğu'nun son genel valisi kimdir?", options: ["Talat Paşa", "Enver Paşa", "Ahmet Tevfik", "Said Halim"], correctAnswer: 2, level: 10)
    ]
    
    static func getQuestions(for level: Int, count: Int = 15) -> [Question] {
        let filtered = questions.filter { $0.level == level }
        return Array(filtered.shuffled().prefix(count))
    }
}
