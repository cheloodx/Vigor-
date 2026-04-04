import SwiftUI

// MARK: - Privacy Policy View
struct PrivacyPolicyView: View {
    @EnvironmentObject var localization: LocalizationManager
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.primary)
                    Text(localization.t("privacy.title"))
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Theme.textPrimary)
                    Text("Ultima actualizare: Martie 2026")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
                
                policySection(title: "1. Date Colectate", content: """
                AutoDiag Pro colecteaza urmatoarele date:
                
                • Informatii vehicul: marca, model, an, kilometraj, VIN (optional)
                • Date OBD2: parametri motor in timp real (temperatura, turatie, viteza, tensiune baterie)
                • Istoric diagnostic: rezultate scanari, erori DTC detectate
                • Jurnal vehicul: alimentari, reparatii, inspectii
                • Date locatie: doar pentru functia Harta Service-uri (cu permisiunea dvs.)
                • Inregistrari audio: doar pentru Analiza Sunet Motor (procesate local)
                
                NU colectam date personale precum nume, email sau informatii financiare decat daca utilizati Sign in with Apple (doar Apple ID-ul).
                """)
                
                policySection(title: "2. Utilizarea Datelor", content: """
                Datele sunt utilizate exclusiv pentru:
                
                • Furnizarea serviciilor de diagnostic auto
                • Calcularea scorului de sanatate al vehiculului
                • Generarea alertelor de intretinere
                • Imbunatatirea algoritmilor de diagnostic
                • Sincronizarea datelor intre dispozitivele dvs. (iCloud)
                
                NU vindem si NU partajam datele dvs. cu terti.
                """)
                
                policySection(title: "3. Stocare Date", content: """
                • Date locale: stocate pe dispozitiv folosind UserDefaults si fisiere locale
                • iCloud: sincronizare optionala prin NSUbiquitousKeyValueStore (criptare Apple)
                • Date OBD2: procesate in timp real, nu sunt stocate pe servere externe
                • Inregistrari audio: procesate local pe dispozitiv, nu sunt transmise
                """)
                
                policySection(title: "4. Permisiuni", content: """
                Aplicatia solicita urmatoarele permisiuni:
                
                • Camera: pentru scanarea VIN/numar inmatriculare si foto diagnostic
                • Microfon: pentru recunoastere vocala si analiza sunet motor
                • Bluetooth: pentru conectarea la adaptorul OBD2
                • Locatie: pentru harta service-uri (optional)
                • Notificari: pentru alarme de intretinere (optional)
                • Recunoastere vocala: pentru functia de diagnostic vocal
                
                Fiecare permisiune este solicitata doar cand este necesara si poate fi revocata din Setari.
                """)
                
                policySection(title: "5. Drepturile Dvs.", content: """
                Conform GDPR si legislatiei europene, aveti dreptul:
                
                • Sa accesati datele dvs.
                • Sa stergeti toate datele (Setari > Sterge Date)
                • Sa exportati datele (Export PDF)
                • Sa dezactivati orice permisiune
                • Sa dezactivati sincronizarea iCloud
                • Sa va retrageti consimtamantul oricand
                """)
                
                policySection(title: "6. Contact", content: """
                Pentru intrebari despre confidentialitate:
                
                Email: privacy@autodiagpro.eu
                Website: www.autodiagpro.eu/privacy
                """)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Confidentialitate")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }
    
    private func policySection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.primary)
            Text(content)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}

// MARK: - Terms of Service View
struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Theme.primary)
                    Text(localization.t("terms.title"))
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Theme.textPrimary)
                    Text("Ultima actualizare: Martie 2026")
                        .font(.system(size: 11))
                        .foregroundColor(Theme.textMuted)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 8)
                
                termsSection(title: "1. Acceptarea Termenilor", content: """
                Prin utilizarea aplicatiei AutoDiag Pro, acceptati acesti termeni si conditii. Daca nu sunteti de acord, va rugam sa nu utilizati aplicatia.
                """)
                
                termsSection(title: "2. Descrierea Serviciului", content: """
                AutoDiag Pro este o aplicatie de diagnostic auto care ofera:
                
                • Diagnostic vizual si vocal al vehiculului
                • Conectivitate OBD2 Bluetooth pentru date in timp real
                • Scor de sanatate si alarme de intretinere
                • Chat AI cu mecanic virtual
                • Export rapoarte PDF
                • Suport multi-tara pentru 44 de tari europene
                
                Aplicatia este un instrument informativ si NU inlocuieste diagnosticul profesional al unui mecanic autorizat.
                """)
                
                termsSection(title: "3. Limitare Responsabilitate", content: """
                IMPORTANT: AutoDiag Pro ofera informatii orientative si NU garanteaza acuratetea diagnosticului.
                
                • Diagnosticul AI este bazat pe pattern-matching si NU pe analiza profesionala
                • Datele OBD2 depind de compatibilitatea adaptorului si vehiculului
                • Estimarile de cost sunt orientative si variaza in functie de zona si service
                • Scorul de sanatate este o estimare si NU un diagnostic certificat
                
                Utilizatorul este responsabil pentru deciziile luate pe baza informatiilor din aplicatie.
                """)
                
                termsSection(title: "4. Abonamente si Plati", content: """
                • Versiunea gratuita include functii de baza cu anumite limitari
                • Versiunea PRO se achizitioneaza prin In-App Purchase
                • Abonamentele se reinnoiesc automat (lunar/anual)
                • Anularea se face din Setari > Abonamente pe dispozitivul iOS
                • Plata pe viata ofera acces permanent fara reinnoiri
                • Rambursarea se solicita prin Apple conform politicii App Store
                """)
                
                termsSection(title: "5. Proprietate Intelectuala", content: """
                Tot continutul aplicatiei (cod, design, texte, grafice) este proprietatea AutoDiag Pro. Reproducerea, distribuirea sau modificarea neautorizata este interzisa.
                """)
                
                termsSection(title: "6. Modificari", content: """
                Ne rezervam dreptul de a modifica acesti termeni. Modificarile vor fi comunicate prin actualizarea aplicatiei. Continuarea utilizarii dupa modificari constituie acceptarea noilor termeni.
                """)
                
                termsSection(title: "7. Legislatie Aplicabila", content: """
                Acesti termeni sunt guvernati de legislatia Uniunii Europene si de legislatia tarii in care utilizatorul isi are rezidenta.
                
                Pentru litigii, se va aplica jurisdictia instantelor din tara de rezidenta a utilizatorului, conform Regulamentului UE.
                """)
                
                termsSection(title: "8. Contact", content: """
                Email: legal@autodiagpro.eu
                Website: www.autodiagpro.eu/terms
                """)
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(localization.t("terms.title"))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Theme.textPrimary)
            }
        }
    }
    
    private func termsSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Theme.primary)
            Text(content)
                .font(.system(size: 12))
                .foregroundColor(Theme.textSecondary)
                .lineSpacing(3)
        }
        .padding(14)
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
    }
}
