import SwiftUI
import AuthenticationServices
import Combine

// MARK: - Authentication Manager
// Sign in with Apple + user account management
class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated = false
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var userID: String = ""
    @Published var profileImageInitials: String = ""
    
    init() {
        loadSavedUser()
    }
    
    // MARK: - Sign In with Apple Handler
    func handleSignInResult(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                let displayName: String
                if let givenName = fullName?.givenName, let familyName = fullName?.familyName {
                    displayName = "\(givenName) \(familyName)"
                } else {
                    displayName = UserDefaults.standard.string(forKey: "auth_userName") ?? "Utilizator"
                }
                
                let displayEmail = email ?? UserDefaults.standard.string(forKey: "auth_userEmail") ?? ""
                
                DispatchQueue.main.async { [weak self] in
                    self?.userID = userId
                    self?.userName = displayName
                    self?.userEmail = displayEmail
                    self?.isAuthenticated = true
                    self?.profileImageInitials = String(displayName.prefix(2)).uppercased()
                    self?.saveUser()
                }
            }
        case .failure:
            DispatchQueue.main.async { [weak self] in
                self?.isAuthenticated = false
            }
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        isAuthenticated = false
        userName = ""
        userEmail = ""
        userID = ""
        profileImageInitials = ""
        clearSavedUser()
    }
    
    // MARK: - Persistence
    private func saveUser() {
        UserDefaults.standard.set(userID, forKey: "auth_userID")
        UserDefaults.standard.set(userName, forKey: "auth_userName")
        UserDefaults.standard.set(userEmail, forKey: "auth_userEmail")
        UserDefaults.standard.set(true, forKey: "auth_isAuthenticated")
    }
    
    private func loadSavedUser() {
        if UserDefaults.standard.bool(forKey: "auth_isAuthenticated") {
            userID = UserDefaults.standard.string(forKey: "auth_userID") ?? ""
            userName = UserDefaults.standard.string(forKey: "auth_userName") ?? "Utilizator"
            userEmail = UserDefaults.standard.string(forKey: "auth_userEmail") ?? ""
            profileImageInitials = String(userName.prefix(2)).uppercased()
            isAuthenticated = true
        }
    }
    
    private func clearSavedUser() {
        UserDefaults.standard.removeObject(forKey: "auth_userID")
        UserDefaults.standard.removeObject(forKey: "auth_userName")
        UserDefaults.standard.removeObject(forKey: "auth_userEmail")
        UserDefaults.standard.set(false, forKey: "auth_isAuthenticated")
    }
}

// MARK: - Sign In View
struct SignInView: View {
    @ObservedObject private var authManager = AuthenticationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if authManager.isAuthenticated {
                    // Profile view
                    profileView
                } else {
                    // Sign in view
                    signInContent
                }
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Theme.primary)
                    Text("Cont")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Theme.textPrimary)
                }
            }
        }
    }
    
    // MARK: - Sign In Content
    private var signInContent: some View {
        VStack(spacing: 16) {
            // Logo
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 100, height: 100)
                Image(systemName: "car.fill")
                    .font(.system(size: 44))
                    .foregroundColor(Theme.primary)
            }
            .padding(.top, 30)
            
            Text("AutoDiag Pro")
                .font(.system(size: 24, weight: .black))
                .foregroundColor(Theme.textPrimary)
            
            Text("Conecteaza-te pentru a sincroniza datele pe toate dispozitivele tale")
                .font(.system(size: 13))
                .foregroundColor(Theme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            // Benefits
            VStack(alignment: .leading, spacing: 10) {
                benefitRow(icon: "icloud.fill", text: "Sincronizare iCloud automata")
                benefitRow(icon: "iphone.and.arrow.forward", text: "Aceleasi date pe iPhone si iPad")
                benefitRow(icon: "lock.shield.fill", text: "Criptare end-to-end")
                benefitRow(icon: "clock.arrow.circlepath", text: "Backup automat istoric")
            }
            .padding(16)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Sign in with Apple
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                authManager.handleSignInResult(result)
            }
            .signInWithAppleButtonStyle(.white)
            .frame(height: 50)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            // Skip
            Button(action: { dismiss() }) {
                Text("Continua fara cont")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Theme.textMuted)
            }
            .padding(.top, 4)
        }
    }
    
    // MARK: - Profile View
    private var profileView: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(Theme.primary.opacity(0.15))
                    .frame(width: 80, height: 80)
                Text(authManager.profileImageInitials)
                    .font(.system(size: 28, weight: .black))
                    .foregroundColor(Theme.primary)
            }
            .padding(.top, 20)
            
            Text(authManager.userName)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Theme.textPrimary)
            
            if !authManager.userEmail.isEmpty {
                Text(authManager.userEmail)
                    .font(.system(size: 13))
                    .foregroundColor(Theme.textSecondary)
            }
            
            // Account info
            VStack(spacing: 12) {
                accountRow(icon: "checkmark.circle.fill", title: "Cont activ", subtitle: "Sincronizare iCloud activata", color: Theme.gaugeGreen)
                accountRow(icon: "iphone.and.arrow.forward", title: "Dispozitive", subtitle: "Sincronizat pe toate dispozitivele", color: Theme.primary)
                accountRow(icon: "clock.fill", title: "Membru din", subtitle: dateFormatter.string(from: Date()), color: Theme.gaugeYellow)
            }
            .padding(14)
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            
            // Sign out
            Button(action: { authManager.signOut() }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.right.circle")
                    Text("Deconecteaza-te")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.gaugeRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Theme.gaugeRed.opacity(0.1))
                .cornerRadius(12)
            }
            .padding(.top, 8)
        }
    }
    
    private func benefitRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Theme.primary)
                .frame(width: 24)
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Theme.textPrimary)
        }
    }
    
    private func accountRow(icon: String, title: String, subtitle: String, color: Color) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
                .frame(width: 28, height: 28)
                .background(color.opacity(0.15))
                .cornerRadius(7)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Theme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 10))
                    .foregroundColor(Theme.textMuted)
            }
            Spacer()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }
}
