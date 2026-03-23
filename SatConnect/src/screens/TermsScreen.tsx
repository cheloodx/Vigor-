import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

interface TermsScreenProps {
  onBack: () => void;
}

export function TermsScreen({ onBack }: TermsScreenProps) {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={onBack} style={styles.backButton}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={COLORS.text} />
        </TouchableOpacity>
        <Text style={styles.title}>Termeni și Condiții</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView contentContainerStyle={styles.content}>
        <Text style={styles.date}>Ultima actualizare: 19 martie 2026</Text>

        <Section title="1. Acceptarea Termenilor">
          Prin utilizarea aplicației SatConnect, acceptați acești termeni și condiții în totalitate.
          Dacă nu sunteți de acord cu oricare dintre acești termeni, vă rugăm să nu utilizați aplicația.
        </Section>

        <Section title="2. Descrierea Serviciului">
          SatConnect oferă servicii de conectivitate globală, incluzând internet mobil, roaming internațional,
          conectivitate prin satelit GPS, eSIM virtual și comunicare offline-first. Serviciul acoperă 175+ țări.
        </Section>

        <Section title="3. Conturi de Utilizator">
          Sunteți responsabil pentru păstrarea confidențialității datelor contului dumneavoastră.
          Trebuie să ne notificați imediat despre orice utilizare neautorizată a contului.
          Nu puteți transfera sau partaja contul cu alte persoane fără acordul nostru.
        </Section>

        <Section title="4. Planuri și Plăți">
          Abonamentele sunt gestionate prin Apple In-App Purchase. Prețurile sunt afișate în EUR și includ TVA.
          Abonamentele se reînnoiesc automat la sfârșitul perioadei. Puteți anula oricând din setările Apple ID.
          Rambursările sunt gestionate conform politicii Apple.
        </Section>

        <Section title="5. Utilizare Acceptabilă">
          Nu puteți utiliza serviciul pentru activități ilegale. Nu puteți încerca să interferați cu funcționarea
          serviciului. Utilizarea excesivă (fair use) poate fi limitată conform planului ales.
        </Section>

        <Section title="6. eSIM și Conectivitate">
          Cartelele eSIM virtuale sunt furnizate prin parteneri autorizați. Activarea necesită un dispozitiv
          compatibil eSIM. Acoperirea și vitezele pot varia în funcție de locație și operator local.
        </Section>

        <Section title="7. SOS și Urgențe">
          Funcția SOS este destinată situațiilor de urgență reale. Utilizarea abuzivă a funcției SOS
          poate duce la suspendarea contului. SatConnect nu garantează disponibilitatea serviciilor de urgență
          în toate zonele.
        </Section>

        <Section title="8. Confidențialitate">
          Datele personale sunt procesate conform Politicii de Confidențialitate și GDPR.
          Mesajele sunt criptate end-to-end. Nu vindem datele personale către terți.
        </Section>

        <Section title="9. Limitarea Responsabilității">
          SatConnect nu garantează conectivitate neîntreruptă. Nu suntem responsabili pentru pierderi
          cauzate de indisponibilitatea serviciului sau de conectivitate limitată în anumite zone.
        </Section>

        <Section title="10. Modificări ale Termenilor">
          Ne rezervăm dreptul de a modifica acești termeni. Veți fi notificat prin aplicație despre
          orice modificare semnificativă. Continuarea utilizării serviciului implică acceptarea noilor termeni.
        </Section>

        <Section title="11. Contact">
          {`Pentru întrebări sau reclamații: support@satconnect.app\nSatConnect SRL, București, România\nCUI: RO12345678`}
        </Section>
      </ScrollView>
    </View>
  );
}

function Section({ title, children }: { title: string; children: string }) {
  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{title}</Text>
      <Text style={styles.sectionText}>{children}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.surface,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 60,
    paddingHorizontal: SPACING.lg,
    paddingBottom: SPACING.md,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
  },
  content: {
    padding: SPACING.lg,
    paddingBottom: SPACING.xxxl,
  },
  date: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textLight,
    marginBottom: SPACING.xl,
  },
  section: {
    marginBottom: SPACING.xl,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.md,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.sm,
  },
  sectionText: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    lineHeight: 22,
  },
});
