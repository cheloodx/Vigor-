import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, SPACING, GLASS } from '../constants/theme';

interface PrivacyScreenProps {
  onBack: () => void;
}

export function PrivacyScreen({ onBack }: PrivacyScreenProps) {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <TouchableOpacity onPress={onBack} style={styles.backButton}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={COLORS.text} />
        </TouchableOpacity>
        <Text style={styles.title}>Politica de Confidențialitate</Text>
        <View style={{ width: 40 }} />
      </View>

      <ScrollView contentContainerStyle={styles.content}>
        <Text style={styles.date}>Ultima actualizare: 19 martie 2026</Text>

        <Section title="1. Introducere">
          SatConnect respectă confidențialitatea datelor dumneavoastră. Această politică descrie modul
          în care colectăm, utilizăm și protejăm informațiile personale conform Regulamentului General
          privind Protecția Datelor (GDPR).
        </Section>

        <Section title="2. Date Colectate">
          Colectăm: numele și adresa de email (la înregistrare), date de localizare GPS (când tracking-ul
          este activ), mesajele trimise (criptate end-to-end), date de utilizare a serviciului (pentru
          facturare), informații despre dispozitiv și conexiune (pentru optimizare).
        </Section>

        <Section title="3. Scopul Procesării">
          Datele sunt utilizate pentru: furnizarea serviciilor de conectivitate, procesarea plăților și
          abonamentelor, îmbunătățirea serviciului, comunicări legate de cont, funcția SOS de urgență.
        </Section>

        <Section title="4. Criptare și Securitate">
          Toate mesajele sunt criptate end-to-end. Datele de localizare sunt criptate în tranzit și
          în repaus. Utilizăm protocoale de securitate standard industrial (TLS 1.3, AES-256).
          Accesul la date este limitat strict la personalul autorizat.
        </Section>

        <Section title="5. Date Offline">
          Datele stocate offline pe dispozitiv sunt protejate de mecanismele de securitate ale sistemului
          de operare. Sincronizarea se face doar pe conexiuni criptate. Datele locale pot fi șterse
          oricând din setările aplicației.
        </Section>

        <Section title="6. Partajare cu Terți">
          Nu vindem datele personale. Partajăm date doar cu: operatori telecom (pentru eSIM și roaming),
          servicii de urgență (la activarea SOS), Apple (pentru procesarea plăților), servicii de
          infrastructură (pentru hosting și securitate).
        </Section>

        <Section title="7. Drepturile Dumneavoastră (GDPR)">
          Aveți dreptul la: acces la datele personale, rectificarea datelor incorecte, ștergerea datelor
          (dreptul de a fi uitat), portabilitatea datelor, restricționarea procesării, obiecție la
          procesare, retragerea consimțământului.
        </Section>

        <Section title="8. Retenția Datelor">
          Datele contului sunt păstrate pe durata existenței contului. Mesajele sunt șterse automat
          după 90 de zile. Datele de localizare sunt păstrate 30 de zile. Datele de facturare sunt
          păstrate conform obligațiilor legale (5 ani).
        </Section>

        <Section title="9. Cookie-uri și Tracking">
          Aplicația mobilă nu utilizează cookie-uri. Colectăm date anonime de performanță pentru
          îmbunătățirea serviciului. Puteți dezactiva analytics-ul din setările aplicației.
        </Section>

        <Section title="10. Transferuri Internaționale">
          Datele pot fi transferate în afara UE/SEE pentru furnizarea serviciilor de roaming global.
          Transferurile sunt protejate prin clauze contractuale standard aprobate de Comisia Europeană.
        </Section>

        <Section title="11. Contact DPO">
          {`Responsabil Protecția Datelor: dpo@satconnect.app\nSatConnect SRL, București, România\nAutoritate de supraveghere: ANSPDCP (www.dataprotection.ro)`}
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
