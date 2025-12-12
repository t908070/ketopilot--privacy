import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FirebaseService {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;
  
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;

  static FirebaseAuth get auth {
    if (!_isInitialized) {
      throw Exception('Firebase is not initialized. Please configure Firebase first.');
    }
    return _auth ?? FirebaseAuth.instance;
  }

  static FirebaseFirestore get firestore {
    if (!_isInitialized) {
      throw Exception('Firebase is not initialized. Please configure Firebase first.');
    }
    return _firestore ?? FirebaseFirestore.instance;
  }

  static FirebaseStorage get storage {
    if (!_isInitialized) {
      throw Exception('Firebase is not initialized. Please configure Firebase first.');
    }
    return _storage ?? FirebaseStorage.instance;
  }

  static Future<void> initialize({FirebaseOptions? webOptions}) async {
    try {
      // Check if Firebase is already initialized
      if (Firebase.apps.isEmpty) {
        // For web platform, FirebaseOptions are required
        if (kIsWeb) {
          if (webOptions == null) {
            print('⚠️ Firebase is not configured for web platform.');
            print('⚠️ App will run in demo mode without Firebase features.');
            print('⚠️ To enable Firebase, please provide FirebaseOptions.');
            return;
          }
          await Firebase.initializeApp(options: webOptions);
        } else {
          // For mobile platforms (Android/iOS), use default initialization
          // This will use google-services.json (Android) or GoogleService-Info.plist (iOS)
          await Firebase.initializeApp();
        }
      }
      _isInitialized = true;
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = FirebaseStorage.instance;
      print('✅ Firebase initialized successfully');
    } catch (e) {
      // If Firebase is not configured, log the error but don't crash the app
      print('⚠️ Firebase initialization failed: $e');
      print('⚠️ App will continue without Firebase features.');
      print('⚠️ Please check your Firebase configuration files:');
      print('   - Android: android/app/google-services.json');
      print('   - iOS: ios/Runner/GoogleService-Info.plist');
      print('   - Web: Provide FirebaseOptions in initialize()');
      _isInitialized = false;
    }
  }

  static User? get currentUser {
    if (!_isInitialized) return null;
    try {
      return _auth?.currentUser;
    } catch (e) {
      return null;
    }
  }
  
  static String? get currentUserId {
    if (!_isInitialized) return null;
    try {
      return _auth?.currentUser?.uid;
    } catch (e) {
      return null;
    }
  }

  static Future<UserCredential?> signInAnonymously() async {
    if (!_isInitialized || _auth == null) {
      print('Firebase is not initialized. Cannot sign in.');
      return null;
    }
    try {
      return await _auth!.signInAnonymously();
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    if (!_isInitialized || _auth == null) return;
    try {
      await _auth!.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  static Stream<User?> get authStateChanges {
    if (!_isInitialized || _auth == null) {
      return Stream.value(null);
    }
    try {
      return _auth!.authStateChanges();
    } catch (e) {
      return Stream.value(null);
    }
  }
}

