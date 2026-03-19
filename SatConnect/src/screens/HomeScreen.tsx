import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  RefreshControl,
  TouchableOpacity,
  Alert,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import { MOCK_USAGE, MOCK_CONNECTIVITY, CONNECTION_TYPE_LABELS, MOCK_ESIM_CARDS } from '../constants/data';
import { ConnectivityBadge } from '../components/ConnectivityBadge';
import { UsageCard } from '../components/UsageCard';
import { SOSButton } from '../components/SOSButton';
import { ConnectivityState, UsageStats } from '../types';

export function HomeScreen() {
  const [refreshing, setRefreshing] = useState(false);
  const [connectivity] = useState<ConnectivityState>(MOCK_CONNECTIVITY);
  const [usage] = useState<UsageStats>(MOCK_USAGE);

  const [dataAlertShown, setDataAlertShown] = useState(false);

  const onRefresh = () => {
    setRefreshing(true);
    setTimeout(() => setRefreshing(false), 1500);
  };

  const dataProgress = usage.dataUsedMB / usage.dataLimitMB;

  // Data usage alert
  useEffect(() => {
    if (dataAlertShown) return;
    const percentage = (usage.dataUsedMB / usage.dataLimitMB) * 100;
    if (percentage >= 80) {
      setDataAlertShown(true);
      const remaining = ((usage.dataLimitMB - usage.dataUsedMB) / 1024).toFixed(1);
      if (percentage >= 100) {
        Alert.alert(
          'Alert\u0103 consum date',
          'Ai consumat toate datele planului t\u0103u. F\u0103 upgrade pentru a continua.',
        );
      } else if (percentage >= 90) {
        Alert.alert(
          'Alert\u0103 consum date',
          `Ai consumat 90% din date. Mai ai ${remaining} GB disponibil. Consider\u0103 upgrade-ul.`,
        );
      } else {
        Alert.alert(
          'Alert\u0103 consum date',
          `Ai consumat ${Math.round(percentage)}% din date. Mai ai ${remaining} GB disponibil.`,
        );
      }
    }
  }, [usage.dataUsedMB, usage.dataLimitMB, dataAlertShown]);

  return (
    <ScrollView
      style={styles.container}
      contentContainerStyle={styles.content}
      refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} tintColor={COLORS.primary} />}
    >
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.greeting}>Bună ziua!</Text>
          <Text style={styles.name}>Ion Popescu</Text>
        </View>
        <ConnectivityBadge
          connectionType={connectivity.connectionType}
          signalStrength={connectivity.signalStrength}
          pendingSync={connectivity.pendingSync}
          isSyncing={connectivity.isSyncing}
        />
      </View>

      {/* Connection Status Card */}
      <View style={styles.connectionCard}>
        <View style={styles.connectionRow}>
          <MaterialCommunityIcons
            name={connectivity.isConnected ? 'satellite-variant' : 'wifi-off'}
            size={28}
            color={connectivity.isConnected ? COLORS.accent : COLORS.error}
          />
          <View style={styles.connectionInfo}>
            <Text style={styles.connectionStatus}>
              {connectivity.isConnected ? 'Conectat' : 'Deconectat'}
            </Text>
            <Text style={styles.connectionType}>
              {CONNECTION_TYPE_LABELS[connectivity.connectionType]} • {connectivity.signalStrength}% semnal
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
              {connectivity.pendingSync} elemente în așteptare
            </Text>
          </View>
        )}
        {connectivity.lastSyncAt && (
          <Text style={styles.lastSync}>
            Ultima sincronizare: {new Date(connectivity.lastSyncAt).toLocaleTimeString('ro-RO')}
          </Text>
        )}
      </View>

      {/* Multi-connectivity panel */}
      <Text style={styles.sectionTitle}>Conectivitate activă</Text>
      <View style={styles.connectivityPanel}>
        <ConnectivityTile icon="wifi" label="WiFi" sublabel="72% semnal" color={COLORS.success} active />
        <ConnectivityTile icon="signal-cellular-3" label="Date mobile" sublabel="175 țări" color={COLORS.info} active />
        <ConnectivityTile icon="earth" label="Roaming Global" sublabel="175 țări" color="#F59E0B" active={connectivity.isRoaming} />
        <ConnectivityTile icon="satellite-variant" label="GPS Satelit" sublabel={connectivity.gpsAccuracy ? `±${connectivity.gpsAccuracy}m` : 'Activ'} color={COLORS.satellite} active={connectivity.gpsEnabled} />
        <ConnectivityTile icon="sim-outline" label="eSIM" sublabel={MOCK_ESIM_CARDS.find((c) => c.iccid === connectivity.activeESIM)?.label ?? 'Inactiv'} color={COLORS.accent} active={!!connectivity.activeESIM} />
        <ConnectivityTile icon="map-marker-radius-outline" label="GPS Local" sublabel="Activ" color={COLORS.primary} active />
      </View>

      {/* SOS Button */}
      <View style={styles.sosSection}>
        <SOSButton onActivate={() => {}} />
      </View>

      {/* Usage Stats */}
      <Text style={styles.sectionTitle}>Utilizare</Text>
      <View style={styles.usageGrid}>
        <View style={styles.usageRow}>
          <View style={styles.usageItem}>
            <UsageCard
              icon="cloud-upload-outline"
              title="Date folosite"
              value={`${(usage.dataUsedMB / 1024).toFixed(1)} GB`}
              subtitle={`din ${(usage.dataLimitMB / 1024).toFixed(0)} GB`}
              progress={dataProgress}
              color={COLORS.primary}
            />
          </View>
          <View style={styles.usageItem}>
            <UsageCard
              icon="chatbubble-outline"
              title="Mesaje trimise"
              value={`${usage.messagesSent}`}
              subtitle={`${usage.messagesQueued} în coadă`}
              color={COLORS.accent}
            />
          </View>
        </View>
        <View style={styles.usageRow}>
          <View style={styles.usageItem}>
            <UsageCard
              icon="location-outline"
              title="Locații partajate"
              value={`${usage.locationsShared}`}
              color={COLORS.info}
            />
          </View>
          <View style={styles.usageItem}>
            <UsageCard
              icon="calendar-outline"
              title="Zile rămase"
              value={`${usage.planDaysRemaining}`}
              subtitle="plan Explorer"
              progress={usage.planDaysRemaining / 30}
              color={COLORS.success}
            />
          </View>
        </View>
      </View>

      {/* Quick Actions */}
      <Text style={styles.sectionTitle}>Acțiuni rapide</Text>
      <View style={styles.quickActions}>
        <QuickAction icon="message-text-outline" label="Mesaj nou" color={COLORS.primary} />
        <QuickAction icon="map-marker-outline" label="Trimite locația" color={COLORS.info} />
        <QuickAction icon="sync" label="Sincronizează" color={COLORS.accent} />
        <QuickAction icon="cog-outline" label="Setări" color={COLORS.textSecondary} />
      </View>
    </ScrollView>
  );
}

function ConnectivityTile({ icon, label, sublabel, color, active }: { icon: string; label: string; sublabel: string; color: string; active: boolean }) {
  return (
    <View style={[styles.connectivityTile, active && { borderColor: color, borderWidth: 1.5 }]}>
      <View style={[styles.connectivityTileIcon, { backgroundColor: color + '20' }]}>
        <MaterialCommunityIcons
          name={icon as keyof typeof MaterialCommunityIcons.glyphMap}
          size={18}
          color={active ? color : COLORS.textLight}
        />
      </View>
      <Text style={[styles.connectivityTileLabel, { color: active ? COLORS.text : COLORS.textLight }]}>{label}</Text>
      <Text style={styles.connectivityTileSub}>{sublabel}</Text>
      {active && <View style={[styles.connectivityActiveDot, { backgroundColor: color }]} />}
    </View>
  );
}

function QuickAction({ icon, label, color }: { icon: string; label: string; color: string }) {
  return (
    <View style={styles.quickAction}>
      <View style={[styles.quickActionIcon, { backgroundColor: color + '15' }]}>
        <MaterialCommunityIcons
          name={icon as keyof typeof MaterialCommunityIcons.glyphMap}
          size={24}
          color={color}
        />
      </View>
      <Text style={styles.quickActionLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.surface,
  },
  content: {
    paddingHorizontal: SPACING.lg,
    paddingTop: 60,
    paddingBottom: SPACING.xxxl,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: SPACING.xl,
  },
  greeting: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
  },
  name: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  connectionCard: {
    backgroundColor: COLORS.primaryDark,
    borderRadius: RADIUS.xl,
    padding: SPACING.lg,
    marginBottom: SPACING.xl,
  },
  connectionRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.md,
  },
  connectionInfo: {
    flex: 1,
  },
  connectionStatus: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.white,
  },
  connectionType: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.gray[300],
  },
  statusDot: {
    width: 12,
    height: 12,
    borderRadius: 6,
  },
  syncInfo: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginTop: SPACING.sm,
    backgroundColor: 'rgba(255,255,255,0.1)',
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.sm,
  },
  syncText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.warning,
  },
  lastSync: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.gray[400],
    marginTop: SPACING.xs,
  },
  sosSection: {
    alignItems: 'center',
    marginBottom: SPACING.xxl,
    paddingVertical: SPACING.lg,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
  },
  usageGrid: {
    gap: SPACING.md,
    marginBottom: SPACING.xl,
  },
  usageRow: {
    flexDirection: 'row',
    gap: SPACING.md,
  },
  usageItem: {
    flex: 1,
  },
  connectivityPanel: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: SPACING.sm,
    marginBottom: SPACING.xl,
  },
  connectivityTile: {
    width: '30%',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    padding: SPACING.sm,
    gap: 3,
    borderColor: COLORS.border,
    borderWidth: 1,
    ...SHADOWS.sm,
    position: 'relative',
  },
  connectivityTileIcon: {
    width: 36,
    height: 36,
    borderRadius: RADIUS.md,
    alignItems: 'center',
    justifyContent: 'center',
  },
  connectivityTileLabel: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
    textAlign: 'center',
  },
  connectivityTileSub: {
    fontSize: 9,
    color: COLORS.textLight,
    textAlign: 'center',
  },
  connectivityActiveDot: {
    position: 'absolute',
    top: 5,
    right: 5,
    width: 7,
    height: 7,
    borderRadius: 4,
  },
  quickActions: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  quickAction: {
    alignItems: 'center',
    gap: SPACING.xs,
  },
  quickActionIcon: {
    width: 56,
    height: 56,
    borderRadius: RADIUS.lg,
    alignItems: 'center',
    justifyContent: 'center',
  },
  quickActionLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    textAlign: 'center',
  },
});
