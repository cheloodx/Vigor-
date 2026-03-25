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

interface RegisterScreenProps {
  onRegister: () => void;
  onGoToLogin: () => void;
}

export function RegisterScreen({ onRegister, onGoToLogin }: RegisterScreenProps) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const handleRegister = async () => {
    if (!name.trim() || !email.trim() || !password.trim() || !confirmPassword.trim()) {
      Alert.alert('Eroare', 'Completează toate câmpurile');
      return;
    }
    if (password !== confirmPassword) {
      Alert.alert('Eroare', 'Parolele nu coincid');
      return;
    }
    if (password.length < 6) {
      Alert.alert('Eroare', 'Parola trebuie să aibă cel puțin 6 caractere');
      return;
    }
    setLoading(true);
    try {
      const result = await supabaseAuth.signUp(email.trim(), password, name.trim());
      setLoading(false);
      if (result.success) {
        if (result.needsEmailConfirmation) {
          Alert.alert('Succes', result.message ?? 'Verifică emailul pentru confirmare.');
        } else {
          onRegister();
        }
      } else {
        Alert.alert('Eroare', result.error ?? 'Înregistrare eșuată.');
      }
    } catch {
      setLoading(false);
      Alert.alert('Eroare', 'A apărut o eroare de rețea. Încearcă din nou.');
    }
  };

  return (
    <KeyboardAvoidingView style={styles.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <ScrollView contentContainerStyle={styles.scroll} keyboardShouldPersistTaps="handled">
        <View style={styles.header}>
          <View style={styles.iconCircle}>
            <MaterialCommunityIcons name="satellite-variant" size={40} color={COLORS.accent} />
          </View>
          <Text style={styles.title}>Creeaza cont</Text>
          <Text style={styles.subtitle}>Conecteaza-te la reteaua globala</Text>
        </View>

        <View style={styles.form}>
          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="account-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="Nume complet"
              placeholderTextColor={COLORS.textLight}
              value={name}
              onChangeText={setName}
              autoCapitalize="words"
            />
          </View>

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
              autoCorrect={false}
            />
          </View>

          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="lock-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="Parola (minim 6 caractere)"
              placeholderTextColor={COLORS.textLight}
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
            />
            <TouchableOpacity onPress={() => setShowPassword(!showPassword)}>
              <MaterialCommunityIcons name={showPassword ? 'eye-off' : 'eye'} size={20} color={COLORS.textLight} />
            </TouchableOpacity>
          </View>

          <View style={styles.inputWrap}>
            <MaterialCommunityIcons name="lock-check-outline" size={20} color={COLORS.textLight} />
            <TextInput
              style={styles.input}
              placeholder="Confirma parola"
              placeholderTextColor={COLORS.textLight}
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              secureTextEntry={!showPassword}
            />
          </View>

          <TouchableOpacity style={styles.registerBtn} onPress={handleRegister} disabled={loading}>
            {loading ? (
              <ActivityIndicator color={COLORS.primary} />
            ) : (
              <Text style={styles.registerBtnText}>Creeaza cont</Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity style={styles.loginBtn} onPress={onGoToLogin} disabled={loading}>
            <Text style={styles.loginBtnText}>Am deja cont - Conectare</Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: COLORS.surface },
  scroll: { flexGrow: 1, justifyContent: 'center', paddingHorizontal: SPACING.xl, paddingVertical: SPACING.xxxl },
  header: { alignItems: 'center', marginBottom: SPACING.xxl },
  iconCircle: { width: 72, height: 72, borderRadius: 36, ...GLASS.card, alignItems: 'center', justifyContent: 'center', marginBottom: SPACING.md },
  title: { fontSize: FONTS.sizes.xxl, fontWeight: '800', color: COLORS.text, marginBottom: SPACING.xs },
  subtitle: { fontSize: FONTS.sizes.md, color: COLORS.textSecondary },
  form: { gap: SPACING.md },
  inputWrap: { ...GLASS.card, borderRadius: RADIUS.lg, flexDirection: 'row', alignItems: 'center', paddingHorizontal: SPACING.md, paddingVertical: SPACING.sm, gap: SPACING.sm },
  input: { flex: 1, fontSize: FONTS.sizes.md, color: COLORS.text, paddingVertical: SPACING.xs },
  registerBtn: { backgroundColor: COLORS.accent, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center', marginTop: SPACING.sm },
  registerBtnText: { fontSize: FONTS.sizes.md, fontWeight: '700', color: COLORS.primary },
  loginBtn: { ...GLASS.panel, borderRadius: RADIUS.lg, paddingVertical: SPACING.md, alignItems: 'center' },
  loginBtnText: { fontSize: FONTS.sizes.md, fontWeight: '600', color: COLORS.text },
});
