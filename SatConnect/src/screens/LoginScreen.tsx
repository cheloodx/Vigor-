import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, GLASS } from '../constants/theme';
import { supabaseAuth } from '../services/supabaseAuth';

interface LoginScreenProps {
  onLogin: () => void;
  onGoToRegister: () => void;
  onForgotPassword: () => void;
}

export function LoginScreen({ onLogin, onGoToRegister, onForgotPassword }: LoginScreenProps) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    if (!email || !password) {
      Alert.alert('Eroare', 'Completati email si parola.');
      return;
    }
    setLoading(true);
    try {
      const result = await supabaseAuth.signIn(email.trim(), password);
      setLoading(false);
      if (result.success) {
        onLogin();
      } else {
        Alert.alert('Eroare', result.error ?? 'Autentificare esuata.');
      }
    } catch (err: unknown) {
      setLoading(false);
      const message = err instanceof Error ? err.message : 'Autentificare esuata.';
      Alert.alert('Eroare', message);
    }
  };

  const handleDemoLogin = async () => {
    setLoading(true);
    try {
      await supabaseAuth.signIn('demo@satconnect.app', 'demo123');
      onLogin();
    } catch {
      // Even if demo login fails, go to main screen
      onLogin();
    } finally {
      setLoading(false);
    }
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <View style={styles.inner}>
        {/* Logo */}
        <View style={styles.logoWrap}>
          <MaterialCommunityIcons name="satellite-variant" size={40} color={COLORS.accent} />
        </View>
        <Text style={styles.title}>SatConnect</Text>
        <Text style={styles.subtitle}>Conectivitate globala</Text>

        {/* Form */}
        <View style={styles.form}>
          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="email-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="Email"
              placeholderTextColor={COLORS.textLight}
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
            />
          </View>
          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="lock-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="Parola"
              placeholderTextColor={COLORS.textLight}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
            />
            <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
              <MaterialCommunityIcons name={showPassword ? 'eye-off' : 'eye'} size={20} color={COLORS.textLight} />
            </TouchableOpacity>
          </View>

          <TouchableOpacity onPress={onForgotPassword}>
            <Text style={styles.forgotText}>Am uitat parola</Text>
          </TouchableOpacity>

          <TouchableOpacity style={styles.loginBtn} onPress={handleLogin} disabled={loading}>
            {loading ? (
              <ActivityIndicator color={COLORS.primary} />
            ) : (
              <Text style={styles.loginBtnText}>Conectare</Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity style={styles.registerBtn} onPress={onGoToRegister} disabled={loading}>
            <Text style={styles.registerBtnText}>Creeaza cont</Text>
          </TouchableOpacity>

          <View style={styles.divider}>
            <View style={styles.dividerLine} />
            <Text style={styles.dividerText}>sau</Text>
            <View style={styles.dividerLine} />
          </View>

          <TouchableOpacity style={styles.demoBtn} onPress={handleDemoLogin} disabled={loading}>
            <MaterialCommunityIcons name="play-circle-outline" size={20} color={COLORS.accent} />
            <Text style={styles.demoBtnText}>Mod Demo</Text>
          </TouchableOpacity>
        </View>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  inner: { flex: 1, justifyContent: 'center', paddingHorizontal: SPACING.xl },
  logoWrap: { width: 72, height: 72, borderRadius: 36, ...GLASS.card, alignItems: 'center', justifyContent: 'center', alignSelf: 'center', marginBottom: SPACING.lg },
  title: { fontSize: FONTS.sizes.xxxl, fontWeight: '800', color: COLORS.text, textAlign: 'center', letterSpacing: -0.5 },
  subtitle: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary, textAlign: 'center', marginBottom: SPACING.xxl },
  form: { gap: SPACING.md },
  inputWrap: { ...GLASS.card, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', paddingHorizontal: SPACING.md, paddingVertical: SPACING.sm, gap: SPACING.sm },
  input: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text, paddingVertical: SPACING.xs },
  forgotText: { fontSize: FONTS.sizes.sm, color: COLORS.accent, textAlign: 'right', fontWeight: '600' },
  loginBtn: { backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center', marginTop: SPACING.sm },
  loginBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.primary },
  registerBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center' },
  registerBtnText: { fontSize: FONTS.sizes.md, fontWeight: '600', color: COLORS.text },
  divider: { flexDirection: 'row', alignItems: 'center', gap: SPACING.md, marginVertical: SPACING.sm },
  dividerLine: { flex: 1, height: 0.5, backgroundColor: 'rgba(255,255,255,0.1)' },
  dividerText: { fontSize: FONTS.sizes.sm, color: COLORS.textLight },
  demoBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', justifyContent: 'center', paddingVertical: SPACING.md, gap: SPACING.sm },
  demoBtnText: { fontSize: FONTS.sizes.md, fontWeight: '600', color: COLORS.accent },
});
