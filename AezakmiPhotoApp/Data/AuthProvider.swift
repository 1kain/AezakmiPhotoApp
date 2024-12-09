//
//  AuthProvider.swift
//  AezakmiPhotoApp
//
//  Created by Тимур Шаов on 06.12.2024.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

@MainActor
class AuthProvider: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmation: String = ""
    
    @Published var showAuth: Bool = false
    @Published var showRegister: Bool = false
    @Published var isButtonActive: Bool = false
    @Published var isResetButtonActive: Bool = false
    
    @Published var user: User?
    @Published var inProgress: Bool = false
    @Published var error: Error?
    @Published var showError: Bool = false
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    init() {
        registerListener()
        setupBindings()
    }
    
    private func setupBindings() {
        $showRegister
            .combineLatest($email, $password, $confirmation)
            .map { showRegister, email, password, confirmation in
                let isMailValid = email.isValidEmail
                let isPasswordValid = password.count >= 6 && !password.containsCyrillic
                return showRegister
                    ? isMailValid && isPasswordValid && password == confirmation
                    : isMailValid && isPasswordValid
            }
            .assign(to: &$isButtonActive)
        
        $email
            .map { $0.isValidEmail }
            .assign(to: &$isResetButtonActive)
        
        $error
            .map { $0 != nil}
            .assign(to: &$showError)
    }
    
    private func registerListener() {
        authListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.user = user
            self.showAuth = (user == nil)
        }
    }
    
    func registerWithEmailAndPassword() async {
        inProgress = true
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            handleError(error)
        }
        inProgress = false
    }
    
    func loginWithEmailAndPassword() async {
        inProgress = true
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            handleError(error)
        }
        inProgress = false
    }
    
    func passwordRecovery() async {
        inProgress = true
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            handleError(error)
        }
        inProgress = false
    }
    
    func sendEmailVerification() async -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        do {
            try await user.sendEmailVerification()
            return true
        } catch {
            handleError(error)
        }
        return false
    }
    
    func checkUserEmailVerified() -> Bool {
        guard let user = Auth.auth().currentUser else { return false }
        user.reload { error in
            if let error = error {
                self.handleError(error)
                return
            }
        }
        return user.isEmailVerified
    }
    
    func signInWithGoogle() async {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .windows.first?.rootViewController else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
            guard let idToken = userAuthentication.user.idToken?.tokenString else {
                throw NSError(domain: "Missing tokens", code: 1, userInfo: nil)
            }
            let accessToken = userAuthentication.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            inProgress = true
            try await Auth.auth().signIn(with: credential)
            inProgress = false
        } catch {
            handleError(error)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        print("Auth Error: \(error.localizedDescription)")
        inProgress = false
        self.error = error
    }
}
