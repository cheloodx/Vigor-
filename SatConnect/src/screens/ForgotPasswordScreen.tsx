import React, { useState } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import { supabaseAuth } from '../services/supabaseAuth';

interface ForgotPasswordScreenProps {
  onBack: () => void;
}

export function ForgotPasswordScreen({ onBack }: ForgotPasswordScreenProps) {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);

  const handleSendReset = async () => {
    if (!email.trim()) {
      Alert.alert('Eroare', 'Introdu adresa de email.');
      return;
    }
    setLoading(true);
    try {
      const result = await supabaseAuth.resetPassword(email.trim());
      setLoading(false);
      if (result.success) {
        setSent(true);
      } else {
        Alert.alert('Eroare', result.error ?? 'Nu am putut trimite emailul.');
      }
    } catch {
      setLoading(false);
      Alert.alert('Eroare', 'A apărut o eroare de rețea. Încearcă din nou.');
    }
  };

  if (sent) {
    return (
      <View style={styles.container}>
        <View style={styles.sentContent}>
          <View style={styles.successCircle}>
            <MaterialCommunityIcons name="email-check-outline" size={56} color={COLORS.success} />
          </View>
          <Text style={styles.sentTitle}>Email trimis!</Text>
          <Text style={styles.sentDesc}>
            Verifica emailul pentru linkul de resetare a parolei. Poate dura cateva minute.
          </Text>
          <Text style={styles.sentEmail}>{email}</Text>
          <TouchableOpacity style={styles.backBtn} onPress={onBack}>
            <Text style={styles.backBtnText}>Inapoi la login</Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <TouchableOpacity style={styles.backNav} onPress={onBack}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={COLORS.accent} />
          <Text style={styles.backNavText}>Inapoi</Text>
        </TouchableOpacity>

        <View style={styles.header}>
          <View style={styles.iconCircle}>
            <MaterialCommunityIcons name="lock-reset" size={48} color={COLORS.accent} />
          </View>
          <Text style={styles.title}>Recuperare parola</Text>
          <Text style={styles.subtitle}>
            Introdu adresa de email asociata contului tau si iti vom trimite un link pentru resetarea parolei.
          </Text>
        </View>

        <View style={styles.form}>
          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="email-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="email@exemplu.com"
              placeholderTextColor={COLORS.textLight}
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />
          </View>

          <TouchableOpacity style={styles.submitBtn} onPress={handleSendReset} disabled={loading}>
            {loading ? (
              <ActivityIndicator color={COLORS.primary} />
            ) : (
              <Text style={styles.submitBtnText}>Trimite link de resetare</Text>
            )}
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  scroll: { flexGrow: 1, paddingHorizontal: SPACING.xl, paddingVertical: SPACING.xxxl },
  backNav: { flexDirection: 'row', alignItems: 'center', gap: 6, alignSelf: 'flex-start', marginBottom: SPACING.lg },
  backNavText: { fontSize: FONTS.sizes.md, color: COLORS.accent, fontWeight: '600' },
  header: { alignItems: 'center', marginBottom: SPACING.xxxl },
  iconCircle: { width: 90, height: 90, borderRadius: 45, ...GLASS.card, alignItems: 'center', justifyContent: 'center', marginBottom: SPACING.lg },
  title: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text, marginBottom: SPACING.sm },
  subtitle: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, textAlign: 'center', lineHeight: 22 },
  form: { gap: SPACING.lg },
  inputWrap: { ...GLASS.card, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', paddingHorizontal: SPACING.md, paddingVertical: SPACING.sm, gap: SPACING.sm },
  input: { flex: 1, paddingVertical: SPACING.xs, fontSize: FONTS.sizes.md, color: COLORS.text },
  submitBtn: { backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center', marginTop: SPACING.md },
  submitBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.primary },
  sentContent: { flex: 1, justifyContent: 'center', alignItems: 'center', paddingHorizontal: SPACING.xl },
  successCircle: { width: 100, height: 100, borderRadius: 50, backgroundColor: 'rgba(52,211,153,0.12)', alignItems: 'center', justifyContent: 'center', marginBottom: SPACING.xl },
  sentTitle: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text, marginBottom: SPACING.sm },
  sentDesc: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, textAlign: 'center', lineHeight: 22, marginBottom: SPACING.md },
  sentEmail: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.accent, marginBottom: SPACING.xxl },
  backBtn: { backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center', width: '100%' },
  backBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.primary },
});
