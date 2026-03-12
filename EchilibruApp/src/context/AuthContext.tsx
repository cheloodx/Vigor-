import React, { createContext, useContext, useState, ReactNode } from 'react';

interface User {
  email: string;
  name: string;
}

interface AuthContextType {
  user: User | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<boolean>;
  register: (name: string, email: string, password: string) => Promise<boolean>;
  logout: () => void;
  favorites: string[];
  toggleFavorite: (id: string) => void;
  shoppingList: { id: string; name: string; checked: boolean }[];
  toggleShoppingItem: (id: string) => void;
  addShoppingItem: (name: string) => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [favorites, setFavorites] = useState<string[]>([]);
  const [shoppingList, setShoppingList] = useState<{ id: string; name: string; checked: boolean }[]>([
    { id: '1', name: 'Piept de pui 500g', checked: false },
    { id: '2', name: 'Orez integral 1kg', checked: false },
    { id: '3', name: 'Broccoli 300g', checked: false },
    { id: '4', name: 'Oua 10 buc', checked: true },
    { id: '5', name: 'Lapte 1L', checked: false },
    { id: '6', name: 'Rosii 500g', checked: false },
    { id: '7', name: 'Ulei de masline', checked: true },
    { id: '8', name: 'Banane 1kg', checked: false },
  ]);

  const login = async (email: string, _password: string): Promise<boolean> => {
    setUser({ email, name: email.split('@')[0] });
    return true;
  };

  const register = async (name: string, email: string, _password: string): Promise<boolean> => {
    setUser({ email, name });
    return true;
  };

  const logout = () => {
    setUser(null);
    setFavorites([]);
  };

  const toggleFavorite = (id: string) => {
    setFavorites(prev =>
      prev.includes(id) ? prev.filter(f => f !== id) : [...prev, id]
    );
  };

  const toggleShoppingItem = (id: string) => {
    setShoppingList(prev =>
      prev.map(item =>
        item.id === id ? { ...item, checked: !item.checked } : item
      )
    );
  };

  const addShoppingItem = (name: string) => {
    setShoppingList(prev => {
      const newId = (prev.length + 1).toString();
      return [...prev, { id: newId, name, checked: false }];
    });
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated: !!user,
        login,
        register,
        logout,
        favorites,
        toggleFavorite,
        shoppingList,
        toggleShoppingItem,
        addShoppingItem,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within AuthProvider');
  }
  return context;
}
