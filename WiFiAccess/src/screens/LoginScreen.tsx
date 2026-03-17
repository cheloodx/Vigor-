import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Alert,
} from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { Button } from '../components/Button';

interface LoginScreenProps {
  onLogin: () => void;
  onGoToRegister: () => void;
}

export function LoginScreen({ onLogin, onGoToRegister }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const timeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  useEffect(() => {
    return () => {
      if (timeoutRef.current) clearTimeout(timeoutRef.current);
    };
  }, []);

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Eroare', 'Completează toate câmpurile');
      return;
    }
    setLoading(true);
    // Simulate API call
    timeoutRef.current = setTimeout(() => {
      setLoading(false);
      onLogin();
    }, 1500);
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      <ScrollView
        contentContainerStyle={styles.scrollContent}
        keyboardShouldPersistTaps="handled"
      >
        <View style={styles.header}>
          <View style={styles.logo}>
            <Ionicons name="wifi" size={32} color={COLORS.white} />
          </View>
          <Text style={styles.appName}>WiFi Access</Text>
          <Text style={styles.subtitle}>Conectează-te la contul tău</Text>
        </View>

        <View style={styles.form}>
          <View style={styles.inputContainer}>
            <Ionicons
              name="mail-outline"
              size={20}
              color={COLORS.gray[400]}
              style={styles.inputIcon}
            />
            <TextInput
              style={styles.input}
              placeholder="Email"
              placeholderTextColor={COLORS.gray[400]}
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
            />
          </View>

          <View style={styles.inputContainer}>
            <Ionicons
              name="lock-closed-outline"
              size={20}
              color={COLORS.gray[400]}
              style={styles.inputIcon}
            />
            <TextInput
              style={styles.input}
              placeholder="Parolă"
              placeholderTextColor={COLORS.gray[400]}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
            />
            <TouchableOpacity
              onPress={() => setShowPassword(!showPassword)}
              style={styles.eyeButton}
            >
              <Ionicons
                name={showPassword ? 'eye-off-outline' : 'eye-outline'}
                size={20}
                color={COLORS.gray[400]}
              />
            </TouchableOpacity>
          </View>

          <TouchableOpacity style={styles.forgotPassword}>
            <Text style={styles.forgotPasswordText}>Ai uitat parola?</Text>
          </TouchableOpacity>

          <Button
            title="Conectează-te"
            onPress={handleLogin}
            loading={loading}
            style={styles.loginButton}
          />

          <View style={styles.dividerRow}>
            <View style={styles.divider} />
            <Text style={styles.dividerText}>sau</Text>
            <View style={styles.divider} />
          </View>

          <Button
            title="Conectează-te cu Apple"
            onPress={() => Alert.alert('Info', 'Apple Sign In va fi disponibil în curând')}
            variant="outline"
            icon={<Ionicons name="logo-apple" size={20} color={COLORS.text} />}
            textStyle={{ color: COLORS.text }}
          />
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Nu ai un cont? </Text>
          <TouchableOpacity onPress={onGoToRegister}>
            <Text style={styles.footerLink}>Înregistrează-te</Text>
          </TouchableOpacity>
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
  scrollContent: {
    flexGrow: 1,
    paddingHorizontal: SPACING.lg,
    paddingTop: 80,
    paddingBottom: SPACING.xl,
  },
  header: {
    alignItems: 'center',
    marginBottom: SPACING.xl,
  },
  logo: {
    width: 64,
    height: 64,
    borderRadius: RADIUS.lg,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: SPACING.md,
  },
  appName: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '700',
    color: COLORS.text,
  },
  subtitle: {
    fontSize: FONTS.sizes.md,
    color: COLORS.textSecondary,
    marginTop: SPACING.xs,
  },
  form: {
    gap: SPACING.md,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.gray[50],
    borderRadius: RADIUS.md,
    borderWidth: 1,
    borderColor: COLORS.border,
    paddingHorizontal: SPACING.md,
  },
  inputIcon: {
    marginRight: SPACING.sm,
  },
  input: {
    flex: 1,
    paddingVertical: SPACING.md,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
  },
  eyeButton: {
    padding: SPACING.xs,
  },
  forgotPassword: {
    alignSelf: 'flex-end',
  },
  forgotPasswordText: {
    color: COLORS.primary,
    fontSize: FONTS.sizes.sm,
    fontWeight: '500',
  },
  loginButton: {
    marginTop: SPACING.sm,
  },
  dividerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: SPACING.sm,
  },
  divider: {
    flex: 1,
    height: 1,
    backgroundColor: COLORS.border,
  },
  dividerText: {
    color: COLORS.textSecondary,
    marginHorizontal: SPACING.md,
    fontSize: FONTS.sizes.sm,
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'center',
    marginTop: SPACING.xl,
  },
  footerText: {
    color: COLORS.textSecondary,
    fontSize: FONTS.sizes.sm,
  },
  footerLink: {
    color: COLORS.primary,
    fontSize: FONTS.sizes.sm,
    fontWeight: '600',
  },
});
