import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  Switch,
  TouchableOpacity,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';

interface SettingsScreenProps {
  onBack: () => void;
}

export function SettingsScreen({ onBack }: SettingsScreenProps) {
  const [darkMode, setDarkMode] = useState(true);
  const [notifications, setNotifications] = useState(true);
  const [dataAlerts, setDataAlerts] = useState(true);
  const [roamingAlerts, setRoamingAlerts] = useState(true);
  const [biometric, setBiometric] = useState(false);
  const [autoSync, setAutoSync] = useState(true);
  const [wifiOnly, setWifiOnly] = useState(false);
  const [analytics, setAnalytics] = useState(true);

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Back button */}
      <TouchableOpacity style={styles.backBtn} onPress={onBack}>
        <MaterialCommunityIcons name="arrow-left" size={22} color={COLORS.accent} />
        <Text style={styles.backText}>Inapoi</Text>
      </TouchableOpacity>

      <Text style={styles.screenTitle}>Setari</Text>

      {/* Appearance */}
      <Text style={styles.sectionLabel}>Aparenta</Text>
      <View style={styles.settingsCard}>
        <SettingRow icon="theme-light-dark" label="Mod intunecat" value={darkMode} onToggle={setDarkMode} />
      </View>

      {/* Notifications */}
      <Text style={styles.sectionLabel}>Notificari</Text>
      <View style={styles.settingsCard}>
        <SettingRow icon="bell-outline" label="Notificari push" value={notifications} onToggle={setNotifications} />
        <SettingRow icon="chart-bar" label="Alerte consum date" value={dataAlerts} onToggle={setDataAlerts} />
        <SettingRow icon="airplane" label="Alerte roaming" value={roamingAlerts} onToggle={setRoamingAlerts} />
      </View>

      {/* Security */}
      <Text style={styles.sectionLabel}>Securitate</Text>
      <View style={styles.settingsCard}>
        <SettingRow icon="fingerprint" label="Autentificare biometrica" value={biometric} onToggle={setBiometric} />
        <SettingArrow icon="lock-outline" label="Schimba parola" />
        <SettingArrow icon="two-factor-authentication" label="Autentificare 2FA" />
      </View>

      {/* General */}
      <Text style={styles.sectionLabel}>General</Text>
      <View style={styles.settingsCard}>
        <SettingRow icon="sync" label="Sincronizare automata" value={autoSync} onToggle={setAutoSync} />
        <SettingRow icon="wifi" label="Doar WiFi" value={wifiOnly} onToggle={setWifiOnly} />
        <SettingRow icon="chart-line" label="Analitice" value={analytics} onToggle={setAnalytics} />
      </View>

      {/* About */}
      <Text style={styles.sectionLabel}>Despre</Text>
      <View style={styles.settingsCard}>
        <SettingArrow icon="information-outline" label="Versiune: 1.0.0" />
        <SettingArrow icon="file-document-outline" label="Termeni & Conditii" />
        <SettingArrow icon="shield-check-outline" label="Politica de confidentialitate" />
        <SettingArrow icon="open-source-initiative" label="Licente open source" />
      </View>

      {/* Danger zone */}
      <Text style={styles.sectionLabel}>Zona periculoasa</Text>
      <View style={[styles.settingsCard, { borderColor: 'rgba(248,113,113,0.15)' }]}>
        <TouchableOpacity style={styles.dangerRow}>
          <MaterialCommunityIcons name="trash-can-outline" size={20} color={COLORS.error} />
          <Text style={styles.dangerText}>Sterge contul</Text>
        </TouchableOpacity>
      </View>
    </ScrollView>
  );
}

function SettingRow({ icon, label, value, onToggle }: { icon: string; label: string; value: boolean; onToggle: (v: boolean) => void }) {
  return (
    <View style={styles.settingRow}>
      <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={20} color={COLORS.textSecondary} />
      <Text style={styles.settingLabel}>{label}</Text>
      <Switch
        value={value}
        onValueChange={onToggle}
        trackColor={{ false: 'rgba(255,255,255,0.1)', true: COLORS.accent + '60' }}
        thumbColor={value ? COLORS.accent : COLORS.textLight}
      />
    </View>
  );
}

function SettingArrow({ icon, label }: { icon: string; label: string }) {
  return (
    <TouchableOpacity style={styles.settingRow}>
      <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={20} color={COLORS.textSecondary} />
      <Text style={styles.settingLabel}>{label}</Text>
      <MaterialCommunityIcons name="chevron-right" size={18} color={COLORS.textLight} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: SPACING.xxxl },
  backBtn: { flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: SPACING.lg },
  backText: { fontSize: FONTS.sizes.md, color: COLORS.accent, fontWeight: '600' },
  screenTitle: { fontSize: FONTS.sizes.xxxl, fontWeight: '800', color: COLORS.text, marginBottom: SPACING.xl, letterSpacing: -0.5 },
  sectionLabel: { fontSize: FONTS.sizes.sm, fontWeight: '700', color: COLORS.textSecondary, textTransform: 'uppercase', letterSpacing: 1, marginBottom: SPACING.sm, marginTop: SPACING.lg },
  settingsCard: { ...GLASS.panel, borderRadius: RADIUS.lg, overflow: 'hidden', marginBottom: SPACING.sm },
  settingRow: { flexDirection: 'row', alignItems: 'center', padding: SPACING.md, gap: SPACING.md, borderBottomWidth: 0.5, borderBottomColor: 'rgba(255,255,255,0.06)' },
  settingLabel: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text, fontWeight: '500' },
  dangerRow: { flexDirection: 'row', alignItems: 'center', padding: SPACING.md, gap: SPACING.md },
  dangerText: { fontSize: FONTS.sizes.md, color: COLORS.error, fontWeight: '600' },
});
