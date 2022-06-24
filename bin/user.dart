
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:supabase/supabase.dart';
import 'dart:convert';

class Users {
  final client = SupabaseClient('https://wqrjqixoihriivkstbyw.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndxcmpxaXhvaWhyaWl2a3N0Ynl3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTU3OTI0OTIsImV4cCI6MTk3MTM2ODQ5Mn0.FYyQysDQeN6KFjF2FZRwSO3K6A0XUD1ENnWK0XV7tBc');

  Handler get handler {
    final router = Router(
      notFoundHandler: (Request request) => 
        Response.notFound(
          'We dont have an API for this request'
        )
    );

    /// Create new user
    router.post('/users/create', (Request request) async {
    final payload = jsonDecode(await request.readAsString());

    // If the payload is passed properly
    if(payload.containsKey('name') && payload.containsKey('age')) {

    // Create operation
    final res = await client
      .from('users')
      .insert([
        {'name': payload['name'], 'age': payload['age']}
      ]).execute();

      // If Create operation fails
      if(res.error!=null) {
        return Response.notFound(
          jsonEncode(
            {'success':false, 'data': res.error!.message,}
          ),
          headers: {'Content-type':'application/json'}
        );
      }

      // Return the newly added data
      return Response.ok(
        jsonEncode({
          'success':true,
          'data':res.data
        }),
        headers: {'Content-type':'application/json'},
      );
    }

    // If data sent as payload is not as per the rules
    return Response.notFound(
      jsonEncode(
        {'success':false, 'data':'Invalid data sent to API',}
        ),
      headers: {'Content-type':'application/json'}
    );

 });

    /// Read all users
  router.get('/users', (Request request) async {
    final res = await client
      .from('users')
      .select()
      .execute();

    // If the select operation fails
    if(res.error!=null) {
      return Response.notFound(
        jsonEncode({
          'success':false,
          'data':res.error!.message
        }),
        headers: {'Content-type':'application/json'}
      );
    }

    final result = {
      'success':true,
      'data': res.data,
    };

    return Response.ok(
      jsonEncode(result),
      headers: {'Content-type':'application/json'}
    );
  });

  // frontent website


    /// Read user data with id

    /// Update user using Id

    /// Delete a user using ID



    return router;
  }
}