import SwiftUI

// MARK: - European Country Model
// Complete data for all 44 European countries with laws, currencies, languages
struct EuropeanCountry: Identifiable {
    let id: String  // ISO 3166-1 alpha-2
    let name: String
    let nameLocal: String
    let flag: String
    let language: String
    let languageCode: String  // BCP 47
    let currency: String
    let currencySymbol: String
    let currencyCode: String  // ISO 4217
    let inspectionName: String  // ITP/MOT/TUV etc
    let inspectionInterval: String
    let insuranceName: String  // RCA/MTPL etc
    let insuranceMinCost: String
    let drivingSide: String
    let speedLimitUrban: Int
    let speedLimitRural: Int
    let speedLimitMotorway: Int
    let alcoholLimit: Double  // BAC g/L
    let emergencyNumber: String
    let roadAssistance: String
    let commonBrands: [String]
    let region: EURegion
    
    enum EURegion: String {
        case western = "Europa de Vest"
        case eastern = "Europa de Est"
        case northern = "Europa de Nord"
        case southern = "Europa de Sud"
        case central = "Europa Centrala"
    }
    
    // MARK: - All 44 European Countries
    static let allCountries: [EuropeanCountry] = [
        // Eastern Europe
        EuropeanCountry(id: "RO", name: "Romania", nameLocal: "Romania", flag: "🇷🇴", language: "Romana", languageCode: "ro", currency: "Leu romanesc", currencySymbol: "RON", currencyCode: "RON", inspectionName: "ITP (Inspectia Tehnica Periodica)", inspectionInterval: "2 ani (noi: 3 ani)", insuranceName: "RCA", insuranceMinCost: "800-1500 RON/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "ACIR: 021-9271", commonBrands: ["Dacia", "VW", "Skoda", "BMW", "Audi", "Ford"], region: .eastern),
        
        EuropeanCountry(id: "BG", name: "Bulgaria", nameLocal: "България", flag: "🇧🇬", language: "Bulgara", languageCode: "bg", currency: "Lev bulgaresc", currencySymbol: "лв", currencyCode: "BGN", inspectionName: "ГТП (Годишен технически преглед)", inspectionInterval: "1 an", insuranceName: "ГО (Гражданска отговорност)", insuranceMinCost: "200-500 BGN/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 140, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "SBA: 1286", commonBrands: ["VW", "Opel", "Mercedes", "BMW", "Toyota"], region: .eastern),
        
        EuropeanCountry(id: "UA", name: "Ucraina", nameLocal: "Україна", flag: "🇺🇦", language: "Ucraineana", languageCode: "uk", currency: "Hrivna", currencySymbol: "₴", currencyCode: "UAH", inspectionName: "ТО (Технічний огляд)", inspectionInterval: "2 ani", insuranceName: "ОСЦПВ", insuranceMinCost: "600-2000 UAH/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "AUA: 112", commonBrands: ["VW", "Skoda", "Renault", "Toyota", "Hyundai"], region: .eastern),
        
        EuropeanCountry(id: "MD", name: "Moldova", nameLocal: "Moldova", flag: "🇲🇩", language: "Romana", languageCode: "ro", currency: "Leu moldovenesc", currencySymbol: "L", currencyCode: "MDL", inspectionName: "Inspectia Tehnica", inspectionInterval: "2 ani", insuranceName: "RCA", insuranceMinCost: "800-2000 MDL/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 110, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "ACM: 901", commonBrands: ["VW", "Skoda", "Dacia", "Toyota", "Ford"], region: .eastern),
        
        EuropeanCountry(id: "RU", name: "Rusia", nameLocal: "Россия", flag: "🇷🇺", language: "Rusa", languageCode: "ru", currency: "Rubla", currencySymbol: "₽", currencyCode: "RUB", inspectionName: "ТО (Технический осмотр)", inspectionInterval: "1-2 ani", insuranceName: "ОСАГО", insuranceMinCost: "3000-15000 RUB/an", drivingSide: "dreapta", speedLimitUrban: 60, speedLimitRural: 90, speedLimitMotorway: 110, alcoholLimit: 0.3, emergencyNumber: "112", roadAssistance: "RAMT: 112", commonBrands: ["Lada", "Hyundai", "Kia", "VW", "Toyota", "Renault"], region: .eastern),
        
        EuropeanCountry(id: "BY", name: "Belarus", nameLocal: "Беларусь", flag: "🇧🇾", language: "Belarusa/Rusa", languageCode: "be", currency: "Rubla belarusa", currencySymbol: "Br", currencyCode: "BYN", inspectionName: "ТО (Тэхагляд)", inspectionInterval: "2 ani", insuranceName: "ОСАГО", insuranceMinCost: "50-200 BYN/an", drivingSide: "dreapta", speedLimitUrban: 60, speedLimitRural: 90, speedLimitMotorway: 120, alcoholLimit: 0.3, emergencyNumber: "112", roadAssistance: "BAAC: 112", commonBrands: ["VW", "Renault", "Geely", "Hyundai", "Lada"], region: .eastern),
        
        // Central Europe
        EuropeanCountry(id: "PL", name: "Polonia", nameLocal: "Polska", flag: "🇵🇱", language: "Poloneza", languageCode: "pl", currency: "Zlot polonez", currencySymbol: "zł", currencyCode: "PLN", inspectionName: "Przegląd techniczny", inspectionInterval: "1 an", insuranceName: "OC", insuranceMinCost: "400-1500 PLN/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 140, alcoholLimit: 0.2, emergencyNumber: "112", roadAssistance: "PZMot: 981", commonBrands: ["VW", "Skoda", "Toyota", "Opel", "Ford"], region: .central),
        
        EuropeanCountry(id: "CZ", name: "Cehia", nameLocal: "Česko", flag: "🇨🇿", language: "Ceha", languageCode: "cs", currency: "Coroana ceha", currencySymbol: "Kč", currencyCode: "CZK", inspectionName: "STK (Stanice technické kontroly)", inspectionInterval: "2 ani", insuranceName: "Povinné ručení", insuranceMinCost: "2000-5000 CZK/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "UAMK: 1230", commonBrands: ["Skoda", "VW", "Hyundai", "Ford", "Toyota"], region: .central),
        
        EuropeanCountry(id: "SK", name: "Slovacia", nameLocal: "Slovensko", flag: "🇸🇰", language: "Slovaca", languageCode: "sk", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "STK/EK", inspectionInterval: "2 ani", insuranceName: "PZP", insuranceMinCost: "50-200 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "SATC: 18124", commonBrands: ["Skoda", "VW", "Kia", "Hyundai", "Peugeot"], region: .central),
        
        EuropeanCountry(id: "HU", name: "Ungaria", nameLocal: "Magyarország", flag: "🇭🇺", language: "Maghiara", languageCode: "hu", currency: "Forint", currencySymbol: "Ft", currencyCode: "HUF", inspectionName: "Műszaki vizsga", inspectionInterval: "2 ani", insuranceName: "KGFB", insuranceMinCost: "20000-80000 HUF/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.0, emergencyNumber: "112", roadAssistance: "MAK: 188", commonBrands: ["Suzuki", "VW", "Opel", "Ford", "Skoda"], region: .central),
        
        EuropeanCountry(id: "AT", name: "Austria", nameLocal: "Österreich", flag: "🇦🇹", language: "Germana", languageCode: "de-AT", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "§57a Begutachtung (Pickerl)", inspectionInterval: "1 an (noi: 3 ani)", insuranceName: "Haftpflicht", insuranceMinCost: "300-800 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 100, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ÖAMTC: 120", commonBrands: ["VW", "Skoda", "BMW", "Audi", "Mercedes"], region: .central),
        
        EuropeanCountry(id: "CH", name: "Elvetia", nameLocal: "Schweiz/Suisse", flag: "🇨🇭", language: "Germana/Franceza/Italiana", languageCode: "de-CH", currency: "Franc elvetian", currencySymbol: "CHF", currencyCode: "CHF", inspectionName: "MFK (Motorfahrzeugkontrolle)", inspectionInterval: "Dupa 5 ani, apoi la 2-3 ani", insuranceName: "Haftpflicht", insuranceMinCost: "400-1200 CHF/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "TCS: 140", commonBrands: ["VW", "BMW", "Mercedes", "Audi", "Skoda"], region: .central),
        
        EuropeanCountry(id: "SI", name: "Slovenia", nameLocal: "Slovenija", flag: "🇸🇮", language: "Slovena", languageCode: "sl", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Tehnični pregled", inspectionInterval: "2 ani", insuranceName: "AO", insuranceMinCost: "200-500 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "AMZS: 1987", commonBrands: ["VW", "Renault", "Skoda", "BMW", "Audi"], region: .central),
        
        // Western Europe
        EuropeanCountry(id: "DE", name: "Germania", nameLocal: "Deutschland", flag: "🇩🇪", language: "Germana", languageCode: "de", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "TÜV/HU (Hauptuntersuchung)", inspectionInterval: "2 ani", insuranceName: "Kfz-Haftpflicht", insuranceMinCost: "200-800 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 100, speedLimitMotorway: 0, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ADAC: 222 222", commonBrands: ["VW", "BMW", "Mercedes", "Audi", "Opel", "Ford"], region: .western),
        
        EuropeanCountry(id: "FR", name: "Franta", nameLocal: "France", flag: "🇫🇷", language: "Franceza", languageCode: "fr", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Contrôle Technique", inspectionInterval: "2 ani", insuranceName: "Assurance RC", insuranceMinCost: "300-900 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "Automobile Club: 0800 08 92 22", commonBrands: ["Renault", "Peugeot", "Citroen", "VW", "Toyota"], region: .western),
        
        EuropeanCountry(id: "BE", name: "Belgia", nameLocal: "Belgique/België", flag: "🇧🇪", language: "Franceza/Olandeza/Germana", languageCode: "fr-BE", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Contrôle Technique / Technische Keuring", inspectionInterval: "1 an", insuranceName: "RC Auto", insuranceMinCost: "300-700 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 70, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "Touring: 070 344 777", commonBrands: ["VW", "BMW", "Peugeot", "Renault", "Mercedes"], region: .western),
        
        EuropeanCountry(id: "NL", name: "Olanda", nameLocal: "Nederland", flag: "🇳🇱", language: "Olandeza", languageCode: "nl", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "APK (Algemene Periodieke Keuring)", inspectionInterval: "1 an (dupa 3 ani)", insuranceName: "WA-verzekering", insuranceMinCost: "300-600 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 100, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ANWB: 088 269 2888", commonBrands: ["VW", "Kia", "Toyota", "Peugeot", "Opel"], region: .western),
        
        EuropeanCountry(id: "LU", name: "Luxemburg", nameLocal: "Luxembourg", flag: "🇱🇺", language: "Franceza/Germana/Luxemburgheza", languageCode: "lb", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Contrôle technique", inspectionInterval: "1 an (dupa 4 ani)", insuranceName: "RC Auto", insuranceMinCost: "300-700 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACL: 26000", commonBrands: ["VW", "BMW", "Mercedes", "Audi", "Toyota"], region: .western),
        
        EuropeanCountry(id: "GB", name: "Regatul Unit", nameLocal: "United Kingdom", flag: "🇬🇧", language: "Engleza", languageCode: "en", currency: "Lira sterlina", currencySymbol: "£", currencyCode: "GBP", inspectionName: "MOT Test", inspectionInterval: "1 an (dupa 3 ani)", insuranceName: "Motor Insurance", insuranceMinCost: "300-1000 GBP/an", drivingSide: "stanga", speedLimitUrban: 48, speedLimitRural: 96, speedLimitMotorway: 112, alcoholLimit: 0.8, emergencyNumber: "999/112", roadAssistance: "AA: 0800 887766", commonBrands: ["Ford", "VW", "BMW", "Mercedes", "Toyota", "Vauxhall"], region: .western),
        
        EuropeanCountry(id: "IE", name: "Irlanda", nameLocal: "Éire/Ireland", flag: "🇮🇪", language: "Engleza/Irlandeza", languageCode: "ga", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "NCT (National Car Test)", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Motor Insurance", insuranceMinCost: "400-1200 EUR/an", drivingSide: "stanga", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112/999", roadAssistance: "AA Ireland: 01 617 9999", commonBrands: ["VW", "Toyota", "Hyundai", "Ford", "Skoda"], region: .western),
        
        // Southern Europe
        EuropeanCountry(id: "IT", name: "Italia", nameLocal: "Italia", flag: "🇮🇹", language: "Italiana", languageCode: "it", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Revisione Auto", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "RC Auto", insuranceMinCost: "300-900 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACI: 803 116", commonBrands: ["Fiat", "VW", "Ford", "Toyota", "BMW", "Audi"], region: .southern),
        
        EuropeanCountry(id: "ES", name: "Spania", nameLocal: "España", flag: "🇪🇸", language: "Spaniola", languageCode: "es", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "ITV (Inspección Técnica de Vehículos)", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Seguro RC", insuranceMinCost: "200-600 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "RACE: 900 100 992", commonBrands: ["SEAT", "VW", "Renault", "Peugeot", "Toyota"], region: .southern),
        
        EuropeanCountry(id: "PT", name: "Portugalia", nameLocal: "Portugal", flag: "🇵🇹", language: "Portugheza", languageCode: "pt", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "IPO (Inspeção Periódica Obrigatória)", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Seguro Automóvel", insuranceMinCost: "200-500 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACP: 808 222 222", commonBrands: ["Renault", "Peugeot", "VW", "BMW", "Mercedes"], region: .southern),
        
        EuropeanCountry(id: "GR", name: "Grecia", nameLocal: "Ελλάδα", flag: "🇬🇷", language: "Greaca", languageCode: "el", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "ΚΤΕΟ (Κέντρο Τεχνικού Ελέγχου)", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Ασφάλεια RC", insuranceMinCost: "200-600 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ELPA: 10400", commonBrands: ["Toyota", "VW", "Hyundai", "Suzuki", "Fiat"], region: .southern),
        
        EuropeanCountry(id: "HR", name: "Croatia", nameLocal: "Hrvatska", flag: "🇭🇷", language: "Croata", languageCode: "hr", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Tehnički pregled", inspectionInterval: "2 ani", insuranceName: "AO osiguranje", insuranceMinCost: "150-400 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "HAK: 1987", commonBrands: ["VW", "Opel", "Renault", "Skoda", "Ford"], region: .southern),
        
        EuropeanCountry(id: "RS", name: "Serbia", nameLocal: "Србија", flag: "🇷🇸", language: "Sarba", languageCode: "sr", currency: "Dinar sarbesc", currencySymbol: "RSD", currencyCode: "RSD", inspectionName: "Технички преглед", inspectionInterval: "1 an", insuranceName: "Осигурање AO", insuranceMinCost: "8000-25000 RSD/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.3, emergencyNumber: "112", roadAssistance: "AMSS: 1987", commonBrands: ["VW", "Fiat", "Opel", "Skoda", "Peugeot"], region: .southern),
        
        EuropeanCountry(id: "BA", name: "Bosnia", nameLocal: "Bosna i Hercegovina", flag: "🇧🇦", language: "Bosniana", languageCode: "bs", currency: "Marca convertibila", currencySymbol: "KM", currencyCode: "BAM", inspectionName: "Tehnički pregled", inspectionInterval: "1 an", insuranceName: "AO osiguranje", insuranceMinCost: "150-400 KM/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 130, alcoholLimit: 0.3, emergencyNumber: "112", roadAssistance: "BIHAMK: 1282", commonBrands: ["VW", "Skoda", "Opel", "Mercedes", "BMW"], region: .southern),
        
        EuropeanCountry(id: "ME", name: "Muntenegru", nameLocal: "Crna Gora", flag: "🇲🇪", language: "Muntenegreana", languageCode: "me", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Tehnički pregled", inspectionInterval: "1 an", insuranceName: "AO osiguranje", insuranceMinCost: "60-200 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.3, emergencyNumber: "112", roadAssistance: "AMSCG: 19807", commonBrands: ["VW", "Mercedes", "Fiat", "Opel", "Skoda"], region: .southern),
        
        EuropeanCountry(id: "MK", name: "Macedonia de Nord", nameLocal: "Северна Македонија", flag: "🇲🇰", language: "Macedoneana", languageCode: "mk", currency: "Denar", currencySymbol: "ден", currencyCode: "MKD", inspectionName: "Технички преглед", inspectionInterval: "1 an", insuranceName: "АО осигурување", insuranceMinCost: "3000-10000 MKD/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "AMSM: 196", commonBrands: ["VW", "Opel", "Mercedes", "Skoda", "Fiat"], region: .southern),
        
        EuropeanCountry(id: "AL", name: "Albania", nameLocal: "Shqipëria", flag: "🇦🇱", language: "Albaneza", languageCode: "sq", currency: "Lek", currencySymbol: "L", currencyCode: "ALL", inspectionName: "Kontrolli Teknik", inspectionInterval: "1 an", insuranceName: "TPL", insuranceMinCost: "10000-30000 ALL/an", drivingSide: "dreapta", speedLimitUrban: 40, speedLimitRural: 80, speedLimitMotorway: 110, alcoholLimit: 0.1, emergencyNumber: "112", roadAssistance: "ACA: 112", commonBrands: ["Mercedes", "VW", "BMW", "Fiat", "Toyota"], region: .southern),
        
        EuropeanCountry(id: "XK", name: "Kosovo", nameLocal: "Kosova", flag: "🇽🇰", language: "Albaneza/Sarba", languageCode: "sq", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Kontrolli Teknik", inspectionInterval: "1 an", insuranceName: "TPL", insuranceMinCost: "50-150 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "AMRKS: 112", commonBrands: ["VW", "Mercedes", "BMW", "Opel", "Ford"], region: .southern),
        
        EuropeanCountry(id: "CY", name: "Cipru", nameLocal: "Κύπρος", flag: "🇨🇾", language: "Greaca/Turca", languageCode: "el", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "MOT Test", inspectionInterval: "1 an (dupa 4 ani)", insuranceName: "Motor Insurance", insuranceMinCost: "200-500 EUR/an", drivingSide: "stanga", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 100, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "CAA: 22313233", commonBrands: ["Toyota", "Nissan", "VW", "BMW", "Mercedes"], region: .southern),
        
        EuropeanCountry(id: "MT", name: "Malta", nameLocal: "Malta", flag: "🇲🇹", language: "Malteza/Engleza", languageCode: "mt", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "VRT (Vehicle Roadworthiness Test)", inspectionInterval: "1 an", insuranceName: "Motor Insurance", insuranceMinCost: "300-700 EUR/an", drivingSide: "stanga", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 80, alcoholLimit: 0.8, emergencyNumber: "112", roadAssistance: "Touring Club Malta", commonBrands: ["Toyota", "VW", "Ford", "BMW", "Mercedes"], region: .southern),
        
        EuropeanCountry(id: "TR", name: "Turcia", nameLocal: "Türkiye", flag: "🇹🇷", language: "Turca", languageCode: "tr", currency: "Lira turceasca", currencySymbol: "₺", currencyCode: "TRY", inspectionName: "Araç Muayene", inspectionInterval: "2 ani", insuranceName: "Trafik Sigortası", insuranceMinCost: "2000-8000 TRY/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "TTOK: 0212 282 8140", commonBrands: ["Fiat", "Renault", "VW", "Toyota", "Hyundai", "Ford"], region: .southern),
        
        // Northern Europe
        EuropeanCountry(id: "SE", name: "Suedia", nameLocal: "Sverige", flag: "🇸🇪", language: "Suedeza", languageCode: "sv", currency: "Coroana suedeza", currencySymbol: "kr", currencyCode: "SEK", inspectionName: "Besiktning", inspectionInterval: "1-2 ani", insuranceName: "Trafikförsäkring", insuranceMinCost: "2000-6000 SEK/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 70, speedLimitMotorway: 120, alcoholLimit: 0.2, emergencyNumber: "112", roadAssistance: "Assistancekåren: 020-912 912", commonBrands: ["Volvo", "VW", "Toyota", "Kia", "BMW"], region: .northern),
        
        EuropeanCountry(id: "NO", name: "Norvegia", nameLocal: "Norge", flag: "🇳🇴", language: "Norvegiana", languageCode: "no", currency: "Coroana norvegiana", currencySymbol: "kr", currencyCode: "NOK", inspectionName: "EU-kontroll/PKK", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Ansvarsforsikring", insuranceMinCost: "3000-8000 NOK/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 110, alcoholLimit: 0.2, emergencyNumber: "112", roadAssistance: "NAF: 08505", commonBrands: ["Tesla", "Toyota", "VW", "BMW", "Volvo"], region: .northern),
        
        EuropeanCountry(id: "DK", name: "Danemarca", nameLocal: "Danmark", flag: "🇩🇰", language: "Daneza", languageCode: "da", currency: "Coroana daneza", currencySymbol: "kr", currencyCode: "DKK", inspectionName: "Syn (Periodisk syn)", inspectionInterval: "2 ani (noi: 4 ani)", insuranceName: "Ansvarsforsikring", insuranceMinCost: "2000-5000 DKK/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 130, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "FDM: 70 13 30 40", commonBrands: ["VW", "Peugeot", "Toyota", "BMW", "Kia"], region: .northern),
        
        EuropeanCountry(id: "FI", name: "Finlanda", nameLocal: "Suomi", flag: "🇫🇮", language: "Finlandeza", languageCode: "fi", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Katsastus", inspectionInterval: "1 an (dupa 3 ani)", insuranceName: "Liikennevakuutus", insuranceMinCost: "200-600 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "AL: 0200 8080", commonBrands: ["Toyota", "VW", "Skoda", "BMW", "Mercedes"], region: .northern),
        
        EuropeanCountry(id: "IS", name: "Islanda", nameLocal: "Ísland", flag: "🇮🇸", language: "Islandeza", languageCode: "is", currency: "Coroana islandeza", currencySymbol: "kr", currencyCode: "ISK", inspectionName: "Skoðun", inspectionInterval: "1 an (dupa 4 ani)", insuranceName: "Ökutrygging", insuranceMinCost: "40000-100000 ISK/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 90, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "FIB: 112", commonBrands: ["Toyota", "VW", "Hyundai", "Kia", "Subaru"], region: .northern),
        
        EuropeanCountry(id: "EE", name: "Estonia", nameLocal: "Eesti", flag: "🇪🇪", language: "Estoniana", languageCode: "et", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Tehnoülevaatus", inspectionInterval: "2 ani", insuranceName: "Liikluskindlustus", insuranceMinCost: "100-400 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 110, alcoholLimit: 0.2, emergencyNumber: "112", roadAssistance: "EAKL: 1888", commonBrands: ["VW", "Toyota", "Skoda", "BMW", "Audi"], region: .northern),
        
        EuropeanCountry(id: "LV", name: "Letonia", nameLocal: "Latvija", flag: "🇱🇻", language: "Letona", languageCode: "lv", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Valsts tehniskā apskate", inspectionInterval: "1-2 ani", insuranceName: "OCTA", insuranceMinCost: "80-300 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 110, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "LAMB: 1888", commonBrands: ["VW", "BMW", "Audi", "Toyota", "Opel"], region: .northern),
        
        EuropeanCountry(id: "LT", name: "Lituania", nameLocal: "Lietuva", flag: "🇱🇹", language: "Lituaniana", languageCode: "lt", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Techninė apžiūra", inspectionInterval: "2 ani", insuranceName: "TPVCA", insuranceMinCost: "80-250 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 130, alcoholLimit: 0.4, emergencyNumber: "112", roadAssistance: "LAA: 8 700 55511", commonBrands: ["VW", "BMW", "Audi", "Toyota", "Opel"], region: .northern),
        
        // Additional countries
        EuropeanCountry(id: "LI", name: "Liechtenstein", nameLocal: "Liechtenstein", flag: "🇱🇮", language: "Germana", languageCode: "de", currency: "Franc elvetian", currencySymbol: "CHF", currencyCode: "CHF", inspectionName: "MFK", inspectionInterval: "2 ani", insuranceName: "Haftpflicht", insuranceMinCost: "400-1000 CHF/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 80, speedLimitMotorway: 120, alcoholLimit: 0.8, emergencyNumber: "112", roadAssistance: "TCS: 140", commonBrands: ["VW", "BMW", "Mercedes", "Audi", "Porsche"], region: .central),
        
        EuropeanCountry(id: "MC", name: "Monaco", nameLocal: "Monaco", flag: "🇲🇨", language: "Franceza", languageCode: "fr", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Contrôle Technique", inspectionInterval: "1 an", insuranceName: "Assurance RC", insuranceMinCost: "500-2000 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 50, speedLimitMotorway: 50, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACM", commonBrands: ["Ferrari", "Mercedes", "BMW", "Porsche", "Bentley"], region: .western),
        
        EuropeanCountry(id: "AD", name: "Andorra", nameLocal: "Andorra", flag: "🇦🇩", language: "Catalana", languageCode: "ca", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "ITV", inspectionInterval: "2 ani", insuranceName: "Assegurança RC", insuranceMinCost: "200-500 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 90, speedLimitMotorway: 90, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACA: 803 400", commonBrands: ["SEAT", "Renault", "Peugeot", "VW", "BMW"], region: .southern),
        
        EuropeanCountry(id: "SM", name: "San Marino", nameLocal: "San Marino", flag: "🇸🇲", language: "Italiana", languageCode: "it", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Revisione", inspectionInterval: "2 ani", insuranceName: "RC Auto", insuranceMinCost: "200-500 EUR/an", drivingSide: "dreapta", speedLimitUrban: 50, speedLimitRural: 70, speedLimitMotorway: 70, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACS", commonBrands: ["Fiat", "VW", "BMW", "Mercedes", "Audi"], region: .southern),
        
        EuropeanCountry(id: "VA", name: "Vatican", nameLocal: "Città del Vaticano", flag: "🇻🇦", language: "Italiana", languageCode: "it", currency: "Euro", currencySymbol: "€", currencyCode: "EUR", inspectionName: "Revisione (Italia)", inspectionInterval: "2 ani", insuranceName: "RC Auto", insuranceMinCost: "200-500 EUR/an", drivingSide: "dreapta", speedLimitUrban: 30, speedLimitRural: 30, speedLimitMotorway: 30, alcoholLimit: 0.5, emergencyNumber: "112", roadAssistance: "ACI Italia", commonBrands: ["VW", "Fiat", "Opel"], region: .southern),
    ]
    
    // MARK: - Helper methods
    static func country(for code: String) -> EuropeanCountry? {
        allCountries.first { $0.id == code }
    }
    
    static var countryNames: [String: String] {
        Dictionary(uniqueKeysWithValues: allCountries.map { ($0.id, $0.name) })
    }
    
    static func countriesForRegion(_ region: EURegion) -> [EuropeanCountry] {
        allCountries.filter { $0.region == region }
    }
}
