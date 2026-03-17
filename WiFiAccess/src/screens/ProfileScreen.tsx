import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SHADOWS, SPACING } from '../constants/theme';

interface ProfileScreenProps {
  onLogout: () => void;
}

export function ProfileScreen({ onLogout }: ProfileScreenProps) {
  const handleLogout = () => {
    Alert.alert('Deconectare', 'Ești sigur că vrei să te deconectezi?', [
      { text: 'Anulează', style: 'cancel' },
      { text: 'Deconectare', style: 'destructive', onPress: onLogout },
    ]);
  };

  const menuItems = [
    {
      section: 'Cont',
      items: [
        { icon: 'person-outline', label: 'Informații personale', action: () => {} },
        { icon: 'card-outline', label: 'Abonament & Plăți', action: () => {} },
        { icon: 'phone-portrait-outline', label: 'Dispozitivele mele', action: () => {} },
      ],
    },
    {
      section: 'Setări',
      items: [
        { icon: 'notifications-outline', label: 'Notificări', action: () => {} },
        { icon: 'globe-outline', label: 'Limbă', action: () => {} },
        { icon: 'moon-outline', label: 'Aspect', action: () => {} },
        { icon: 'shield-outline', label: 'Securitate', action: () => {} },
      ],
    },
    {
      section: 'Suport',
      items: [
        { icon: 'help-circle-outline', label: 'Centru de ajutor', action: () => {} },
        { icon: 'chatbubble-outline', label: 'Contactează-ne', action: () => {} },
        { icon: 'document-text-outline', label: 'Termeni și condiții', action: () => {} },
        { icon: 'lock-closed-outline', label: 'Politică de confidențialitate', action: () => {} },
      ],
    },
  ];

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.avatarContainer}>
          <View style={styles.avatar}>
            <Ionicons name="person" size={40} color={COLORS.white} />
          </View>
          <TouchableOpacity style={styles.editButton}>
            <Ionicons name="camera-outline" size={16} color={COLORS.white} />
          </TouchableOpacity>
        </View>
        <Text style={styles.name}>Utilizator WiFi</Text>
        <Text style={styles.email}>user@wifiaccess.com</Text>

        {/* Plan Badge */}
        <View style={styles.planBadge}>
          <Ionicons name="star" size={14} color={COLORS.warning} />
          <Text style={styles.planText}>Plan Premium</Text>
        </View>
      </View>

      {/* Usage Stats */}
      <View style={styles.usageCard}>
        <View style={styles.usageStat}>
          <Text style={styles.usageValue}>2.4 GB</Text>
          <Text style={styles.usageLabel}>Date folosite</Text>
        </View>
        <View style={styles.usageDivider} />
        <View style={styles.usageStat}>
          <Text style={styles.usageValue}>2/3</Text>
          <Text style={styles.usageLabel}>Dispozitive</Text>
        </View>
        <View style={styles.usageDivider} />
        <View style={styles.usageStat}>
          <Text style={styles.usageValue}>15</Text>
          <Text style={styles.usageLabel}>Zile rămase</Text>
        </View>
      </View>

      {/* Menu Sections */}
      {menuItems.map((section, sIndex) => (
        <View key={sIndex} style={styles.menuSection}>
          <Text style={styles.sectionTitle}>{section.section}</Text>
          <View style={styles.menuCard}>
            {section.items.map((item, iIndex) => (
              <TouchableOpacity
                key={iIndex}
                style={[
                  styles.menuItem,
                  iIndex < section.items.length - 1 && styles.menuItemBorder,
                ]}
                onPress={item.action}
              >
                <View style={styles.menuItemLeft}>
                  <Ionicons
                    name={item.icon as keyof typeof Ionicons.glyphMap}
                    size={20}
                    color={COLORS.textSecondary}
                  />
                  <Text style={styles.menuItemLabel}>{item.label}</Text>
                </View>
                <Ionicons
                  name="chevron-forward"
                  size={18}
                  color={COLORS.gray[400]}
                />
              </TouchableOpacity>
            ))}
          </View>
        </View>
      ))}

      {/* Logout */}
      <TouchableOpacity style={styles.logoutButton} onPress={handleLogout}>
        <Ionicons name="log-out-outline" size={20} color={COLORS.error} />
        <Text style={styles.logoutText}>Deconectează-te</Text>
      </TouchableOpacity>

      {/* Version */}
      <Text style={styles.version}>WiFi Access v1.0.0</Text>

      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.surface,
  },
  header: {
    backgroundColor: COLORS.white,
    paddingTop: 60,
    paddingBottom: SPACING.lg,
    alignItems: 'center',
    borderBottomLeftRadius: RADIUS.xl,
    borderBottomRightRadius: RADIUS.xl,
    ...SHADOWS.sm,
  },
  avatarContainer: {
    position: 'relative',
    marginBottom: SPACING.md,
  },
  avatar: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  editButton: {
    position: 'absolute',
    bottom: 0,
    right: 0,
    width: 28,
    height: 28,
    borderRadius: 14,
    backgroundColor: COLORS.primaryDark,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: COLORS.white,
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
    gap: SPACING.xs,
    backgroundColor: COLORS.warning + '15',
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
    marginTop: SPACING.sm,
  },
  planText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
    color: COLORS.warning,
  },
  usageCard: {
    flexDirection: 'row',
    backgroundColor: COLORS.white,
    marginHorizontal: SPACING.lg,
    marginTop: SPACING.lg,
    borderRadius: RADIUS.lg,
    padding: SPACING.lg,
    ...SHADOWS.sm,
  },
  usageStat: {
    flex: 1,
    alignItems: 'center',
  },
  usageValue: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.primary,
  },
  usageLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 4,
  },
  usageDivider: {
    width: 1,
    backgroundColor: COLORS.border,
  },
  menuSection: {
    paddingHorizontal: SPACING.lg,
    marginTop: SPACING.lg,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.textSecondary,
    marginBottom: SPACING.sm,
    textTransform: 'uppercase',
    letterSpacing: 0.5,
  },
  menuCard: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    ...SHADOWS.sm,
  },
  menuItem: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: SPACING.md,
    paddingHorizontal: SPACING.md,
  },
  menuItemBorder: {
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  menuItemLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.md,
  },
  menuItemLabel: {
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
  },
  logoutButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: SPACING.sm,
    marginHorizontal: SPACING.lg,
    marginTop: SPACING.xl,
    paddingVertical: SPACING.md,
    borderRadius: RADIUS.md,
    backgroundColor: COLORS.error + '10',
    borderWidth: 1,
    borderColor: COLORS.error + '30',
  },
  logoutText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
    color: COLORS.error,
  },
  version: {
    textAlign: 'center',
    fontSize: FONTS.sizes.xs,
    color: COLORS.gray[400],
    marginTop: SPACING.lg,
  },
});
