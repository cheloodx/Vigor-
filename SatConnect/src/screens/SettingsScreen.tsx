import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Switch,
  Alert,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import { useTheme } from '../contexts/ThemeContext';
import { useLanguage } from '../i18n/LanguageContext';
import { Language, LANGUAGE_NAMES } from '../i18n/translations';

interface SettingsScreenProps {
  onBack: () => void;
}

export function SettingsScreen({ onBack }: SettingsScreenProps) {
  const { isDark, colors, toggleTheme } = useTheme();
  const { language, t, setLanguage } = useLanguage();

  const [pushEnabled, setPushEnabled] = useState(true);
  const [sosEnabled, setSosEnabled] = useState(true);
  const [dataAlertEnabled, setDataAlertEnabled] = useState(true);
  const [biometricEnabled, setBiometricEnabled] = useState(false);
  const [autoLockEnabled, setAutoLockEnabled] = useState(true);
  const [autoSyncEnabled, setAutoSyncEnabled] = useState(true);
  const [compressionEnabled, setCompressionEnabled] = useState(true);
  const [wifiOnlyEnabled, setWifiOnlyEnabled] = useState(false);

  const handleLanguageChange = () => {
    const languages: Language[] = ['ro', 'en'];
    const currentIndex = languages.indexOf(language);
    const nextLanguage = languages[(currentIndex + 1) % languages.length];
    setLanguage(nextLanguage);
  };

  const bg = isDark ? colors.card : COLORS.white;
  const surfaceBg = isDark ? colors.surface : COLORS.surface;
  const textColor = isDark ? colors.text : COLORS.text;
  const secondaryText = isDark ? colors.textSecondary : COLORS.textSecondary;
  const borderColor = isDark ? colors.border : COLORS.gray[100];

  return (
    <ScrollView style={[styles.container, { backgroundColor: surfaceBg }]} contentContainerStyle={styles.content}>
      <View style={styles.header}>
        <TouchableOpacity onPress={onBack} style={styles.backButton}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={textColor} />
        </TouchableOpacity>
        <Text style={[styles.title, { color: textColor }]}>{t.settingsTitle}</Text>
        <View style={{ width: 40 }} />
      </View>

      {/* Appearance */}
      <Text style={[styles.sectionTitle, { color: secondaryText }]}>{t.appearance}</Text>
      <View style={[styles.card, { backgroundColor: bg }]}>
        <SettingRow
          icon="theme-light-dark"
          label={t.darkMode}
          description={t.darkModeDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={isDark}
              onValueChange={toggleTheme}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
        <SettingRow
          icon="translate"
          label={t.language}
          description={t.languageDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          right={
            <TouchableOpacity onPress={handleLanguageChange} style={[styles.langBadge, { backgroundColor: COLORS.accent + '20' }]}>
              <Text style={styles.langText}>{LANGUAGE_NAMES[language]}</Text>
            </TouchableOpacity>
          }
        />
      </View>

      {/* Notifications */}
      <Text style={[styles.sectionTitle, { color: secondaryText }]}>{t.notificationsSettings}</Text>
      <View style={[styles.card, { backgroundColor: bg }]}>
        <SettingRow
          icon="bell-outline"
          label={t.pushNotifications}
          description={t.pushNotificationsDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={pushEnabled}
              onValueChange={setPushEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
        <SettingRow
          icon="alert-circle-outline"
          label={t.sosAlerts}
          description={t.sosAlertsDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={sosEnabled}
              onValueChange={() => {
                Alert.alert(t.sosAlerts, t.sosAlertsDesc);
              }}
              trackColor={{ false: COLORS.gray[300], true: COLORS.success }}
              thumbColor={COLORS.white}
              disabled
            />
          }
        />
        <SettingRow
          icon="chart-line"
          label={t.dataAlerts}
          description={t.dataAlertsDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          right={
            <Switch
              value={dataAlertEnabled}
              onValueChange={setDataAlertEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
      </View>

      {/* Security */}
      <Text style={[styles.sectionTitle, { color: secondaryText }]}>{t.securitySettings}</Text>
      <View style={[styles.card, { backgroundColor: bg }]}>
        <SettingRow
          icon="fingerprint"
          label={t.biometricLogin}
          description={t.biometricDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={biometricEnabled}
              onValueChange={setBiometricEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
        <SettingRow
          icon="lock-clock"
          label={t.autoLock}
          description={t.autoLockDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          right={
            <Switch
              value={autoLockEnabled}
              onValueChange={setAutoLockEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
      </View>

      {/* General */}
      <Text style={[styles.sectionTitle, { color: secondaryText }]}>{t.generalSettings}</Text>
      <View style={[styles.card, { backgroundColor: bg }]}>
        <SettingRow
          icon="sync"
          label={t.autoSync}
          description={t.autoSyncDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={autoSyncEnabled}
              onValueChange={setAutoSyncEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
        <SettingRow
          icon="arrow-collapse"
          label={t.dataCompressor}
          description={t.dataCompressorDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          showBorder
          right={
            <Switch
              value={compressionEnabled}
              onValueChange={setCompressionEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
        <SettingRow
          icon="wifi"
          label={t.wifiOnly}
          description={t.wifiOnlyDesc}
          textColor={textColor}
          secondaryText={secondaryText}
          borderColor={borderColor}
          right={
            <Switch
              value={wifiOnlyEnabled}
              onValueChange={setWifiOnlyEnabled}
              trackColor={{ false: COLORS.gray[300], true: COLORS.accent }}
              thumbColor={COLORS.white}
            />
          }
        />
      </View>
    </ScrollView>
  );
}

function SettingRow({
  icon,
  label,
  description,
  right,
  showBorder,
  textColor,
  secondaryText,
  borderColor,
}: {
  icon: string;
  label: string;
  description: string;
  right: React.ReactNode;
  showBorder?: boolean;
  textColor: string;
  secondaryText: string;
  borderColor: string;
}) {
  return (
    <View style={[styles.settingRow, showBorder && { borderBottomWidth: 1, borderBottomColor: borderColor }]}>
      <MaterialCommunityIcons
        name={icon as keyof typeof MaterialCommunityIcons.glyphMap}
        size={22}
        color={secondaryText}
      />
      <View style={styles.settingInfo}>
        <Text style={[styles.settingLabel, { color: textColor }]}>{label}</Text>
        <Text style={[styles.settingDesc, { color: secondaryText }]}>{description}</Text>
      </View>
      {right}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    paddingBottom: SPACING.xxxl,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingTop: 60,
    paddingHorizontal: SPACING.lg,
    paddingBottom: SPACING.lg,
  },
  backButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    alignItems: 'center',
    justifyContent: 'center',
  },
  title: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '800',
  },
  sectionTitle: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginLeft: SPACING.xl,
    marginTop: SPACING.xl,
    marginBottom: SPACING.sm,
  },
  card: {
    marginHorizontal: SPACING.lg,
    borderRadius: RADIUS.lg,
    ...SHADOWS.sm,
  },
  settingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: SPACING.md,
    gap: SPACING.md,
  },
  settingInfo: {
    flex: 1,
  },
  settingLabel: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
  },
  settingDesc: {
    fontSize: FONTS.sizes.xs,
    marginTop: 2,
  },
  langBadge: {
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  langText: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.accent,
  },
});
