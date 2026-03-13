import React, { useState } from 'react';
import { View, Text, StyleSheet, TextInput, TouchableOpacity, Alert, KeyboardAvoidingView, Platform } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';
import { Colors } from '../constants/colors';
import { useAuth } from '../context/AuthContext';
import { useNavigation } from '@react-navigation/native';
import type { NativeStackNavigationProp } from '@react-navigation/native-stack';
import type { RootStackParamList } from '../constants/types';
import { useLanguage } from '../context/LanguageContext';

type Nav = NativeStackNavigationProp<RootStackParamList>;

export default function RegisterScreen() {
  const { register } = useAuth();
  const navigation = useNavigation<Nav>();
  const { t } = useLanguage();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleRegister = async () => {
    if (!name || !email || !password) { Alert.alert(t.register.error, t.register.fillAll); return; }
    const success = await register(name, email, password);
    if (success) navigation.goBack();
  };

  return (
    <KeyboardAvoidingView style={s.container} behavior={Platform.OS === 'ios' ? 'padding' : 'height'}>
      <LinearGradient colors={['#F0FDF4', '#FFFFFF']} style={s.bg}>
        <View style={s.form}>
                    <Text style={s.title}>{t.register.title}</Text>
                    <Text style={s.subtitle}>{t.register.subtitle}</Text>

                    <Text style={s.label}>{t.register.name}</Text>
                    <TextInput style={s.input} placeholder={t.register.namePlaceholder} value={name} onChangeText={setName} />

                    <Text style={s.label}>{t.register.email}</Text>
                    <TextInput style={s.input} placeholder={t.register.emailPlaceholder} value={email} onChangeText={setEmail} keyboardType="email-address" autoCapitalize="none" />

                    <Text style={s.label}>{t.register.password}</Text>
                    <TextInput style={s.input} placeholder={t.register.passwordPlaceholder} value={password} onChangeText={setPassword} secureTextEntry />

          <TouchableOpacity style={s.btn} onPress={handleRegister}>
            <Text style={s.btnText}>{t.register.registerBtn}</Text>
          </TouchableOpacity>

          <TouchableOpacity onPress={() => navigation.navigate('Login')} style={s.linkRow}>
                        <Text style={s.linkText}>{t.register.hasAccount}</Text>
                        <Text style={s.linkBold}>{t.register.login}</Text>
          </TouchableOpacity>
        </View>
      </LinearGradient>
    </KeyboardAvoidingView>
  );
}

const s = StyleSheet.create({
  container: { flex: 1 },
  bg: { flex: 1, justifyContent: 'center' },
  form: { marginHorizontal: 24, backgroundColor: Colors.white, borderRadius: 20, padding: 24, shadowColor: '#000', shadowOffset: { width: 0, height: 4 }, shadowOpacity: 0.1, shadowRadius: 12, elevation: 5 },
  title: { fontSize: 24, fontWeight: '800', color: Colors.black, marginBottom: 4 },
  subtitle: { fontSize: 14, color: Colors.gray[500], marginBottom: 24 },
  label: { fontSize: 14, fontWeight: '600', color: Colors.gray[700], marginBottom: 6 },
  input: { borderWidth: 1, borderColor: Colors.gray[200], borderRadius: 12, paddingHorizontal: 14, paddingVertical: 12, fontSize: 15, marginBottom: 16, backgroundColor: Colors.gray[50] },
  btn: { backgroundColor: Colors.primary, borderRadius: 12, paddingVertical: 14, alignItems: 'center', marginTop: 8 },
  btnText: { color: '#FFF', fontSize: 16, fontWeight: '700' },
  linkRow: { flexDirection: 'row', justifyContent: 'center', marginTop: 16 },
  linkText: { fontSize: 14, color: Colors.gray[500] },
  linkBold: { fontSize: 14, color: Colors.primary, fontWeight: '700' },
});
