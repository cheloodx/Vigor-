import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { Message } from '../types';

interface MessageBubbleProps {
  message: Message;
  isOwn: boolean;
}

const STATUS_ICONS: Record<string, { name: keyof typeof Ionicons.glyphMap; color: string }> = {
  queued: { name: 'time-outline', color: COLORS.textLight },
  sending: { name: 'arrow-up-circle-outline', color: COLORS.warning },
  sent: { name: 'checkmark', color: COLORS.textLight },
  delivered: { name: 'checkmark-done', color: COLORS.accent },
  failed: { name: 'alert-circle', color: COLORS.error },
};

export function MessageBubble({ message, isOwn }: MessageBubbleProps) {
  const statusInfo = STATUS_ICONS[message.status];
  const time = new Date(message.timestamp).toLocaleTimeString('ro-RO', {
    hour: '2-digit',
    minute: '2-digit',
  });

  return (
    <View style={[styles.container, isOwn ? styles.own : styles.other]}>
      <View style={[styles.bubble, isOwn ? styles.bubbleOwn : styles.bubbleOther]}>
        <Text style={[styles.text, isOwn ? styles.textOwn : styles.textOther]}>
          {message.text}
        </Text>
        <View style={styles.meta}>
          {message.compressed && (
            <Ionicons name="compass" size={10} color={isOwn ? COLORS.gray[300] : COLORS.textLight} />
          )}
          <Text style={[styles.time, isOwn ? styles.timeOwn : styles.timeOther]}>{time}</Text>
          {isOwn && statusInfo && (
            <Ionicons name={statusInfo.name} size={14} color={statusInfo.color} />
          )}
          <Text style={[styles.size, isOwn ? styles.timeOwn : styles.timeOther]}>
            {message.sizeBytes}B
          </Text>
        </View>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    marginVertical: 2,
    paddingHorizontal: SPACING.md,
  },
  own: {
    alignItems: 'flex-end',
  },
  other: {
    alignItems: 'flex-start',
  },
  bubble: {
    maxWidth: '80%',
    borderRadius: RADIUS.lg,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
  },
  bubbleOwn: {
    backgroundColor: COLORS.primary,
    borderBottomRightRadius: RADIUS.sm,
  },
  bubbleOther: {
    backgroundColor: 'rgba(255,255,255,0.08)',
    borderBottomLeftRadius: RADIUS.sm,
  },
  text: {
    fontSize: FONTS.sizes.md,
    lineHeight: 20,
  },
  textOwn: {
    color: COLORS.white,
  },
  textOther: {
    color: COLORS.text,
  },
  meta: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 4,
  },
  time: {
    fontSize: FONTS.sizes.xs,
  },
  timeOwn: {
    color: COLORS.gray[300],
  },
  timeOther: {
    color: COLORS.textLight,
  },
  size: {
    fontSize: 9,
  },
});
