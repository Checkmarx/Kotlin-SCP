M6: Insecure Authorization
==========================

It is important to distinguish between authentication and authorization: the
former is the act of identifying an individual whilst the later is the act of
checking that the identified individual has the necessary permissions to perform
the act. To exploit Insecure Authorization, usually adversaries first login to
the application as a legitimate user and then they typically force-browse to a
vulnerable endpoint.

Because authentication precedes authorization, if an application fails to
identify an individual before making an API request, then it automatically
suffers from Insecure Authorization.

Usually Insecure Authorization is greatly associated with IDOR - Insecure Direct
Object Reference but it is also found on hidden endpoints that developers assume
will be accessed only by someone with the right role. If the mobile app sends
the user role or permissions to the backend as part of the request, it is likely
vulnerable to Insecure Authorization.

The movie below demonstrates how Insecure Authorization can be exploited on our
Kotlin goat.

@todo include exploitation movie

In order to fix the Insecure Authorization, the backend should perform role and
permissions validation of the authenticated individual using only information
contained in the backend.

