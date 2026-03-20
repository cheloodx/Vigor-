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

interface LoginScreenProps {
  onLogin: () => void;
  onGoToRegister: () => void;
  onForgotPassword?: () => void;
}

export function LoginScreen({ onLogin, onGoToRegister, onForgotPassword }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, []);

  const handleLogin = async () => {
    if (!email.trim() || !password.trim()) {
      Alert.alert('Eroare', 'Completează toate câmpurile');
      return;
    }
    setLoading(true);
    try {
      const result = await supabaseAuth.signIn(email.trim(), password);
      setLoading(false);
      if (result.success) {
        onLogin();
      } else {
        Alert.alert('Eroare', result.error ?? 'Autentificare eșuată.');
      }
    } catch {
      setLoading(false);
      Alert.alert('Eroare', 'A apărut o eroare de rețea. Încearcă din nou.');
    }
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <View style={styles.header}>
          <View style={styles.iconCircle}>
            <MaterialCommunityIcons name="satellite-variant" size={48} color={COLORS.white} />
          </View>
          <Text style={styles.title}>SatConnect</Text>
          <Text style={styles.subtitle}>Conectat oriunde, oricând</Text>
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

          <View style={styles.inputGroup}>
            <Text style={styles.label}>Parolă</Text>
            <View style={styles.inputWrapper}>
              <MaterialCommunityIcons name="lock-outline" size={20} color={COLORS.textLight} />
              <TextInput
                style={styles.input}
                placeholder="Parola ta"
                placeholderTextColor={COLORS.textLight}
                value={password}
                onChangeText={setPassword}
                secureTextEntry={!showPassword}
              />
              <Button
                title=""
                onPress={() => setShowPassword(!showPassword)}
                variant="ghost"
                icon={
                  <MaterialCommunityIcons
                    name={showPassword ? 'eye-off' : 'eye'}
                    size={20}
                    color={COLORS.textLight}
                  />
                }
              />
            </View>
          </View>

          <Button
            title="Conectează-te"
            onPress={handleLogin}
            variant="primary"
            size="lg"
            loading={loading}
            style={styles.loginButton}
          />

          {onForgotPassword && (
            <Button
              title="Am uitat parola"
              onPress={onForgotPassword}
              variant="ghost"
              size="sm"
              style={styles.forgotButton}
            />
          )}

          <View style={styles.registerRow}>
            <Text style={styles.registerText}>Nu ai cont? </Text>
            <Button title="Înregistrează-te" onPress={onGoToRegister} variant="ghost" size="sm" />
          </View>
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
    justifyContent: 'center',
    paddingHorizontal: SPACING.xl,
    paddingVertical: SPACING.xxxl,
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
    fontSize: FONTS.sizes.xxxl,
    fontWeight: '800',
    color: COLORS.primary,
    marginBottom: SPACING.xs,
  },
  subtitle: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
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
  loginButton: {
    marginTop: SPACING.md,
  },
  registerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  registerText: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
  },
  forgotButton: {
    alignSelf: 'center',
  },
});
