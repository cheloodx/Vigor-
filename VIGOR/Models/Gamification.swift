import Foundation
import SwiftUI

// MARK: - Position Data (All 57 Positions)
struct PositionData {
    static let allPositions: [Position] = [
        Position(
            id: "missionary", name: "Misionarul", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800&h=600&fit=crop",
            description: "Pozitia clasica si intima, perfecta pentru conexiune emotionala profunda.",
            benefits: ["Contact vizual intim", "Permite sarutari", "Usor de practicat", "Stimulare prin contact direct"],
            tips: ["Folositi perne sub solduri", "Mentineti contactul vizual", "Experimentati cu ritmuri diferite"],
            variations: ["Cu picioarele ridicate", "Cu perna sub solduri", "Cu picioarele incrucisate"]
        ),
        Position(
            id: "cowgirl", name: "Cowgirl", category: .passionate, difficulty: .beginner, intimacy: 4,
            image: "https://images.unsplash.com/photo-1522673607200-164d1b6ce486?w=800&h=600&fit=crop",
            description: "Femeia este in control complet, permitandu-i sa stabileasca ritmul.",
            benefits: ["Femeia controleaza ritmul", "Stimulare excelenta", "Permite stimulare manuala", "Vedere placuta"],
            tips: ["Experimentati cu unghiuri diferite", "Folositi miscari circulare", "Sprijiniti-va de pieptul partenerului"],
            variations: ["Aplecata inainte", "Cu spatele arcuit", "Cu miscari circulare"]
        ),
        Position(
            id: "doggy-style", name: "Doggy Style", category: .passionate, difficulty: .beginner, intimacy: 3,
            image: "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=800&h=600&fit=crop",
            description: "O pozitie pasionala care permite penetrare profunda si control.",
            benefits: ["Penetrare profunda", "Miscari puternice", "Stimulare simultana", "Acces la zone erogene"],
            tips: ["Comunicati despre profunzime", "Folositi perne sub genunchi", "Experimentati cu unghiuri"],
            variations: ["Cu fata in jos pe pat", "In picioare", "Cu un picior ridicat"]
        ),
        Position(
            id: "spooning", name: "Spooning", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1516589091380-5d8e87df6999?w=800&h=600&fit=crop",
            description: "Pozitie intima si relaxanta, perfecta pentru dimineata.",
            benefits: ["Extrem de intima", "Perfecta pentru dimineata", "Permite stimulare clitoridiana", "Ideala pentru sarcina"],
            tips: ["Ridicati usor piciorul de sus", "Folositi miscari lente", "Imbratisati-va strans"],
            variations: ["Cu piciorul ridicat", "Cu stimulare manuala", "In pozitie semi-asezata"]
        ),
        Position(
            id: "standing", name: "In Picioare", category: .adventurous, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1529333166437-7750a6dd5a70?w=800&h=600&fit=crop",
            description: "Pozitie pasionala si spontana, perfecta pentru pasiune intensa.",
            benefits: ["Foarte pasionala", "Poate fi facuta oriunde", "Senzatii unice", "Variatii multiple"],
            tips: ["Folositi un perete pentru suport", "Comunicati despre echilibru", "Experimentati cu inaltimi"],
            variations: ["Cu un picior ridicat", "Sprijiniti de perete", "Cu femeia ridicata"]
        ),
        Position(
            id: "butterfly", name: "Fluturele", category: .intimate, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800&h=600&fit=crop",
            description: "Femeia sta pe marginea patului cu picioarele ridicate, barbatul in picioare.",
            benefits: ["Penetrare profunda", "Contact vizual romantic", "Permite stimulare manuala", "Confortabila"],
            tips: ["Ajustati inaltimea cu perne", "Mentineti contactul vizual", "Experimentati cu unghiul picioarelor"],
            variations: ["Cu picioarele pe umeri", "Cu picioarele in lateral", "Cu femeia ridicata pe perne"]
        ),
        Position(
            id: "69", name: "69", category: .intimate, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1474552226712-ac0f0961a954?w=800&h=600&fit=crop",
            description: "Pozitie de stimulare orala reciproca simultana.",
            benefits: ["Stimulare reciproca", "Foarte intima", "Permite explorare", "Excelenta pentru preludiu"],
            tips: ["Comunicati despre preferinte", "Gasiti o pozitie confortabila", "Alternati focusul"],
            variations: ["Pe o parte (lateral)", "Cu femeia deasupra", "Cu barbatul deasupra"]
        ),
        Position(
            id: "lotus", name: "Lotus", category: .romantic, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=800&h=600&fit=crop",
            description: "Pozitie tantrica unde partenerii stau fata in fata.",
            benefits: ["Extrem de intima", "Contact vizual continuu", "Stimulare profunda", "Ideala pentru tantra"],
            tips: ["Miscari lente si constiente", "Respirati impreuna", "Mentineti contactul vizual"],
            variations: ["Cu miscari de leganare", "Cu meditatie", "Cu respiratie sincronizata"]
        ),
        Position(
            id: "bridge", name: "Podul", category: .adventurous, difficulty: .advanced, intimacy: 3,
            image: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&h=600&fit=crop",
            description: "Pozitie acrobatica unde barbatul formeaza un pod cu corpul.",
            benefits: ["Stimulare unica", "Necesita cooperare", "Acces la zone noi", "Foarte vizuala"],
            tips: ["Asigurati-va ca aveti suficienta forta", "Incepeti treptat", "Comunicati despre confort"],
            variations: ["Cu sprijin pe coate", "Cu perne sub spate", "Semi-pod"]
        ),
        Position(
            id: "pretzel", name: "Pretzel", category: .adventurous, difficulty: .advanced, intimacy: 4,
            image: "https://images.unsplash.com/photo-1515023115894-bacee5d91250?w=800&h=600&fit=crop",
            description: "Pozitie complexa cu configuratie incrucisata unica.",
            benefits: ["Stimulare din unghiuri neobisnuite", "Foarte intima", "Contact vizual", "Senzatii unice"],
            tips: ["Luati-o usor la inceput", "Comunicati despre confort", "Experimentati cu unghiuri"],
            variations: ["Cu picioare in pozitii diferite", "Cu perne pentru suport", "Cu unghi ajustat"]
        ),
        Position(
            id: "wheelbarrow", name: "Roaba", category: .adventurous, difficulty: .expert, intimacy: 3,
            image: "https://images.unsplash.com/photo-1534367610401-9f5ed68180aa?w=800&h=600&fit=crop",
            description: "Pozitie acrobatica unde barbatul tine picioarele femeii.",
            benefits: ["Foarte dinamica", "Penetrare profunda", "Senzatie de aventura", "Stimulare din unghi unic"],
            tips: ["Asigurati-va ca aveti forta", "Incepeti pe o suprafata moale", "Comunicati constant"],
            variations: ["Cu femeia sprijinita pe pat", "Cu un singur picior ridicat", "Cu sprijin pe coate"]
        ),
        Position(
            id: "amazon", name: "Amazoana", category: .passionate, difficulty: .advanced, intimacy: 4,
            image: "https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?w=800&h=600&fit=crop",
            description: "Femeia este in control complet, barbatul cu picioarele ridicate.",
            benefits: ["Femeia are control total", "Stimulare intensa", "Senzatii noi", "Foarte pasionala"],
            tips: ["Comunicati despre ritm", "Experimentati cu unghiuri", "Incepeti cu miscari lente"],
            variations: ["Cu barbatul pe spate complet", "Cu picioarele in pozitii diferite", "Cu stimulare manuala"]
        ),
        Position(
            id: "reverse-cowgirl", name: "Reverse Cowgirl", category: .passionate, difficulty: .beginner, intimacy: 3,
            image: "https://images.unsplash.com/photo-1521038199265-bc482db0f923?w=800&h=600&fit=crop",
            description: "Varianta Cowgirl unde femeia sta cu spatele la barbat.",
            benefits: ["Stimulare din unghi diferit", "Vizual excitant", "Femeia mentine controlul", "Acces la stimulare"],
            tips: ["Atentie la unghi", "Miscari de leganare", "Comunicati despre confort"],
            variations: ["Aplecata inainte", "Cu sprijin pe genunchi", "Cu miscari circulare"]
        ),
        Position(
            id: "sideways", name: "Lateral", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1504439468489-c8920d796a29?w=800&h=600&fit=crop",
            description: "Partenerii stau pe o parte, fata in fata. Pozitie intima.",
            benefits: ["Foarte intima si relaxanta", "Permite imbratisari", "Confortabila pentru perioade lungi", "Contact vizual natural"],
            tips: ["Folositi perne", "Miscari lente si intime", "Bucurati-va de apropiere"],
            variations: ["Cu piciorul ridicat", "Cu fata la partener", "Cu imbratisari stranse"]
        ),
        Position(
            id: "scissors", name: "Foarfecele", category: .intimate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1501901609772-df0848060b33?w=800&h=600&fit=crop",
            description: "Picioarele partenerilor se incruciseaza ca o foarfece.",
            benefits: ["Stimulare unica din unghi lateral", "Permite contact vizual", "Confortabila", "Intima si pasionala"],
            tips: ["Experimentati cu unghiul picioarelor", "Comunicati despre ritm", "Folositi perne"],
            variations: ["Cu un picior ridicat", "Cu stimulare manuala", "Cu unghiuri diferite"]
        ),
        Position(
            id: "anvil", name: "Nicovala", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1527956041665-d7a1b380c460?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu picioarele ridicate pe umerii barbatului.",
            benefits: ["Penetrare foarte profunda", "Stimulare intensa", "Contact vizual bun", "Usor de realizat"],
            tips: ["Comunicati despre profunzime", "Atentie la flexibilitate", "Ajustati unghiul"],
            variations: ["Cu un picior ridicat", "Cu ambele pe umeri", "Cu perne sub solduri"]
        ),
        Position(
            id: "g-spot", name: "G-Spot", category: .intimate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1523438885200-e635ba2c371e?w=800&h=600&fit=crop",
            description: "Pozitie speciala pentru stimularea punctului G.",
            benefits: ["Stimulare directa a punctului G", "Foarte eficienta", "Usor de ajustat", "Permite stimulare simultana"],
            tips: ["Folositi o perna sub solduri", "Ajustati unghiul", "Miscari scurte si precise"],
            variations: ["Cu unghiuri diferite", "Cu stimulare manuala", "Cu perne de diferite inaltimi"]
        ),
        Position(
            id: "the-chair", name: "Scaunul", category: .passionate, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1517705008128-361805f42e86?w=800&h=600&fit=crop",
            description: "Barbatul sta pe scaun, femeia se aseaza in poala lui.",
            benefits: ["Foarte intima", "Femeia controleaza ritmul", "Permite imbratisari", "Confortabila si stabila"],
            tips: ["Alegeti un scaun stabil", "Experimentati cu unghiuri", "Folositi bratele pentru suport"],
            variations: ["Cu spatele la partener", "Pe marginea patului", "Cu miscari de leganare"]
        ),
        Position(
            id: "the-arc", name: "Arcul", category: .adventurous, difficulty: .advanced, intimacy: 3,
            image: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&h=600&fit=crop",
            description: "Femeia se arcuieste pe spate, creand un arc cu corpul.",
            benefits: ["Senzatii foarte intense", "Vizual impresionant", "Stimulare din unghi unic", "Provocare placuta"],
            tips: ["Incalziti-va inainte", "Folositi perne pentru suport", "Nu fortati flexibilitatea"],
            variations: ["Cu sprijin pe maini", "Semi-arc", "Cu suport sub spate"]
        ),
        Position(
            id: "the-seashell", name: "Scoica", category: .intimate, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu genunchii trasi spre piept.",
            benefits: ["Penetrare foarte profunda", "Contact vizual intens", "Stimulare emotionala", "Permite imbratisari"],
            tips: ["Ridicati genunchii treptat", "Comunicati despre confort", "Miscari lente la inceput"],
            variations: ["Cu genunchii pe umeri", "Cu genunchii lateral", "Cu picioarele drepte in sus"]
        ),
        Position(
            id: "the-snake", name: "Sarpele", category: .passionate, difficulty: .intermediate, intimacy: 3,
            image: "https://images.unsplash.com/photo-1509909756405-be0199881695?w=800&h=600&fit=crop",
            description: "Femeia sta pe burta, barbatul deasupra. Stimulare intensa.",
            benefits: ["Stimulare intensa", "Senzatie de dominare", "Contact corporal complet", "Foarte pasionala"],
            tips: ["Folositi perne sub abdomen", "Miscari ondulate", "Comunicati despre greutate"],
            variations: ["Cu perna sub solduri", "Cu picioarele impreunate", "Cu bratele intinse"]
        ),
        Position(
            id: "the-viennese-oyster", name: "Stridia Vieneza", category: .adventurous, difficulty: .advanced, intimacy: 4,
            image: "https://images.unsplash.com/photo-1519834785169-98be25ec3f84?w=800&h=600&fit=crop",
            description: "Pozitie avansata unde femeia isi ridica picioarele peste cap.",
            benefits: ["Penetrare extrem de profunda", "Senzatii unice", "Stimulare intensa", "Provocatoare"],
            tips: ["Necesita flexibilitate buna", "Incepeti treptat", "Comunicati constant"],
            variations: ["Semi-pliat", "Cu sprijin pe perne", "Cu unghiuri ajustate"]
        ),
        Position(
            id: "the-victory", name: "Victoria", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1533227268428-f9ed0900fb3b?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu picioarele ridicate in forma de V.",
            benefits: ["Stimulare profunda", "Acces excelent", "Contact vizual bun", "Usor de mentinut"],
            tips: ["Ajustati unghiul picioarelor", "Folositi mainile", "Experimentati cu ritmuri"],
            variations: ["Cu picioarele mai sus", "Cu picioarele pe umeri", "Cu genunchii indoiti"]
        ),
        Position(
            id: "the-ballet-dancer", name: "Balerina", category: .adventurous, difficulty: .advanced, intimacy: 4,
            image: "https://images.unsplash.com/photo-1518834107812-67b0b7c58434?w=800&h=600&fit=crop",
            description: "In picioare, femeia ridica un picior sus pe umarul barbatului.",
            benefits: ["Foarte eleganta", "Penetrare profunda", "Necesita cooperare", "Senzatii unice"],
            tips: ["Folositi un perete pentru suport", "Incalziti-va inainte", "Comunicati despre echilibru"],
            variations: ["Cu sprijin pe perete", "Cu piciorul la inaltimi diferite", "Cu partenerul sprijinind piciorul"]
        ),
        Position(
            id: "the-splitting-bamboo", name: "Bambusul Despartit", category: .intimate, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=800&h=600&fit=crop",
            description: "Femeia pe spate, un picior intins, celalalt pe umarul barbatului.",
            benefits: ["Stimulare din unghi unic", "Contact vizual intim", "Permite variatie", "Clasica"],
            tips: ["Alternati picioarele", "Comunicati despre confort", "Ajustati unghiul"],
            variations: ["Cu ambele picioare ridicate", "Cu piciorul pe piept", "Cu unghiuri diferite"]
        ),
        Position(
            id: "the-waterfall", name: "Cascada", category: .adventurous, difficulty: .advanced, intimacy: 3,
            image: "https://images.unsplash.com/photo-1432405972618-c6b0cfba8b03?w=800&h=600&fit=crop",
            description: "Femeia pe marginea patului cu capul in jos.",
            benefits: ["Senzatii intense", "Vizual dramatic", "Stimulare unica", "Fluxul sanguin intensificat"],
            tips: ["Nu stati prea mult cu capul in jos", "Folositi perne", "Comunicati despre confort"],
            variations: ["Semi-cascada", "Cu sprijin sub cap", "Cu picioarele pe umeri"]
        ),
        Position(
            id: "the-dragon", name: "Dragonul", category: .passionate, difficulty: .intermediate, intimacy: 3,
            image: "https://images.unsplash.com/photo-1519681393784-d120267933ba?w=800&h=600&fit=crop",
            description: "Similar cu Doggy Style dar femeia sta complet culcata pe burta.",
            benefits: ["Senzatie foarte stransa", "Stimulare intensa", "Confortabila", "Permite intimitate"],
            tips: ["Folositi perne sub solduri", "Miscari lente si profunde", "Comunicati despre presiune"],
            variations: ["Cu picioarele impreunate", "Cu perna sub abdomen", "Cu bratele sub piept"]
        ),
        Position(
            id: "the-table-top", name: "Masa", category: .passionate, difficulty: .beginner, intimacy: 3,
            image: "https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=800&h=600&fit=crop",
            description: "Femeia sta pe o masa, barbatul in picioare. Spontana.",
            benefits: ["Foarte spontana", "Penetrare profunda", "Diferite unghiuri", "Excitanta"],
            tips: ["Asigurati-va ca masa este stabila", "Ajustati inaltimea", "Experimentati cu pozitia picioarelor"],
            variations: ["Cu picioarele in jurul taliei", "Cu femeia sprijinita", "Cu diferite mobiliere"]
        ),
        Position(
            id: "the-spider", name: "Paianjenul", category: .intimate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1470252649378-9c29740c9fa8?w=800&h=600&fit=crop",
            description: "Ambii parteneri stau rezemati pe maini si picioare, fata in fata.",
            benefits: ["Stimulare unica", "Necesita cooperare", "Permite contact vizual", "Diferita"],
            tips: ["Gasiti echilibrul impreuna", "Miscari de leganare", "Comunicati despre ritm"],
            variations: ["Cu sprijin pe coate", "Cu picioarele in pozitii diferite", "Cu ritmuri variate"]
        ),
        Position(
            id: "the-eagle", name: "Vulturul", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1611689342806-0a0a0a2b1b1b?w=800&h=600&fit=crop",
            description: "Femeia pe marginea patului cu picioarele larg deschise.",
            benefits: ["Penetrare profunda", "Acces excelent", "Permite stimulare manuala", "Contact vizual bun"],
            tips: ["Folositi perne sub genunchi", "Ajustati unghiul", "Experimentati cu ritmuri"],
            variations: ["Cu picioarele pe umeri", "Cu genunchii ridicati", "Cu unghiuri diferite"]
        ),
        Position(
            id: "the-yawning", name: "Cascatul", category: .intimate, difficulty: .advanced, intimacy: 5,
            image: "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu picioarele larg deschise si ridicate. Clasica din Kamasutra.",
            benefits: ["Penetrare foarte profunda", "Stimulare intensa", "Contact vizual", "Clasica"],
            tips: ["Necesita flexibilitate buna", "Incepeti treptat", "Folositi perne"],
            variations: ["Cu picioarele mai sus sau mai jos", "Cu genunchii indoiti", "Cu miscari diferite"]
        ),
        Position(
            id: "the-cross", name: "Crucea", category: .adventurous, difficulty: .intermediate, intimacy: 3,
            image: "https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?w=800&h=600&fit=crop",
            description: "Partenerii formeaza o cruce, perpendiculari unul pe altul.",
            benefits: ["Unghi de stimulare unic", "Vizual interesant", "Permite relaxare", "Senzatii noi"],
            tips: ["Experimentati cu unghiul exact", "Folositi perne", "Miscari lente"],
            variations: ["Cu diferite unghiuri", "Cu picioare variate", "Cu stimulare manuala"]
        ),
        Position(
            id: "the-sandwich", name: "Sandvisul", category: .intimate, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1505935428862-770b6f24f629?w=800&h=600&fit=crop",
            description: "Pozitie foarte intima, corpurile sunt complet lipite.",
            benefits: ["Extrem de intima", "Contact corporal maxim", "Senzatie de siguranta", "Stimulare emotionala"],
            tips: ["Miscari mici si intime", "Savurati apropierea", "Respirati impreuna"],
            variations: ["Cu picioarele impletite", "Cu bratele in jurul partenerului", "Cu miscari minime"]
        ),
        Position(
            id: "the-pretzel-dip", name: "Pretzel Inclinat", category: .adventurous, difficulty: .advanced, intimacy: 4,
            image: "https://images.unsplash.com/photo-1518609878373-06d740f60d8b?w=800&h=600&fit=crop",
            description: "Variatie complexa a pretzelului cu o inclinare unica.",
            benefits: ["Stimulare din unghiuri neobisnuite", "Foarte intima", "Permite variatie", "Senzatii intense"],
            tips: ["Gasiti pozitia confortabila", "Comunicati despre unghi", "Ajustati treptat"],
            variations: ["Cu diferite grade de inclinare", "Cu perne pentru suport", "Cu picioare variate"]
        ),
        Position(
            id: "the-magic-mountain", name: "Muntele Magic", category: .romantic, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=800&h=600&fit=crop",
            description: "Ambii parteneri in pozitie asezata, fata in fata.",
            benefits: ["Extrem de romantica", "Contact vizual constant", "Permite sarutari", "Miscari ritmice naturale"],
            tips: ["Folositi perne pentru confort", "Sincronizati respiratia", "Miscari de leganare"],
            variations: ["Cu picioarele in diferite pozitii", "Cu imbratisari", "Cu miscari minime"]
        ),
        Position(
            id: "the-fusion", name: "Fuziunea", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1518199266791-5375a83190b7?w=800&h=600&fit=crop",
            description: "Partenerii se imbina intr-o imbratisare stransa.",
            benefits: ["Conexiune emotionala profunda", "Contact corporal maxim", "Senzatie de unitate", "Foarte intima"],
            tips: ["Concentrati-va pe conexiune", "Miscari lente si sincronizate", "Savurati momentul"],
            variations: ["In diferite pozitii de baza", "Cu respiratie sincronizata", "Cu miscari minime"]
        ),
        Position(
            id: "the-star", name: "Steaua", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1419242902214-272b3f66ee7a?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu picioarele larg deschise formand o stea.",
            benefits: ["Acces excelent", "Vizual atractiv", "Stimulare multipla", "Confortabila"],
            tips: ["Experimentati cu unghiul", "Folositi perne sub solduri", "Combinati cu stimulare manuala"],
            variations: ["Cu picioarele mai ridicate", "Cu rotatie usoara", "Cu stimulare orala si manuala"]
        ),
        Position(
            id: "the-plow", name: "Plugul", category: .adventurous, difficulty: .expert, intimacy: 3,
            image: "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=800&h=600&fit=crop",
            description: "Pozitie avansata cu picioarele ridicate complet peste cap.",
            benefits: ["Penetrare extrem de profunda", "Senzatii intense", "Provocare fizica", "Stimulare unica"],
            tips: ["Doar cu flexibilitate foarte buna", "Incepeti cu variante mai usoare", "Comunicati constant"],
            variations: ["Semi-plug", "Cu sprijin pe perne", "Cu unghiuri ajustate"]
        ),
        Position(
            id: "the-splitting-bridge", name: "Podul Despartit", category: .adventurous, difficulty: .expert, intimacy: 3,
            image: "https://images.unsplash.com/photo-1513622790541-eaa84d356909?w=800&h=600&fit=crop",
            description: "Combinatie intre pod si spagat. Extrem de avansata.",
            benefits: ["Senzatii unice si intense", "Extrem de provocatoare", "Vizual impresionant", "Pentru avansati"],
            tips: ["Doar cu experienta avansata", "Incalzire extensiva necesara", "Comunicare constanta"],
            variations: ["Semi-pod cu un picior", "Cu sprijin pe mobilier", "Cu asistenta"]
        ),
        Position(
            id: "the-shoulder-holder", name: "Sustinerea Umerilor", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1526724038726-3007ffb47b68?w=800&h=600&fit=crop",
            description: "Femeia pe spate cu picioarele pe umerii barbatului.",
            benefits: ["Penetrare profunda", "Control bun", "Stimulare intensa", "Contact vizual"],
            tips: ["Ajustati inaltimea picioarelor", "Comunicati despre profunzime", "Variati ritmul"],
            variations: ["Cu un picior pe umar", "Cu ambele picioare", "Cu genunchii indoiti"]
        ),
        Position(
            id: "the-deck-chair", name: "Sezlongul", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800&h=600&fit=crop",
            description: "Barbatul sta rezemat, femeia se aseaza in poala lui.",
            benefits: ["Foarte relaxanta", "Intima si confortabila", "Permite sarutari", "Femeia are control"],
            tips: ["Folositi perne pentru spate", "Miscari lente de leganare", "Bucurati-va de intimitate"],
            variations: ["Cu unghiuri diferite", "Cu picioarele variate", "Cu bratele in jurul partenerului"]
        ),
        Position(
            id: "the-squat", name: "Genuflexiunea", category: .passionate, difficulty: .intermediate, intimacy: 3,
            image: "https://images.unsplash.com/photo-1518310383802-640c2de311b2?w=800&h=600&fit=crop",
            description: "Femeia in pozitie de genuflexiune deasupra barbatului.",
            benefits: ["Femeia are control total", "Stimulare profunda", "Bun antrenament", "Senzatii intense"],
            tips: ["Odihiti-va cand este necesar", "Folositi mainile pentru echilibru", "Alternati cu alte pozitii"],
            variations: ["Cu sprijin pe genunchi", "Cu diferite adancimi", "Cu miscari variate"]
        ),
        Position(
            id: "the-om", name: "Om", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1545389336-cf090694435e?w=800&h=600&fit=crop",
            description: "Pozitie tantrica clasica. Focus pe conexiune spirituala.",
            benefits: ["Conexiune spirituala profunda", "Intimitate maxima", "Sincronizare respiratorie", "Calmanta"],
            tips: ["Respirati impreuna", "Miscari minime", "Concentrati-va pe conexiune"],
            variations: ["Cu meditatie activa", "Cu miscari de leganare", "Cu mantre"]
        ),
        Position(
            id: "the-tilt", name: "Inclinarea", category: .intimate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1518495973542-4542c06a5843?w=800&h=600&fit=crop",
            description: "Femeia pe marginea patului, inclinata inapoi pe coate.",
            benefits: ["Unghi excelent", "Contact vizual bun", "Permite stimulare manuala", "Confortabila"],
            tips: ["Ajustati unghiul", "Folositi perne sub coate", "Experimentati cu profunzimea"],
            variations: ["Mai mult sau mai putin inclinata", "Cu picioarele ridicate", "Cu sprijin pe maini"]
        ),
        Position(
            id: "the-wraparound", name: "Infasurarea", category: .romantic, difficulty: .beginner, intimacy: 5,
            image: "https://images.unsplash.com/photo-1516585427167-9f4af9627e6c?w=800&h=600&fit=crop",
            description: "Misionarul cu picioarele femeii infasurate strans.",
            benefits: ["Extrem de intima", "Senzatie de unitate", "Contact corporal maxim", "Stimulare emotionala"],
            tips: ["Strangeti picioarele ritmic", "Miscari sincronizate", "Savurati apropierea"],
            variations: ["Cu bratele si picioarele infasurate", "Cu picioarele la diferite inaltimi", "Cu miscari de leganare"]
        ),
        Position(
            id: "the-glowing-triangle", name: "Triunghiul Stralucitor", category: .intimate, difficulty: .advanced, intimacy: 5,
            image: "https://images.unsplash.com/photo-1501436513145-30f24e19fbd8?w=800&h=600&fit=crop",
            description: "Pozitie tantrica avansata care formeaza un triunghi energetic.",
            benefits: ["Conexiune energetica profunda", "Stimulare fizica si spirituala", "Unica", "Pentru cupluri avansate"],
            tips: ["Practicati respiratia tantrica", "Concentrati-va pe energie", "Miscari foarte lente"],
            variations: ["Cu diferite configuratii", "Cu meditatie", "Cu respiratie specifica"]
        ),
        Position(
            id: "the-speed-bump", name: "Denivelarea", category: .passionate, difficulty: .beginner, intimacy: 3,
            image: "https://images.unsplash.com/photo-1518611012118-696072aa579a?w=800&h=600&fit=crop",
            description: "Femeia pe burta cu o perna sub solduri.",
            benefits: ["Stimulare din unghi perfect", "Usor de realizat", "Confortabila", "Penetrare profunda"],
            tips: ["Alegeti perna potrivita", "Ajustati inaltimea pernei", "Miscari variate"],
            variations: ["Cu perne de diferite marimi", "Cu picioarele impreunate sau departate", "Cu stimulare manuala"]
        ),
        Position(
            id: "the-corkscrew", name: "Tirbusonul", category: .adventurous, difficulty: .advanced, intimacy: 3,
            image: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=800&h=600&fit=crop",
            description: "Pozitie complexa cu rotatie si rasucire.",
            benefits: ["Senzatii unice de rotatie", "Stimulare din unghiuri neobisnuite", "Provocatoare", "Excitanta"],
            tips: ["Miscari lente de rotatie", "Comunicati constant", "Nu fortati miscarile"],
            variations: ["Cu diferite grade de rotatie", "Cu sprijin pe mobilier", "Cu miscari variate"]
        ),
        Position(
            id: "the-lazy-man", name: "Lenesul", category: .romantic, difficulty: .beginner, intimacy: 4,
            image: "https://images.unsplash.com/photo-1520038410233-7141be7e6f97?w=800&h=600&fit=crop",
            description: "Barbatul sta relaxat pe spate, femeia face toata munca.",
            benefits: ["Foarte relaxanta", "Femeia are control complet", "Perfecta dimineata", "Intima si confortabila"],
            tips: ["Lasati partenera sa conduca", "Bucurati-va de moment", "Comunicati apreciere"],
            variations: ["Cu femeia in diferite pozitii", "Cu stimulare manuala", "Cu miscari variate"]
        ),
        Position(
            id: "the-column", name: "Coloana", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1491396122945-4a1f7b4c193a?w=800&h=600&fit=crop",
            description: "Ambii parteneri in picioare, femeia cu spatele la perete.",
            benefits: ["Foarte pasionala", "Poate fi facuta oriunde", "Spontana si intensa", "Senzatie de urgenta"],
            tips: ["Folositi un perete", "Atentie la echilibru", "Experimentati cu inaltimi"],
            variations: ["Cu un picior ridicat", "Cu sprijin pe mobilier", "Cu diferite unghiuri"]
        ),
        Position(
            id: "the-proposal", name: "Cererea", category: .romantic, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1519741497674-611481863552?w=800&h=600&fit=crop",
            description: "Barbatul in genunchi, femeia pe marginea patului. Romantica.",
            benefits: ["Foarte romantica", "Permite stimulare orala si penetrare", "Respectuoasa", "Intima"],
            tips: ["Folositi perne sub genunchi", "Alternati intre stimulari", "Creati atmosfera"],
            variations: ["Cu diferite inaltimi", "Cu stimulare variata", "Cu pozitii ale picioarelor diferite"]
        ),
        Position(
            id: "the-lusty-leg", name: "Piciorul Pasional", category: .passionate, difficulty: .beginner, intimacy: 4,
            image: "https://images.unsplash.com/photo-1504439468489-c8920d796a29?w=800&h=600&fit=crop",
            description: "Misionarul cu un picior al femeii ridicat pe umarul barbatului.",
            benefits: ["Penetrare mai profunda", "Usor de realizat", "Permite variatie", "Contact vizual pastrat"],
            tips: ["Alternati picioarele", "Experimentati cu unghiuri", "Comunicati despre profunzime"],
            variations: ["Cu ambele picioare ridicate", "Cu picior pe piept", "Cu unghiuri diferite"]
        ),
        Position(
            id: "the-sofa-brace", name: "Sprijinul pe Canapea", category: .adventurous, difficulty: .intermediate, intimacy: 3,
            image: "https://images.unsplash.com/photo-1493663284031-b7e3aefcae8e?w=800&h=600&fit=crop",
            description: "Femeia se sprijina de canapea, barbatul din spate.",
            benefits: ["Foarte spontana", "Poate fi facuta in living", "Pasionala si intensa", "Unghi excelent"],
            tips: ["Asigurati-va ca mobilierul este stabil", "Ajustati inaltimea", "Experimentati cu unghiuri"],
            variations: ["Cu femeia in genunchi pe canapea", "Cu un picior pe canapea", "In diferite pozitii"]
        ),
        Position(
            id: "the-double-decker", name: "Etajul Dublu", category: .intimate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=800&h=600&fit=crop",
            description: "Femeia pe marginea patului, barbatul in genunchi pe podea.",
            benefits: ["Control excelent", "Permite stimulare orala si penetrare", "Flexibila si versatila", "Contact vizual bun"],
            tips: ["Folositi perne sub genunchi", "Ajustati inaltimea patului", "Alternati intre stimulari"],
            variations: ["Cu diferite inaltimi", "Cu picioarele in pozitii diferite", "Cu combinatii de stimulare"]
        ),
        Position(
            id: "the-champagne-room", name: "Camera de Sampanie", category: .passionate, difficulty: .intermediate, intimacy: 4,
            image: "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=800&h=600&fit=crop",
            description: "Femeia danseaza in poala barbatului care sta pe scaun.",
            benefits: ["Foarte jucausa si distractiva", "Permite dans si seductie", "Intima si pasionala", "Femeia are control"],
            tips: ["Creati atmosfera cu muzica", "Lasati-va purtati de moment", "Savurati aspectul jucaus"],
            variations: ["Cu dans mai mult sau mai putin", "Cu miscari diferite", "Cu seductie prelungita"]
        ),
        Position(
            id: "the-bodyguard", name: "Bodyguardul", category: .passionate, difficulty: .beginner, intimacy: 4,
            image: "https://images.unsplash.com/photo-1507537297725-24a1c029d3ca?w=800&h=600&fit=crop",
            description: "In picioare, barbatul in spatele femeii, imbratisand-o protector.",
            benefits: ["Foarte protectoare", "Permite imbratisari stranse", "Poate fi facuta oriunde", "Stimulare profunda"],
            tips: ["Barbatul sa imbratiseze ferm", "Folositi un perete", "Comunicati despre unghi"],
            variations: ["Cu femeia aplecata usor", "Cu un picior ridicat", "In diferite locatii"]
        ),
        Position(
            id: "the-turtle", name: "Testoasa", category: .intimate, difficulty: .intermediate, intimacy: 5,
            image: "https://images.unsplash.com/photo-1518621736915-f3b1c41bfd00?w=800&h=600&fit=crop",
            description: "Pozitie intima in pozitie compacta, apropiati. Foarte calda.",
            benefits: ["Extrem de intima", "Senzatie de siguranta", "Contact fizic maxim", "Calda si confortabila"],
            tips: ["Miscari mici si intime", "Savurati apropierea", "Comunicati non-verbal"],
            variations: ["Cu diferite grade de compactare", "Cu miscari minime", "Cu focus pe conexiune"]
        )
    ]
}
