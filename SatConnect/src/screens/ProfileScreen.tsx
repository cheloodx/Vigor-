import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import { Button } from '../components/Button';
import { MOCK_USAGE, MOCK_CONNECTIVITY } from '../constants/data';
import { supabaseAuth, type AuthUser } from '../services/supabaseAuth';

interface ProfileScreenProps {
  onLogout: () => void;
  onOpenSettings?: () => void;
  onOpenTerms?: () => void;
  onOpenPrivacy?: () => void;
  onOpenContacts?: () => void;
}

interface MenuItem {
  icon: keyof typeof MaterialCommunityIcons.glyphMap;
  label: string;
  value?: string;
  color?: string;
  onPress?: () => void;
}

export function ProfileScreen({ onLogout, onOpenSettings, onOpenTerms, onOpenPrivacy, onOpenContacts }: ProfileScreenProps) {
  const [user, setUser] = useState<AuthUser | null>(null);

  useEffect(() => {
    setUser(supabaseAuth.getUser());
  }, []);

  const displayName = user?.name ?? 'Ion Popescu';
  const displayEmail = user?.email ?? 'ion.popescu@exemplu.com';
  const initials = displayName
    .split(' ')
    .map((w) => w[0])
    .join('')
    .toUpperCase()
    .slice(0, 2) || 'IP';

  const handleLogout = () => {
    Alert.alert(
      'Deconectare',
      'Ești sigur că vrei să te deconectezi? Datele nesincronizate vor fi păstrate local.',
      [
        { text: 'Anulează', style: 'cancel' },
        {
          text: 'Deconectare',
          style: 'destructive',
          onPress: onLogout,
        },
      ]
    );
  };

  const menuSections: { title: string; items: MenuItem[] }[] = [
    {
      title: 'Cont',
      items: [
        { icon: 'account-outline', label: 'Editează profilul' },
        { icon: 'cog-outline', label: 'Setări', onPress: onOpenSettings },
        { icon: 'account-group-outline', label: 'Contacte', onPress: onOpenContacts },
      ],
    },
    {
      title: 'Conectivitate',
      items: [
        {
          icon: 'satellite-variant',
          label: 'Dispozitive satelit',
          value: '0 conectate',
        },
        {
          icon: 'bluetooth',
          label: 'Bluetooth',
          value: 'Dezactivat',
        },
        {
          icon: 'sync',
          label: 'Sincronizare',
          value: `${MOCK_CONNECTIVITY.pendingSync} în așteptare`,
        },
      ],
    },
    {
      title: 'Date & Stocare',
      items: [
        {
          icon: 'database-outline',
          label: 'Date locale',
          value: `${MOCK_USAGE.dataUsedMB} MB folosite`,
        },
        {
          icon: 'arrow-collapse',
          label: 'Compresie date',
          value: 'Activată',
        },
        {
          icon: 'trash-can-outline',
          label: 'Șterge cache-ul',
          color: COLORS.error,
          onPress: () => {
            Alert.alert('Șterge cache', 'Ești sigur? Datele nesincronizate vor fi pierdute.', [
              { text: 'Anulează', style: 'cancel' },
              { text: 'Șterge', style: 'destructive' },
            ]);
          },
        },
      ],
    },
    {
      title: 'Despre',
      items: [
        { icon: 'information-outline', label: 'Versiune', value: '1.0.0 (MVP)' },
        { icon: 'file-document-outline', label: 'Termeni și condiții', onPress: onOpenTerms },
        { icon: 'shield-check-outline', label: 'Politica de confidențialitate', onPress: onOpenPrivacy },
        { icon: 'help-circle-outline', label: 'Ajutor & Suport' },
      ],
    },
  ];

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Profile Header */}
      <View style={styles.profileHeader}>
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{initials}</Text>
        </View>
        <Text style={styles.name}>{displayName}</Text>
        <Text style={styles.email}>{displayEmail}</Text>
        <View style={styles.planBadge}>
          <MaterialCommunityIcons name="star" size={14} color={COLORS.accent} />
          <Text style={styles.planText}>Plan Standard</Text>
        </View>
      </View>

      {/* Usage Summary */}
      <View style={styles.usageSummary}>
        <View style={styles.usageItem}>
          <Text style={styles.usageValue}>{MOCK_USAGE.dataUsedMB}</Text>
          <Text style={styles.usageLabel}>MB folosite</Text>
        </View>
        <View style={styles.usageDivider} />
        <View style={styles.usageItem}>
          <Text style={styles.usageValue}>{MOCK_USAGE.messagesSent}</Text>
          <Text style={styles.usageLabel}>Mesaje</Text>
        </View>
        <View style={styles.usageDivider} />
        <View style={styles.usageItem}>
          <Text style={styles.usageValue}>{MOCK_USAGE.planDaysRemaining}</Text>
          <Text style={styles.usageLabel}>Zile rămase</Text>
        </View>
      </View>

      {/* Menu Sections */}
      {menuSections.map((section) => (
        <View key={section.title} style={styles.section}>
          <Text style={styles.sectionTitle}>{section.title}</Text>
          <View style={styles.menuCard}>
            {section.items.map((item, index) => (
              <TouchableOpacity
                key={item.label}
                style={[
                  styles.menuItem,
                  index < section.items.length - 1 && styles.menuItemBorder,
                ]}
                onPress={item.onPress}
                activeOpacity={0.7}
              >
                <MaterialCommunityIcons
                  name={item.icon}
                  size={22}
                  color={item.color || COLORS.textSecondary}
                />
                <Text style={[styles.menuLabel, item.color ? { color: item.color } : null]}>
                  {item.label}
                </Text>
                {item.value && (
                  <Text style={styles.menuValue}>{item.value}</Text>
                )}
                <MaterialCommunityIcons name="chevron-right" size={20} color={COLORS.textLight} />
              </TouchableOpacity>
            ))}
          </View>
        </View>
      ))}

      {/* Logout */}
      <Button
        title="Deconectează-te"
        onPress={handleLogout}
        variant="danger"
        size="lg"
        icon={<MaterialCommunityIcons name="logout" size={20} color={COLORS.white} />}
        style={styles.logoutButton}
      />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.surface,
  },
  content: {
    paddingBottom: SPACING.xxxl,
  },
  profileHeader: {
    alignItems: 'center',
    paddingTop: 60,
    paddingBottom: SPACING.xl,
    backgroundColor: COLORS.white,
    borderBottomLeftRadius: RADIUS.xl,
    borderBottomRightRadius: RADIUS.xl,
    ...SHADOWS.md,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: SPACING.md,
  },
  avatarText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
  },
  name: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.text,
  },
  email: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  planBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: COLORS.accent + '15',
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
    marginTop: SPACING.sm,
  },
  planText: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.accent,
  },
  usageSummary: {
    flexDirection: 'row',
    backgroundColor: COLORS.white,
    marginHorizontal: SPACING.lg,
    marginTop: SPACING.lg,
    borderRadius: RADIUS.lg,
    padding: SPACING.lg,
    ...SHADOWS.sm,
  },
  usageItem: {
    flex: 1,
    alignItems: 'center',
  },
  usageValue: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '800',
    color: COLORS.primary,
  },
  usageLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  usageDivider: {
    width: 1,
    backgroundColor: COLORS.border,
  },
  section: {
    marginTop: SPACING.xl,
    paddingHorizontal: SPACING.lg,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.textSecondary,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
    marginBottom: SPACING.sm,
    marginLeft: SPACING.xs,
  },
  menuCard: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    ...SHADOWS.sm,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: SPACING.md,
    gap: SPACING.md,
  },
  menuItemBorder: {
    borderBottomWidth: 1,
    borderBottomColor: COLORS.gray[100],
  },
  menuLabel: {
    flex: 1,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
  },
  menuValue: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textLight,
  },
  logoutButton: {
    marginHorizontal: SPACING.lg,
    marginTop: SPACING.xxl,
  },
});
