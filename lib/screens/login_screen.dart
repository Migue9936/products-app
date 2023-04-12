import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
import 'package:products_app/providers/providers.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children:  [
              const SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text('Login',style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 30),

                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _LoginForm(),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
                style:  ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder()),
                  ),
                child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                child: Text('Create a new account',style: TextStyle(fontSize: 18,color: Colors.black87))),
                ),
              const SizedBox(height: 280),


            ],
          ),
        )
      )
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
  
  final loginForm = Provider.of<LoginFormProvider>(context);
  
    return Form(
      key:loginForm.formKey ,
      child: Column(
        children: [
          //Email text
          TextFormField(
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => loginForm.email = value,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(hintText: 'sisas@gmail.com',labelText:'Email',prefixIcon: Icons.alternate_email),
            validator: (value) {
              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ??'') ? null : 'Invalid email format'; 
            },
          ),
          const SizedBox(height: 20),
          //Email text
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) => loginForm.password = value,
            obscureText: true,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(hintText: '******',labelText:'Password',prefixIcon: Icons.lock_clock_outlined),
            validator: (value) {
              return value != null && value.length >=6 ? null : 'Min characteres 6'; 
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            padding: const EdgeInsets.symmetric(horizontal: 80,vertical: 20),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurple,
            disabledColor: Colors.grey,
            onPressed: loginForm.isLoading ? null : () async{
              
               FocusScope.of(context).unfocus();
              final authProvider = Provider.of<AuthProvider>(context,listen: false);
              
              if(!loginForm.isValidForm())  return; 
              
              loginForm.isLoading = true;
              
              final String? errorMessage = await authProvider.login(loginForm.email, loginForm.password);

              if (errorMessage == null) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, 'home');
              }else{
                  showError(errorMessage); 
                  loginForm.isLoading = false;
              }

            },
            child: loginForm.isLoading ? const SizedBox(width: 38,height: 17, child: CircularProgressIndicator(color: Colors.deepPurple,)) : 
            const Text(
              'Login',
              
              style: TextStyle(color: Colors.white)
              ),
            )
          
        ],
      ),
    );
  }

  void showError(String errorMessage) {
    print(errorMessage);
    if (errorMessage.contains("EMAIL_NOT_FOUND")) {
      // Mostrar mensaje de correo electrónico incorrecto
      NotificationsProvider.showSnackbar("The e-mail address is not registered.");
    } else if (errorMessage.contains("INVALID_PASSWORD")) {
      // Mostrar mensaje de contraseña incorrecta
      NotificationsProvider.showSnackbar("Password Incorrect");
      // Mostrar mensaje de contraseña erronea es insertada varas veces
    } else if (errorMessage.contains("TOO_MANY_ATTEMPTS_TRY_LATER")){
      NotificationsProvider.showSnackbar('Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later');
    }
  }
}