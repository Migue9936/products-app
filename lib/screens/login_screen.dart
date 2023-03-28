import 'package:flutter/material.dart';
import 'package:products_app/providers/login_form_provider.dart';
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
              const Text('Create a new account',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
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
  
    return Container(
      child: Form(
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
                
                if(!loginForm.isValidForm())  return; 
                
                loginForm.isLoading = true;
                
                await Future.delayed(const Duration(seconds: 2));


                // ignore: use_build_context_synchronously
                 Navigator.pushReplacementNamed(context, 'home');
              },
              child: loginForm.isLoading ? const SizedBox(width: 38,height: 17, child: CircularProgressIndicator(color: Colors.deepPurple,)) : 
              const Text(
                'Login',
                
                style: TextStyle(color: Colors.white)
                ),
              )
            
          ],
        ),
      ),
    );
  }
}