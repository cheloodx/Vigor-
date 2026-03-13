import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, TextInput, TouchableOpacity, Platform } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Ionicons } from '@expo/vector-icons';
import { Colors } from '../constants/colors';
import { useLanguage } from '../context/LanguageContext';

type Gender = 'masculin' | 'feminin';
type ActivityLevel = 'sedentar' | 'usor_activ' | 'moderat_activ' | 'foarte_activ' | 'extra_activ';

export default function CalculatorCaloriiScreen() {
  const { t } = useLanguage();

  const activityOptions: { key: ActivityLevel; label: string; multiplier: number; desc: string }[] = [
    { key: 'sedentar', label: t.calculator.sedentary, multiplier: 1.2, desc: t.calculator.sedentaryDesc },
    { key: 'usor_activ', label: t.calculator.lightlyActive, multiplier: 1.375, desc: t.calculator.lightlyActiveDesc },
    { key: 'moderat_activ', label: t.calculator.moderatelyActive, multiplier: 1.55, desc: t.calculator.moderatelyActiveDesc },
    { key: 'foarte_activ', label: t.calculator.veryActive, multiplier: 1.725, desc: t.calculator.veryActiveDesc },
    { key: 'extra_activ', label: t.calculator.extraActive, multiplier: 1.9, desc: t.calculator.extraActiveDesc },
  ];
  const [gender, setGender] = useState<Gender>('masculin');
  const [age, setAge] = useState('');
  const [weight, setWeight] = useState('');
  const [height, setHeight] = useState('');
  const [activity, setActivity] = useState<ActivityLevel>('moderat_activ');
  const [result, setResult] = useState<number | null>(null);

  const calculate = () => {
    const a = parseFloat(age);
    const w = parseFloat(weight);
    const h = parseFloat(height);
    if (isNaN(a) || isNaN(w) || isNaN(h)) return;

    let bmr: number;
    if (gender === 'masculin') {
      bmr = 10 * w + 6.25 * h - 5 * a + 5;
    } else {
      bmr = 10 * w + 6.25 * h - 5 * a - 161;
    }

    const mult = activityOptions.find(o => o.key === activity)?.multiplier || 1.55;
    setResult(Math.round(bmr * mult));
  };

  return (
    <ScrollView style={s.container} showsVerticalScrollIndicator={false}>
      <LinearGradient colors={['#F59E0B', '#D97706']} style={s.header}>
        <Ionicons name="calculator" size={32} color="#FFF" />
                <Text style={s.headerTitle}>{t.calculator.title}</Text>
                <Text style={s.headerDesc}>{t.calculator.desc}</Text>
      </LinearGradient>

      <View style={s.form}>
        <Text style={s.sectionTitle}>{t.calculator.gender}</Text>
        <View style={s.genderRow}>
          <TouchableOpacity
            style={[s.genderBtn, gender === 'masculin' && s.genderBtnActive]}
            onPress={() => setGender('masculin')}
          >
            <Ionicons name="male" size={24} color={gender === 'masculin' ? '#FFF' : Colors.primary} />
            <Text style={[s.genderText, gender === 'masculin' && s.genderTextActive]}>{t.calculator.male}</Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[s.genderBtn, gender === 'feminin' && s.genderBtnActive]}
            onPress={() => setGender('feminin')}
          >
            <Ionicons name="female" size={24} color={gender === 'feminin' ? '#FFF' : Colors.primary} />
            <Text style={[s.genderText, gender === 'feminin' && s.genderTextActive]}>{t.calculator.female}</Text>
          </TouchableOpacity>
        </View>

        <Text style={s.sectionTitle}>{t.calculator.personalData}</Text>
        <View style={s.inputRow}>
          <View style={s.inputGroup}>
            <Text style={s.inputLabel}>{t.calculator.age}</Text>
            <TextInput
              style={s.input}
              value={age}
              onChangeText={setAge}
              keyboardType="numeric"
              placeholder="25"
              placeholderTextColor={Colors.gray[300]}
            />
          </View>
          <View style={s.inputGroup}>
            <Text style={s.inputLabel}>{t.calculator.weight}</Text>
            <TextInput
              style={s.input}
              value={weight}
              onChangeText={setWeight}
              keyboardType="numeric"
              placeholder="70"
              placeholderTextColor={Colors.gray[300]}
            />
          </View>
          <View style={s.inputGroup}>
            <Text style={s.inputLabel}>{t.calculator.height}</Text>
            <TextInput
              style={s.input}
              value={height}
              onChangeText={setHeight}
              keyboardType="numeric"
              placeholder="175"
              placeholderTextColor={Colors.gray[300]}
            />
          </View>
        </View>

        <Text style={s.sectionTitle}>{t.calculator.activityLevel}</Text>
        <View style={s.activityList}>
          {activityOptions.map(opt => (
            <TouchableOpacity
              key={opt.key}
              style={[s.activityBtn, activity === opt.key && s.activityBtnActive]}
              onPress={() => setActivity(opt.key)}
            >
              <View style={s.activityRadio}>
                {activity === opt.key && <View style={s.activityRadioInner} />}
              </View>
              <View style={s.activityTextWrap}>
                <Text style={[s.activityLabel, activity === opt.key && s.activityLabelActive]}>{opt.label}</Text>
                <Text style={s.activityDesc}>{opt.desc}</Text>
              </View>
            </TouchableOpacity>
          ))}
        </View>

        <TouchableOpacity onPress={calculate} activeOpacity={0.8}>
          <LinearGradient colors={Colors.gradient.primary} style={s.calcBtn}>
            <Ionicons name="calculator" size={20} color="#FFF" />
            <Text style={s.calcBtnText}>{t.calculator.calculate}</Text>
          </LinearGradient>
        </TouchableOpacity>

        {result !== null && (
          <View style={s.resultBox}>
            <Text style={s.resultLabel}>{t.calculator.dailyNeed}</Text>
            <Text style={s.resultValue}>{result}</Text>
            <Text style={s.resultUnit}>{t.calculator.caloriesPerDay}</Text>

            <View style={s.resultGoals}>
              <View style={s.goalItem}>
                <Text style={s.goalLabel}>{t.calculator.weightLoss}</Text>
                <Text style={[s.goalValue, { color: '#EF4444' }]}>{Math.round(result * 0.8)} cal</Text>
                <Text style={s.goalDesc}>{t.calculator.deficit}</Text>
              </View>
              <View style={[s.goalItem, s.goalItemCenter]}>
                <Text style={s.goalLabel}>{t.calculator.maintenance}</Text>
                <Text style={[s.goalValue, { color: Colors.primary }]}>{result} cal</Text>
                <Text style={s.goalDesc}>{t.calculator.balance}</Text>
              </View>
              <View style={s.goalItem}>
                <Text style={s.goalLabel}>{t.calculator.muscleGain}</Text>
                <Text style={[s.goalValue, { color: '#3B82F6' }]}>{Math.round(result * 1.15)} cal</Text>
                <Text style={s.goalDesc}>{t.calculator.surplus}</Text>
              </View>
            </View>

            <View style={s.macroBox}>
              <Text style={s.macroTitle}>{t.calculator.macroTitle}</Text>
              <View style={s.macroRow}>
                <View style={s.macroItem}>
                  <View style={[s.macroDot, { backgroundColor: '#EF4444' }]} />
                  <Text style={s.macroLabel}>{t.calculator.protein}</Text>
                  <Text style={s.macroValue}>{Math.round(result * 0.3 / 4)}g</Text>
                  <Text style={s.macroPercent}>30%</Text>
                </View>
                <View style={s.macroItem}>
                  <View style={[s.macroDot, { backgroundColor: '#F59E0B' }]} />
                  <Text style={s.macroLabel}>{t.calculator.carbs}</Text>
                  <Text style={s.macroValue}>{Math.round(result * 0.45 / 4)}g</Text>
                  <Text style={s.macroPercent}>45%</Text>
                </View>
                <View style={s.macroItem}>
                  <View style={[s.macroDot, { backgroundColor: '#10B981' }]} />
                  <Text style={s.macroLabel}>{t.calculator.fats}</Text>
                  <Text style={s.macroValue}>{Math.round(result * 0.25 / 9)}g</Text>
                  <Text style={s.macroPercent}>25%</Text>
                </View>
              </View>
            </View>
          </View>
        )}
      </View>

      <View style={{ height: 100 }} />
    </ScrollView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1, backgroundColor: Colors.white },
  header: { paddingTop: 60, paddingBottom: 24, paddingHorizontal: 20, alignItems: 'center' },
  headerTitle: { fontSize: 28, fontWeight: '800', color: '#FFF', marginTop: 8, marginBottom: 8 },
  headerDesc: { fontSize: 14, color: 'rgba(255,255,255,0.9)', textAlign: 'center', lineHeight: 20 },
  form: { padding: 20 },
  sectionTitle: { fontSize: 16, fontWeight: '700', color: Colors.gray[800], marginBottom: 12, marginTop: 8 },
  genderRow: { flexDirection: 'row', gap: 12, marginBottom: 16 },
  genderBtn: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    padding: 14,
    borderRadius: 12,
    borderWidth: 2,
    borderColor: Colors.gray[200],
    backgroundColor: '#FFF',
  },
  genderBtnActive: { borderColor: Colors.primary, backgroundColor: Colors.primary },
  genderText: { fontSize: 15, fontWeight: '600', color: Colors.gray[700] },
  genderTextActive: { color: '#FFF' },
  inputRow: { flexDirection: 'row', gap: 12, marginBottom: 16 },
  inputGroup: { flex: 1 },
  inputLabel: { fontSize: 12, fontWeight: '600', color: Colors.gray[600], marginBottom: 6 },
  input: {
    borderWidth: 1.5,
    borderColor: Colors.gray[200],
    borderRadius: 12,
    padding: 12,
    fontSize: 16,
    fontWeight: '600',
    color: Colors.gray[800],
    backgroundColor: '#FFF',
    textAlign: 'center',
    ...Platform.select({ web: { outlineStyle: 'none' } as any }),
  },
  activityList: { gap: 8, marginBottom: 20 },
  activityBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 14,
    borderRadius: 12,
    borderWidth: 1.5,
    borderColor: Colors.gray[200],
    backgroundColor: '#FFF',
    gap: 12,
  },
  activityBtnActive: { borderColor: Colors.primary, backgroundColor: Colors.primary + '08' },
  activityRadio: {
    width: 22,
    height: 22,
    borderRadius: 11,
    borderWidth: 2,
    borderColor: Colors.gray[300],
    justifyContent: 'center',
    alignItems: 'center',
  },
  activityRadioInner: { width: 12, height: 12, borderRadius: 6, backgroundColor: Colors.primary },
  activityTextWrap: { flex: 1 },
  activityLabel: { fontSize: 14, fontWeight: '600', color: Colors.gray[700] },
  activityLabelActive: { color: Colors.primary },
  activityDesc: { fontSize: 12, color: Colors.gray[500], marginTop: 2 },
  calcBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    padding: 16,
    borderRadius: 14,
  },
  calcBtnText: { fontSize: 16, fontWeight: '700', color: '#FFF' },
  resultBox: {
    marginTop: 24,
    backgroundColor: '#FFF',
    borderRadius: 20,
    padding: 24,
    alignItems: 'center',
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.1,
    shadowRadius: 12,
    elevation: 5,
    borderWidth: 1,
    borderColor: Colors.gray[100],
  },
  resultLabel: { fontSize: 14, color: Colors.gray[500], fontWeight: '600' },
  resultValue: { fontSize: 48, fontWeight: '900', color: Colors.primary, marginTop: 4 },
  resultUnit: { fontSize: 16, color: Colors.gray[600], fontWeight: '600', marginBottom: 20 },
  resultGoals: { flexDirection: 'row', width: '100%', gap: 8 },
  goalItem: { flex: 1, alignItems: 'center', padding: 12, backgroundColor: Colors.gray[50], borderRadius: 12 },
  goalItemCenter: { backgroundColor: Colors.primary + '10' },
  goalLabel: { fontSize: 12, fontWeight: '600', color: Colors.gray[600], marginBottom: 4 },
  goalValue: { fontSize: 16, fontWeight: '800' },
  goalDesc: { fontSize: 11, color: Colors.gray[400], marginTop: 2 },
  macroBox: { marginTop: 20, width: '100%', backgroundColor: Colors.gray[50], borderRadius: 14, padding: 16 },
  macroTitle: { fontSize: 13, fontWeight: '700', color: Colors.gray[700], textAlign: 'center', marginBottom: 12 },
  macroRow: { flexDirection: 'row', justifyContent: 'space-between' },
  macroItem: { alignItems: 'center', flex: 1 },
  macroDot: { width: 10, height: 10, borderRadius: 5, marginBottom: 6 },
  macroLabel: { fontSize: 11, color: Colors.gray[600], fontWeight: '600' },
  macroValue: { fontSize: 16, fontWeight: '800', color: Colors.gray[800], marginTop: 2 },
  macroPercent: { fontSize: 11, color: Colors.gray[400], marginTop: 2 },
});
