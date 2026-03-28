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
    // Core UI strings in 44 European languages (one per country)
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
            "sq": sqTranslations,
            "be": beTranslations,
            "bs": bsTranslations,
            "da": daTranslations,
            "et": etTranslations,
            "fi": fiTranslations,
            "ka": kaTranslations,
            "is": isTranslations,
            "ga": gaTranslations,
            "lv": lvTranslations,
            "lt": ltTranslations,
            "lb": lbTranslations,
            "mk": mkTranslations,
            "mt": mtTranslations,
            "me": meTranslations,
            "no": noTranslations,
            "sv": svTranslations,
            "ca": caTranslations,
            "de-AT": deATTranslations,
            "de-CH": deCHTranslations,
            "fr-BE": frBETranslations,
            "nl-BE": nlBETranslations,
            "fr-CH": frCHTranslations,
            "it-CH": itCHTranslations,
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
    
    // MARK: - Albanian
    private var sqTranslations: [String: String] {
        [
            "tab.scan": "Skanim",
            "tab.vin": "VIN/Targa",
            "tab.live": "Drejtperdrejt",
            "tab.mechanic": "Mekanik",
            "tab.more": "Me shume",
            "health.score": "Rezultati i shendetit",
            "health.engine": "Motori",
            "health.brakes": "Frenat",
            "health.electrical": "Elektrike",
            "health.suspension": "Suspensioni",
            "health.transmission": "Transmisioni",
            "health.body": "Karoseria",
            "obd.connected": "I lidhur",
            "obd.disconnected": "I shkeputer",
            "chat.placeholder": "Pershkruani problemin...",
            "chat.send": "Dergo",
            "chat.welcome": "Miresevini! Une jam mekaniku juaj virtual.",
            "general.save": "Ruaj",
            "general.cancel": "Anullo",
            "general.delete": "Fshi",
            "general.search": "Kerko",
            "general.close": "Mbyll",
            "general.back": "Prapa",
            "general.next": "Tjetri",
            "general.done": "U krye",
            "itp.title": "Kontrolli teknik",
            "itp.pass": "Do ta kaloje kontrollin",
            "itp.fail": "Nuk do ta kaloje kontrollin",
            "purchase.upgrade": "Permireso ne PRO",
            "privacy.title": "Politika e privatesis",
            "terms.title": "Kushtet e perdorimit",
        ]
    }
    
    // MARK: - Belarusian
    private var beTranslations: [String: String] {
        [
            "tab.scan": "Сканаваць",
            "tab.vin": "VIN/Нумар",
            "tab.live": "Нажыва",
            "tab.mechanic": "Механiк",
            "tab.more": "Яшчэ",
            "health.score": "Ацэнка здароўя",
            "health.engine": "Рухавiк",
            "health.brakes": "Тармазы",
            "obd.connected": "Падключана",
            "obd.disconnected": "Адключана",
            "chat.placeholder": "Апiшыце праблему...",
            "chat.send": "Адправiць",
            "chat.welcome": "Вiтаем! Я ваш вiртуальны механiк.",
            "general.save": "Захаваць",
            "general.cancel": "Адмянiць",
            "general.search": "Шукаць",
            "itp.title": "Тэхагляд",
            "purchase.upgrade": "Абнавiць да PRO",
            "privacy.title": "Палiтыка канфiдэнцыяльнасцi",
            "terms.title": "Умовы выкарыстання",
        ]
    }
    
    // MARK: - Bosnian
    private var bsTranslations: [String: String] {
        [
            "tab.scan": "Skeniranje",
            "tab.vin": "VIN/Tablica",
            "tab.live": "Uzivo",
            "tab.mechanic": "Mehanicar",
            "tab.more": "Vise",
            "health.score": "Ocjena zdravlja",
            "health.engine": "Motor",
            "health.brakes": "Kocnice",
            "obd.connected": "Povezan",
            "obd.disconnected": "Nije povezan",
            "chat.placeholder": "Opisite problem...",
            "chat.send": "Posalji",
            "chat.welcome": "Dobrodosli! Ja sam vas virtualni mehanicar.",
            "general.save": "Spremi",
            "general.cancel": "Otkazi",
            "general.search": "Pretrazi",
            "itp.title": "Tehnicki pregled",
            "purchase.upgrade": "Nadogradi na PRO",
            "privacy.title": "Politika privatnosti",
            "terms.title": "Uslovi koristenja",
        ]
    }
    
    // MARK: - Danish
    private var daTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Nummerplade",
            "tab.live": "Live",
            "tab.mechanic": "Mekaniker",
            "tab.more": "Mere",
            "health.score": "Sundhedsscore",
            "health.engine": "Motor",
            "health.brakes": "Bremser",
            "health.electrical": "Elektrisk",
            "health.suspension": "Affjedring",
            "health.transmission": "Gearkasse",
            "health.body": "Karrosseri",
            "obd.connected": "Tilsluttet",
            "obd.disconnected": "Frakoblet",
            "chat.placeholder": "Beskriv problemet...",
            "chat.send": "Send",
            "chat.welcome": "Velkommen! Jeg er din virtuelle mekaniker.",
            "general.save": "Gem",
            "general.cancel": "Annuller",
            "general.delete": "Slet",
            "general.search": "Sog",
            "general.close": "Luk",
            "general.back": "Tilbage",
            "general.next": "Naeste",
            "general.done": "Faerdig",
            "itp.title": "Syn",
            "itp.pass": "Vil bestaa syn",
            "itp.fail": "Vil ikke bestaa syn",
            "purchase.upgrade": "Opgrader til PRO",
            "privacy.title": "Privatlivspolitik",
            "terms.title": "Vilkaar og betingelser",
        ]
    }
    
    // MARK: - Estonian
    private var etTranslations: [String: String] {
        [
            "tab.scan": "Skaneeri",
            "tab.vin": "VIN/Numbrimork",
            "tab.live": "Otse",
            "tab.mechanic": "Mehaanik",
            "tab.more": "Rohkem",
            "health.score": "Tervise skoor",
            "health.engine": "Mootor",
            "health.brakes": "Pidurid",
            "obd.connected": "Uhendatud",
            "obd.disconnected": "Uhendus katkestatud",
            "chat.placeholder": "Kirjeldage probleemi...",
            "chat.send": "Saada",
            "chat.welcome": "Tere tulemast! Olen teie virtuaalne mehaanik.",
            "general.save": "Salvesta",
            "general.cancel": "Tuhista",
            "general.search": "Otsi",
            "itp.title": "Tehnoulevaatus",
            "purchase.upgrade": "Uuenda PRO-ks",
            "privacy.title": "Privaatsuspoliitika",
            "terms.title": "Kasutustingimused",
        ]
    }
    
    // MARK: - Finnish
    private var fiTranslations: [String: String] {
        [
            "tab.scan": "Skannaa",
            "tab.vin": "VIN/Rekisterikilpi",
            "tab.live": "Live",
            "tab.mechanic": "Mekaanikko",
            "tab.more": "Lisaa",
            "health.score": "Terveyspistemaat",
            "health.engine": "Moottori",
            "health.brakes": "Jarrut",
            "health.electrical": "Sahko",
            "health.suspension": "Jousitus",
            "health.transmission": "Vaihteisto",
            "health.body": "Kori",
            "obd.connected": "Yhdistetty",
            "obd.disconnected": "Yhteys katkaistu",
            "chat.placeholder": "Kuvaile ongelma...",
            "chat.send": "Laheta",
            "chat.welcome": "Tervetuloa! Olen virtuaalimekaanikko.",
            "general.save": "Tallenna",
            "general.cancel": "Peruuta",
            "general.delete": "Poista",
            "general.search": "Etsi",
            "general.close": "Sulje",
            "general.back": "Takaisin",
            "general.next": "Seuraava",
            "general.done": "Valmis",
            "itp.title": "Katsastus",
            "itp.pass": "Lapaiseekatsastuksen",
            "itp.fail": "Ei lapaise katsastusta",
            "purchase.upgrade": "Paivita PRO:hon",
            "privacy.title": "Tietosuojakaytanto",
            "terms.title": "Kayttoehdot",
        ]
    }
    
    // MARK: - Georgian
    private var kaTranslations: [String: String] {
        [
            "tab.scan": "სკანირება",
            "tab.vin": "VIN/ნომერი",
            "tab.live": "პირდაპირ",
            "tab.mechanic": "მექანიკოსი",
            "tab.more": "მეტი",
            "health.score": "ჯანმრთელობის ქულა",
            "health.engine": "ძრავი",
            "health.brakes": "მუხრუჭები",
            "obd.connected": "დაკავშირებული",
            "obd.disconnected": "გათიშული",
            "chat.placeholder": "აღწერეთ პრობლემა...",
            "chat.send": "გაგზავნა",
            "chat.welcome": "კეთილი იყოს თქვენი მობრძანება! მე ვარ თქვენი ვირტუალური მექანიკოსი.",
            "general.save": "შენახვა",
            "general.cancel": "გაუქმება",
            "general.search": "ძებნა",
            "itp.title": "ტექ. ინსპექცია",
            "purchase.upgrade": "განახლება PRO-ზე",
            "privacy.title": "კონფიდენციალურობის პოლიტიკა",
            "terms.title": "მოხმარების პირობები",
        ]
    }
    
    // MARK: - Icelandic
    private var isTranslations: [String: String] {
        [
            "tab.scan": "Skanna",
            "tab.vin": "VIN/Numeraplata",
            "tab.live": "Beint",
            "tab.mechanic": "Bifreidameistari",
            "tab.more": "Meira",
            "health.score": "Heilbrigdisskor",
            "health.engine": "Vel",
            "health.brakes": "Hemlar",
            "obd.connected": "Tengt",
            "obd.disconnected": "Aftengt",
            "chat.placeholder": "Lystu vandamalinu...",
            "chat.send": "Senda",
            "chat.welcome": "Velkomin! Eg er sjarufur bifreidameistari.",
            "general.save": "Vista",
            "general.cancel": "Haetta vid",
            "general.search": "Leita",
            "itp.title": "Skodun",
            "purchase.upgrade": "Uppfaera i PRO",
            "privacy.title": "Personuverndarstefna",
            "terms.title": "Notkunarskilmalar",
        ]
    }
    
    // MARK: - Irish
    private var gaTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Plata",
            "tab.live": "Beo",
            "tab.mechanic": "Meicneoir",
            "tab.more": "Nios Mo",
            "health.score": "Scor Slainte",
            "health.engine": "Inneall",
            "health.brakes": "Coscain",
            "obd.connected": "Ceangailte",
            "obd.disconnected": "Diceangailte",
            "chat.placeholder": "Cuir sios ar an bhfadhb...",
            "chat.send": "Seol",
            "chat.welcome": "Failte! Is mise do mheicneoir fiorual.",
            "general.save": "Sabhdil",
            "general.cancel": "Cealaigh",
            "general.search": "Cuardaigh",
            "itp.title": "NCT",
            "itp.pass": "Eireoidh leis an NCT",
            "itp.fail": "Ni eireoidh leis an NCT",
            "purchase.upgrade": "Uasghradaigh go PRO",
            "privacy.title": "Polasai priobhaideachta",
            "terms.title": "Tearmai agus coinniollachta",
        ]
    }
    
    // MARK: - Latvian
    private var lvTranslations: [String: String] {
        [
            "tab.scan": "Skenet",
            "tab.vin": "VIN/Numurs",
            "tab.live": "Tiesraide",
            "tab.mechanic": "Mehanikus",
            "tab.more": "Vairak",
            "health.score": "Veselibas rezultats",
            "health.engine": "Motors",
            "health.brakes": "Bremzes",
            "obd.connected": "Savienots",
            "obd.disconnected": "Atvienots",
            "chat.placeholder": "Aprakstiet problemu...",
            "chat.send": "Nosutit",
            "chat.welcome": "Laipni ludzam! Es esmu jusu virtualais mehanikus.",
            "general.save": "Saglabar",
            "general.cancel": "Atcelt",
            "general.search": "Meklet",
            "itp.title": "Tehniska apskate",
            "purchase.upgrade": "Jauninet uz PRO",
            "privacy.title": "Privatuma politika",
            "terms.title": "Lietosanas noteikumi",
        ]
    }
    
    // MARK: - Lithuanian
    private var ltTranslations: [String: String] {
        [
            "tab.scan": "Skenuoti",
            "tab.vin": "VIN/Numeris",
            "tab.live": "Tiesiogiai",
            "tab.mechanic": "Mechanikas",
            "tab.more": "Daugiau",
            "health.score": "Sveikatos balas",
            "health.engine": "Variklis",
            "health.brakes": "Stabdziai",
            "obd.connected": "Prijungtas",
            "obd.disconnected": "Atjungtas",
            "chat.placeholder": "Aprasyke problema...",
            "chat.send": "Siusti",
            "chat.welcome": "Sveiki! As esu jusu virtualus mechanikas.",
            "general.save": "Issaugoti",
            "general.cancel": "Atsaukti",
            "general.search": "Ieskoti",
            "itp.title": "Technine apziura",
            "purchase.upgrade": "Atnaujinti i PRO",
            "privacy.title": "Privatumo politika",
            "terms.title": "Naudojimo salygos",
        ]
    }
    
    // MARK: - Luxembourgish
    private var lbTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Plack",
            "tab.live": "Live",
            "tab.mechanic": "Mechaniker",
            "tab.more": "Mei",
            "health.score": "Gesondheetsscore",
            "health.engine": "Motor",
            "health.brakes": "Bremsen",
            "obd.connected": "Verbonnen",
            "obd.disconnected": "Getrennt",
            "chat.placeholder": "Beschreift de Problem...",
            "chat.send": "Schecken",
            "chat.welcome": "Willkomm! Ech sinn Iere virtuellen Mechaniker.",
            "general.save": "Spicheren",
            "general.cancel": "Ofbriechen",
            "general.search": "Sichen",
            "itp.title": "Controle technique",
            "purchase.upgrade": "Op PRO upgraden",
            "privacy.title": "Dateschutzpolitik",
            "terms.title": "Notzungsbedengungen",
        ]
    }
    
    // MARK: - Macedonian
    private var mkTranslations: [String: String] {
        [
            "tab.scan": "Скенирај",
            "tab.vin": "VIN/Таблица",
            "tab.live": "Во живо",
            "tab.mechanic": "Механичар",
            "tab.more": "Повеќе",
            "health.score": "Оцена на здравје",
            "health.engine": "Мотор",
            "health.brakes": "Сопирачки",
            "obd.connected": "Поврзан",
            "obd.disconnected": "Исклучен",
            "chat.placeholder": "Опишете го проблемот...",
            "chat.send": "Испрати",
            "chat.welcome": "Добредојдовте! Јас сум вашиот виртуелен механичар.",
            "general.save": "Зачувај",
            "general.cancel": "Откажи",
            "general.search": "Пребарај",
            "itp.title": "Технички преглед",
            "purchase.upgrade": "Надгради на PRO",
            "privacy.title": "Политика за приватност",
            "terms.title": "Услови за користење",
        ]
    }
    
    // MARK: - Maltese
    private var mtTranslations: [String: String] {
        [
            "tab.scan": "Iskennja",
            "tab.vin": "VIN/Pjancha",
            "tab.live": "Dirett",
            "tab.mechanic": "Mekkanik",
            "tab.more": "Iktar",
            "health.score": "Puntegg tas-sahha",
            "health.engine": "Magna",
            "health.brakes": "Brejkijiet",
            "obd.connected": "Konness",
            "obd.disconnected": "Mhux konness",
            "chat.placeholder": "Iddeskrivi l-problema...",
            "chat.send": "Ibghat",
            "chat.welcome": "Merhba! Jien il-mekkanik virtwali tieghek.",
            "general.save": "Issejvja",
            "general.cancel": "Ikkanxella",
            "general.search": "Fittex",
            "itp.title": "VRT",
            "purchase.upgrade": "Aghmel upgrade ghal PRO",
            "privacy.title": "Politika tal-privatezza",
            "terms.title": "Termini u kondizzjonijiet",
        ]
    }
    
    // MARK: - Montenegrin
    private var meTranslations: [String: String] {
        [
            "tab.scan": "Skeniraj",
            "tab.vin": "VIN/Tablica",
            "tab.live": "Uzivo",
            "tab.mechanic": "Mehanicar",
            "tab.more": "Vise",
            "health.score": "Ocjena zdravlja",
            "health.engine": "Motor",
            "health.brakes": "Kocnice",
            "obd.connected": "Povezan",
            "obd.disconnected": "Nije povezan",
            "chat.placeholder": "Opisite problem...",
            "chat.send": "Posalji",
            "chat.welcome": "Dobrodosli! Ja sam vas virtualni mehanicar.",
            "general.save": "Sacuvaj",
            "general.cancel": "Otkazi",
            "general.search": "Pretrazi",
            "itp.title": "Tehnicki pregled",
            "purchase.upgrade": "Nadogradi na PRO",
            "privacy.title": "Politika privatnosti",
            "terms.title": "Uslovi koriscenja",
        ]
    }
    
    // MARK: - Norwegian
    private var noTranslations: [String: String] {
        [
            "tab.scan": "Skann",
            "tab.vin": "VIN/Skilt",
            "tab.live": "Direkte",
            "tab.mechanic": "Mekaniker",
            "tab.more": "Mer",
            "health.score": "Helsepoeng",
            "health.engine": "Motor",
            "health.brakes": "Bremser",
            "health.electrical": "Elektrisk",
            "health.suspension": "Fjering",
            "health.transmission": "Girkasse",
            "health.body": "Karosseri",
            "obd.connected": "Tilkoblet",
            "obd.disconnected": "Frakoblet",
            "chat.placeholder": "Beskriv problemet...",
            "chat.send": "Send",
            "chat.welcome": "Velkommen! Jeg er din virtuelle mekaniker.",
            "general.save": "Lagre",
            "general.cancel": "Avbryt",
            "general.delete": "Slett",
            "general.search": "Sok",
            "general.close": "Lukk",
            "general.back": "Tilbake",
            "general.next": "Neste",
            "general.done": "Ferdig",
            "itp.title": "EU-kontroll",
            "itp.pass": "Vil bestaa EU-kontroll",
            "itp.fail": "Vil ikke bestaa EU-kontroll",
            "purchase.upgrade": "Oppgrader til PRO",
            "privacy.title": "Personvernpolicy",
            "terms.title": "Vilkaar og betingelser",
        ]
    }
    
    // MARK: - Swedish
    private var svTranslations: [String: String] {
        [
            "tab.scan": "Skanna",
            "tab.vin": "VIN/Reg.nr",
            "tab.live": "Live",
            "tab.mechanic": "Mekaniker",
            "tab.more": "Mer",
            "health.score": "Halsopoang",
            "health.engine": "Motor",
            "health.brakes": "Bromsar",
            "health.electrical": "Elektrisk",
            "health.suspension": "Fjadring",
            "health.transmission": "Vaxellada",
            "health.body": "Kaross",
            "obd.connected": "Ansluten",
            "obd.disconnected": "Frankopplad",
            "chat.placeholder": "Beskriv problemet...",
            "chat.send": "Skicka",
            "chat.welcome": "Valkommen! Jag ar din virtuella mekaniker.",
            "general.save": "Spara",
            "general.cancel": "Avbryt",
            "general.delete": "Radera",
            "general.search": "Sok",
            "general.close": "Stang",
            "general.back": "Tillbaka",
            "general.next": "Nasta",
            "general.done": "Klar",
            "itp.title": "Besiktning",
            "itp.pass": "Kommer klara besiktning",
            "itp.fail": "Kommer inte klara besiktning",
            "purchase.upgrade": "Uppgradera till PRO",
            "privacy.title": "Integritetspolicy",
            "terms.title": "Villkor och anvandaravtal",
        ]
    }
    
    // MARK: - Catalan (Andorra)
    private var caTranslations: [String: String] {
        [
            "tab.scan": "Escanejar",
            "tab.vin": "VIN/Matricula",
            "tab.live": "En directe",
            "tab.mechanic": "Mecanic",
            "tab.more": "Mes",
            "health.score": "Puntuacio de salut",
            "health.engine": "Motor",
            "health.brakes": "Frens",
            "obd.connected": "Connectat",
            "obd.disconnected": "Desconnectat",
            "chat.placeholder": "Descriu el problema...",
            "chat.send": "Envia",
            "chat.welcome": "Benvingut! Soc el teu mecanic virtual.",
            "general.save": "Desa",
            "general.cancel": "Cancel·la",
            "general.search": "Cerca",
            "itp.title": "ITV",
            "purchase.upgrade": "Actualitza a PRO",
            "privacy.title": "Politica de privacitat",
            "terms.title": "Termes i condicions",
        ]
    }
    
    // MARK: - Austrian German
    private var deATTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Kennz.",
            "tab.live": "Live",
            "tab.mechanic": "Mechaniker",
            "tab.more": "Mehr",
            "health.score": "Gesundheitswert",
            "health.engine": "Motor",
            "health.brakes": "Bremsen",
            "obd.connected": "Verbunden",
            "obd.disconnected": "Getrennt",
            "chat.placeholder": "Problem beschreiben...",
            "chat.send": "Senden",
            "chat.welcome": "Willkommen! Ich bin Ihr virtueller Mechaniker.",
            "general.save": "Speichern",
            "general.cancel": "Abbrechen",
            "general.search": "Suchen",
            "itp.title": "Paragraf 57a (Pickerl)",
            "itp.pass": "Wird Pickerl bestehen",
            "itp.fail": "Wird Pickerl nicht bestehen",
            "purchase.upgrade": "Auf PRO upgraden",
            "privacy.title": "Datenschutzrichtlinie",
            "terms.title": "Nutzungsbedingungen",
        ]
    }
    
    // MARK: - Swiss German
    private var deCHTranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Kennz.",
            "tab.live": "Live",
            "tab.mechanic": "Mechaniker",
            "tab.more": "Meh",
            "health.score": "Gsundheitswart",
            "health.engine": "Motor",
            "health.brakes": "Bremse",
            "obd.connected": "Verbunde",
            "obd.disconnected": "Trennt",
            "chat.placeholder": "Problem beschriibe...",
            "chat.send": "Schicke",
            "chat.welcome": "Willkomme! Ich bi Ihre virtuell Mechaniker.",
            "general.save": "Speichere",
            "general.cancel": "Abbrache",
            "general.search": "Sueche",
            "itp.title": "MFK",
            "itp.pass": "Wird MFK bestah",
            "itp.fail": "Wird MFK nid bestah",
            "purchase.upgrade": "Uf PRO upgrade",
            "privacy.title": "Dateschutzrichtlinie",
            "terms.title": "Nutzigsbedingige",
        ]
    }
    
    // MARK: - Belgian French
    private var frBETranslations: [String: String] {
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
            "chat.placeholder": "Decrivez le probleme...",
            "chat.send": "Envoyer",
            "chat.welcome": "Bienvenue! Je suis votre mecanicien virtuel.",
            "general.save": "Enregistrer",
            "general.cancel": "Annuler",
            "general.search": "Rechercher",
            "itp.title": "Controle technique",
            "itp.pass": "Passera le CT",
            "itp.fail": "Ne passera pas le CT",
            "purchase.upgrade": "Passer a PRO",
            "privacy.title": "Politique de confidentialite",
            "terms.title": "Conditions d'utilisation",
        ]
    }
    
    // MARK: - Belgian Dutch
    private var nlBETranslations: [String: String] {
        [
            "tab.scan": "Scan",
            "tab.vin": "VIN/Nummerplaat",
            "tab.live": "Live",
            "tab.mechanic": "Mecanicien",
            "tab.more": "Meer",
            "health.score": "Gezondheidsscore",
            "health.engine": "Motor",
            "health.brakes": "Remmen",
            "obd.connected": "Verbonden",
            "obd.disconnected": "Verbroken",
            "chat.placeholder": "Beschrijf het probleem...",
            "chat.send": "Verstuur",
            "chat.welcome": "Welkom! Ik ben uw virtuele mecanicien.",
            "general.save": "Opslaan",
            "general.cancel": "Annuleren",
            "general.search": "Zoeken",
            "itp.title": "Autokeuring",
            "itp.pass": "Zal autokeuring halen",
            "itp.fail": "Zal autokeuring niet halen",
            "purchase.upgrade": "Upgrade naar PRO",
            "privacy.title": "Privacybeleid",
            "terms.title": "Algemene voorwaarden",
        ]
    }
    
    // MARK: - Swiss French
    private var frCHTranslations: [String: String] {
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
            "chat.placeholder": "Decrivez le probleme...",
            "chat.send": "Envoyer",
            "chat.welcome": "Bienvenue! Je suis votre mecanicien virtuel.",
            "general.save": "Enregistrer",
            "general.cancel": "Annuler",
            "general.search": "Rechercher",
            "itp.title": "Expertise",
            "itp.pass": "Passera l'expertise",
            "itp.fail": "Ne passera pas l'expertise",
            "purchase.upgrade": "Passer a PRO",
            "privacy.title": "Politique de confidentialite",
            "terms.title": "Conditions d'utilisation",
        ]
    }
    
    // MARK: - Swiss Italian
    private var itCHTranslations: [String: String] {
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
            "chat.placeholder": "Descrivi il problema...",
            "chat.send": "Invia",
            "chat.welcome": "Benvenuto! Sono il tuo meccanico virtuale.",
            "general.save": "Salva",
            "general.cancel": "Annulla",
            "general.search": "Cerca",
            "itp.title": "Collaudo",
            "itp.pass": "Passera il collaudo",
            "itp.fail": "Non passera il collaudo",
            "purchase.upgrade": "Passa a PRO",
            "privacy.title": "Informativa sulla privacy",
            "terms.title": "Termini e condizioni",
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
            ("sq", "Albanian", "Shqip"),
            ("be", "Belarusian", "Беларуская"),
            ("bs", "Bosnian", "Bosanski"),
            ("da", "Danish", "Dansk"),
            ("et", "Estonian", "Eesti"),
            ("fi", "Finnish", "Suomi"),
            ("ka", "Georgian", "ქართული"),
            ("is", "Icelandic", "Islenska"),
            ("ga", "Irish", "Gaeilge"),
            ("lv", "Latvian", "Latviesu"),
            ("lt", "Lithuanian", "Lietuviu"),
            ("lb", "Luxembourgish", "Letzebuergesch"),
            ("mk", "Macedonian", "Македонски"),
            ("mt", "Maltese", "Malti"),
            ("me", "Montenegrin", "Crnogorski"),
            ("no", "Norwegian", "Norsk"),
            ("sv", "Swedish", "Svenska"),
            ("ca", "Catalan", "Catala"),
            ("de-AT", "Austrian German", "Osterreichisches Deutsch"),
            ("de-CH", "Swiss German", "Schwiizerduutsch"),
            ("fr-BE", "Belgian French", "Francais (Belgique)"),
            ("nl-BE", "Belgian Dutch", "Nederlands (Belgie)"),
            ("fr-CH", "Swiss French", "Francais (Suisse)"),
            ("it-CH", "Swiss Italian", "Italiano (Svizzera)"),
        ]
    }
}
