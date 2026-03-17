import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  FlatList,
  TouchableOpacity,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING, SHADOWS } from '../constants/theme';
import { MOCK_CONVERSATIONS, MOCK_CONTACTS } from '../constants/data';
import { Conversation, Contact } from '../types';

interface MessagesScreenProps {
  onOpenChat: (conversationId: string, contactName: string) => void;
}

export function MessagesScreen({ onOpenChat }: MessagesScreenProps) {
  const getContact = (participantId: string): Contact | undefined => {
    return MOCK_CONTACTS.find((c) => c.id === participantId);
  };

  const formatTime = (timestamp: string): string => {
    const date = new Date(timestamp);
    const now = new Date();
    const diff = now.getTime() - date.getTime();
    const hours = Math.floor(diff / (1000 * 60 * 60));

    if (hours < 1) return 'Acum';
    if (hours < 24) return `${hours}h`;
    return date.toLocaleDateString('ro-RO', { day: 'numeric', month: 'short' });
  };

  const renderConversation = ({ item }: { item: Conversation }) => {
    const otherParticipant = item.participants.find((p) => p !== 'user');
    const contact = otherParticipant ? getContact(otherParticipant) : undefined;
    const name = contact?.name || 'Necunoscut';
    const isOnline = contact?.isOnline || false;

    return (
      <TouchableOpacity
        style={styles.conversationItem}
        onPress={() => onOpenChat(item.id, name)}
        activeOpacity={0.7}
      >
        <View style={styles.avatar}>
          <Text style={styles.avatarText}>{name.charAt(0)}</Text>
          {isOnline && <View style={styles.onlineDot} />}
        </View>

        <View style={styles.conversationContent}>
          <View style={styles.conversationHeader}>
            <Text style={styles.contactName} numberOfLines={1}>{name}</Text>
            <Text style={styles.time}>
              {item.lastMessage ? formatTime(item.lastMessage.timestamp) : ''}
            </Text>
          </View>

          <View style={styles.messageRow}>
            {item.lastMessage && (
              <>
                {item.lastMessage.status === 'queued' && (
                  <MaterialCommunityIcons name="clock-outline" size={14} color={COLORS.warning} />
                )}
                {item.lastMessage.compressed && (
                  <MaterialCommunityIcons name="arrow-collapse" size={12} color={COLORS.textLight} />
                )}
                <Text style={styles.lastMessage} numberOfLines={1}>
                  {item.lastMessage.senderId === 'user' ? 'Tu: ' : ''}
                  {item.lastMessage.text}
                </Text>
              </>
            )}
            {item.unreadCount > 0 && (
              <View style={styles.unreadBadge}>
                <Text style={styles.unreadText}>{item.unreadCount}</Text>
              </View>
            )}
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Mesaje</Text>
        <View style={styles.headerBadge}>
          <MaterialCommunityIcons name="sync" size={14} color={COLORS.accent} />
          <Text style={styles.headerBadgeText}>Sincronizat</Text>
        </View>
      </View>

      <FlatList
        data={MOCK_CONVERSATIONS}
        renderItem={renderConversation}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.list}
        ItemSeparatorComponent={() => <View style={styles.separator} />}
        ListEmptyComponent={
          <View style={styles.empty}>
            <MaterialCommunityIcons name="message-text-outline" size={48} color={COLORS.textLight} />
            <Text style={styles.emptyText}>Nicio conversație încă</Text>
            <Text style={styles.emptySubtext}>
              Mesajele tale se salvează offline și se sincronizează automat
            </Text>
          </View>
        }
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: SPACING.lg,
    paddingTop: 60,
    paddingBottom: SPACING.md,
    backgroundColor: COLORS.white,
    borderBottomWidth: 1,
    borderBottomColor: COLORS.border,
  },
  title: {
    fontSize: FONTS.sizes.xxl,
    fontWeight: '800',
    color: COLORS.text,
  },
  headerBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: COLORS.accent + '15',
    paddingHorizontal: SPACING.sm,
    paddingVertical: SPACING.xs,
    borderRadius: RADIUS.full,
  },
  headerBadgeText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.accent,
    fontWeight: '600',
  },
  list: {
    paddingVertical: SPACING.sm,
  },
  conversationItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: SPACING.lg,
    paddingVertical: SPACING.md,
    gap: SPACING.md,
  },
  avatar: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {
    color: COLORS.white,
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
  },
  onlineDot: {
    position: 'absolute',
    bottom: 0,
    right: 0,
    width: 14,
    height: 14,
    borderRadius: 7,
    backgroundColor: COLORS.success,
    borderWidth: 2,
    borderColor: COLORS.white,
  },
  conversationContent: {
    flex: 1,
  },
  conversationHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 4,
  },
  contactName: {
    fontSize: FONTS.sizes.md,
    fontWeight: '600',
    color: COLORS.text,
    flex: 1,
    marginRight: SPACING.sm,
  },
  time: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textLight,
  },
  messageRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  lastMessage: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    flex: 1,
  },
  unreadBadge: {
    backgroundColor: COLORS.primary,
    borderRadius: RADIUS.full,
    minWidth: 20,
    height: 20,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 5,
  },
  unreadText: {
    color: COLORS.white,
    fontSize: 11,
    fontWeight: '700',
  },
  separator: {
    height: 1,
    backgroundColor: COLORS.gray[100],
    marginLeft: 80,
  },
  empty: {
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: 100,
    gap: SPACING.sm,
  },
  emptyText: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '600',
    color: COLORS.text,
  },
  emptySubtext: {
    fontSize: FONTS.sizes.sm,
    color: COLORS.textSecondary,
    textAlign: 'center',
    paddingHorizontal: SPACING.xxxl,
  },
});
