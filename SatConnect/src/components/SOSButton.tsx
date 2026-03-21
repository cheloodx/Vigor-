import React, { useRef, useState, useEffect } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated, Alert } from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';

interface Props {
  onActivate: () => void;
}

export function SOSButton({ onActivate }: Props) {
  const pulseAnim = useRef(new Animated.Value(1)).current;
  const [pressing, setPressing] = useState(false);
  const [progress, setProgress] = useState(0);
  const timerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, { toValue: 1.15, duration: 1200, useNativeDriver: true }),
        Animated.timing(pulseAnim, { toValue: 1, duration: 1200, useNativeDriver: true }),
      ])
    ).start();
  }, [pulseAnim]);

  const startPress = () => {
    setPressing(true);
    setProgress(0);
    let p = 0;
    timerRef.current = setInterval(() => {
      p += 0.033;
      setProgress(p);
      if (p >= 1) {
        if (timerRef.current) clearInterval(timerRef.current);
        setPressing(false);
        setProgress(0);
        Alert.alert('SOS Activat', 'Semnal de urgenta trimis!');
        onActivate();
      }
    }, 100);
  };

  const endPress = () => {
    if (timerRef.current) clearInterval(timerRef.current);
    setPressing(false);
    setProgress(0);
  };

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.pulseRing, { transform: [{ scale: pulseAnim }] }]} />
      <TouchableOpacity
        style={[styles.button, pressing && styles.buttonActive]}
        onPressIn={startPress}
        onPressOut={endPress}
        activeOpacity={0.8}
      >
        <MaterialCommunityIcons name="alert-circle" size={28} color={COLORS.white} />
        <Text style={styles.label}>SOS</Text>
        {pressing && (
          <View style={[styles.progressOverlay, { height: `${progress * 100}%` }]} />
        )}
      </TouchableOpacity>
      <Text style={styles.hint}>Tineti apasat 3s pentru SOS</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { alignItems: 'center', gap: SPACING.sm },
  pulseRing: { position: 'absolute', width: 88, height: 88, borderRadius: 44, borderWidth: 2, borderColor: 'rgba(220,38,38,0.25)' },
  button: { width: 72, height: 72, borderRadius: 36, backgroundColor: COLORS.sos, alignItems: 'center', justifyContent: 'center', overflow: 'hidden' },
  buttonActive: { backgroundColor: '#B91C1C' },
  label: { fontSize: 11, fontWeight: '900', color: COLORS.white, letterSpacing: 2, marginTop: 2 },
  progressOverlay: { position: 'absolute', bottom: 0, left: 0, right: 0, backgroundColor: 'rgba(255,255,255,0.2)', borderRadius: 36 },
  hint: { fontSize: FONTS.sizes.xs, color: COLORS.textLight },
});
