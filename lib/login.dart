import 'package:flutter/material.dart';

void main() {
  // Inicializa la aplicación con el widget raíz MyApp.
  runApp(const MyApp());
}

// Clase raíz de la aplicación (StatelessWidget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Demo Flutter',
      theme: ThemeData(
        // Tema moderno con un color principal vibrante
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.deepPurple, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, // Fondo del botón
            foregroundColor: Colors.white, // Color del texto
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      // La página principal de la aplicación es el widget de inicio de sesión
      home: const LoginPage(),
    );
  }
}

// Widget principal de la página de Login (StatefulWidget)
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Clave global para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Estado para controlar la visibilidad de la contraseña
  bool _isPasswordVisible = false;

  // Usuario y contraseña de prueba
  final String correctEmail = "test@example.com";
  final String correctPassword = "123456";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función de lógica de inicio de sesión con credenciales
  void _login() {
    if (_formKey.currentState!.validate()) {
      // Si la validación es exitosa, se verifica la credencial
      if (_emailController.text.trim() == correctEmail &&
          _passwordController.text.trim() == correctPassword) {
        // Login correcto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Login exitoso! Bienvenido.', textAlign: TextAlign.center),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
        // Aquí podrías navegar a la siguiente pantalla
      } else {
        // Login incorrecto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Credenciales incorrectas. Intenta con test@example.com / 123456', textAlign: TextAlign.center),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  // Función de lógica de inicio de sesión con Google (simulación)
  void _loginWithGoogle() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Simulación: Iniciando sesión con Google...', textAlign: TextAlign.center),
        backgroundColor: Colors.blue.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
    // En una aplicación real, aquí se llamaría al SDK de Google Sign-In
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text(
          'INICIAR SESIÓN',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icono de la aplicación
              const Icon(
                Icons.lock_open_rounded,
                size: 100,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 40),
              
              // Título descriptivo
              Text(
                'Bienvenido de vuelta!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurple.shade800,
                ),
              ),
              const SizedBox(height: 30),

              // Formulario de Login
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Campo Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'ej. test@example.com',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Campo Contraseña
                    TextFormField(
                      controller: _passwordController,
                      // Controla si se oculta el texto
                      obscureText: !_isPasswordVisible, 
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Mínimo 6 caracteres',
                        prefixIcon: const Icon(Icons.lock),
                        // Botón para mostrar/ocultar la contraseña
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa tu contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Botón de Iniciar Sesión Estándar
              ElevatedButton(
                onPressed: _login,
                child: const Text('INICIAR SESIÓN'),
              ),
              
              const SizedBox(height: 20),
              
              const Text(
                'O',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Botón de Iniciar Sesión con Google (Custom Style)
              ElevatedButton.icon(
                onPressed: _loginWithGoogle,
                // CORRECCIÓN: Se usa un Text estilizado como la 'G' de Google
                icon: const Text(
                  'G',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Usamos el azul de Google
                  ),
                ),
                label: const Text(
                  'Continuar con Google',
                  style: TextStyle(
                    color: Colors.black54, // Color de texto oscuro para Google
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Fondo blanco
                  side: const BorderSide(color: Colors.grey, width: 1.0), // Borde gris
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

