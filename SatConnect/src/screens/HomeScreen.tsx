import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  RefreshControl,
  Alert,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS, GLASS } from '../constants/theme';
import { MOCK_USAGE, MOCK_CONNECTIVITY, CONNECTION_TYPE_LABELS, MOCK_ESIM_CARDS } from '../constants/data';
import { ConnectivityBadge } from '../components/ConnectivityBadge';
import { SOSButton } from '../components/SOSButton';
import { ConnectivityState, UsageStats } from '../types';
import { supabaseAuth } from '../services/supabaseAuth';

export function HomeScreen() {
  const [refreshing, setRefreshing] = useState(false);
  const [connectivity] = useState<ConnectivityState>(MOCK_CONNECTIVITY);
  const [usage] = useState<UsageStats>(MOCK_USAGE);
  const [userName, setUserName] = useState('Ion Popescu');
  const [dataAlertShown, setDataAlertShown] = useState(false);

  useEffect(() => {
    const user = supabaseAuth.getUser();
    if (user?.name) {
      setUserName(user.name);
    }
  }, []);

  const onRefresh = () => {
    setRefreshing(true);
    setTimeout(() => setRefreshing(false), 1500);
  };

  const dataProgress = usage.dataUsedMB / usage.dataLimitMB;

  useEffect(() => {
    if (dataAlertShown) return;
    const pct = (usage.dataUsedMB / usage.dataLimitMB) * 100;
    if (pct >= 80) {
      setDataAlertShown(true);
      const rem = ((usage.dataLimitMB - usage.dataUsedMB) / 1024).toFixed(1);
      if (pct >= 100) {
        Alert.alert('Alerta consum date', 'Ai consumat toate datele. Fa upgrade.');
      } else if (pct >= 90) {
        Alert.alert('Alerta consum date', `Ai consumat 90% din date. Mai ai ${rem} GB.`);
      } else {
        Alert.alert('Alerta consum date', `Ai consumat ${Math.round(pct)}% din date. Mai ai ${rem} GB.`);
      }
    }
  }, [usage.dataUsedMB, usage.dataLimitMB, dataAlertShown]);

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.content}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={COLORS.accent} />}
    >
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Buna ziua</Text>
          <Text style={styles.name}>{userName}</Text>
        </View>
        <ConnectivityBadge
          connectionType={connectivity.connectionType}
          signalStrength={connectivity.signalStrength}
          pendingSync={connectivity.pendingSync}
          isSyncing={connectivity.isSyncing}
        />
      </View>

      {/* Connection Status Card - Glass */}
      <View style={styles.connectionCard}>
        <View style={styles.connectionRow}>
          <View style={styles.connectionIconWrap}>
            <MaterialCommunityIcons
              name={connectivity.isConnected ? 'satellite-variant' : 'wifi-off'}
              size={24}
              color={connectivity.isConnected ? COLORS.accent : COLORS.error}
            />
          </View>
          <View style={styles.connectionInfo}>
            <Text style={styles.connectionStatus}>
              {connectivity.isConnected ? 'Conectat' : 'Deconectat'}
            </Text>
            <Text style={styles.connectionType}>
              {CONNECTION_TYPE_LABELS[connectivity.connectionType]} {'\u2022'} {connectivity.signalStrength}% semnal
            </Text>
          </View>
          <View style={[styles.statusDot, {
            backgroundColor: connectivity.isConnected ? COLORS.success : COLORS.error,
          }]} />
        </View>
        {connectivity.pendingSync > 0 && (
          <View style={styles.syncInfo}>
            <MaterialCommunityIcons name="sync" size={14} color={COLORS.warning} />
            <Text style={styles.syncText}>
              {connectivity.pendingSync} elemente in asteptare
            </Text>
          </View>
        )}
        {connectivity.lastSyncAt && (
          <Text style={styles.lastSync}>
            Ultima sincronizare: {new Date(connectivity.lastSyncAt).toLocaleTimeString('ro-RO')}
          </Text>
        )}
      </View>

      {/* Active eSIM Plan Card - Glass */}
      <View style={styles.esimPlanCard}>
        <View style={styles.esimPlanHeader}>
          <View style={styles.esimPlanIconWrap}>
            <MaterialCommunityIcons name="sim-outline" size={20} color={COLORS.accent} />
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.esimPlanTitle}>eSIM Global Plan</Text>
            <Text style={styles.esimPlanSub}>Europa 30+ tari {'\u2022'} Activ</Text>
          </View>
          <View style={styles.esimActiveBadge}>
            <Text style={styles.esimActiveBadgeText}>ACTIV</Text>
          </View>
        </View>
        <View style={styles.esimPlanStats}>
          <View style={styles.esimStatItem}>
            <Text style={styles.esimStatValue}>{(usage.dataUsedMB / 1024).toFixed(1)}</Text>
            <Text style={styles.esimStatUnit}>GB folosit</Text>
          </View>
          <View style={styles.esimStatDivider} />
          <View style={styles.esimStatItem}>
            <Text style={styles.esimStatValue}>{((usage.dataLimitMB - usage.dataUsedMB) / 1024).toFixed(1)}</Text>
            <Text style={styles.esimStatUnit}>GB ramas</Text>
          </View>
          <View style={styles.esimStatDivider} />
          <View style={styles.esimStatItem}>
            <Text style={styles.esimStatValue}>{usage.planDaysRemaining}</Text>
            <Text style={styles.esimStatUnit}>zile</Text>
          </View>
        </View>
        <View style={styles.progressBarBg}>
          <View style={[styles.progressBarFill, { width: `${Math.min(dataProgress * 100, 100)}%` }]} />
        </View>
      </View>

      {/* Connectivity tiles */}
      <Text style={styles.sectionTitle}>Conectivitate</Text>
      <View style={styles.connectivityPanel}>
        <ConnectivityTile icon="wifi" label="WiFi" sublabel="72% semnal" color={COLORS.success} active />
        <ConnectivityTile icon="signal-cellular-3" label="Date mobile" sublabel="175+ tari" color={COLORS.info} active />
        <ConnectivityTile icon="earth" label="Roaming" sublabel="Global" color="#FBBF24" active={connectivity.isRoaming} />
        <ConnectivityTile icon="satellite-variant" label="Satelit" sublabel="GPS" color={COLORS.satellite} active={connectivity.gpsEnabled} beta />
        <ConnectivityTile icon="sim-outline" label="eSIM" sublabel={MOCK_ESIM_CARDS.find((c) => c.iccid === connectivity.activeESIM)?.label ?? 'Inactiv'} color={COLORS.accent} active={!!connectivity.activeESIM} />
        <ConnectivityTile icon="map-marker-radius-outline" label="GPS" sublabel="Activ" color={COLORS.info} active />
      </View>

      {/* SOS Button */}
      <View style={styles.sosSection}>
        <SOSButton onActivate={() => {}} />
      </View>

      {/* Usage Stats - Glass Cards */}
      <Text style={styles.sectionTitle}>Utilizare</Text>
      <View style={styles.usageGrid}>
        <View style={styles.usageRow}>
          <GlassUsageCard icon="cloud-upload-outline" title="Date folosite" value={`${(usage.dataUsedMB / 1024).toFixed(1)} GB`} subtitle={`din ${(usage.dataLimitMB / 1024).toFixed(0)} GB`} progress={dataProgress} color={COLORS.accent} />
          <GlassUsageCard icon="message-text-outline" title="Mesaje" value={`${usage.messagesSent}`} subtitle={`${usage.messagesQueued} in coada`} color={COLORS.info} />
        </View>
        <View style={styles.usageRow}>
          <GlassUsageCard icon="map-marker-outline" title="Locatii" value={`${usage.locationsShared}`} subtitle="partajate" color={COLORS.satellite} />
          <GlassUsageCard icon="calendar-outline" title="Zile ramase" value={`${usage.planDaysRemaining}`} subtitle="plan Explorer" progress={usage.planDaysRemaining / 30} color={COLORS.success} />
        </View>
      </View>

      {/* Quick Actions */}
      <Text style={styles.sectionTitle}>Actiuni rapide</Text>
      <View style={styles.quickActions}>
        <QuickAction icon="message-text-outline" label="Mesaj" color={COLORS.accent} />
        <QuickAction icon="map-marker-outline" label="Locatie" color={COLORS.info} />
        <QuickAction icon="sync" label="Sync" color={COLORS.warning} />
        <QuickAction icon="cog-outline" label="Setari" color={COLORS.textSecondary} />
      </View>
    </ScrollView>
  );
}

function ConnectivityTile({ icon, label, sublabel, color, active, beta }: { icon: string; label: string; sublabel: string; color: string; active: boolean; beta?: boolean }) {
  return (
    <View style={[styles.connectivityTile, active && { borderColor: color + '40' }]}>
      <View style={[styles.connectivityTileIcon, { backgroundColor: color + '15' }]}>
        <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={18} color={active ? color : COLORS.textLight} />
      </View>
      <Text style={[styles.connectivityTileLabel, { color: active ? COLORS.text : COLORS.textLight }]}>{label}</Text>
      <Text style={styles.connectivityTileSub}>{sublabel}</Text>
      {active && <View style={[styles.connectivityActiveDot, { backgroundColor: color }]} />}
      {beta && (
        <View style={styles.betaBadge}>
          <Text style={styles.betaBadgeText}>BETA</Text>
        </View>
      )}
    </View>
  );
}

function GlassUsageCard({ icon, title, value, subtitle, progress, color }: { icon: string; title: string; value: string; subtitle?: string; progress?: number; color: string }) {
  return (
    <View style={styles.glassUsageCard}>
      <View style={styles.glassUsageHeader}>
        <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={18} color={color} />
        <Text style={styles.glassUsageTitle}>{title}</Text>
      </View>
      <Text style={[styles.glassUsageValue, { color }]}>{value}</Text>
      {subtitle && <Text style={styles.glassUsageSub}>{subtitle}</Text>}
      {progress !== undefined && (
        <View style={styles.miniProgressBg}>
          <View style={[styles.miniProgressFill, { width: `${Math.min(progress * 100, 100)}%`, backgroundColor: color }]} />
        </View>
      )}
    </View>
  );
}

function QuickAction({ icon, label, color }: { icon: string; label: string; color: string }) {
  return (
    <View style={styles.quickAction}>
      <View style={[styles.quickActionIcon, { backgroundColor: color + '15' }]}>
        <MaterialCommunityIcons name={icon as keyof typeof MaterialCommunityIcons.glyphMap} size={22} color={color} />
      </View>
      <Text style={styles.quickActionLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  content: { paddingHorizontal: SPACING.lg, paddingTop: 60, paddingBottom: SPACING.xxxl },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: SPACING.xl },
  greeting: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, letterSpacing: 0.5 },
  name: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text, letterSpacing: -0.5 },
  connectionCard: { ...GLASS.card, borderRadius: RADIUS.xl, padding: SPACING.lg, marginBottom: SPACING.lg },
  connectionRow: { flexDirection: 'row', alignItems: 'center', gap: SPACING.md },
  connectionIconWrap: { width: 44, height: 44, borderRadius: RADIUS.md, backgroundColor: 'rgba(0,212,170,0.12)', alignItems: 'center', justifyContent: 'center' },
  connectionInfo: { flex: 1 },
  connectionStatus: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text },
  connectionType: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginTop: 2 },
  statusDot: { width: 10, height: 10, borderRadius: 5 },
  syncInfo: { flexDirection: 'row', alignItems: 'center', gap: 6, marginTop: SPACING.sm, backgroundColor: 'rgba(251,191,36,0.08)', paddingHorizontal: SPACING.sm, paddingVertical: SPACING.xs, borderRadius: RADIUS.sm },
  syncText: { fontSize: FONTS.sizes.xs, color: COLORS.warning },
  lastSync: { fontSize: FONTS.sizes.xs, color: COLORS.textLight, marginTop: SPACING.xs },
  esimPlanCard: { ...GLASS.card, borderRadius: RADIUS.xl, padding: SPACING.lg, marginBottom: SPACING.xl },
  esimPlanHeader: { flexDirection: 'row', alignItems: 'center', gap: SPACING.md, marginBottom: SPACING.lg },
  esimPlanIconWrap: { width: 40, height: 40, borderRadius: RADIUS.md, backgroundColor: 'rgba(0,212,170,0.12)', alignItems: 'center', justifyContent: 'center' },
  esimPlanTitle: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text },
  esimPlanSub: { fontSize: FONTS.sizes.sm, color: COLORS.textSecondary, marginTop: 1 },
  esimActiveBadge: { backgroundColor: 'rgba(52,211,153,0.15)', paddingHorizontal: SPACING.sm, paddingVertical: 3, borderRadius: RADIUS.full, borderWidth: 1, borderColor: 'rgba(52,211,153,0.3)' },
  esimActiveBadgeText: { fontSize: 10, fontWeight: '700', color: COLORS.success, letterSpacing: 1 },
  esimPlanStats: { flexDirection: 'row', alignItems: 'center', justifyContent: 'space-around', marginBottom: SPACING.md },
  esimStatItem: { alignItems: 'center', flex: 1 },
  esimStatValue: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text },
  esimStatUnit: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, marginTop: 2 },
  esimStatDivider: { width: 1, height: 32, backgroundColor: 'rgba(255,255,255,0.08)' },
  progressBarBg: { height: 4, backgroundColor: 'rgba(255,255,255,0.06)', borderRadius: 2, overflow: 'hidden' },
  progressBarFill: { height: 4, backgroundColor: COLORS.accent, borderRadius: 2 },
  sectionTitle: { fontSize: FONTS.sizes.lg, fontWeight: '700', color: COLORS.text, marginBottom: SPACING.md, letterSpacing: -0.3 },
  connectivityPanel: { flexDirection: 'row', flexWrap: 'wrap', gap: SPACING.sm, marginBottom: SPACING.xl },
  connectivityTile: { width: '30%', alignItems: 'center', ...GLASS.panel, borderRadius: RADIUS.lg, padding: SPACING.sm, paddingVertical: SPACING.md, gap: 4, position: 'relative' as const },
  connectivityTileIcon: { width: 36, height: 36, borderRadius: RADIUS.md, alignItems: 'center', justifyContent: 'center' },
  connectivityTileLabel: { fontSize: FONTS.sizes.xs, fontWeight: '700', textAlign: 'center' },
  connectivityTileSub: { fontSize: 9, color: COLORS.textLight, textAlign: 'center' },
  connectivityActiveDot: { position: 'absolute' as const, top: 6, right: 6, width: 6, height: 6, borderRadius: 3 },
  betaBadge: { position: 'absolute' as const, top: 4, left: 4, backgroundColor: 'rgba(167,139,250,0.2)', paddingHorizontal: 4, paddingVertical: 1, borderRadius: 4, borderWidth: 0.5, borderColor: 'rgba(167,139,250,0.4)' },
  betaBadgeText: { fontSize: 7, fontWeight: '800', color: COLORS.satellite, letterSpacing: 0.5 },
  sosSection: { alignItems: 'center', marginBottom: SPACING.xxl, paddingVertical: SPACING.md },
  usageGrid: { gap: SPACING.sm, marginBottom: SPACING.xl },
  usageRow: { flexDirection: 'row', gap: SPACING.sm },
  glassUsageCard: { flex: 1, ...GLASS.panel, borderRadius: RADIUS.lg, padding: SPACING.md },
  glassUsageHeader: { flexDirection: 'row', alignItems: 'center', gap: 6, marginBottom: SPACING.sm },
  glassUsageTitle: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, fontWeight: '600' },
  glassUsageValue: { fontSize: FONTS.sizes.xxl, fontWeight: '800', letterSpacing: -0.5 },
  glassUsageSub: { fontSize: FONTS.sizes.xs, color: COLORS.textLight, marginTop: 2 },
  miniProgressBg: { height: 3, backgroundColor: 'rgba(255,255,255,0.06)', borderRadius: 2, marginTop: SPACING.sm, overflow: 'hidden' },
  miniProgressFill: { height: 3, borderRadius: 2 },
  quickActions: { flexDirection: 'row', justifyContent: 'space-between' },
  quickAction: { alignItems: 'center', gap: SPACING.xs },
  quickActionIcon: { width: 52, height: 52, borderRadius: RADIUS.lg, alignItems: 'center', justifyContent: 'center' },
  quickActionLabel: { fontSize: FONTS.sizes.xs, color: COLORS.textSecondary, textAlign: 'center', fontWeight: '500' },
});
