import Foundation
import SwiftUI

// MARK: - Game Data
struct GameData {
    
    // MARK: - Available Games
    static let allGames: [CoupleGame] = [
        CoupleGame(id: "truth-or-dare", name: "Adevar sau Provocare", icon: "flame.fill", description: "Jocul clasic de cuplu cu intrebari intime si provocari indraznete.", color1: "FF6B8A", color2: "C44569", minPlayers: 2),
        CoupleGame(id: "would-you-rather", name: "Ce Ai Prefera", icon: "arrow.left.arrow.right", description: "Alege intre doua scenarii romantice sau picante.", color1: "A55EEA", color2: "8854D0", minPlayers: 2),
        CoupleGame(id: "dice-game", name: "Zarurile Pasiunii", icon: "dice.fill", description: "Arunca zarurile si descopera actiuni romantice aleatorii.", color1: "FF6348", color2: "EE5A24", minPlayers: 2),
        CoupleGame(id: "quiz", name: "Cat de Bine Ma Cunosti?", icon: "questionmark.circle.fill", description: "Testeaza cat de bine va cunoasteti partenerul.", color1: "4FC3F7", color2: "0288D1", minPlayers: 2),
        CoupleGame(id: "challenges", name: "Provocari de Cuplu", icon: "star.fill", description: "Provocari zilnice pentru a mentine flacara aprinsa.", color1: "FFB74D", color2: "FF8F00", minPlayers: 2),
        CoupleGame(id: "position-roulette", name: "Ruleta Pozitiilor", icon: "arrow.triangle.2.circlepath", description: "Lasa soarta sa aleaga pozitia urmatoare pentru voi!", color1: "FC5C7D", color2: "6A82FB", minPlayers: 2),
    ]
    
    // MARK: - Truth or Dare Cards
    static let truthCards: [TruthOrDareCard] = [
        TruthOrDareCard(type: .truth, text: "Care a fost cel mai romantic moment al nostru impreuna?", intensity: 1),
        TruthOrDareCard(type: .truth, text: "Ce iti place cel mai mult la mine fizic?", intensity: 2),
        TruthOrDareCard(type: .truth, text: "Care este fantazia ta secreta?", intensity: 3),
        TruthOrDareCard(type: .truth, text: "Unde ai vrea sa facem dragoste cel mai mult?", intensity: 4),
        TruthOrDareCard(type: .truth, text: "Ce pozitie iti place cel mai mult si de ce?", intensity: 4),
        TruthOrDareCard(type: .truth, text: "Care este cea mai indrazneata dorinta pe care nu mi-ai spus-o?", intensity: 5),
        TruthOrDareCard(type: .truth, text: "Cand te-ai simtit cel mai atras de mine?", intensity: 2),
        TruthOrDareCard(type: .truth, text: "Ce as putea face diferit in dormitor?", intensity: 4),
        TruthOrDareCard(type: .truth, text: "Care a fost prima ta impresie despre mine?", intensity: 1),
        TruthOrDareCard(type: .truth, text: "Daca ai putea planifica o seara romantica perfecta, cum ar fi?", intensity: 2),
        TruthOrDareCard(type: .truth, text: "Ce te excita cel mai mult?", intensity: 4),
        TruthOrDareCard(type: .truth, text: "Care este zona ta erogena preferata?", intensity: 3),
        TruthOrDareCard(type: .truth, text: "Ai incercat vreodata ceva in pat de care ti-a fost rusine sa vorbesti?", intensity: 5),
        TruthOrDareCard(type: .truth, text: "Ce compliment iti face cea mai mare placere?", intensity: 1),
        TruthOrDareCard(type: .truth, text: "Daca am fi singuri pe o insula, ce am face prima data?", intensity: 3),
        TruthOrDareCard(type: .truth, text: "Ce tip de atingere te relaxeaza cel mai mult?", intensity: 2),
        TruthOrDareCard(type: .truth, text: "Ai vrea sa incercam ceva nou in dormitor? Ce anume?", intensity: 4),
        TruthOrDareCard(type: .truth, text: "Care este amintirea ta favorita despre noi?", intensity: 1),
        TruthOrDareCard(type: .truth, text: "Ce iti trece prin minte cand ma vezi dezbracat/a?", intensity: 3),
        TruthOrDareCard(type: .truth, text: "Unde este cel mai indraznet loc in care ai vrea sa fim intimi?", intensity: 5),
    ]
    
    static let dareCards: [TruthOrDareCard] = [
        TruthOrDareCard(type: .dare, text: "Saruta-ti partenerul timp de 30 de secunde fara sa te opresti.", intensity: 1),
        TruthOrDareCard(type: .dare, text: "Fa-i partenerului un masaj de 2 minute la umeri.", intensity: 1),
        TruthOrDareCard(type: .dare, text: "Sopteste ceva seducator la urechea partenerului.", intensity: 2),
        TruthOrDareCard(type: .dare, text: "Danseaza provocator pentru partenerul tau timp de 1 minut.", intensity: 3),
        TruthOrDareCard(type: .dare, text: "Scoate o piesa vestimentara la alegerea partenerului.", intensity: 3),
        TruthOrDareCard(type: .dare, text: "Fa-i partenerului un masaj senzual pe picioare.", intensity: 2),
        TruthOrDareCard(type: .dare, text: "Imita scena romantica preferata dintr-un film.", intensity: 2),
        TruthOrDareCard(type: .dare, text: "Mananca ceva de pe corpul partenerului.", intensity: 4),
        TruthOrDareCard(type: .dare, text: "Leaga-ti partenerul la ochi si saruta-l in 5 locuri diferite.", intensity: 4),
        TruthOrDareCard(type: .dare, text: "Pozeaza seducator pentru partenerul tau.", intensity: 3),
        TruthOrDareCard(type: .dare, text: "Fa-i partenerului un strip-tease de 1 minut.", intensity: 5),
        TruthOrDareCard(type: .dare, text: "Tine-ti partenerul in brate si cara-l prin camera.", intensity: 2),
        TruthOrDareCard(type: .dare, text: "Spune-i partenerului 5 lucruri pe care le iubesti la el/ea.", intensity: 1),
        TruthOrDareCard(type: .dare, text: "Saruta fiecare deget al partenerului tau.", intensity: 2),
        TruthOrDareCard(type: .dare, text: "Fa o declaratie de dragoste improvizata.", intensity: 1),
        TruthOrDareCard(type: .dare, text: "Masaj cu cuburi de gheata pe spatele partenerului.", intensity: 4),
        TruthOrDareCard(type: .dare, text: "Atingeti-va doar cu varful degetelor timp de 1 minut.", intensity: 3),
        TruthOrDareCard(type: .dare, text: "Reproduce sunetul cel mai seducator pe care il poti face.", intensity: 3),
        TruthOrDareCard(type: .dare, text: "Alege o pozitie din aplicatie si demonstreaz-o.", intensity: 5),
        TruthOrDareCard(type: .dare, text: "Fa-i partenerului cel mai lung sarut de pe gat.", intensity: 4),
    ]
    
    // MARK: - Would You Rather
    static let wouldYouRather: [WouldYouRatherCard] = [
        WouldYouRatherCard(optionA: "O seara romantica la restaurant", optionB: "O seara intima acasa cu lumanari", category: "Romantic"),
        WouldYouRatherCard(optionA: "Un masaj de o ora", optionB: "O baie fierbinte impreuna", category: "Relaxare"),
        WouldYouRatherCard(optionA: "Sex spontan intr-un loc neobisnuit", optionB: "O noapte lunga si planificata in dormitor", category: "Aventura"),
        WouldYouRatherCard(optionA: "Sa fiti legati la ochi", optionB: "Sa fiti legati de pat", category: "Indraznet"),
        WouldYouRatherCard(optionA: "Dimineata lenta in pat", optionB: "Seara tarzie cu vin si muzica", category: "Timp"),
        WouldYouRatherCard(optionA: "Un weekend la munte, doar voi doi", optionB: "Un weekend la mare, doar voi doi", category: "Destinatie"),
        WouldYouRatherCard(optionA: "Sa primesti un masaj senzual", optionB: "Sa oferi un masaj senzual", category: "Atingere"),
        WouldYouRatherCard(optionA: "Sa experimentati role-play", optionB: "Sa experimentati jucarii noi", category: "Indraznet"),
        WouldYouRatherCard(optionA: "Sa va spuneti fanteziile", optionB: "Sa le puneti in practica fara sa vorbiti", category: "Comunicare"),
        WouldYouRatherCard(optionA: "Lumina aprinsa", optionB: "Intuneric total", category: "Atmosfera"),
        WouldYouRatherCard(optionA: "Muzica romantica in fundal", optionB: "Liniste completa", category: "Atmosfera"),
        WouldYouRatherCard(optionA: "Sa incercati 3 pozitii noi intr-o seara", optionB: "Sa perfectionati pozitia voastra preferata", category: "Explorare"),
        WouldYouRatherCard(optionA: "Mic dejun in pat dupa o noapte de pasiune", optionB: "Cina romantica inainte de o noapte de pasiune", category: "Romantic"),
        WouldYouRatherCard(optionA: "Sa scrieti scrisori de dragoste", optionB: "Sa va trimiteti mesaje provocatoare", category: "Comunicare"),
        WouldYouRatherCard(optionA: "Vacanta la Paris, orasul iubirii", optionB: "Vacanta pe o insula privata tropicala", category: "Destinatie"),
    ]
    
    // MARK: - Dice Actions
    static let diceActions: [DiceAction] = [
        DiceAction(action: "Saruta", bodyPart: "buzele", duration: "30 secunde", icon: "mouth.fill"),
        DiceAction(action: "Maseaza", bodyPart: "umerii", duration: "2 minute", icon: "hand.raised.fill"),
        DiceAction(action: "Saruta", bodyPart: "gatul", duration: "1 minut", icon: "mouth.fill"),
        DiceAction(action: "Mangaie", bodyPart: "spatele", duration: "1 minut", icon: "hand.draw.fill"),
        DiceAction(action: "Sufla usor pe", bodyPart: "urechea", duration: "30 secunde", icon: "wind"),
        DiceAction(action: "Saruta", bodyPart: "mana", duration: "30 secunde", icon: "mouth.fill"),
        DiceAction(action: "Maseaza", bodyPart: "picioarele", duration: "2 minute", icon: "hand.raised.fill"),
        DiceAction(action: "Atinge usor", bodyPart: "fata", duration: "1 minut", icon: "hand.point.up.fill"),
        DiceAction(action: "Imbratiseaza si tine", bodyPart: "tot corpul", duration: "2 minute", icon: "figure.2.arms.open"),
        DiceAction(action: "Saruta", bodyPart: "fruntea", duration: "10 secunde", icon: "mouth.fill"),
        DiceAction(action: "Mangaie", bodyPart: "parul", duration: "1 minut", icon: "hand.draw.fill"),
        DiceAction(action: "Maseaza", bodyPart: "talia", duration: "1 minut", icon: "hand.raised.fill"),
        DiceAction(action: "Atinge delicat", bodyPart: "bratele", duration: "30 secunde", icon: "hand.point.up.fill"),
        DiceAction(action: "Saruta drumul de la", bodyPart: "mana pana la umar", duration: "1 minut", icon: "mouth.fill"),
        DiceAction(action: "Priveste in ochi si tine", bodyPart: "mainile", duration: "1 minut", icon: "eye.fill"),
        DiceAction(action: "Maseaza", bodyPart: "degetele", duration: "1 minut", icon: "hand.raised.fill"),
    ]
    
    // MARK: - Quiz Questions
    static let quizQuestions: [QuizQuestion] = [
        QuizQuestion(question: "Care este limba iubirii cea mai importanta?", options: ["Cuvinte de afirmare", "Timp de calitate", "Cadouri", "Toate sunt importante"], correctIndex: 3, explanation: "Toate cele 5 limbi ale iubirii sunt importante. Fiecare persoana are preferinta sa."),
        QuizQuestion(question: "Cat timp ar trebui sa dureze preludiul ideal?", options: ["5 minute", "10-15 minute", "15-30 minute", "Nu exista timp ideal"], correctIndex: 3, explanation: "Nu exista un timp ideal universal. Comunicarea cu partenerul este cheia."),
        QuizQuestion(question: "Ce hormon este eliberat in timpul sarutului?", options: ["Adrenalina", "Oxitocina", "Cortizol", "Melatonina"], correctIndex: 1, explanation: "Oxitocina, hormonul iubirii, este eliberat in timpul sarutului si intareste legatura emotionala."),
        QuizQuestion(question: "Care este cel mai important factor intr-o relatie intima?", options: ["Atractia fizica", "Comunicarea", "Experienta", "Frecventa"], correctIndex: 1, explanation: "Comunicarea deschisa si sincera este baza unei relatii intime sanatoase."),
        QuizQuestion(question: "Kamasutra a fost scrisa in ce tara?", options: ["China", "Japonia", "India", "Egipt"], correctIndex: 2, explanation: "Kamasutra a fost scrisa in India antica de Vatsyayana, in secolul al III-lea."),
        QuizQuestion(question: "Cate pozitii contine Kamasutra originala?", options: ["57", "64", "100+", "36"], correctIndex: 1, explanation: "Kamasutra originala descrie 64 de arte, inclusiv pozitii si tehnici."),
        QuizQuestion(question: "Ce zona este considerata cea mai erogena?", options: ["Gatul", "Urechea", "Creierul", "Buzele"], correctIndex: 2, explanation: "Creierul este cel mai mare organ sexual. Excitarea incepe in minte."),
        QuizQuestion(question: "Care este beneficiul principal al contactului vizual in timpul intimitatii?", options: ["Arata dominanta", "Creste conexiunea emotionala", "Este o traditie", "Nu are beneficii"], correctIndex: 1, explanation: "Contactul vizual elibereaza oxitocina si creste semnificativ conexiunea emotionala."),
        QuizQuestion(question: "Ce tehnica de respiratie ajuta la relaxare in cuplu?", options: ["Respiratie rapida", "Respiratie sincronizata", "Retinerea respiratiei", "Nu conteaza"], correctIndex: 1, explanation: "Respiratia sincronizata cu partenerul creste intimitatea si relaxarea."),
        QuizQuestion(question: "Care este efectul masajului asupra relatiei?", options: ["Doar relaxare fizica", "Creste increderea si intimitatea", "Nu are efect", "Doar placere fizica"], correctIndex: 1, explanation: "Masajul creste nivelul de oxitocina, reducand stresul si crescand increderea reciproca."),
    ]
    
    // MARK: - Challenge Cards
    static let challenges: [ChallengeCard] = [
        ChallengeCard(title: "Seara fara Telefon", description: "Petreceti o seara intreaga fara telefoane. Concentrati-va doar pe voi.", duration: "O seara", difficulty: "Usor", icon: "iphone.slash"),
        ChallengeCard(title: "Masajul Surpriza", description: "Pregateste un masaj complet surpriza pentru partenerul tau cu uleiuri.", duration: "30 min", difficulty: "Usor", icon: "hand.raised.fill"),
        ChallengeCard(title: "Scrisoare de Dragoste", description: "Scrieti fiecare o scrisoare de dragoste si cititi-le impreuna seara.", duration: "1 ora", difficulty: "Usor", icon: "envelope.fill"),
        ChallengeCard(title: "Gatiti Impreuna", description: "Alegeti o reteta noua si gatiti impreuna o cina romantica.", duration: "2 ore", difficulty: "Mediu", icon: "fork.knife"),
        ChallengeCard(title: "Dans in Doi", description: "Puneti muzica preferata si dansati impreuna in sufragerie.", duration: "30 min", difficulty: "Usor", icon: "music.note"),
        ChallengeCard(title: "Baie Romantica", description: "Pregatiti o baie cu lumanari, muzica si spuma pentru doi.", duration: "1 ora", difficulty: "Mediu", icon: "drop.fill"),
        ChallengeCard(title: "Pozitia Saptamanii", description: "Alegeti o pozitie noua din aplicatie si incercati-o impreuna.", duration: "O seara", difficulty: "Mediu", icon: "star.fill"),
        ChallengeCard(title: "Joc de Rol", description: "Inventati personaje noi si jucati un scenariu romantic.", duration: "O seara", difficulty: "Avansat", icon: "theatermasks.fill"),
        ChallengeCard(title: "Fotografii de Cuplu", description: "Faceti o sedinta foto romantica, doar pentru voi.", duration: "1 ora", difficulty: "Mediu", icon: "camera.fill"),
        ChallengeCard(title: "Mic Dejun in Pat", description: "Trezeste-te devreme si pregateste mic dejun surpriza in pat.", duration: "1 ora", difficulty: "Usor", icon: "cup.and.saucer.fill"),
        ChallengeCard(title: "Explorare Senzoriala", description: "Cu ochii legati, exploreaza senzatii noi: miere, gheata, pene.", duration: "30 min", difficulty: "Avansat", icon: "eye.slash.fill"),
        ChallengeCard(title: "Zi a Complimentelor", description: "Trimiteti-va cel putin 10 complimente sincere pe parcursul zilei.", duration: "O zi", difficulty: "Usor", icon: "heart.text.square.fill"),
        ChallengeCard(title: "Noapte de Film", description: "Alegeti un film romantic si priviti-l imbratisati sub patura.", duration: "2 ore", difficulty: "Usor", icon: "play.rectangle.fill"),
        ChallengeCard(title: "Striptease", description: "Pregatiti o prezentare seducatoare pentru partenerul vostru.", duration: "30 min", difficulty: "Avansat", icon: "sparkles"),
        ChallengeCard(title: "Lista Dorintelor", description: "Scrieti fiecare 5 dorinte secrete si schimbati listele.", duration: "30 min", difficulty: "Mediu", icon: "list.clipboard.fill"),
    ]
}
