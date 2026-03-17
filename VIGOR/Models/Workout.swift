import Foundation
import SwiftUI

// MARK: - Feature Data
class FeatureData {
    
    // MARK: - Romantic Quotes
    static let quotes: [RomanticQuote] = [
        RomanticQuote(text: "Iubirea nu se masoara in timp, ci in momente.", author: "Anonim", category: .love),
        RomanticQuote(text: "Esti tot ce am visat vreodata si tot ce nu stiam ca am nevoie.", author: "Anonim", category: .romance),
        RomanticQuote(text: "In bratele tale am gasit casa mea.", author: "Anonim", category: .love),
        RomanticQuote(text: "Cel mai frumos lucru pe care il pot face ochii mei este sa te priveasca.", author: "Anonim", category: .romance),
        RomanticQuote(text: "Iubirea adevarata nu are final fericit, pentru ca iubirea adevarata nu se termina niciodata.", author: "Anonim", category: .wisdom),
        RomanticQuote(text: "Nu esti doar iubirea vietii mele, esti viata iubirii mele.", author: "Anonim", category: .passion),
        RomanticQuote(text: "Fiecare poveste de iubire este frumoasa, dar a noastra este preferata mea.", author: "Anonim", category: .romance),
        RomanticQuote(text: "Iubirea este compusa dintr-un singur suflet care locuieste in doua corpuri.", author: "Aristotel", category: .wisdom),
        RomanticQuote(text: "Unde exista iubire, exista viata.", author: "Mahatma Gandhi", category: .wisdom),
        RomanticQuote(text: "Iubirea nu face lumea sa se invarta. Iubirea face ca plimbarea sa merite.", author: "Franklin P. Jones", category: .humor),
        RomanticQuote(text: "A iubi si a fi iubit este a simti soarele din ambele parti.", author: "David Viscott", category: .love),
        RomanticQuote(text: "Cel mai bun lucru la care sa te tii in viata este unul de celalalt.", author: "Audrey Hepburn", category: .wisdom),
        RomanticQuote(text: "Pasiunea face lumea sa se invarta intr-un mod mai frumos.", author: "Anonim", category: .passion),
        RomanticQuote(text: "Inima care iubeste este mereu tanara.", author: "Proverb grecesc", category: .love),
        RomanticQuote(text: "Iubirea este prietenia aprinsa.", author: "Jeremy Taylor", category: .passion),
        RomanticQuote(text: "Atingerea ta este promisiunea mea de fericire.", author: "Anonim", category: .passion),
        RomanticQuote(text: "Casatoria fericita este o conversatie lunga care pare intotdeauna prea scurta.", author: "Andre Maurois", category: .humor),
        RomanticQuote(text: "Nu am nevoie de paradis pentru ca te-am gasit pe tine.", author: "Anonim", category: .romance),
        RomanticQuote(text: "Iubirea este cel mai frumos vis si cel mai real adevar.", author: "Anonim", category: .love),
        RomanticQuote(text: "Viata fara iubire este ca un copac fara flori.", author: "Khalil Gibran", category: .wisdom),
    ]
    
    // MARK: - Date Night Ideas
    static let dateNightIdeas: [DateNightIdea] = [
        DateNightIdea(title: "Cina Romantica Acasa", description: "Gatiti impreuna o reteta noua, aprindeti lumanari si puneti muzica.", icon: "🕯", category: "Acasa", budget: "Mic", duration: "2-3 ore"),
        DateNightIdea(title: "Picnic sub Stele", description: "Pregatiti un cos de picnic si mergeti intr-un loc cu vedere la stele.", icon: "⭐", category: "Afara", budget: "Mic", duration: "2-3 ore"),
        DateNightIdea(title: "Seara de Film", description: "Alegeti 2-3 filme romantice, faceti popcorn si cuibariti-va.", icon: "🎬", category: "Acasa", budget: "Mic", duration: "3-4 ore"),
        DateNightIdea(title: "Curs de Dans", description: "Invatati impreuna un dans nou - salsa, tango sau bachata.", icon: "💃", category: "Activitate", budget: "Mediu", duration: "1-2 ore"),
        DateNightIdea(title: "Spa Acasa", description: "Creati o experienta de spa cu masti, masaj si baie cu spuma.", icon: "🧖", category: "Acasa", budget: "Mic", duration: "2-3 ore"),
        DateNightIdea(title: "Degustare de Vinuri", description: "Cumparati 3-4 vinuri noi si faceti o degustare cu branzeturi.", icon: "🍷", category: "Acasa", budget: "Mediu", duration: "2 ore"),
        DateNightIdea(title: "Aventura Culinara", description: "Incercati un restaurant cu o bucatarie pe care nu ati mai incercat-o.", icon: "🍽", category: "Oras", budget: "Mare", duration: "2-3 ore"),
        DateNightIdea(title: "Plimbare la Apus", description: "Mergeti la o plimbare romantica si urmariti apusul impreuna.", icon: "🌅", category: "Afara", budget: "Gratis", duration: "1-2 ore"),
        DateNightIdea(title: "Jocuri de Societate", description: "Alegeti jocuri de societate pentru doi si competiti amical.", icon: "🎲", category: "Acasa", budget: "Mic", duration: "2-3 ore"),
        DateNightIdea(title: "Atelier Creativ", description: "Pictati, desenati sau faceti ceramica impreuna.", icon: "🎨", category: "Activitate", budget: "Mediu", duration: "2-3 ore"),
        DateNightIdea(title: "Karaoke Privat", description: "Inchiriati o camera de karaoke sau cantati acasa.", icon: "🎤", category: "Activitate", budget: "Mediu", duration: "2 ore"),
        DateNightIdea(title: "Excursie Spontana", description: "Alegeti un oras apropiat si faceti o excursie de o zi.", icon: "🚗", category: "Aventura", budget: "Mediu", duration: "O zi"),
        DateNightIdea(title: "Fotografie de Cuplu", description: "Faceti o sedinta foto impreuna in locuri frumoase.", icon: "📸", category: "Activitate", budget: "Mic", duration: "2 ore"),
        DateNightIdea(title: "Mic Dejun in Pat", description: "Pregatiti un mic dejun special si serviti-l in pat.", icon: "🥐", category: "Acasa", budget: "Mic", duration: "1-2 ore"),
        DateNightIdea(title: "Concert sau Spectacol", description: "Mergeti la un concert, teatru sau spectacol de comedie.", icon: "🎵", category: "Oras", budget: "Mare", duration: "3-4 ore"),
    ]
    
    // MARK: - Bucket List Items
    static let defaultBucketList: [BucketListItem] = [
        BucketListItem(title: "Urmariti rasaritul impreuna", description: "Treziti-va devreme si urmariti rasaritul dintr-un loc special.", icon: "🌅", category: "Romantic"),
        BucketListItem(title: "Scrieti scrisori de dragoste", description: "Scrieti fiecare o scrisoare si cititi-le impreuna.", icon: "💌", category: "Romantic"),
        BucketListItem(title: "Gatiti o reteta complicata", description: "Alegeti o reteta provocatoare si gatiti-o impreuna.", icon: "👨‍🍳", category: "Acasa"),
        BucketListItem(title: "Dansati in ploaie", description: "Data viitoare cand ploua, iesiti si dansati.", icon: "🌧", category: "Aventura"),
        BucketListItem(title: "Faceti un road trip", description: "Planificati o calatorie cu masina fara destinatie fixa.", icon: "🚗", category: "Aventura"),
        BucketListItem(title: "Invatati ceva nou impreuna", description: "Alegeti un hobby nou si invatati-l impreuna.", icon: "📚", category: "Dezvoltare"),
        BucketListItem(title: "Construiti un fort din perne", description: "Construiti un fort din perne si uitati-va la filme.", icon: "🏰", category: "Acasa"),
        BucketListItem(title: "Mergeti la un festival", description: "Participati la un festival de muzica sau mancare.", icon: "🎪", category: "Aventura"),
        BucketListItem(title: "Faceti voluntariat impreuna", description: "Gasiti o cauza care va pasioneaza si ajutati.", icon: "🤝", category: "Dezvoltare"),
        BucketListItem(title: "Creati o capsula a timpului", description: "Puneti amintiri intr-o cutie si deschideti-o peste un an.", icon: "📦", category: "Romantic"),
        BucketListItem(title: "Masaj de cuplu profesional", description: "Mergeti la un salon pentru un masaj de cuplu.", icon: "💆", category: "Relaxare"),
        BucketListItem(title: "Plantati un copac impreuna", description: "Plantati un copac care sa creasca odata cu relatia.", icon: "🌳", category: "Romantic"),
        BucketListItem(title: "Faceti o baie la miezul noptii", description: "Pregatiti o baie romantica la ore tarzii.", icon: "🛁", category: "Romantic"),
        BucketListItem(title: "Incercati 10 pozitii noi", description: "Explorati impreuna 10 pozitii din aplicatie.", icon: "⭐", category: "Intim"),
        BucketListItem(title: "Petreceti o zi fara tehnologie", description: "O zi intreaga fara telefoane sau laptopuri.", icon: "📵", category: "Dezvoltare"),
    ]
    
    // MARK: - Achievements
    static let achievements: [Achievement] = [
        Achievement(id: "explorer", name: "Explorator", description: "Ai vizualizat 10 pozitii diferite", icon: "🗺", requirement: "10 pozitii vizualizate", color1: "FF6B8A", color2: "C44569"),
        Achievement(id: "collector", name: "Colectionar", description: "Ai adaugat 5 pozitii la favorite", icon: "⭐", requirement: "5 favorite", color1: "FFB74D", color2: "FF8F00"),
        Achievement(id: "adventurer", name: "Aventurier", description: "Ai explorat toate categoriile", icon: "🧭", requirement: "Toate categoriile", color1: "A55EEA", color2: "8854D0"),
        Achievement(id: "gamer", name: "Jucator", description: "Ai jucat toate cele 6 jocuri", icon: "🎮", requirement: "6 jocuri jucate", color1: "4FC3F7", color2: "0288D1"),
        Achievement(id: "romantic", name: "Romantic", description: "Ai citit 20 de citate romantice", icon: "💕", requirement: "20 citate citite", color1: "FF6B8A", color2: "FC5C7D"),
        Achievement(id: "planner", name: "Planificator", description: "Ai generat 5 idei de intalniri", icon: "📅", requirement: "5 date nights", color1: "66BB6A", color2: "43A047"),
        Achievement(id: "mood_master", name: "Maestru Emotional", description: "Ai inregistrat starea 7 zile la rand", icon: "📊", requirement: "7 zile consecutive", color1: "FF6348", color2: "EE5A24"),
        Achievement(id: "bucket_starter", name: "Incepator de Aventuri", description: "Ai completat 3 activitati din bucket list", icon: "✅", requirement: "3 activitati", color1: "26C6DA", color2: "00ACC1"),
        Achievement(id: "quiz_master", name: "Maestru Quiz", description: "Ai obtinut scor perfect la quiz", icon: "🏆", requirement: "10/10 la quiz", color1: "FFD54F", color2: "FFC107"),
        Achievement(id: "love_expert", name: "Expert in Iubire", description: "Ai completat testul limbajului iubirii", icon: "💝", requirement: "Test completat", color1: "EC407A", color2: "C2185B"),
    ]
    
    // MARK: - Love Language Questions
    static let loveLanguageQuestions: [LoveLanguageQuestion] = [
        LoveLanguageQuestion(optionA: "Partenerul imi spune cat de mult ma apreciaza", optionB: "Partenerul ma imbratiseaza strans", languageA: .wordsOfAffirmation, languageB: .physicalTouch),
        LoveLanguageQuestion(optionA: "Petrecem timp de calitate impreuna fara distractii", optionB: "Partenerul imi face un cadou neasteptat", languageA: .qualityTime, languageB: .receivingGifts),
        LoveLanguageQuestion(optionA: "Partenerul ma ajuta cu treburile casnice", optionB: "Partenerul imi spune ca ma iubeste", languageA: .actsOfService, languageB: .wordsOfAffirmation),
        LoveLanguageQuestion(optionA: "Partenerul imi tine mana in public", optionB: "Partenerul imi pregateste cina", languageA: .physicalTouch, languageB: .actsOfService),
        LoveLanguageQuestion(optionA: "Primesc un cadou gandit cu atentie", optionB: "Avem o conversatie lunga si profunda", languageA: .receivingGifts, languageB: .qualityTime),
        LoveLanguageQuestion(optionA: "Partenerul imi scrie un mesaj frumos", optionB: "Partenerul imi face un masaj", languageA: .wordsOfAffirmation, languageB: .physicalTouch),
        LoveLanguageQuestion(optionA: "Facem o activitate impreuna", optionB: "Partenerul imi repara ceva in casa", languageA: .qualityTime, languageB: .actsOfService),
        LoveLanguageQuestion(optionA: "Partenerul imi aduce flori", optionB: "Partenerul ma complimenteaza", languageA: .receivingGifts, languageB: .wordsOfAffirmation),
        LoveLanguageQuestion(optionA: "Stam imbratisati pe canapea", optionB: "Partenerul imi planifica o surpriza", languageA: .physicalTouch, languageB: .receivingGifts),
        LoveLanguageQuestion(optionA: "Partenerul gateste mancarea mea preferata", optionB: "Mergem intr-o vacanta doar noi doi", languageA: .actsOfService, languageB: .qualityTime),
        LoveLanguageQuestion(optionA: "Partenerul imi spune ce apreciaza la mine", optionB: "Partenerul imi face un cadou de aniversare special", languageA: .wordsOfAffirmation, languageB: .receivingGifts),
        LoveLanguageQuestion(optionA: "Ne tinem de mana la plimbare", optionB: "Partenerul se ofera sa ma ajute cu un proiect", languageA: .physicalTouch, languageB: .actsOfService),
        LoveLanguageQuestion(optionA: "Avem o seara dedicata doar noua", optionB: "Partenerul ma saruta cand plec de acasa", languageA: .qualityTime, languageB: .physicalTouch),
        LoveLanguageQuestion(optionA: "Partenerul imi curata masina", optionB: "Partenerul imi cumpara cartea pe care o vreau", languageA: .actsOfService, languageB: .receivingGifts),
        LoveLanguageQuestion(optionA: "Partenerul imi lasa un bilet de dragoste", optionB: "Petrecem o dupa-amiaza fara telefoane", languageA: .wordsOfAffirmation, languageB: .qualityTime),
    ]
    
    // MARK: - Compatibility Questions
    static let compatibilityQuestions: [CompatibilityQuestion] = [
        CompatibilityQuestion(question: "Cum preferati sa petreceti o seara libera?", options: ["Acasa cu un film", "La restaurant", "La o petrecere", "In natura"]),
        CompatibilityQuestion(question: "Ce este cel mai important intr-o relatie?", options: ["Comunicarea", "Pasiunea", "Increderea", "Umorul"]),
        CompatibilityQuestion(question: "Cum va exprimati iubirea?", options: ["Prin cuvinte", "Prin gesturi", "Prin cadouri", "Prin atingere"]),
        CompatibilityQuestion(question: "Cat de des aveti nevoie de timp doar pentru voi?", options: ["Zilnic", "Saptamanal", "Lunar", "Rar"]),
        CompatibilityQuestion(question: "Cum gestionati conflictele?", options: ["Discutam imediat", "Ne luam o pauza", "Evitam conflictul", "Cautam compromisul"]),
        CompatibilityQuestion(question: "Ce tip de vacanta preferati?", options: ["Plaja si relaxare", "Aventura si explorare", "Cultura si muzee", "Natura si camping"]),
        CompatibilityQuestion(question: "Cat de important este aspectul fizic?", options: ["Foarte important", "Important", "Moderat", "Nu prea important"]),
        CompatibilityQuestion(question: "Cum vedeti viitorul impreuna?", options: ["Casatorie si copii", "Parteneriat pe termen lung", "Traim prezentul", "Nu ne gandim la asta"]),
        CompatibilityQuestion(question: "Ce va face sa radeti impreuna?", options: ["Glume si umor", "Situatii amuzante", "Filme de comedie", "Amintiri comune"]),
        CompatibilityQuestion(question: "Cat de deschisi sunteti la lucruri noi in dormitor?", options: ["Foarte deschisi", "Destul de deschisi", "Precauti dar curiosi", "Preferem ce stim"]),
    ]
    
    // MARK: - Massage Presets
    static let massagePresets: [MassagePreset] = [
        MassagePreset(name: "Masaj Rapid", duration: 5, icon: "⚡", description: "Un masaj scurt si energizant pentru umeri si gat.", color1: "FF6B8A", color2: "C44569"),
        MassagePreset(name: "Masaj Relaxant", duration: 15, icon: "🧘", description: "Masaj complet de relaxare pentru spate si umeri.", color1: "4FC3F7", color2: "0288D1"),
        MassagePreset(name: "Masaj Senzual", duration: 20, icon: "💕", description: "Masaj senzual cu uleiuri esentiale si lumina de lumanari.", color1: "A55EEA", color2: "8854D0"),
        MassagePreset(name: "Masaj Complet", duration: 30, icon: "🤲", description: "Masaj complet al corpului, de la cap pana la picioare.", color1: "FF6348", color2: "EE5A24"),
        MassagePreset(name: "Masaj de Picioare", duration: 10, icon: "🦶", description: "Masaj reflexoterapeutic pentru picioare.", color1: "66BB6A", color2: "43A047"),
        MassagePreset(name: "Masaj Tantric", duration: 45, icon: "🕉", description: "Masaj tantric lung cu respiratie sincronizata.", color1: "FFB74D", color2: "FF8F00"),
    ]
    
    // MARK: - Playlist Recommendations
    static let playlists: [PlaylistRecommendation] = [
        PlaylistRecommendation(name: "Seara Romantica", description: "Melodii perfecte pentru o seara intima.", icon: "🕯", mood: "Romantic", songs: [
            SongSuggestion(title: "All of Me", artist: "John Legend"),
            SongSuggestion(title: "Perfect", artist: "Ed Sheeran"),
            SongSuggestion(title: "Thinking Out Loud", artist: "Ed Sheeran"),
            SongSuggestion(title: "At Last", artist: "Etta James"),
            SongSuggestion(title: "Make You Feel My Love", artist: "Adele"),
        ], color1: "FF6B8A", color2: "C44569"),
        PlaylistRecommendation(name: "Pasiune Intensa", description: "Ritmuri care aprind flacara pasiunii.", icon: "🔥", mood: "Pasional", songs: [
            SongSuggestion(title: "Earned It", artist: "The Weeknd"),
            SongSuggestion(title: "Wicked Games", artist: "The Weeknd"),
            SongSuggestion(title: "Skin", artist: "Rihanna"),
            SongSuggestion(title: "Drunk in Love", artist: "Beyonce"),
            SongSuggestion(title: "Pony", artist: "Ginuwine"),
        ], color1: "FF6348", color2: "EE5A24"),
        PlaylistRecommendation(name: "Chill & Relax", description: "Sunete ambientale pentru relaxare.", icon: "🌊", mood: "Relaxant", songs: [
            SongSuggestion(title: "Sunset Lover", artist: "Petit Biscuit"),
            SongSuggestion(title: "Breathe Me", artist: "Sia"),
            SongSuggestion(title: "Skinny Love", artist: "Bon Iver"),
            SongSuggestion(title: "Cherry Wine", artist: "Hozier"),
            SongSuggestion(title: "Falling", artist: "Harry Styles"),
        ], color1: "4FC3F7", color2: "0288D1"),
        PlaylistRecommendation(name: "Dans Senzual", description: "Ritmuri latine pentru dans in doi.", icon: "💃", mood: "Energic", songs: [
            SongSuggestion(title: "Despacito", artist: "Luis Fonsi"),
            SongSuggestion(title: "Bailando", artist: "Enrique Iglesias"),
            SongSuggestion(title: "Havana", artist: "Camila Cabello"),
            SongSuggestion(title: "Senorita", artist: "Shawn Mendes & Camila Cabello"),
            SongSuggestion(title: "Shape of You", artist: "Ed Sheeran"),
        ], color1: "A55EEA", color2: "8854D0"),
        PlaylistRecommendation(name: "Dimineata Lenta", description: "Melodii blande pentru o dimineata in doi.", icon: "☀", mood: "Calm", songs: [
            SongSuggestion(title: "Sunday Morning", artist: "Maroon 5"),
            SongSuggestion(title: "Banana Pancakes", artist: "Jack Johnson"),
            SongSuggestion(title: "Better Together", artist: "Jack Johnson"),
            SongSuggestion(title: "I'm Yours", artist: "Jason Mraz"),
            SongSuggestion(title: "Lucky", artist: "Jason Mraz & Colbie Caillat"),
        ], color1: "FFB74D", color2: "FF8F00"),
    ]
    
    // MARK: - Discover Features
    static let discoverFeatures: [DiscoverFeature] = [
        DiscoverFeature(id: "quotes", name: "Citate Romantice", icon: "💬", description: "20 citate despre iubire si pasiune", color1: "FF6B8A", color2: "C44569"),
        DiscoverFeature(id: "mood", name: "Mood Tracker", icon: "📊", description: "Urmareste starea de spirit zilnic", color1: "A55EEA", color2: "8854D0"),
        DiscoverFeature(id: "datenight", name: "Date Night", icon: "🌙", description: "15 idei pentru seri romantice", color1: "4FC3F7", color2: "0288D1"),
        DiscoverFeature(id: "massage", name: "Timer Masaj", icon: "🤲", description: "6 preseturi de masaj cu timer", color1: "FF6348", color2: "EE5A24"),
        DiscoverFeature(id: "bucketlist", name: "Bucket List", icon: "📋", description: "15 activitati de facut impreuna", color1: "66BB6A", color2: "43A047"),
        DiscoverFeature(id: "playlists", name: "Playlisturi", icon: "🎵", description: "5 playlisturi tematice cu melodii", color1: "FFB74D", color2: "FF8F00"),
        DiscoverFeature(id: "lovelanguage", name: "Limbajul Iubirii", icon: "💝", description: "Descopera cum iubesti si esti iubit", color1: "EC407A", color2: "C2185B"),
        DiscoverFeature(id: "compatibility", name: "Compatibilitate", icon: "💑", description: "Test de compatibilitate pentru cuplu", color1: "26C6DA", color2: "00ACC1"),
        DiscoverFeature(id: "achievements", name: "Realizari", icon: "🏆", description: "10 badge-uri de deblocat", color1: "FFD54F", color2: "FFC107"),
    ]
}
