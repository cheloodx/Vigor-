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
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import { supabaseAuth } from '../services/supabaseAuth';

interface ProfileScreenProps {
  onLogout: () => void;
  onOpenSettings: () => void;
  onOpenTerms: () => void;
  onOpenPrivacy: () => void;
  onOpenContacts: () => void;
}

export function ProfileScreen({ onLogout, onOpenSettings, onOpenTerms, onOpenPrivacy, onOpenContacts }: ProfileScreenProps) {
  const [user, setUser] = useState<{ name?: string; email?: string } | null>(null);

  useEffect(() => {
    const u = supabaseAuth.getUser();
    setUser(u);
  }, []);

  const handleLogout = () => {
    Alert.alert('Deconectare', 'Sigur doriti sa va deconectati?', [
      { text: 'Anuleaza', style: 'cancel' },
      { text: 'Deconectare', style: 'destructive', onPress: onLogout },
    ]);
  };

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      <Text style={styles.screenTitle}>Profil</Text>

      {/* Avatar & Info */}
      <View style={styles.profileCard}>
        <View style={styles.avatarWrap}>
          <MaterialCommunityIcons name="account-circle" size={64} color={COLORS.accent} />
        </View>
        <Text style={styles.userName}>{user?.name || 'Ion Popescu'}</Text>
        <Text style={styles.userEmail}>{user?.email || 'ion@satconnect.app'}</Text>
        <View style={styles.memberBadge}>
          <Text style={styles.memberBadgeText}>EXPLORER</Text>
        </View>
      </View>

      {/* Usage Summary */}
      <View style={styles.usageSummary}>
        <View style={styles.usageStat}>
          <Text style={styles.usageStatValue}>4.2</Text>
          <Text style={styles.usageStatLabel}>GB folosit</Text>
        </View>
        <View style={styles.usageStatDivider} />
        <View style={styles.usageStat}>
          <Text style={styles.usageStatValue}>23</Text>
          <Text style={styles.usageStatLabel}>Zile ramase</Text>
        </View>
        <View style={styles.usageStatDivider} />
        <View style={styles.usageStat}>
          <Text style={styles.usageStatValue}>3</Text>
          <Text style={styles.usageStatLabel}>eSIM-uri</Text>
        </View>
      </View>

      {/* Menu Sections */}
      <Text style={styles.sectionLabel}>Cont</Text>
      <View style={styles.menuSection}>
        <MenuItem icon="account-edit-outline" label="Editeaza profilul" />
        <MenuItem icon="shield-lock-outline" label="Securitate" />
        <MenuItem icon="bell-outline" label="Notificari" />
        <MenuItem icon="credit-card-outline" label="Metode de plata" />
      </View>

      <Text style={styles.sectionLabel}>eSIM</Text>
      <View style={styles.menuSection}>
        <MenuItem icon="sim-outline" label="eSIM-urile mele" />
        <MenuItem icon="history" label="Istoric comenzi" />
        <MenuItem icon="chart-line" label="Utilizare date" />
      </View>

      <Text style={styles.sectionLabel}>Aplicatie</Text>
      <View style={styles.menuSection}>
        <MenuItem icon="cog-outline" label="Setari" onPress={onOpenSettings} />
        <MenuItem icon="account-group-outline" label="Contacte" onPress={onOpenContacts} />
        <MenuItem icon="file-document-outline" label="Termeni & Conditii" onPress={onOpenTerms} />
        <MenuItem icon="shield-check-outline" label="Confidentialitate" onPress={onOpenPrivacy} />
        <MenuItem icon="help-circle-outline" label="Ajutor & FAQ" />
      </View>

      {/* Logout */}
      <TouchableOpacity style={styles.logoutBtn} onPress={handleLogout}>
        <MaterialCommunityIcons name="logout" size={20} color={COLORS.error} />
        <Text style={styles.logoutText}>Deconectare</Text>
      </TouchableOpacity>

      <Text style={styles.version}>SatConnect v1.0.0</Text>
    </ScrollView>
  );
}

function MenuItem({ icon, label, onPress }: { icon: string; label: string; onPress?: () => void }) {
  return (
    <TouchableOpacity style={styles.menuItem} onPress={onPress}>
      <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={20} color={COLORS.textSecondary} />
      <Text style={styles.menuItemText}>{label}</Text>
      <MaterialCommunityIcons name="chevron-right" size={18} color={COLORS.textLight} />
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: 120 },
  screenTitle: { fontSize: FONTS.sizes.xxxl, fontWeight: '800', color: COLORS.text, marginBottom: SPACING.xl, letterSpacing: -0.5 },
  profileCard: { ...GLASS.card, borderRadius: RADIUS.xxl, padding: SPACING.xl, alignItems: 'center', marginBottom: SPACING.xl },
  avatarWrap: { width: 80, height: 80, borderRadius: 40, backgroundColor: 'rgba(0,212,170,0.1)', alignItems: 'center', justifyContent: 'center', marginBottom: SPACING.md },
  userName: { fontSize: FONTS.sizes.xl, fontWeight: '800', color: COLORS.text },
  userEmail: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginTop: 4 },
  memberBadge: { marginTop: SPACING.md, backgroundColor: 'rgba(0,212,170,0.12)', paddingHorizontal: SPACING.md, paddingVertical: 4, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(0,212,170,0.25)' },
  memberBadgeText: { fontSize: 10, fontWeight: '800', color: COLORS.accent, letterSpacing: 1.5 },
  usageSummary: { ...GLASS.panel, borderRadius: RADIUS.xl, padding: SPACING.lg, flexDirection: 'row', alignItems: 'center', marginBottom: SPACING.xl },
  usageStat: { flex: 1, alignItems: 'center' },
  usageStatValue: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  usageStatLabel: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, marginTop: 2 },
  usageStatDivider: { width: 1, height: 32, backgroundColor: 'rgba(255,255,255,0.08)' },
  sectionLabel: { fontSize: FONTS.sizes.sm, fontWeight: '700', color: COLORS.textSecondary, textTransform: 'uppercase', letterSpacing: 1, marginBottom: SPACING.sm, marginTop: SPACING.md },
  menuSection: { ...GLASS.panel, borderRadius: RADIUS.lg, overflow: 'hidden', marginBottom: SPACING.md },
  menuItem: { flexDirection: 'row', alignItems: 'center', padding: SPACING.md, gap: SPACING.md, borderBottomWidth: 0.5, borderBottomColor: 'rgba(255,255,255,0.06)' },
  menuItemText: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text, fontWeight: '500' },
  logoutBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', padding: SPACING.md, gap: SPACING.sm, marginTop: SPACING.xl, borderColor: 'rgba(248,113,113,0.2)' },
  logoutText: { fontSize: FONTS.sizes.md, fontWeight: '600', color: COLORS.error },
  version: { textAlign: 'center', fontSize: FONTS.sizes.xs, color: COLORS.textLight, marginTop: SPACING.lg },
});
