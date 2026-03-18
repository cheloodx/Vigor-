import React, { useState } from 'react';
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
import { MOCK_ESIM_CARDS } from '../constants/data';
import { ESIMCard, ESIMStatus } from '../types';

const STATUS_COLORS: Record<ESIMStatus, string> = {
  active: COLORS.success,
  inactive: COLORS.textLight,
  pending: '#F59E0B',
  expired: COLORS.error,
};

const STATUS_LABELS: Record<ESIMStatus, string> = {
  active: 'Activ',
  inactive: 'Inactiv',
  pending: 'În așteptare',
  expired: 'Expirat',
};

const PLAN_TYPE_LABELS: Record<string, string> = {
  national: 'Național',
  international: 'Internațional',
  global: 'Global',
};

const PLAN_TYPE_ICONS: Record<string, string> = {
  national: 'flag-outline',
  international: 'earth',
  global: 'satellite-variant',
};

export function ESIMScreen() {
  const [cards, setCards] = useState<ESIMCard[]>(MOCK_ESIM_CARDS);
  const [activeCardId, setActiveCardId] = useState<string>('esim-1');

  const handleActivate = (card: ESIMCard) => {
    if (card.status === 'active') {
      Alert.alert(
        'eSIM Activ',
        `Cartela "${card.label}" este deja activă și în uz.`,
        [{ text: 'OK' }]
      );
      return;
    }
    Alert.alert(
      'Activează eSIM',
      `Dorești să activezi "${card.label}"?\n\nAcest plan include ${card.dataLimit} date în ${card.country}.`,
      [
        { text: 'Anulează', style: 'cancel' },
        {
          text: 'Activează',
          onPress: () => {
            setCards((prev) =>
              prev.map((c) => ({
                ...c,
                status: c.id === card.id ? 'active' : c.status === 'active' ? 'inactive' : c.status,
              }))
            );
            setActiveCardId(card.id);
            Alert.alert('Succes!', `eSIM "${card.label}" a fost activat cu succes!`, [{ text: 'OK' }]);
          },
        },
      ]
    );
  };

  const handleAddNew = () => {
    Alert.alert(
      'Adaugă eSIM nou',
      'Scanează codul QR primit de la operator sau introdu manual codul de activare.',
      [
        { text: 'Anulează', style: 'cancel' },
        { text: 'Scanează QR', onPress: () => Alert.alert('Coming soon', 'Scanarea QR va fi disponibilă în curând.') },
        { text: 'Cod manual', onPress: () => Alert.alert('Coming soon', 'Activarea manuală va fi disponibilă în curând.') },
      ]
    );
  };

  const dataProgress = (card: ESIMCard) => card.dataUsedMB / card.dataLimitMB;

  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.content}>
      {/* Header */}
      <View style={styles.header}>
        <View>
          <Text style={styles.title}>eSIM Virtual</Text>
          <Text style={styles.subtitle}>Gestionează cartelele tale digitale</Text>
        </View>
        <TouchableOpacity style={styles.addButton} onPress={handleAddNew}>
          <MaterialCommunityIcons name="plus" size={22} color={COLORS.white} />
        </TouchableOpacity>
      </View>

      {/* Active connection banner */}
      <View style={styles.activeBanner}>
        <MaterialCommunityIcons name="sim-outline" size={20} color={COLORS.accent} />
        <View style={styles.activeBannerText}>
          <Text style={styles.activeBannerTitle}>Conexiune activă</Text>
          <Text style={styles.activeBannerSub}>
            {cards.find((c) => c.id === activeCardId)?.label ?? 'Niciun eSIM activ'}
          </Text>
        </View>
        <View style={styles.activeDot} />
      </View>

      {/* Connectivity modes */}
      <Text style={styles.sectionTitle}>Moduri de conectivitate</Text>
      <View style={styles.modesGrid}>
        <ConnectivityMode icon="wifi" label="WiFi" color={COLORS.success} active />
        <ConnectivityMode icon="signal-cellular-3" label="Date mobile" color={COLORS.info} active />
        <ConnectivityMode icon="earth" label="Roaming EU" color="#F59E0B" active />
        <ConnectivityMode icon="satellite-variant" label="GPS Satelit" color={COLORS.satellite} active />
        <ConnectivityMode icon="sim-outline" label="eSIM" color={COLORS.accent} active />
        <ConnectivityMode icon="map-marker-radius-outline" label="GPS Local" color={COLORS.primary} active />
      </View>

      {/* eSIM Cards */}
      <Text style={styles.sectionTitle}>Cartelele mele eSIM</Text>
      {cards.map((card) => (
        <ESIMCardItem
          key={card.id}
          card={card}
          isSelected={card.id === activeCardId}
          progress={dataProgress(card)}
          onActivate={() => handleActivate(card)}
        />
      ))}

      {/* Add new card */}
      <TouchableOpacity style={styles.addCard} onPress={handleAddNew}>
        <MaterialCommunityIcons name="plus-circle-outline" size={28} color={COLORS.primary} />
        <Text style={styles.addCardText}>Adaugă eSIM nou</Text>
        <Text style={styles.addCardSub}>Scanează QR sau introdu cod manual</Text>
      </TouchableOpacity>

      {/* Info section */}
      <View style={styles.infoBox}>
        <MaterialCommunityIcons name="information-outline" size={18} color={COLORS.primary} />
        <Text style={styles.infoText}>
          eSIM-ul virtual îți permite să ai internet în 175+ țări fără cartelă fizică. Activează planul potrivit pentru destinația ta.
        </Text>
      </View>
    </ScrollView>
  );
}

function ConnectivityMode({ icon, label, color, active }: { icon: string; label: string; color: string; active: boolean }) {
  return (
    <View style={[styles.modeItem, active && { borderColor: color, borderWidth: 1.5 }]}>
      <View style={[styles.modeIcon, { backgroundColor: color + '20' }]}>
        <MaterialCommunityIcons
          name={icon as keyof typeof MaterialCommunityIcons.glyphMap}
          size={20}
          color={color}
        />
      </View>
      <Text style={styles.modeLabel}>{label}</Text>
      {active && (
        <View style={[styles.modeActiveDot, { backgroundColor: color }]} />
      )}
    </View>
  );
}

function ESIMCardItem({
  card,
  isSelected,
  progress,
  onActivate,
}: {
  card: ESIMCard;
  isSelected: boolean;
  progress: number;
  onActivate: () => void;
}) {
  const statusColor = STATUS_COLORS[card.status];

  return (
    <TouchableOpacity
      style={[styles.card, isSelected && styles.cardSelected]}
      onPress={onActivate}
      activeOpacity={0.85}
    >
      {/* Card header */}
      <View style={styles.cardHeader}>
        <View style={styles.cardFlag}>
          <Text style={styles.flagEmoji}>{card.countryFlag}</Text>
        </View>
        <View style={styles.cardInfo}>
          <Text style={styles.cardLabel}>{card.label}</Text>
          <Text style={styles.cardCarrier}>{card.carrier}</Text>
        </View>
        <View style={[styles.statusBadge, { backgroundColor: statusColor + '20' }]}>
          <View style={[styles.statusDot, { backgroundColor: statusColor }]} />
          <Text style={[styles.statusText, { color: statusColor }]}>
            {STATUS_LABELS[card.status]}
          </Text>
        </View>
      </View>

      {/* Plan type */}
      <View style={styles.planTypeRow}>
        <MaterialCommunityIcons
          name={PLAN_TYPE_ICONS[card.planType] as keyof typeof MaterialCommunityIcons.glyphMap}
          size={14}
          color={COLORS.textSecondary}
        />
        <Text style={styles.planTypeText}>
          {PLAN_TYPE_LABELS[card.planType]} • {card.country}
        </Text>
        {card.isRoaming && (
          <View style={styles.roamingBadge}>
            <Text style={styles.roamingText}>ROAMING</Text>
          </View>
        )}
      </View>

      {/* Data usage bar */}
      <View style={styles.dataSection}>
        <View style={styles.dataRow}>
          <Text style={styles.dataLabel}>Date folosite</Text>
          <Text style={styles.dataValue}>
            {card.dataUsed} / {card.dataLimit}
          </Text>
        </View>
        <View style={styles.progressBar}>
          <View
            style={[
              styles.progressFill,
              {
                width: `${Math.min(progress * 100, 100)}%` as `${number}%`,
                backgroundColor: progress > 0.8 ? COLORS.error : progress > 0.6 ? '#F59E0B' : COLORS.accent,
              },
            ]}
          />
        </View>
      </View>

      {/* Footer */}
      <View style={styles.cardFooter}>
        <View style={styles.iccidRow}>
          <MaterialCommunityIcons name="sim-outline" size={12} color={COLORS.textLight} />
          <Text style={styles.iccidText}>
            {card.iccid.slice(0, 8)}...{card.iccid.slice(-4)}
          </Text>
        </View>
        <Text style={styles.validText}>Valabil până: {card.validUntil}</Text>
        <Text style={styles.priceText}>€{card.price}/lună</Text>
      </View>

      {isSelected && (
        <View style={styles.selectedBadge}>
          <MaterialCommunityIcons name="check-circle" size={16} color={COLORS.accent} />
          <Text style={styles.selectedText}>Activ acum</Text>
        </View>
      )}
    </TouchableOpacity>
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
  title: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  subtitle: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    marginTop: 2,
  },
  addButton: {
    width: 44,
    height: 44,
    borderRadius: RADIUS.full,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
    ...SHADOWS.md,
  },
  activeBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.primaryDark,
    borderRadius: RADIUS.xl,
    padding: SPACING.md,
    marginBottom: SPACING.xl,
    gap: SPACING.sm,
  },
  activeBannerText: {
    flex: 1,
  },
  activeBannerTitle: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.gray[400],
    fontWeight: '600',
  },
  activeBannerSub: {
    fontSize: FONTS.sizes.md,
    color: COLORS.white,
    fontWeight: '700',
  },
  activeDot: {
    width: 10,
    height: 10,
    borderRadius: 5,
    backgroundColor: COLORS.success,
  },
  sectionTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
  },
  modesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: SPACING.sm,
    marginBottom: SPACING.xl,
  },
  modeItem: {
    width: '30%',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    padding: SPACING.sm,
    gap: 4,
    borderColor: COLORS.border,
    borderWidth: 1,
    ...SHADOWS.sm,
    position: 'relative',
  },
  modeIcon: {
    width: 40,
    height: 40,
    borderRadius: RADIUS.md,
    alignItems: 'center',
    justifyContent: 'center',
  },
  modeLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.text,
    fontWeight: '600',
    textAlign: 'center',
  },
  modeActiveDot: {
    position: 'absolute',
    top: 6,
    right: 6,
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  card: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.xl,
    padding: SPACING.lg,
    marginBottom: SPACING.md,
    borderWidth: 1.5,
    borderColor: COLORS.border,
    ...SHADOWS.md,
  },
  cardSelected: {
    borderColor: COLORS.accent,
    backgroundColor: '#F0FDFB',
  },
  cardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
    marginBottom: SPACING.sm,
  },
  cardFlag: {
    width: 44,
    height: 44,
    borderRadius: RADIUS.md,
    backgroundColor: COLORS.surface,
    alignItems: 'center',
    justifyContent: 'center',
  },
  flagEmoji: {
    fontSize: 26,
  },
  cardInfo: {
    flex: 1,
  },
  cardLabel: {
    fontSize: FONTS.sizes.md,
    fontWeight: '700',
    color: COLORS.text,
  },
  cardCarrier: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
  statusBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: SPACING.sm,
    paddingVertical: 4,
    borderRadius: RADIUS.full,
  },
  statusDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
  },
  statusText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
  },
  planTypeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginBottom: SPACING.md,
  },
  planTypeText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    flex: 1,
  },
  roamingBadge: {
    backgroundColor: '#FEF3C7',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: RADIUS.sm,
  },
  roamingText: {
    fontSize: 9,
    fontWeight: '800',
    color: '#92400E',
    letterSpacing: 0.5,
  },
  dataSection: {
    marginBottom: SPACING.md,
  },
  dataRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 6,
  },
  dataLabel: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
  dataValue: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '700',
    color: COLORS.text,
  },
  progressBar: {
    height: 6,
    backgroundColor: COLORS.surface,
    borderRadius: RADIUS.full,
    overflow: 'hidden',
  },
  progressFill: {
    height: '100%',
    borderRadius: RADIUS.full,
  },
  cardFooter: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
  },
  iccidRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
    flex: 1,
  },
  iccidText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textLight,
    fontFamily: 'monospace',
  },
  validText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
  priceText: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '700',
    color: COLORS.primary,
  },
  selectedBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: SPACING.sm,
    paddingTop: SPACING.sm,
    borderTopWidth: 1,
    borderTopColor: COLORS.accent + '30',
  },
  selectedText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.accent,
    fontWeight: '700',
  },
  addCard: {
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.xl,
    padding: SPACING.xl,
    marginBottom: SPACING.xl,
    borderWidth: 1.5,
    borderColor: COLORS.primary + '40',
    borderStyle: 'dashed',
    gap: SPACING.xs,
  },
  addCardText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '700',
    color: COLORS.primary,
  },
  addCardSub: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
  },
  infoBox: {
    flexDirection: 'row',
    gap: SPACING.sm,
    backgroundColor: COLORS.primary + '10',
    borderRadius: RADIUS.lg,
    padding: SPACING.md,
    alignItems: 'flex-start',
  },
  infoText: {
    flex: 1,
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    lineHeight: 18,
  },
});
