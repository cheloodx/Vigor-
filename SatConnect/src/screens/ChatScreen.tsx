import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  StyleSheet,
  FlatList,
  TouchableOpacity,
  KeyboardAvoidingView,
  Platform,
} from 'react-native';
import { MaterialCommunityIcons } from '@expo/vector-icons';
import { COLORS, FONTS, RADIUS, SPACING } from '../constants/theme';
import { MOCK_MESSAGES, MOCK_CONVERSATIONS } from '../constants/data';
import { MessageBubble } from '../components/MessageBubble';
import { Message } from '../types';

interface ChatScreenProps {
  conversationId: string;
  contactName: string;
  onBack: () => void;
}

export function ChatScreen({ conversationId, contactName, onBack }: ChatScreenProps) {
  const [messages, setMessages] = useState<Message[]>(
    MOCK_MESSAGES.filter((m) => m.conversationId === conversationId)
  );
  const [inputText, setInputText] = useState('');
  const flatListRef = useRef<FlatList>(null);

  useEffect(() => {
    // Scroll to bottom on mount
    if (flatListRef.current && messages.length > 0) {
      setTimeout(() => {
        flatListRef.current?.scrollToEnd({ animated: false });
      }, 100);
    }
  }, [messages.length]);

  const handleSend = () => {
    if (!inputText.trim()) return;

    const newMessage: Message = {
      id: `msg-${Date.now()}`,
      senderId: 'user',
      receiverId: MOCK_CONVERSATIONS.find(c => c.id === conversationId)?.participants.find(p => p !== 'user') || '',
      conversationId,
      text: inputText.trim(),
      timestamp: new Date().toISOString(),
      status: 'queued',
      compressed: false,
      sizeBytes: new TextEncoder().encode(inputText.trim()).length,
    };

    setMessages((prev) => [...prev, newMessage]);
    setInputText('');

    // Simulate sending - status changes over time
    setTimeout(() => {
      setMessages((prev) =>
        prev.map((m) => (m.id === newMessage.id ? { ...m, status: 'sending' } : m))
      );
    }, 500);

    setTimeout(() => {
      setMessages((prev) =>
        prev.map((m) => (m.id === newMessage.id ? { ...m, status: 'sent' } : m))
      );
    }, 2000);

    setTimeout(() => {
      setMessages((prev) =>
        prev.map((m) => (m.id === newMessage.id ? { ...m, status: 'delivered' } : m))
      );
    }, 3500);
  };

  const estimateSize = new TextEncoder().encode(inputText.trim()).length;

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
    >
      {/* Header */}
      <View style={styles.header}>
        <TouchableOpacity onPress={onBack} style={styles.backButton}>
          <MaterialCommunityIcons name="arrow-left" size={24} color={COLORS.white} />
        </TouchableOpacity>
        <View style={styles.headerInfo}>
          <Text style={styles.headerName}>{contactName}</Text>
          <View style={styles.headerStatus}>
            <View style={styles.headerDot} />
            <Text style={styles.headerStatusText}>Offline - mesaje în coadă</Text>
          </View>
        </View>
      </View>

      {/* Messages */}
      <FlatList
        ref={flatListRef}
        data={messages}
        renderItem={({ item }) => (
          <MessageBubble message={item} isOwn={item.senderId === 'user'} />
        )}
        keyExtractor={(item) => item.id}
        contentContainerStyle={styles.messagesList}
        ListEmptyComponent={
          <View style={styles.empty}>
            <MaterialCommunityIcons name="satellite-variant" size={40} color={COLORS.textLight} />
            <Text style={styles.emptyText}>Începe o conversație</Text>
            <Text style={styles.emptySubtext}>
              Mesajele se salvează local și se trimit când apare conexiune
            </Text>
          </View>
        }
      />

      {/* Input */}
      <View style={styles.inputContainer}>
        <View style={styles.inputRow}>
          <TextInput
            style={styles.input}
            placeholder="Scrie un mesaj..."
            placeholderTextColor={COLORS.textLight}
            value={inputText}
            onChangeText={setInputText}
            multiline
            maxLength={500}
          />
          <TouchableOpacity
            style={[styles.sendButton, !inputText.trim() && styles.sendDisabled]}
            onPress={handleSend}
            disabled={!inputText.trim()}
          >
            <MaterialCommunityIcons name="send" size={20} color={COLORS.white} />
          </TouchableOpacity>
        </View>
        {inputText.length > 0 && (
          <Text style={styles.sizeEstimate}>
            ~{estimateSize}B • {inputText.length}/500 caractere
          </Text>
        )}
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: COLORS.white,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: COLORS.primary,
    paddingTop: 50,
    paddingBottom: SPACING.md,
    paddingHorizontal: SPACING.md,
    gap: SPACING.md,
  },
  backButton: {
    padding: SPACING.xs,
  },
  headerInfo: {
    flex: 1,
  },
  headerName: {
    fontSize: FONTS.sizes.lg,
    fontWeight: '700',
    color: COLORS.white,
  },
  headerStatus: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  headerDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: COLORS.warning,
  },
  headerStatusText: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.gray[300],
  },
  messagesList: {
    paddingVertical: SPACING.md,
    flexGrow: 1,
    justifyContent: 'flex-end',
  },
  empty: {
    flex: 1,
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
  inputContainer: {
    borderTopWidth: 1,
    borderTopColor: COLORS.border,
    paddingHorizontal: SPACING.md,
    paddingVertical: SPACING.sm,
    backgroundColor: COLORS.white,
  },
  inputRow: {
    flexDirection: 'row',
    alignItems: 'flex-end',
    gap: SPACING.sm,
  },
  input: {
    flex: 1,
    backgroundColor: COLORS.gray[50],
    borderRadius: RADIUS.xl,
    paddingHorizontal: SPACING.lg,
    paddingVertical: SPACING.sm,
    fontSize: FONTS.sizes.md,
    color: COLORS.text,
    maxHeight: 100,
    borderWidth: 1,
    borderColor: COLORS.border,
  },
  sendButton: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: COLORS.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  sendDisabled: {
    backgroundColor: COLORS.gray[300],
  },
  sizeEstimate: {
    fontSize: FONTS.sizes.xs,
    color: COLORS.textLight,
    textAlign: 'right',
    marginTop: 4,
  },
});
