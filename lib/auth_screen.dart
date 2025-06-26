import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isLogin = true;

  Widget _inputField(
    String label,
    IconData icon,
    TextEditingController ctrl, {
    bool obscure = false,
  }) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red),
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter $label';
        if (label == 'Email' && !value.contains('@'))
          return 'Enter valid email';
        if (label == 'Password' && value.length < 6)
          return 'Password must be 6+ characters';
        if (label == 'Confirm Password' && value != _pass.text)
          return 'Passwords do not match';
        return null;
      },
    );
  }

  Future<void> _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // Sign in
        await _signInUser();
      } else {
        // Register
        await _registerUser();
      }
    } catch (error) {
      _handleAuthError(error);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInUser() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      if (credential.user != null && mounted) {
        // Navigate to dashboard
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      // Handle the type casting error specifically
      print('Unexpected error during sign in: $e');

      // Try to check if user is actually signed in despite the error
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null && mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
        return;
      }

      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'An unexpected error occurred. Please try again.',
      );
    }
  }

  Future<void> _registerUser() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _pass.text.trim(),
      );

      if (mounted) {
        setState(() => _isLogin = true);
        _pass.clear();
        _confirm.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created! Please login'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      print('Unexpected error during registration: $e');
      throw FirebaseAuthException(
        code: 'unknown-error',
        message: 'Failed to create account. Please try again.',
      );
    }
  }

  void _handleAuthError(dynamic error) {
    String message = 'An error occurred';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'email-already-in-use':
          message = 'Email is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email format';
          break;
        case 'network-request-failed':
          message = 'Network error. Check your connection';
          break;
        default:
          message = error.message ?? 'Authentication failed';
      }
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/erickfy.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
              BlendMode.darken,
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Card(
                color: Colors.grey[850],
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Erickfy',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          _isLogin
                              ? 'Login to continue'
                              : 'Create your account',
                          style: TextStyle(color: Colors.white60),
                        ),
                        SizedBox(height: 20),
                        _inputField('Email', Icons.email, _email),
                        SizedBox(height: 16),
                        _inputField(
                          'Password',
                          Icons.lock,
                          _pass,
                          obscure: true,
                        ),
                        if (!_isLogin) ...[
                          SizedBox(height: 16),
                          _inputField(
                            'Confirm Password',
                            Icons.lock_outline,
                            _confirm,
                            obscure: true,
                          ),
                        ],
                        SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          onPressed: _isLoading ? null : _submitAuthForm,
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin
                                ? 'New to Erickfy? Sign up'
                                : 'Already have an account? Login',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _confirm.dispose();
    super.dispose();
  }
}
