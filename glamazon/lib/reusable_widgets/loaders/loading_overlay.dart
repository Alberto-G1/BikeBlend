import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.sienna,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message!,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import '../../utils/colors.dart';

// class LoadingOverlay extends StatelessWidget {
//   final bool isLoading;
//   final Widget child;
//   final String? message;

//   const LoadingOverlay({
//     Key? key,
//     required this.isLoading,
//     required this.child,
//     this.message,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         child,
//         if (isLoading)
//           Container(
//             color: Colors.black54,
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(AppColors.sienna),
//                   ),
//                   if (message != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 16.0),
//                       child: Text(
//                         message!,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.0,
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
