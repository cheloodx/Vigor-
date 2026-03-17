import React from 'react';
import { View, Text, StyleSheet, ScrollView, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { PLANS, COUNTRIES } from '../constants/data';
import { PlanCard } from '../components/PlanCard';
import { Plan } from '../types';

export function PlansScreen() {
  const handleSelectPlan = (plan: Plan) => {
    Alert.alert(
      'Confirmare',
      `Dorești să activezi planul ${plan.name} la ${plan.price} ${plan.currency}/${plan.period}?`,
      [
        { text: 'Anulează', style: 'cancel' },
        {
          text: 'Activează',
          onPress: () =>
            Alert.alert('Succes', `Planul ${plan.name} a fost activat!`),
        },
      ]
    );
  };

  return (
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Alege planul potrivit</Text>
        <Text style={styles.headerSubtitle}>
          Acces în 175 de țări, indiferent de planul ales
        </Text>
      </View>

      {/* Plans */}
      <View style={styles.plansSection}>
        {PLANS.map((plan) => (
          <PlanCard key={plan.id} plan={plan} onSelect={handleSelectPlan} />
        ))}
      </View>

      {/* Countries */}
      <View style={styles.countriesSection}>
        <View style={styles.countriesHeader}>
          <Ionicons name="globe-outline" size={24} color={COLORS.primary} />
          <Text style={styles.countriesTitle}>Acoperire Globală</Text>
        </View>
        <Text style={styles.countriesSubtitle}>
          De la Paris la Tokyo, de la New York la Sydney
        </Text>
        <View style={styles.countriesGrid}>
          {COUNTRIES.map((country, index) => (
            <View key={index} style={styles.countryChip}>
              <Text style={styles.countryFlag}>{country.flag}</Text>
              <Text style={styles.countryName}>{country.name}</Text>
            </View>
          ))}
          <View style={styles.moreCountries}>
            <Text style={styles.moreCountriesText}>+167 țări</Text>
          </View>
        </View>
      </View>

      {/* FAQ */}
      <View style={styles.faqSection}>
        <Text style={styles.faqTitle}>Întrebări frecvente</Text>

        <View style={styles.faqItem}>
          <Text style={styles.faqQuestion}>
            Pot schimba planul oricând?
          </Text>
          <Text style={styles.faqAnswer}>
            Da, poți face upgrade sau downgrade la planul tău în orice moment din setările contului.
          </Text>
        </View>

        <View style={styles.faqItem}>
          <Text style={styles.faqQuestion}>
            Există perioadă de probă?
          </Text>
          <Text style={styles.faqAnswer}>
            Da, oferim 7 zile gratuite pentru toate planurile noi. Poți anula oricând.
          </Text>
        </View>

        <View style={styles.faqItem}>
          <Text style={styles.faqQuestion}>
            Cum funcționează conectarea?
          </Text>
          <Text style={styles.faqAnswer}>
            După activarea planului, aplicația se conectează automat la cel mai bun hotspot disponibil în zona ta.
          </Text>
        </View>
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
    alignItems: 'center',
  },
  headerTitle: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '700',
    color: COLORS.text,
    textAlign: 'center',
  },
  headerSubtitle: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    marginTop: SPACING.xs,
    textAlign: 'center',
  },
  plansSection: {
    padding: SPACING.lg,
  },
  countriesSection: {
    backgroundColor: COLORS.white,
    marginHorizontal: SPACING.lg,
    borderRadius: RADIUS.lg,
    padding: SPACING.lg,
    marginBottom: SPACING.lg,
  },
  countriesHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: SPACING.sm,
    marginBottom: SPACING.xs,
  },
  countriesTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
  },
  countriesSubtitle: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    marginBottom: SPACING.md,
  },
  countriesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: SPACING.sm,
  },
  countryChip: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.gray[50],
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    borderRadius: RADIUS.full,
    gap: SPACING.xs,
  },
  countryFlag: {
    fontSize: 16,
  },
  countryName: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '500',
    color: COLORS.text,
  },
  moreCountries: {
    backgroundColor: COLORS.primaryBg,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    borderRadius: RADIUS.full,
  },
  moreCountriesText: {
    fontSize: FONTS.sizes.xs,
    fontWeight: '600',
    color: COLORS.primary,
  },
  faqSection: {
    paddingHorizontal: SPACING.lg,
  },
  faqTitle: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.text,
    marginBottom: SPACING.md,
  },
  faqItem: {
    backgroundColor: COLORS.white,
    borderRadius: RADIUS.md,
    padding: SPACING.md,
    marginBottom: SPACING.sm,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  faqQuestion: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.text,
    marginBottom: SPACING.xs,
  },
  faqAnswer: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    lineHeight: 20,
  },
});
