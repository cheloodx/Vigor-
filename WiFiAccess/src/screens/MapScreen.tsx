import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  TextInput,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SHADOWS, SPACING } from '../constants/theme';
import { HOTSPOTS } from '../constants/data';
import { HotspotCard } from '../components/HotspotCard';
import { Hotspot } from '../types';

export function MapScreen() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedFilter, setSelectedFilter] = useState<'all' | 'premium' | 'basic'>('all');
  const [selectedHotspot, setSelectedHotspot] = useState<Hotspot | null>(null);

  const filters = [
    { key: 'all' as const, label: 'Toate' },
    { key: 'premium' as const, label: 'Premium' },
    { key: 'basic' as const, label: 'Basic' },
  ];

  const filteredHotspots = HOTSPOTS.filter((h) => {
    const matchesSearch = h.name.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesFilter = selectedFilter === 'all' || h.type === selectedFilter;
    return matchesSearch && matchesFilter;
  });

  const handleSelectHotspot = (hotspot: Hotspot) => {
    setSelectedHotspot(hotspot);
  };

  return (
    <View style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Hotspot-uri WiFi</Text>
        <Text style={styles.headerSubtitle}>Găsește hotspot-uri în apropiere</Text>
      </View>

      {/* Map Placeholder */}
      <View style={styles.mapContainer}>
        <View style={styles.mapPlaceholder}>
          <Ionicons name="map" size={64} color={COLORS.primary} />
          <Text style={styles.mapText}>Hartă interactivă</Text>
          <Text style={styles.mapSubtext}>
            {filteredHotspots.length} hotspot-uri disponibile
          </Text>

          {/* Simulated map dots */}
          <View style={styles.mapDots}>
            {filteredHotspots.slice(0, 6).map((hotspot, index) => (
              <TouchableOpacity
                key={hotspot.id}
                style={[
                  styles.mapDot,
                  {
                    left: 30 + (index * 45) % 240,
                    top: 20 + (index * 30) % 80,
                    backgroundColor:
                      hotspot.signal === 'strong'
                        ? COLORS.success
                        : hotspot.signal === 'medium'
                        ? COLORS.warning
                        : COLORS.error,
                  },
                ]}
                onPress={() => handleSelectHotspot(hotspot)}
              >
                <Ionicons name="wifi" size={12} color={COLORS.white} />
              </TouchableOpacity>
            ))}
          </View>
        </View>
      </View>

      {/* Search */}
      <View style={styles.searchSection}>
        <View style={styles.searchContainer}>
          <Ionicons name="search-outline" size={20} color={COLORS.gray[400]} />
          <TextInput
            style={styles.searchInput}
            placeholder="Caută hotspot..."
            placeholderTextColor={COLORS.gray[400]}
            value={searchQuery}
            onChangeText={setSearchQuery}
          />
          {searchQuery.length > 0 && (
            <TouchableOpacity onPress={() => setSearchQuery('')}>
              <Ionicons name="close-circle" size={20} color={COLORS.gray[400]} />
            </TouchableOpacity>
          )}
        </View>

        {/* Filters */}
        <View style={styles.filtersRow}>
          {filters.map((filter) => (
            <TouchableOpacity
              key={filter.key}
              style={[
                styles.filterChip,
                selectedFilter === filter.key && styles.filterChipActive,
              ]}
              onPress={() => setSelectedFilter(filter.key)}
            >
              <Text
                style={[
                  styles.filterText,
                  selectedFilter === filter.key && styles.filterTextActive,
                ]}
              >
                {filter.label}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
      </View>

      {/* Hotspot List */}
      <FlatList
        data={filteredHotspots}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <HotspotCard hotspot={item} onPress={handleSelectHotspot} />
        )}
        contentContainerStyle={styles.listContent}
        showsVerticalScrollIndicator={false}
        ListEmptyComponent={
          <View style={styles.emptyContainer}>
            <Ionicons name="wifi-outline" size={48} color={COLORS.gray[300]} />
            <Text style={styles.emptyText}>Niciun hotspot găsit</Text>
          </View>
        }
      />

      {/* Selected Hotspot Details */}
      {selectedHotspot && (
        <View style={styles.detailCard}>
          <View style={styles.detailHeader}>
            <Text style={styles.detailName}>{selectedHotspot.name}</Text>
            <TouchableOpacity onPress={() => setSelectedHotspot(null)}>
              <Ionicons name="close" size={24} color={COLORS.gray[500]} />
            </TouchableOpacity>
          </View>
          <View style={styles.detailInfo}>
            <View style={styles.detailRow}>
              <Ionicons name="wifi" size={16} color={COLORS.primary} />
              <Text style={styles.detailText}>
                Semnal: {selectedHotspot.signal === 'strong' ? 'Puternic' : selectedHotspot.signal === 'medium' ? 'Mediu' : 'Slab'}
              </Text>
            </View>
            <View style={styles.detailRow}>
              <Ionicons name="star" size={16} color={COLORS.warning} />
              <Text style={styles.detailText}>
                Tip: {selectedHotspot.type === 'premium' ? 'Premium' : 'Basic'}
              </Text>
            </View>
          </View>
          <TouchableOpacity style={styles.connectBtn}>
            <Text style={styles.connectBtnText}>Conectează-te</Text>
          </TouchableOpacity>
        </View>
      )}
    </View>
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
    paddingBottom: SPACING.md,
  },
  headerTitle: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '700',
    color: COLORS.text,
  },
  headerSubtitle: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    marginTop: 4,
  },
  mapContainer: {
    paddingHorizontal: SPACING.lg,
    paddingTop: SPACING.md,
  },
  mapPlaceholder: {
    height: 200,
    backgroundColor: COLORS.primaryBg,
    borderRadius: RADIUS.lg,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: COLORS.primary + '30',
    overflow: 'hidden',
  },
  mapText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
    color: COLORS.primary,
    marginTop: SPACING.sm,
  },
  mapSubtext: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    marginTop: 4,
  },
  mapDots: {
    position: 'absolute',
    width: '100%',
    height: '100%',
  },
  mapDot: {
    position: 'absolute',
    width: 28,
    height: 28,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    ...SHADOWS.sm,
  },
  searchSection: {
    paddingHorizontal: SPACING.lg,
    paddingTop: SPACING.md,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.md,
    paddingHorizontal: SPACING.md,
    borderWidth: 1,
    borderColor: COLORS.border,
    ...SHADOWS.sm,
  },
  searchInput: {
    flex: 1,
    paddingVertical: SPACING.md,
    marginLeft: SPACING.sm,
    fontSize: FONTS.sizes.sm,
    color: COLORS.text,
  },
  filtersRow: {
    flexDirection: 'row',
    gap: SPACING.sm,
    marginTop: SPACING.md,
  },
  filterChip: {
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    borderRadius: RADIUS.full,
    backgroundColor: COLORS.white,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  filterChipActive: {
    backgroundColor: COLORS.primary,
    borderColor: COLORS.primary,
  },
  filterText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '500',
    color: COLORS.textSecondary,
  },
  filterTextActive: {
    color: COLORS.white,
  },
  listContent: {
    padding: SPACING.lg,
  },
  emptyContainer: {
    alignItems: 'center',
    paddingVertical: SPACING.xxl,
  },
  emptyText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    marginTop: SPACING.md,
  },
  detailCard: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: COLORS.white,
    borderTopLeftRadius: RADIUS.xl,
    borderTopRightRadius: RADIUS.xl,
    padding: SPACING.lg,
    ...SHADOWS.lg,
  },
  detailHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: SPACING.md,
  },
  detailName: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    flex: 1,
  },
  detailInfo: {
    gap: SPACING.sm,
    marginBottom: SPACING.md,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
  },
  detailText: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
  },
  connectBtn: {
    backgroundColor: COLORS.primary,
    paddingVertical: SPACING.md,
    borderRadius: RADIUS.md,
    alignItems: 'center',
  },
  connectBtnText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
  },
});
