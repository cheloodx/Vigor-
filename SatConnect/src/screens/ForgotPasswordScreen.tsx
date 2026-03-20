import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  Alert,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { Button } from '../components/Button';
import { supabaseAuth } from '../services/supabaseAuth';

interface ForgotPasswordScreenProps {
  onBack: () => void;
}

export function ForgotPasswordScreen({ onBack }: ForgotPasswordScreenProps) {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [sent, setSent] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, []);

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
            Verifică emailul pentru linkul de resetare a parolei. Poate dura câteva minute.
          </Text>
          <Text style={styles.sentEmail}>{email}</Text>
          <Button
            title="Înapoi la login"
            onPress={onBack}
            variant="primary"
            size="lg"
            style={styles.backButton}
          />
        </View>
      </View>
    );
  }

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <Button
          title=""
          onPress={onBack}
          variant="ghost"
          icon={<MaterialCommunityIcons name="arrow-left" size={24} color={COLORS.text} />}
          style={styles.backNav}
        />

        <View style={styles.header}>
          <View style={styles.iconCircle}>
            <MaterialCommunityIcons name="lock-reset" size={48} color={COLORS.white} />
          </View>
          <Text style={styles.title}>Recuperare parolă</Text>
          <Text style={styles.subtitle}>
            Introdu adresa de email asociată contului tău și îți vom trimite un link pentru resetarea parolei.
          </Text>
        </View>

        <View style={styles.form}>
          <View style={styles.inputGroup}>
            <Text style={styles.label}>Email</Text>
            <View style={styles.inputWrapper}>
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
          </View>

          <Button
            title="Trimite link de resetare"
            onPress={handleSendReset}
            variant="primary"
            size="lg"
            loading={loading}
            style={styles.submitButton}
          />
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  scroll: {
    flexGrow: 1,
    paddingHorizontal: SPACING.xl,
    paddingVertical: SPACING.xxxl,
  },
  backNav: {
    alignSelf: 'flex-start',
    marginBottom: SPACING.lg,
  },
  header: {
    alignItems: 'center',
    marginBottom: SPACING.xxxl,
  },
  iconCircle: {
    width: 90,
    height: 90,
    borderRadius: 45,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: SPACING.lg,
  },
  title: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.primary,
    marginBottom: SPACING.sm,
  },
  subtitle: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    textAlign: 'center',
    lineHeight: 22,
  },
  form: {
    gap: SPACING.lg,
  },
  inputGroup: {
    gap: SPACING.xs,
  },
  label: {
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
    color: COLORS.text,
    marginLeft: SPACING.xs,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.gray[50],
    borderRadius: RADIUS.lg,
    borderWidth: 1,
    borderColor: COLORS.border,
    paddingHorizontal: SPACING.md,
    gap: SPACING.sm,
  },
  input: {
    flex: 1,
    paddingVertical: SPACING.md,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
  },
  submitButton: {
    marginTop: SPACING.md,
  },
  sentContent: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: SPACING.xl,
  },
  successCircle: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: COLORS.success + '15',
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: SPACING.xl,
  },
  sentTitle: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
    marginBottom: SPACING.sm,
  },
  sentDesc: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    textAlign: 'center',
    lineHeight: 22,
    marginBottom: SPACING.md,
  },
  sentEmail: {
    fontSize: FONTS.sizes.md,
    fontWeight: '700',
    color: COLORS.primary,
    marginBottom: SPACING.xxl,
  },
  backButton: {
    width: '100%',
  },
});
