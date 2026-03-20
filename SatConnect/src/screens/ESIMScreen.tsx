import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  ScrollView,
  TouchableOpacity,
  Alert,
  TextInput,
  ActivityIndicator,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import {
  esimProvisioning,
  ESIMCountry,
  ESIMCountryPlan,
} from '../services/esimProvisioning';

type ScreenState = 'countries' | 'plans' | 'activating' | 'success';

export function ESIMScreen() {
  const [screen, setScreen] = useState<ScreenState>('countries');
  const [search, setSearch] = useState('');
  const [countries, setCountries] = useState<ESIMCountry[]>([]);
  const [filteredCountries, setFilteredCountries] = useState<ESIMCountry[]>([]);
  const [selectedCountry, setSelectedCountry] = useState<ESIMCountry | null>(null);
  const [plans, setPlans] = useState<ESIMCountryPlan[]>([]);
  const [loadingPlans, setLoadingPlans] = useState(false);
  const [activatingPlan, setActivatingPlan] = useState<ESIMCountryPlan | null>(null);

  useEffect(() => {
    const all = esimProvisioning.getCountries();
    setCountries(all);
    setFilteredCountries(all);
  }, []);

  const handleSearch = useCallback(
    (query: string) => {
      setSearch(query);
      if (!query.trim()) {
        setFilteredCountries(countries);
      } else {
        setFilteredCountries(esimProvisioning.searchCountries(query));
      }
    },
    [countries],
  );

  const handleSelectCountry = useCallback(async (country: ESIMCountry) => {
    setSelectedCountry(country);
    setLoadingPlans(true);
    setScreen('plans');
    try {
      const countryPlans = await esimProvisioning.getPlansForCountry(country.code);
      setPlans(countryPlans);
    } catch {
      Alert.alert('Eroare', 'Nu am putut încărca planurile. Încearcă din nou.');
      setScreen('countries');
    } finally {
      setLoadingPlans(false);
    }
  }, []);

  const handleSelectPlan = useCallback(
    (plan: ESIMCountryPlan) => {
      if (!selectedCountry) return;
      Alert.alert(
        `Internet pentru ${selectedCountry.name}`,
        `${plan.dataLabel} • ${plan.validDays} zile • €${plan.price.toFixed(2)}\n\nActivare în aproximativ 2 minute.`,
        [
          { text: 'Anulează', style: 'cancel' },
          {
            text: 'Activează acum',
            onPress: async () => {
              setActivatingPlan(plan);
              setScreen('activating');
              try {
                const result = await esimProvisioning.provisionESIM(plan.id);
                if (result.success) {
                  setScreen('success');
                } else {
                  Alert.alert('Eroare', result.error || 'Activarea a eșuat.');
                  setScreen('plans');
                }
              } catch {
                Alert.alert('Eroare', 'Activarea a eșuat. Încearcă din nou.');
                setScreen('plans');
              }
            },
          },
        ],
      );
    },
    [selectedCountry],
  );

  const handleBack = useCallback(() => {
    if (screen === 'plans') {
      setScreen('countries');
      setSelectedCountry(null);
      setPlans([]);
    } else if (screen === 'success') {
      setScreen('countries');
      setSelectedCountry(null);
      setPlans([]);
      setActivatingPlan(null);
    }
  }, [screen]);

  const handleNewESIM = useCallback(() => {
    setScreen('countries');
    setSelectedCountry(null);
    setPlans([]);
    setActivatingPlan(null);
    setSearch('');
    setFilteredCountries(countries);
  }, [countries]);

  // ------- COUNTRY SELECTION SCREEN -------
  if (screen === 'countries') {
    const popularCountries = countries.filter((c) => c.popular);
    const regionGroups: Record<string, ESIMCountry[]> = {};
    for (const c of filteredCountries) {
      if (!regionGroups[c.region]) regionGroups[c.region] = [];
      regionGroups[c.region].push(c);
    }

    return (
      <ScrollView style={styles.container} contentContainerStyle={styles.content}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Unde mergi?</Text>
          <Text style={styles.subtitle}>
            Alege destinația și activează internetul în 2 minute
          </Text>
        </View>

        {/* Search */}
        <View style={styles.searchContainer}>
          <MaterialCommunityIcons name="magnify" size={20} color={COLORS.textLight} />
          <TextInput
            style={styles.searchInput}
            placeholder="Caută țara..."
            placeholderTextColor={COLORS.textLight}
            value={search}
            onChangeText={handleSearch}
            autoCorrect={false}
          />
          {search.length > 0 && (
            <TouchableOpacity onPress={() => handleSearch('')}>
              <MaterialCommunityIcons name="close-circle" size={18} color={COLORS.textLight} />
            </TouchableOpacity>
          )}
        </View>

        {/* Popular countries (only when not searching) */}
        {!search && (
          <>
            <Text style={styles.sectionTitle}>Destinații populare</Text>
            <View style={styles.popularGrid}>
              {popularCountries.map((country) => (
                <TouchableOpacity
                  key={country.code}
                  style={styles.popularItem}
                  onPress={() => handleSelectCountry(country)}
                  activeOpacity={0.7}
                >
                  <Text style={styles.popularFlag}>{country.flag}</Text>
                  <Text style={styles.popularName} numberOfLines={1}>
                    {country.name}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          </>
        )}

        {/* All countries by region */}
        {Object.entries(regionGroups).map(([region, regionCountries]) => (
          <View key={region}>
            <Text style={styles.sectionTitle}>{region}</Text>
            {regionCountries.map((country) => (
              <TouchableOpacity
                key={country.code}
                style={styles.countryRow}
                onPress={() => handleSelectCountry(country)}
                activeOpacity={0.7}
              >
                <Text style={styles.countryFlag}>{country.flag}</Text>
                <Text style={styles.countryName}>{country.name}</Text>
                <MaterialCommunityIcons
                  name="chevron-right"
                  size={20}
                  color={COLORS.textLight}
                />
              </TouchableOpacity>
            ))}
          </View>
        ))}

        {filteredCountries.length === 0 && (
          <View style={styles.emptyState}>
            <MaterialCommunityIcons name="earth-off" size={48} color={COLORS.textLight} />
            <Text style={styles.emptyText}>Nu am găsit nicio țară</Text>
            <Text style={styles.emptySubtext}>Încearcă altă căutare</Text>
          </View>
        )}

        {/* Info */}
        <View style={styles.infoBox}>
          <MaterialCommunityIcons name="information-outline" size={18} color={COLORS.primary} />
          <Text style={styles.infoText}>
            eSIM-ul virtual îți permite internet în 175+ țări fără cartelă fizică. Fiecare țară
            are propriul plan și provider optimizat.
          </Text>
        </View>
      </ScrollView>
    );
  }

  // ------- PLANS FOR COUNTRY SCREEN -------
  if (screen === 'plans' && selectedCountry) {
    return (
      <ScrollView style={styles.container} contentContainerStyle={styles.content}>
        {/* Back button */}
        <TouchableOpacity style={styles.backButton} onPress={handleBack}>
          <MaterialCommunityIcons name="arrow-left" size={22} color={COLORS.text} />
          <Text style={styles.backText}>Înapoi</Text>
        </TouchableOpacity>

        {/* Country header */}
        <View style={styles.countryHeader}>
          <Text style={styles.countryHeaderFlag}>{selectedCountry.flag}</Text>
          <View>
            <Text style={styles.countryHeaderName}>
              Internet pentru {selectedCountry.name}
            </Text>
            <Text style={styles.countryHeaderSub}>Activ în 2 minute</Text>
          </View>
        </View>

        {loadingPlans ? (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="large" color={COLORS.primary} />
            <Text style={styles.loadingText}>Se încarcă planurile...</Text>
          </View>
        ) : (
          <>
            <Text style={styles.sectionTitle}>Alege planul</Text>
            {plans.map((plan) => (
              <TouchableOpacity
                key={plan.id}
                style={[styles.planCard, plan.popular && styles.planCardPopular]}
                onPress={() => handleSelectPlan(plan)}
                activeOpacity={0.8}
              >
                {plan.popular && (
                  <View style={styles.popularBadge}>
                    <Text style={styles.popularBadgeText}>POPULAR</Text>
                  </View>
                )}
                <View style={styles.planCardRow}>
                  <View style={styles.planCardInfo}>
                    <Text style={styles.planDataLabel}>{plan.dataLabel}</Text>
                    <Text style={styles.planValidDays}>{plan.validDays} zile</Text>
                  </View>
                  <View style={styles.planCardPrice}>
                    <Text style={styles.planPrice}>€{plan.price.toFixed(2)}</Text>
                  </View>
                </View>
              </TouchableOpacity>
            ))}

            {plans.length === 0 && (
              <View style={styles.emptyState}>
                <MaterialCommunityIcons name="sim-off-outline" size={48} color={COLORS.textLight} />
                <Text style={styles.emptyText}>Nu sunt planuri disponibile</Text>
              </View>
            )}
          </>
        )}

        {/* Info */}
        <View style={styles.infoBox}>
          <MaterialCommunityIcons name="shield-check-outline" size={18} color={COLORS.accent} />
          <Text style={styles.infoText}>
            Plata securizată. Instalare automată pe iPhone. Fără cartelă fizică necesară.
          </Text>
        </View>
      </ScrollView>
    );
  }

  // ------- ACTIVATING SCREEN -------
  if (screen === 'activating') {
    return (
      <View style={[styles.container, styles.centerContent]}>
        <ActivityIndicator size="large" color={COLORS.accent} />
        <Text style={styles.activatingTitle}>Se activează eSIM...</Text>
        <Text style={styles.activatingSubtitle}>
          {selectedCountry?.flag} Internet pentru {selectedCountry?.name}
        </Text>
        {activatingPlan && (
          <Text style={styles.activatingPlan}>
            {activatingPlan.dataLabel} • €{activatingPlan.price.toFixed(2)}
          </Text>
        )}
        <Text style={styles.activatingWait}>Durează aproximativ 2 minute</Text>
      </View>
    );
  }

  // ------- SUCCESS SCREEN -------
  if (screen === 'success') {
    return (
      <View style={[styles.container, styles.centerContent]}>
        <View style={styles.successIcon}>
          <MaterialCommunityIcons name="check-circle" size={64} color={COLORS.success} />
        </View>
        <Text style={styles.successTitle}>eSIM Activat!</Text>
        <Text style={styles.successSubtitle}>
          {selectedCountry?.flag} Internet pentru {selectedCountry?.name}
        </Text>
        {activatingPlan && (
          <Text style={styles.successPlan}>
            {activatingPlan.dataLabel} • {activatingPlan.validDays} zile
          </Text>
        )}
        <Text style={styles.successMessage}>
          Poți folosi internetul imediat. Conexiunea se va activa automat când ajungi la destinație.
        </Text>

        <TouchableOpacity style={styles.successButton} onPress={handleNewESIM}>
          <MaterialCommunityIcons name="plus" size={20} color={COLORS.white} />
          <Text style={styles.successButtonText}>Adaugă altă destinație</Text>
        </TouchableOpacity>

        <TouchableOpacity style={styles.successBackButton} onPress={handleBack}>
          <Text style={styles.successBackText}>Înapoi la destinații</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return null;
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
  centerContent: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: SPACING.xl,
  },
  header: {
    marginBottom: SPACING.xl,
  },
  title: {
    fontSize: FONTS.sizes.xxxl,
    fontWeight: '800',
    color: COLORS.text,
    marginBottom: SPACING.xs,
  },
  subtitle: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    lineHeight: 22,
  },

  // Search
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    marginBottom: SPACING.xl,
    borderWidth: 1,
    borderColor: COLORS.border,
    gap: SPACING.sm,
    ...SHADOWS.sm,
  },
  searchInput: {
    flex: 1,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
    paddingVertical: 4,
  },

  // Section
  sectionTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
    marginTop: SPACING.md,
  },

  // Popular grid
  popularGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: SPACING.sm,
    marginBottom: SPACING.lg,
  },
  popularItem: {
    width: '30%',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.lg,
    paddingVertical: SPACING.md,
    paddingHorizontal: SPACING.xs,
    borderWidth: 1,
    borderColor: COLORS.border,
    ...SHADOWS.sm,
  },
  popularFlag: {
    fontSize: 28,
    marginBottom: 4,
  },
  popularName: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
    color: COLORS.text,
    textAlign: 'center',
  },

  // Country list
  countryRow: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.md,
    paddingVertical: SPACING.md,
    paddingHorizontal: SPACING.md,
    marginBottom: SPACING.xs,
    gap: SPACING.md,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  countryFlag: {
    fontSize: 24,
  },
  countryName: {
    flex: 1,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
    fontWeight: '500',
  },

  // Empty state
  emptyState: {
    alignItems: 'center',
    paddingVertical: SPACING.xxl,
    gap: SPACING.sm,
  },
  emptyText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
    color: COLORS.textSecondary,
  },
  emptySubtext: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textLight,
  },

  // Info box
  infoBox: {
    flexDirection: 'row',
    gap: SPACING.sm,
    backgroundColor: COLORS.primary + '10',
    borderRadius: RADIUS.lg,
    padding: SPACING.md,
    alignItems: 'flex-start',
    marginTop: SPACING.xl,
  },
  infoText: {
    flex: 1,
    fontSize: FONTS.sizes.xs,
    color: COLORS.textSecondary,
    lineHeight: 18,
  },

  // Back button
  backButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.xs,
    marginBottom: SPACING.lg,
  },
  backText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
    fontWeight: '600',
  },

  // Country header (plans screen)
  countryHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.primaryDark,
    borderRadius: RADIUS.xl,
    padding: SPACING.lg,
    marginBottom: SPACING.xl,
    gap: SPACING.md,
  },
  countryHeaderFlag: {
    fontSize: 40,
  },
  countryHeaderName: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.white,
  },
  countryHeaderSub: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.accent,
    fontWeight: '600',
    marginTop: 2,
  },

  // Loading
  loadingContainer: {
    alignItems: 'center',
    paddingVertical: SPACING.xxl,
    gap: SPACING.md,
  },
  loadingText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
  },

  // Plan cards
  planCard: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.xl,
    padding: SPACING.lg,
    marginBottom: SPACING.md,
    borderWidth: 1.5,
    borderColor: COLORS.border,
    ...SHADOWS.md,
  },
  planCardPopular: {
    borderColor: COLORS.accent,
    backgroundColor: '#F0FDFB',
  },
  popularBadge: {
    position: 'absolute',
    top: -10,
    right: SPACING.lg,
    backgroundColor: COLORS.accent,
    paddingHorizontal: SPACING.sm,
    paddingVertical: 3,
    borderRadius: RADIUS.sm,
  },
  popularBadgeText: {
    fontSize: 10,
    fontWeight: '800',
    color: COLORS.white,
    letterSpacing: 0.5,
  },
  planCardRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  planCardInfo: {
    gap: 2,
  },
  planDataLabel: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '800',
    color: COLORS.text,
  },
  planValidDays: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
  },
  planCardPrice: {
    alignItems: 'flex-end',
  },
  planPrice: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.primary,
  },

  // Activating screen
  activatingTitle: {
    fontSize: FONTS.sizes.xl,
    fontWeight: '700',
    color: COLORS.text,
    marginTop: SPACING.xl,
  },
  activatingSubtitle: {
    fontSize: FONTS.sizes.lg,
    color: COLORS.textSecondary,
    marginTop: SPACING.sm,
  },
  activatingPlan: {
    fontSize: FONTS.sizes.md,
    color: COLORS.accent,
    fontWeight: '600',
    marginTop: SPACING.sm,
  },
  activatingWait: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textLight,
    marginTop: SPACING.lg,
  },

  // Success screen
  successIcon: {
    marginBottom: SPACING.lg,
  },
  successTitle: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.success,
  },
  successSubtitle: {
    fontSize: FONTS.sizes.lg,
    color: COLORS.text,
    marginTop: SPACING.sm,
  },
  successPlan: {
    fontSize: FONTS.sizes.md,
    color: COLORS.accent,
    fontWeight: '600',
    marginTop: SPACING.xs,
  },
  successMessage: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    textAlign: 'center',
    lineHeight: 20,
    marginTop: SPACING.lg,
    paddingHorizontal: SPACING.lg,
  },
  successButton: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
    backgroundColor: COLORS.primary,
    paddingHorizontal: SPACING.xl,
    paddingVertical: SPACING.md,
    borderRadius: RADIUS.full,
    marginTop: SPACING.xl,
    ...SHADOWS.md,
  },
  successButtonText: {
    fontSize: FONTS.sizes.md,
    fontWeight: '700',
    color: COLORS.white,
  },
  successBackButton: {
    marginTop: SPACING.md,
    paddingVertical: SPACING.sm,
  },
  successBackText: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    fontWeight: '600',
  },
});
