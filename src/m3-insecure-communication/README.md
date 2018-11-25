M3: Insecure Communication
==========================

Nowadays most mobile applications at some point, exchange data on a
client-server fashion. When those communications happen, data traverses either
the mobile carrier's network or some Wi-Fi network and the internet.

Although exploiting the mobile carrier's network is not an impossible task,
exploiting a Wi-Fi network is certainly easier. If communications lack SSL/TLS,
then an adversary will be able not only to steal the data but also to play
Man-in-the-Middle (MitM) attacks.

The following video demonstrates Insecure Communications exploitation on our
Kotlin mobile application. The movie starts with network monitoring, what gives
adversary access to exchanged data and then, in the second part, application's
network traffic will be actually modified.


@todo implement some client-server communication on our kotlin goat
@todo add video from vimeo or youtube: 1) network monitorin 2) mitm

Now that we have seen the exploitation taking place, it's time to go back to
application source code and fix this issue. We will add SSL/TLS to all
client-server communications and also implement [Certificate Pinning][3] to
remove the "conference of trust" and no longer depend on Certificate Authorities
or third-party agents regarding decisions on server's identity.

To add SSL/TLS to the application we will need certificates to be available in
the server. You can get certificates with [Let's Encrypt - a free, automated and
open Certificate Authority][4]. Following the [documentation you'll get them
deployed easily][5].

@todo add SSL/TLS to all application communications
@todo implement Certificate Pinning

## Resources

### Tools

* [Wireshark][1]
* [Burp Suite][2]
* [Let's Encrypt][4]

### Readings

* [Certificate Pinning][3]

[1]: https://www.wireshark.org/
[2]: https://portswigger.net/
[3]: https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning
[4]: https://letsencrypt.org/
[5]: https://letsencrypt.org/docs/

