import React, { useState, useRef, useEffect } from 'react';
import { View, Text, StyleSheet, Animated, Alert } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { Button } from './Button';

interface SOSButtonProps {
  onActivate: () => void;
  disabled?: boolean;
}

export function SOSButton({ onActivate, disabled = false }: SOSButtonProps) {
  const [isHolding, setIsHolding] = useState(false);
  const [holdProgress, setHoldProgress] = useState(0);
  const pulseAnim = useRef(new Animated.Value(1)).current;
  const holdTimer = useRef<ReturnType<typeof setInterval> | null>(null);
  const progressRef = useRef(0);

  useEffect(() => {
    const pulse = Animated.loop(
      Animated.sequence([
        Animated.timing(pulseAnim, {
          toValue: 1.15,
          duration: 1000,
          useNativeDriver: true,
        }),
        Animated.timing(pulseAnim, {
          toValue: 1,
          duration: 1000,
          useNativeDriver: true,
        }),
      ])
    );
    pulse.start();
    return () => {
      pulse.stop();
      if (holdTimer.current) clearInterval(holdTimer.current);
    };
  }, [pulseAnim]);

  const startHold = () => {
    if (disabled) return;
    if (holdTimer.current) clearInterval(holdTimer.current);
    setIsHolding(true);
    progressRef.current = 0;
    setHoldProgress(0);

    holdTimer.current = setInterval(() => {
      progressRef.current += 2;
      setHoldProgress(progressRef.current);

      if (progressRef.current >= 100) {
        if (holdTimer.current) clearInterval(holdTimer.current);
        holdTimer.current = null;
        setIsHolding(false);
        setHoldProgress(0);
        onActivate();
        Alert.alert(
          'SOS Activat!',
          'Alerta de urgență a fost trimisă. Locația ta va fi partajată cu contactele de urgență.',
          [{ text: 'OK' }]
        );
      }
    }, 60); // 3 seconds total to fill
  };

  const cancelHold = () => {
    if (holdTimer.current) clearInterval(holdTimer.current);
    setIsHolding(false);
    setHoldProgress(0);
    progressRef.current = 0;
  };

  return (
    <View style={styles.container}>
      <Animated.View style={[styles.pulseRing, { transform: [{ scale: pulseAnim }] }]} />
      <View
        style={styles.buttonWrapper}
        onTouchStart={startHold}
        onTouchEnd={cancelHold}
        onTouchCancel={cancelHold}
      >
        <View style={[styles.button, disabled && styles.disabled]}>
          {isHolding && (
            <View style={[styles.progressOverlay, { height: `${holdProgress}%` }]} />
          )}
          <Ionicons name="warning" size={40} color={COLORS.white} />
          <Text style={styles.sosText}>SOS</Text>
        </View>
      </View>
      <Text style={styles.hint}>
        {isHolding ? `Ține apăsat... ${Math.round(holdProgress)}%` : 'Ține apăsat 3 secunde'}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    gap: SPACING.sm,
  },
  pulseRing: {
    position: 'absolute',
    width: 160,
    height: 160,
    borderRadius: 80,
    backgroundColor: COLORS.sosLight,
    opacity: 0.4,
  },
  buttonWrapper: {
    width: 140,
    height: 140,
    borderRadius: 70,
    overflow: 'hidden',
  },
  button: {
    width: 140,
    height: 140,
    borderRadius: 70,
    backgroundColor: COLORS.sos,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
  },
  disabled: {
    opacity: 0.5,
  },
  progressOverlay: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: 'rgba(0,0,0,0.3)',
  },
  sosText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.xxl,
    fontWeight: '900',
    letterSpacing: 3,
    marginTop: 4,
  },
  hint: {
    color: COLORS.textSecondary,
    fontSize: FONTS.sizes.sm,
    textAlign: 'center',
  },
});
