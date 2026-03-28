import SwiftUI
import Combine

// MARK: - Localization Manager
// Multi-language support for 44 European countries
class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            loadTranslations()
        }
    }
    @Published var currentCountry: String {
        didSet {
            UserDefaults.standard.set(currentCountry, forKey: "selectedCountry")
        }
    }
    @Published private(set) var translations: [String: String] = [:]
    
    init() {
        self.currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ro"
        self.currentCountry = UserDefaults.standard.string(forKey: "selectedCountry") ?? "Romania"
        loadTranslations()
    }
    
    func t(_ key: String) -> String {
        return translations[key] ?? translationFallback(key)
    }
    
    private func translationFallback(_ key: String) -> String {
        // Return Romanian as fallback
        return allTranslations["ro"]?[key] ?? key
    }
    
    private func loadTranslations() {
        translations = allTranslations[currentLanguage] ?? allTranslations["ro"] ?? [:]
    }
    
    // MARK: - All Translations
    // Core UI strings in 20 European languages
    var allTranslations: [String: [String: String]] {
        [
            "ro": roTranslations,
            "en": enTranslations,
            "de": deTranslations,
            "fr": frTranslations,
            "it": itTranslations,
            "es": esTranslations,
            "pl": plTranslations,
            "uk": ukTranslations,
            "bg": bgTranslations,
            "hu": huTranslations,
            "nl": nlTranslations,
            "pt": ptTranslations,
            "cs": csTranslations,
            "sk": skTranslations,
            "hr": hrTranslations,
            "sr": srTranslations,
            "sl": slTranslations,
            "el": elTranslations,
            "tr": trTranslations,
            "ru": ruTranslations,
        ]
    }
    
    // MARK: - Romanian (default)
    private var roTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Nr",
            "tab.live": "Live",
            "tab.mechanic": "Mecanic",
            "tab.more": "Mai Mult",
            "health.score": "Scor Sanatate",
            "health.engine": "Motor",
            "health.brakes": "Frane",
            "health.electrical": "Electrica",
            "health.suspension": "Suspensie",
            "health.transmission": "Transmisie",
            "health.body": "Caroserie",
            "obd.connected": "Conectat",
            "obd.disconnected": "Deconectat",
            "obd.scanning": "Cautare dispozitive...",
            "obd.demo": "Mod Demo Activ",
            "obd.connect": "Conecteaza OBD2",
            "obd.rpm": "RPM",
            "obd.speed": "Viteza",
            "obd.temp": "Temp. Motor",
            "obd.airtemp": "Temp. Aer",
            "obd.battery": "Baterie",
            "obd.oil": "Temp. Ulei",
            "fuel.instant": "CONSUM INSTANT",
            "fuel.average": "CONSUM MEDIU",
            "fuel.unit": "L/100km",
            "service.calendar": "Calendar Intretinere",
            "service.oil": "Ulei Motor",
            "service.filters": "Filtre",
            "service.brakes": "Frane",
            "service.tires": "Anvelope",
            "service.timing": "Distributie",
            "service.coolant": "Antigel",
            "service.spark": "Bujii",
            "service.battery": "Baterie",
            "service.ac": "Clima",
            "chat.placeholder": "Descrie problema...",
            "chat.send": "Trimite",
            "chat.welcome": "Bun venit! Sunt mecanicul tau virtual.",
            "settings.country": "Configurare Tara",
            "settings.nightmode": "Mod Noapte",
            "settings.language": "Limba",
            "more.diagnostic": "DIAGNOSTIC",
            "more.ai": "AI & PREDICTII",
            "more.vehicle": "VEHICUL",
            "more.service": "SERVICE & COSTURI",
            "more.trust": "INCREDERE & PARTAJARE",
            "more.legal": "LEGAL & SIGURANTA",
            "more.europe": "EUROPA & MARKETPLACE",
            "more.settings": "SETARI",
            "general.save": "Salveaza",
            "general.cancel": "Anuleaza",
            "general.delete": "Sterge",
            "general.edit": "Editeaza",
            "general.share": "Partajeaza",
            "general.export": "Exporta",
            "general.search": "Cauta",
            "general.filter": "Filtreaza",
            "general.all": "Toate",
            "general.close": "Inchide",
            "general.back": "Inapoi",
            "general.next": "Urmatorul",
            "general.done": "Gata",
            "general.loading": "Se incarca...",
            "general.error": "Eroare",
            "general.success": "Succes",
            "general.warning": "Atentie",
            "itp.title": "Radar ITP",
            "itp.pass": "Va trece ITP-ul",
            "itp.fail": "Nu va trece ITP-ul",
            "legal.cameras": "Camere Radar",
            "legal.rules": "Reguli Trafic",
            "legal.fines": "Amenzi",
            "purchase.pro": "PRO",
            "purchase.free": "Gratuit",
            "purchase.upgrade": "Upgrade la PRO",
            "purchase.restore": "Restaureaza Achizitii",
            "privacy.title": "Politica de Confidentialitate",
            "terms.title": "Termeni si Conditii",
        ]
    }
    
    // MARK: - English
    private var enTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Plate",
            "tab.live": "Live",
            "tab.mechanic": "Mechanic",
            "tab.more": "More",
            "health.score": "Health Score",
            "health.engine": "Engine",
            "health.brakes": "Brakes",
            "health.electrical": "Electrical",
            "health.suspension": "Suspension",
            "health.transmission": "Transmission",
            "health.body": "Body",
            "obd.connected": "Connected",
            "obd.disconnected": "Disconnected",
            "obd.scanning": "Scanning for devices...",
            "obd.demo": "Demo Mode Active",
            "obd.connect": "Connect OBD2",
            "obd.rpm": "RPM",
            "obd.speed": "Speed",
            "obd.temp": "Engine Temp",
            "obd.airtemp": "Air Temp",
            "obd.battery": "Battery",
            "obd.oil": "Oil Temp",
            "fuel.instant": "INSTANT CONSUMPTION",
            "fuel.average": "AVERAGE CONSUMPTION",
            "fuel.unit": "L/100km",
            "service.calendar": "Maintenance Calendar",
            "service.oil": "Engine Oil",
            "service.filters": "Filters",
            "service.brakes": "Brakes",
            "service.tires": "Tires",
            "service.timing": "Timing Belt",
            "service.coolant": "Coolant",
            "service.spark": "Spark Plugs",
            "service.battery": "Battery",
            "service.ac": "A/C",
            "chat.placeholder": "Describe the issue...",
            "chat.send": "Send",
            "chat.welcome": "Welcome! I'm your virtual mechanic.",
            "settings.country": "Country Settings",
            "settings.nightmode": "Night Mode",
            "settings.language": "Language",
            "more.diagnostic": "DIAGNOSTIC",
            "more.ai": "AI & PREDICTIONS",
            "more.vehicle": "VEHICLE",
            "more.service": "SERVICE & COSTS",
            "more.trust": "TRUST & SHARING",
            "more.legal": "LEGAL & SAFETY",
            "more.europe": "EUROPE & MARKETPLACE",
            "more.settings": "SETTINGS",
            "general.save": "Save",
            "general.cancel": "Cancel",
            "general.delete": "Delete",
            "general.edit": "Edit",
            "general.share": "Share",
            "general.export": "Export",
            "general.search": "Search",
            "general.filter": "Filter",
            "general.all": "All",
            "general.close": "Close",
            "general.back": "Back",
            "general.next": "Next",
            "general.done": "Done",
            "general.loading": "Loading...",
            "general.error": "Error",
            "general.success": "Success",
            "general.warning": "Warning",
            "itp.title": "MOT Radar",
            "itp.pass": "Will pass MOT",
            "itp.fail": "Will not pass MOT",
            "legal.cameras": "Speed Cameras",
            "legal.rules": "Traffic Rules",
            "legal.fines": "Fines",
            "purchase.pro": "PRO",
            "purchase.free": "Free",
            "purchase.upgrade": "Upgrade to PRO",
            "purchase.restore": "Restore Purchases",
            "privacy.title": "Privacy Policy",
            "terms.title": "Terms & Conditions",
        ]
    }
    
    // MARK: - German
    private var deTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Kennz.",
            "tab.live": "Live",
            "tab.mechanic": "Mechaniker",
            "tab.more": "Mehr",
            "health.score": "Gesundheitswert",
            "health.engine": "Motor",
            "health.brakes": "Bremsen",
            "health.electrical": "Elektrik",
            "health.suspension": "Fahrwerk",
            "health.transmission": "Getriebe",
            "health.body": "Karosserie",
            "obd.connected": "Verbunden",
            "obd.disconnected": "Getrennt",
            "obd.scanning": "Suche Gerate...",
            "obd.demo": "Demo-Modus Aktiv",
            "obd.connect": "OBD2 verbinden",
            "fuel.instant": "MOMENTANVERBRAUCH",
            "fuel.average": "DURCHSCHNITTSVERBRAUCH",
            "fuel.unit": "L/100km",
            "service.calendar": "Wartungskalender",
            "chat.placeholder": "Problem beschreiben...",
            "chat.send": "Senden",
            "chat.welcome": "Willkommen! Ich bin Ihr virtueller Mechaniker.",
            "general.save": "Speichern",
            "general.cancel": "Abbrechen",
            "general.delete": "Loschen",
            "general.search": "Suchen",
            "itp.title": "TUV Radar",
            "itp.pass": "Wird TUV bestehen",
            "itp.fail": "Wird TUV nicht bestehen",
            "purchase.upgrade": "Auf PRO upgraden",
            "purchase.restore": "Kaufe wiederherstellen",
            "privacy.title": "Datenschutzrichtlinie",
            "terms.title": "Nutzungsbedingungen",
        ]
    }
    
    // MARK: - French
    private var frTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Plaque",
            "tab.live": "Direct",
            "tab.mechanic": "Mecanicien",
            "tab.more": "Plus",
            "health.score": "Score Sante",
            "health.engine": "Moteur",
            "health.brakes": "Freins",
            "obd.connected": "Connecte",
            "obd.disconnected": "Deconnecte",
            "fuel.instant": "CONSOMMATION INSTANTANEE",
            "fuel.average": "CONSOMMATION MOYENNE",
            "service.calendar": "Calendrier d'entretien",
            "chat.placeholder": "Decrivez le probleme...",
            "chat.send": "Envoyer",
            "chat.welcome": "Bienvenue! Je suis votre mecanicien virtuel.",
            "general.save": "Enregistrer",
            "general.cancel": "Annuler",
            "general.search": "Rechercher",
            "itp.title": "Controle Technique",
            "itp.pass": "Passera le CT",
            "itp.fail": "Ne passera pas le CT",
            "purchase.upgrade": "Passer a PRO",
            "privacy.title": "Politique de confidentialite",
            "terms.title": "Conditions d'utilisation",
        ]
    }
    
    // MARK: - Italian
    private var itTranslations: [String: String] {
        [
            "tab.scan": "Scansione",
            "tab.vin": "VIN/Targa",
            "tab.live": "Live",
            "tab.mechanic": "Meccanico",
            "tab.more": "Altro",
            "health.score": "Punteggio Salute",
            "health.engine": "Motore",
            "health.brakes": "Freni",
            "obd.connected": "Connesso",
            "obd.disconnected": "Disconnesso",
            "fuel.instant": "CONSUMO ISTANTANEO",
            "fuel.average": "CONSUMO MEDIO",
            "service.calendar": "Calendario Manutenzione",
            "chat.placeholder": "Descrivi il problema...",
            "chat.send": "Invia",
            "chat.welcome": "Benvenuto! Sono il tuo meccanico virtuale.",
            "general.save": "Salva",
            "general.cancel": "Annulla",
            "general.search": "Cerca",
            "itp.title": "Revisione",
            "itp.pass": "Passera la revisione",
            "itp.fail": "Non passera la revisione",
            "purchase.upgrade": "Passa a PRO",
            "privacy.title": "Informativa sulla privacy",
            "terms.title": "Termini e condizioni",
        ]
    }
    
    // MARK: - Spanish
    private var esTranslations: [String: String] {
        [
            "tab.scan": "Escanear",
            "tab.vin": "VIN/Matricula",
            "tab.live": "En vivo",
            "tab.mechanic": "Mecanico",
            "tab.more": "Mas",
            "health.score": "Puntuacion Salud",
            "obd.connected": "Conectado",
            "obd.disconnected": "Desconectado",
            "fuel.instant": "CONSUMO INSTANTANEO",
            "fuel.average": "CONSUMO MEDIO",
            "chat.placeholder": "Describe el problema...",
            "chat.send": "Enviar",
            "general.save": "Guardar",
            "general.cancel": "Cancelar",
            "general.search": "Buscar",
            "itp.title": "ITV",
            "purchase.upgrade": "Mejorar a PRO",
            "privacy.title": "Politica de privacidad",
            "terms.title": "Terminos y condiciones",
        ]
    }
    
    // MARK: - Polish
    private var plTranslations: [String: String] {
        [
            "tab.scan": "Skanuj",
            "tab.vin": "VIN/Tablica",
            "tab.live": "Na zywo",
            "tab.mechanic": "Mechanik",
            "tab.more": "Wiecej",
            "health.score": "Wynik zdrowia",
            "obd.connected": "Polaczony",
            "obd.disconnected": "Rozlaczony",
            "chat.placeholder": "Opisz problem...",
            "chat.send": "Wyslij",
            "general.save": "Zapisz",
            "general.cancel": "Anuluj",
            "general.search": "Szukaj",
            "itp.title": "Przeglad techniczny",
            "purchase.upgrade": "Uaktualnij do PRO",
            "privacy.title": "Polityka prywatnosci",
            "terms.title": "Regulamin",
        ]
    }
    
    // MARK: - Ukrainian
    private var ukTranslations: [String: String] {
        [
            "tab.scan": "Сканувати",
            "tab.vin": "VIN/Номер",
            "tab.live": "Наживо",
            "tab.mechanic": "Механiк",
            "tab.more": "Бiльше",
            "health.score": "Оцiнка здоров'я",
            "obd.connected": "Пiдключено",
            "obd.disconnected": "Вiдключено",
            "chat.placeholder": "Опишiть проблему...",
            "chat.send": "Надiслати",
            "general.save": "Зберегти",
            "general.cancel": "Скасувати",
            "itp.title": "Технiчний огляд",
            "purchase.upgrade": "Оновити до PRO",
            "privacy.title": "Полiтика конфiденцiйностi",
            "terms.title": "Умови використання",
        ]
    }
    
    // MARK: - Bulgarian
    private var bgTranslations: [String: String] {
        [
            "tab.scan": "Сканиране",
            "tab.vin": "VIN/Номер",
            "tab.live": "На живо",
            "tab.mechanic": "Механик",
            "tab.more": "Още",
            "health.score": "Здравен резултат",
            "obd.connected": "Свързан",
            "obd.disconnected": "Изключен",
            "chat.placeholder": "Опишете проблема...",
            "chat.send": "Изпрати",
            "general.save": "Запази",
            "general.cancel": "Отмени",
            "itp.title": "ГТП",
            "purchase.upgrade": "Надградете до PRO",
            "privacy.title": "Политика за поверителност",
            "terms.title": "Общи условия",
        ]
    }
    
    // MARK: - Hungarian
    private var huTranslations: [String: String] {
        [
            "tab.scan": "Szkennel",
            "tab.vin": "VIN/Rendszam",
            "tab.live": "Elo",
            "tab.mechanic": "Szerelo",
            "tab.more": "Tobb",
            "health.score": "Egeszseg pontszam",
            "obd.connected": "Csatlakoztatva",
            "obd.disconnected": "Levalasztva",
            "chat.placeholder": "Irja le a problemat...",
            "chat.send": "Kuldes",
            "general.save": "Mentes",
            "general.cancel": "Megse",
            "itp.title": "Muszaki vizsga",
            "purchase.upgrade": "PRO-ra valtas",
            "privacy.title": "Adatvedelmi iranyelvek",
            "terms.title": "Felhasznalasi feltetelek",
        ]
    }
    
    // MARK: - Dutch
    private var nlTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Kenteken",
            "tab.live": "Live",
            "tab.mechanic": "Monteur",
            "tab.more": "Meer",
            "health.score": "Gezondheidsscore",
            "obd.connected": "Verbonden",
            "obd.disconnected": "Verbroken",
            "chat.placeholder": "Beschrijf het probleem...",
            "chat.send": "Verstuur",
            "general.save": "Opslaan",
            "general.cancel": "Annuleren",
            "itp.title": "APK",
            "purchase.upgrade": "Upgrade naar PRO",
            "privacy.title": "Privacybeleid",
            "terms.title": "Algemene voorwaarden",
        ]
    }
    
    // MARK: - Portuguese
    private var ptTranslations: [String: String] {
        [
            "tab.scan": "Escanear",
            "tab.vin": "VIN/Matricula",
            "tab.live": "Ao vivo",
            "tab.mechanic": "Mecanico",
            "tab.more": "Mais",
            "health.score": "Pontuacao de saude",
            "obd.connected": "Conectado",
            "obd.disconnected": "Desconectado",
            "chat.placeholder": "Descreva o problema...",
            "chat.send": "Enviar",
            "general.save": "Guardar",
            "general.cancel": "Cancelar",
            "itp.title": "Inspecao",
            "purchase.upgrade": "Atualizar para PRO",
            "privacy.title": "Politica de privacidade",
            "terms.title": "Termos e condicoes",
        ]
    }
    
    // MARK: - Czech
    private var csTranslations: [String: String] {
        [
            "tab.scan": "Sken",
            "tab.vin": "VIN/SPZ",
            "tab.live": "Zive",
            "tab.mechanic": "Mechanik",
            "tab.more": "Vice",
            "health.score": "Skore zdravi",
            "obd.connected": "Pripojeno",
            "obd.disconnected": "Odpojeno",
            "chat.placeholder": "Popiste problem...",
            "chat.send": "Odeslat",
            "general.save": "Ulozit",
            "general.cancel": "Zrusit",
            "itp.title": "STK",
            "purchase.upgrade": "Prejit na PRO",
            "privacy.title": "Zasady ochrany soukromi",
            "terms.title": "Podminky pouzivani",
        ]
    }
    
    // MARK: - Slovak
    private var skTranslations: [String: String] {
        [
            "tab.scan": "Sken",
            "tab.vin": "VIN/ECV",
            "tab.live": "Nazivo",
            "tab.mechanic": "Mechanik",
            "tab.more": "Viac",
            "health.score": "Skore zdravia",
            "chat.placeholder": "Popiste problem...",
            "chat.send": "Odoslat",
            "general.save": "Ulozit",
            "general.cancel": "Zrusit",
            "itp.title": "STK",
            "purchase.upgrade": "Prejst na PRO",
            "privacy.title": "Zasady ochrany sukromia",
            "terms.title": "Podmienky pouzivania",
        ]
    }
    
    // MARK: - Croatian
    private var hrTranslations: [String: String] {
        [
            "tab.scan": "Skeniranje",
            "tab.vin": "VIN/Tablica",
            "tab.live": "Uzivo",
            "tab.mechanic": "Mehanicar",
            "tab.more": "Vise",
            "health.score": "Ocjena zdravlja",
            "chat.placeholder": "Opisite problem...",
            "chat.send": "Posalji",
            "general.save": "Spremi",
            "general.cancel": "Odustani",
            "itp.title": "Tehnicki pregled",
            "purchase.upgrade": "Nadogradi na PRO",
            "privacy.title": "Pravila privatnosti",
            "terms.title": "Uvjeti koristenja",
        ]
    }
    
    // MARK: - Serbian
    private var srTranslations: [String: String] {
        [
            "tab.scan": "Skeniraj",
            "tab.vin": "VIN/Tablica",
            "tab.live": "Uzivo",
            "tab.mechanic": "Mehanicar",
            "tab.more": "Vise",
            "health.score": "Ocena zdravlja",
            "chat.placeholder": "Opisite problem...",
            "chat.send": "Posalji",
            "general.save": "Sacuvaj",
            "general.cancel": "Otkazl",
            "itp.title": "Tehnicki pregled",
            "purchase.upgrade": "Nadogradi na PRO",
            "privacy.title": "Politika privatnosti",
            "terms.title": "Uslovi koriscenja",
        ]
    }
    
    // MARK: - Slovenian
    private var slTranslations: [String: String] {
        [
            "tab.scan": "Skeniranje",
            "tab.vin": "VIN/Tablica",
            "tab.live": "V zivo",
            "tab.mechanic": "Mehanik",
            "tab.more": "Vec",
            "health.score": "Ocena zdravja",
            "chat.placeholder": "Opisite problem...",
            "chat.send": "Poslji",
            "general.save": "Shrani",
            "general.cancel": "Preklici",
            "itp.title": "Tehnicki pregled",
            "purchase.upgrade": "Nadgradi na PRO",
            "privacy.title": "Politika zasebnosti",
            "terms.title": "Pogoji uporabe",
        ]
    }
    
    // MARK: - Greek
    private var elTranslations: [String: String] {
        [
            "tab.scan": "Σάρωση",
            "tab.vin": "VIN/Πινακίδα",
            "tab.live": "Ζωντανά",
            "tab.mechanic": "Μηχανικός",
            "tab.more": "Περισσότερα",
            "health.score": "Βαθμολογία υγείας",
            "chat.placeholder": "Περιγράψτε το πρόβλημα...",
            "chat.send": "Αποστολή",
            "general.save": "Αποθήκευση",
            "general.cancel": "Ακύρωση",
            "itp.title": "ΚΤΕΟ",
            "purchase.upgrade": "Αναβάθμιση σε PRO",
            "privacy.title": "Πολιτική απορρήτου",
            "terms.title": "Όροι χρήσης",
        ]
    }
    
    // MARK: - Turkish
    private var trTranslations: [String: String] {
        [
            "tab.scan": "Tara",
            "tab.vin": "VIN/Plaka",
            "tab.live": "Canli",
            "tab.mechanic": "Tamirci",
            "tab.more": "Daha Fazla",
            "health.score": "Saglik Puani",
            "chat.placeholder": "Sorunu tanimlayin...",
            "chat.send": "Gonder",
            "general.save": "Kaydet",
            "general.cancel": "Iptal",
            "itp.title": "Muayene",
            "purchase.upgrade": "PRO'ya yukseltin",
            "privacy.title": "Gizlilik politikasi",
            "terms.title": "Kullanim kosullari",
        ]
    }
    
    // MARK: - Russian
    private var ruTranslations: [String: String] {
        [
            "tab.scan": "Сканировать",
            "tab.vin": "VIN/Номер",
            "tab.live": "Онлайн",
            "tab.mechanic": "Механик",
            "tab.more": "Ещё",
            "health.score": "Оценка здоровья",
            "obd.connected": "Подключено",
            "obd.disconnected": "Отключено",
            "chat.placeholder": "Опишите проблему...",
            "chat.send": "Отправить",
            "general.save": "Сохранить",
            "general.cancel": "Отмена",
            "general.search": "Поиск",
            "itp.title": "Техосмотр",
            "purchase.upgrade": "Обновить до PRO",
            "privacy.title": "Политика конфиденциальности",
            "terms.title": "Условия использования",
        ]
    }
    
    // MARK: - Supported Languages List
    static var supportedLanguages: [(code: String, name: String, nativeName: String)] {
        [
            ("ro", "Romanian", "Romana"),
            ("en", "English", "English"),
            ("de", "German", "Deutsch"),
            ("fr", "French", "Francais"),
            ("it", "Italian", "Italiano"),
            ("es", "Spanish", "Espanol"),
            ("pl", "Polish", "Polski"),
            ("uk", "Ukrainian", "Українська"),
            ("bg", "Bulgarian", "Български"),
            ("hu", "Hungarian", "Magyar"),
            ("nl", "Dutch", "Nederlands"),
            ("pt", "Portuguese", "Portugues"),
            ("cs", "Czech", "Cestina"),
            ("sk", "Slovak", "Slovencina"),
            ("hr", "Croatian", "Hrvatski"),
            ("sr", "Serbian", "Srpski"),
            ("sl", "Slovenian", "Slovenscina"),
            ("el", "Greek", "Ελληνικά"),
            ("tr", "Turkish", "Turkce"),
            ("ru", "Russian", "Русский"),
        ]
    }
}
