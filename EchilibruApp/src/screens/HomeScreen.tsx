import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, Image, Dimensions } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { recipes } from '../data/recipes';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';

const { width } = Dimensions.get('window');
type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function HomeScreen() {
  const navigation = useNavigation<Nav>();
  const featured = recipes.slice(0, 4);

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#F0FDF4', '#FFFFFF']} style={s.hero}>
        <View style={s.premBanner}>
          <Ionicons name="sparkles" size={14} color={Colors.secondary} />
          <Text style={s.premText}>Premium Content Disponibil</Text>
          <Ionicons name="gift" size={14} color={Colors.secondary} />
        </View>
        <Text style={s.heroTitle}>
          <Text style={s.heroGreen}>{'Echilibru\nPerfect\n'}</Text>
          <Text style={s.heroBlack}>{'Nutritie &\nFitness'}</Text>
        </Text>
        <Text style={s.heroDesc}>
          Descopera <Text style={s.bold}>122 retete internationale, 85 exercitii profesionale</Text> si planuri personalizate pentru un stil de viata sanatos.
        </Text>
        <View style={s.stats}>
          {([['restaurant', '122 Retete'], ['fitness', '85 Exercitii'], ['calendar', 'Planuri Complete']] as const).map(([icon, t], i) => (
            <View key={i} style={s.stat}>
              <Ionicons name={icon} size={14} color={Colors.primary} />
              <Text style={s.statText}>{t}</Text>
            </View>
          ))}
        </View>
        <View style={s.rating}>
          <Ionicons name="star" size={20} color={Colors.primary} />
          <View>
            <Text style={s.ratingNum}>4.9/5</Text>
            <Text style={s.ratingLabel}>Rating Mediu</Text>
          </View>
        </View>
      </LinearGradient>

      <View style={s.ctaWrap}>
        <LinearGradient colors={['rgba(16,185,129,0.9)', 'rgba(5,150,105,0.9)']} style={s.cta}>
          <Text style={s.ctaLabel}>TRANSFORMA-TI VIATA ASTAZI</Text>
          <Text style={s.ctaTitle}>{'Nutritie Sanatoasa\n+ Sport Regulat\n= Viata Echilibrata'}</Text>
          <Text style={s.ctaDesc}>Alatura-te celor care si-au transformat stilul de viata cu retete sanatoase si programe de exercitii eficiente</Text>
          <View style={s.ctaBtns}>
            <TouchableOpacity style={s.ctaPri}>
              <Ionicons name="cart" size={16} color="#FFF" />
              <Text style={s.ctaPriText}>Incepe Acum - 29 RON/luna</Text>
            </TouchableOpacity>
            <TouchableOpacity style={s.ctaSec}>
              <Ionicons name="book" size={16} color={Colors.primary} />
              <Text style={s.ctaSecText}>Exploreaza Gratuit</Text>
            </TouchableOpacity>
          </View>
        </LinearGradient>
      </View>

      <View style={s.features}>
        {[
          { icon: 'book' as const, color: Colors.primary, bg: Colors.primaryLight, title: 'Retete Internationale', desc: '122 retete din Italia, Franta, Spania si Anglia cu informatii nutritionale complete' },
          { icon: 'fitness' as const, color: Colors.orange, bg: '#FEF3C7', title: 'Exercitii Profesionale', desc: '85 exercitii cu videoclipuri demonstrative pentru toate nivelurile' },
          { icon: 'calendar' as const, color: Colors.accent, bg: '#FEE2E2', title: 'Planuri de Mese', desc: 'Planuri saptamanale echilibrate pentru a-ti organiza alimentatia' },
          { icon: 'trending-up' as const, color: Colors.blue, bg: '#DBEAFE', title: 'Planuri de Antrenament', desc: 'Programe complete structurate pentru toate nivelurile' },
          { icon: 'nutrition' as const, color: Colors.purple, bg: '#EDE9FE', title: 'Sfaturi Nutritionale', desc: 'Sfaturi practice pentru o alimentatie sanatoasa si echilibrata' },
        ].map((f, i) => (
          <View key={i} style={s.featureCard}>
            <View style={[s.featureIcon, { backgroundColor: f.bg }]}>
              <Ionicons name={f.icon} size={24} color={f.color} />
            </View>
            <Text style={s.featureTitle}>{f.title}</Text>
            <Text style={s.featureDesc}>{f.desc}</Text>
          </View>
        ))}
      </View>

      <View style={s.recSection}>
        <Text style={s.secTitle}>Retete Recomandate</Text>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ gap: 12, paddingRight: 20 }}>
          {featured.map(r => (
            <TouchableOpacity key={r.id} style={s.recCard} onPress={() => navigation.navigate('RecipeDetail', { recipe: r })}>
              <Image source={{ uri: r.image }} style={s.recImg} />
              {r.isPremium && (
                <View style={s.recPrem}>
                  <Ionicons name="star" size={8} color="#FFF" />
                  <Text style={s.recPremT}>Premium</Text>
                </View>
              )}
              <View style={s.recContent}>
                <Text style={s.recTitle} numberOfLines={1}>{r.title}</Text>
                <Text style={s.recDesc} numberOfLines={2}>{r.description}</Text>
                <View style={s.recInfo}>
                  <Text style={s.recInfoT}>{r.prepTime}</Text>
                  <Text style={s.recInfoT}>{r.calories} kcal</Text>
                </View>
              </View>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      <View style={s.testSection}>
        <Text style={s.secTitle}>Ce spun utilizatorii</Text>
        {[
          { name: 'Maria Popescu', ini: 'MP', res: '-8kg in 3 luni', text: 'Retetele sunt delicioase si usor de preparat! Am reusit sa slabesc 8kg fara sa ma simt flamanda.' },
          { name: 'Andrei Ionescu', ini: 'AI', res: '+5kg muschi, -7% grasime', text: 'Planurile de antrenament sunt exact ce aveam nevoie. Am castigat muschi si am redus grasimea corporala.' },
          { name: 'Elena Georgescu', ini: 'EG', res: '-12kg in 5 luni', text: 'Nu credeam ca pot slabi atat de mult! Abonamentul Premium merita fiecare ban.' },
        ].map((t, i) => (
          <View key={i} style={s.testCard}>
            <Text style={s.testText}>{'"' + t.text + '"'}</Text>
            <View style={s.testAuthor}>
              <View style={s.testAvatar}><Text style={s.testIni}>{t.ini}</Text></View>
              <View><Text style={s.testName}>{t.name}</Text><Text style={s.testRes}>{t.res}</Text></View>
            </View>
          </View>
        ))}
      </View>

      <View style={s.trust}>
        <Text style={s.trustTitle}>Peste 500+ utilizatori multumiti</Text>
        <View style={s.trustBadges}>
          {([['shield-checkmark', 'Plata Securizata'], ['card', 'Stripe Certified'], ['close-circle', 'Anuleaza Oricand'], ['lock-closed', 'Date Protejate'], ['people', '1000+ Membri']] as const).map(([icon, t], i) => (
            <View key={i} style={s.trustBadge}>
              <Ionicons name={icon} size={18} color={Colors.gray[500]} />
              <Text style={s.trustBadgeT}>{t}</Text>
            </View>
          ))}
        </View>
      </View>
      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  hero: { padding: 20, paddingTop: 60 },
  premBanner: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: Colors.primaryLight, alignSelf: 'flex-start', paddingHorizontal: 14, paddingVertical: 8, borderRadius: 20, marginBottom: 20 },
  premText: { fontSize: 13, fontWeight: '600', color: Colors.primaryDark },
  heroTitle: { fontSize: 36, lineHeight: 44, marginBottom: 16 },
  heroGreen: { fontWeight: '800', color: Colors.primary },
  heroBlack: { fontWeight: '800', color: Colors.black },
  heroDesc: { fontSize: 15, color: Colors.gray[600], lineHeight: 22, marginBottom: 20 },
  bold: { fontWeight: '700', color: Colors.primary },
  stats: { flexDirection: 'row', flexWrap: 'wrap', gap: 8, marginBottom: 20 },
  stat: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: Colors.white, paddingHorizontal: 14, paddingVertical: 8, borderRadius: 20, borderWidth: 1, borderColor: Colors.gray[200] },
  statText: { fontSize: 13, fontWeight: '600', color: Colors.gray[700] },
  rating: { flexDirection: 'row', alignItems: 'center', gap: 8, backgroundColor: Colors.white, alignSelf: 'flex-start', paddingHorizontal: 16, paddingVertical: 10, borderRadius: 16, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 8, elevation: 3 },
  ratingNum: { fontSize: 18, fontWeight: '800', color: Colors.black },
  ratingLabel: { fontSize: 11, color: Colors.gray[500] },
  ctaWrap: { padding: 20 },
  cta: { borderRadius: 20, padding: 24, alignItems: 'center' },
  ctaLabel: { fontSize: 12, fontWeight: '700', color: Colors.secondaryLight, letterSpacing: 1, marginBottom: 12 },
  ctaTitle: { fontSize: 26, fontWeight: '800', color: '#FFF', textAlign: 'center', marginBottom: 12, lineHeight: 32 },
  ctaDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20, marginBottom: 20 },
  ctaBtns: { flexDirection: 'row', gap: 10, flexWrap: 'wrap', justifyContent: 'center' },
  ctaPri: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: Colors.secondary, paddingHorizontal: 20, paddingVertical: 12, borderRadius: 12 },
  ctaPriText: { color: '#FFF', fontWeight: '700', fontSize: 14 },
  ctaSec: { flexDirection: 'row', alignItems: 'center', gap: 6, backgroundColor: Colors.white, paddingHorizontal: 20, paddingVertical: 12, borderRadius: 12 },
  ctaSecText: { color: Colors.primary, fontWeight: '700', fontSize: 14 },
  features: { padding: 20, flexDirection: 'row', flexWrap: 'wrap', gap: 12 },
  featureCard: { width: (width - 52) / 2, backgroundColor: Colors.primaryBg, borderRadius: 16, padding: 16 },
  featureIcon: { width: 48, height: 48, borderRadius: 12, justifyContent: 'center', alignItems: 'center', marginBottom: 12 },
  featureTitle: { fontSize: 15, fontWeight: '700', color: Colors.black, marginBottom: 6 },
  featureDesc: { fontSize: 12, color: Colors.gray[500], lineHeight: 17 },
  recSection: { padding: 20 },
  secTitle: { fontSize: 22, fontWeight: '800', color: Colors.primary, textAlign: 'center', marginBottom: 16 },
  recCard: { width: 200, backgroundColor: Colors.white, borderRadius: 16, shadowColor: '#000', shadowOffset: { width: 0, height: 2 }, shadowOpacity: 0.1, shadowRadius: 8, elevation: 3, overflow: 'hidden' as const },
  recImg: { width: '100%', height: 120, backgroundColor: Colors.gray[200] },
  recPrem: { position: 'absolute' as const, top: 8, left: 8, backgroundColor: Colors.primary, borderRadius: 12, paddingHorizontal: 8, paddingVertical: 3, flexDirection: 'row' as const, alignItems: 'center' as const, gap: 3 },
  recPremT: { color: '#FFF', fontSize: 10, fontWeight: '600' },
  recContent: { padding: 12 },
  recTitle: { fontSize: 14, fontWeight: '700', color: Colors.black, marginBottom: 4 },
  recDesc: { fontSize: 11, color: Colors.gray[500], lineHeight: 15, marginBottom: 8 },
  recInfo: { flexDirection: 'row' as const, justifyContent: 'space-between' as const },
  recInfoT: { fontSize: 11, color: Colors.gray[400] },
  testSection: { padding: 20 },
  testCard: { backgroundColor: Colors.white, borderRadius: 16, padding: 16, marginBottom: 12, shadowColor: '#000', shadowOffset: { width: 0, height: 1 }, shadowOpacity: 0.05, shadowRadius: 4, elevation: 2, borderWidth: 1, borderColor: Colors.gray[100] },
  testText: { fontSize: 13, color: Colors.gray[600], lineHeight: 20, fontStyle: 'italic' as const, marginBottom: 12 },
  testAuthor: { flexDirection: 'row' as const, alignItems: 'center' as const, gap: 10 },
  testAvatar: { width: 40, height: 40, borderRadius: 20, backgroundColor: Colors.primaryLight, justifyContent: 'center' as const, alignItems: 'center' as const },
  testIni: { fontSize: 14, fontWeight: '700', color: Colors.primary },
  testName: { fontSize: 14, fontWeight: '700', color: Colors.black },
  testRes: { fontSize: 12, color: Colors.primary, fontWeight: '600' },
  trust: { padding: 20, alignItems: 'center' as const },
  trustTitle: { fontSize: 14, color: Colors.gray[500], marginBottom: 16, textAlign: 'center' as const },
  trustBadges: { flexDirection: 'row' as const, flexWrap: 'wrap' as const, justifyContent: 'center' as const, gap: 16 },
  trustBadge: { flexDirection: 'row' as const, alignItems: 'center' as const, gap: 6 },
  trustBadgeT: { fontSize: 12, color: Colors.gray[500] },
});
