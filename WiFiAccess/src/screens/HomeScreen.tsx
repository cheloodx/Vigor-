import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SHADOWS, SPACING } from '../constants/theme';
import { STATS, FEATURES, HOTSPOTS } from '../constants/data';
import { StatCard } from '../components/StatCard';
import { FeatureCard } from '../components/FeatureCard';
import { HotspotCard } from '../components/HotspotCard';

interface HomeScreenProps {
  onNavigateToMap: () => void;
  onNavigateToPlans: () => void;
}

export function HomeScreen({ onNavigateToMap, onNavigateToPlans }: HomeScreenProps) {
  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={styles.header}>
        <View style={styles.headerTop}>
          <View>
            <Text style={styles.greeting}>Bună ziua! 👋</Text>
            <Text style={styles.userName}>Bun venit la WiFi Access</Text>
          </View>
          <TouchableOpacity style={styles.notificationButton}>
            <Ionicons name="notifications-outline" size={24} color={COLORS.text} />
            <View style={styles.notificationBadge} />
          </TouchableOpacity>
        </View>

        {/* Connection Status Card */}
        <View style={styles.statusCard}>
          <View style={styles.statusLeft}>
            <View style={styles.statusIconContainer}>
              <Ionicons name="wifi" size={28} color={COLORS.white} />
            </View>
            <View>
              <Text style={styles.statusTitle}>Nu ești conectat</Text>
              <Text style={styles.statusSubtitle}>Găsește un hotspot aproape</Text>
            </View>
          </View>
          <TouchableOpacity style={styles.connectButton} onPress={onNavigateToMap}>
            <Text style={styles.connectButtonText}>Conectează</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Stats */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Statistici globale</Text>
        <View style={styles.statsRow}>
          {STATS.map((stat, index) => (
            <StatCard key={index} value={stat.value} label={stat.label} />
          ))}
        </View>
      </View>

      {/* Quick Actions */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Acțiuni rapide</Text>
        <View style={styles.actionsRow}>
          <TouchableOpacity style={styles.actionCard} onPress={onNavigateToMap}>
            <View style={[styles.actionIcon, { backgroundColor: '#EFF6FF' }]}>
              <Ionicons name="map-outline" size={24} color={COLORS.primary} />
            </View>
            <Text style={styles.actionText}>Hartă</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionCard} onPress={onNavigateToPlans}>
            <View style={[styles.actionIcon, { backgroundColor: '#F0FDF4' }]}>
              <Ionicons name="card-outline" size={24} color={COLORS.success} />
            </View>
            <Text style={styles.actionText}>Planuri</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionCard}>
            <View style={[styles.actionIcon, { backgroundColor: '#FFF7ED' }]}>
              <Ionicons name="settings-outline" size={24} color={COLORS.warning} />
            </View>
            <Text style={styles.actionText}>Setări</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.actionCard}>
            <View style={[styles.actionIcon, { backgroundColor: '#FEF2F2' }]}>
              <Ionicons name="help-circle-outline" size={24} color={COLORS.error} />
            </View>
            <Text style={styles.actionText}>Ajutor</Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Features */}
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>De ce WiFi Access?</Text>
        <View style={styles.featuresGrid}>
          {FEATURES.map((feature, index) => (
            <FeatureCard
              key={index}
              icon={feature.icon as keyof typeof Ionicons.glyphMap}
              title={feature.title}
              description={feature.description}
            />
          ))}
        </View>
      </View>

      {/* Nearby Hotspots */}
      <View style={styles.section}>
        <View style={styles.sectionHeader}>
          <Text style={styles.sectionTitle}>Hotspot-uri apropiate</Text>
          <TouchableOpacity onPress={onNavigateToMap}>
            <Text style={styles.seeAllText}>Vezi toate</Text>
          </TouchableOpacity>
        </View>
        {HOTSPOTS.slice(0, 3).map((hotspot) => (
          <HotspotCard
            key={hotspot.id}
            hotspot={hotspot}
            onPress={() => {}}
          />
        ))}
      </View>

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
    paddingHorizontal: SPACING.lg,
    paddingBottom: SPACING.lg,
    borderBottomLeftRadius: RADIUS.xl,
    borderBottomRightRadius: RADIUS.xl,
    ...SHADOWS.md,
  },
  headerTop: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: SPACING.lg,
  },
  greeting: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
  },
  userName: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.text,
    marginTop: 2,
  },
  notificationButton: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: COLORS.gray[50],
    alignItems: 'center',
    justifyContent: 'center',
  },
  notificationBadge: {
    position: 'absolute',
    top: 10,
    right: 12,
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: COLORS.error,
  },
  statusCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: COLORS.primaryBg,
    borderRadius: RADIUS.lg,
    padding: SPACING.md,
    borderWidth: 1,
    borderColor: COLORS.primary + '30',
  },
  statusLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.md,
  },
  statusIconContainer: {
    width: 48,
    height: 48,
    borderRadius: RADIUS.md,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  statusTitle: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.text,
  },
  statusSubtitle: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  connectButton: {
    backgroundColor: COLORS.primary,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    borderRadius: RADIUS.sm,
  },
  connectButtonText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
  },
  section: {
    paddingHorizontal: SPACING.lg,
    marginTop: SPACING.lg,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  sectionTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
  },
  seeAllText: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.primary,
    fontWeight: '500',
    marginBottom: SPACING.md,
  },
  statsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    gap: SPACING.sm,
  },
  actionsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  actionCard: {
    alignItems: 'center',
    gap: SPACING.sm,
  },
  actionIcon: {
    width: 56,
    height: 56,
    borderRadius: RADIUS.lg,
    alignItems: 'center',
    justifyContent: 'center',
  },
  actionText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '500',
    color: COLORS.text,
  },
  featuresGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'space-between',
  },
});
