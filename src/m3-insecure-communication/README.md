M3: Insecure Communication
==========================

Currently, most mobile applications exchange data in a client-server fashion at
some point. When these communications happen, data traverses either the mobile
carrier's network or between some Wi-Fi network and the internet.

Although exploiting the mobile carrier's network is not an impossible task,
exploiting a Wi-Fi network is usually much easier. If communications lack
SSL/TLS, then an adversary will be able to not only steal the data, but also to
execute Man-in-the-Middle (MitM) attacks.

The following video demonstrates Insecure Communications exploitation on [Kotlin
Goat][0] mobile application. The movie shows network monitoring, what gives an
adversary access to exchanged data nevertheless, due to insecure communication,
Man-in-the-Middle (MitM) would also be possible.

{% youtube %}
https://www.youtube.com/watch?v=0onwBnAvWI4
{% endyoutube %}

Now that we have seen the exploitation taking place, it's time to go back to the
application source code and fix this issue. We will add SSL/TLS to all
client-server communications and also implement [Certificate Pinning][3] to
remove the "conference of trust" to no longer depend on Certificate Authorities
or third-party agents regarding decisions on a server's identity.

To enable SSL/TLS, we will need certificates to be available in the server.
Nowadays you can get free certificates with [Let's Encrypt][4] - a free,
automated and open Certificate Authority. You'll [get the certificates deployed
easily by following the documentation][5].

On [Goatlin][0], we'll go with a self-signed certificate. While this is a common
practice during the development stage, it is not recommended for production
systems. How to generate the certificate is out of scope for this guide.

With the certificate in hand, we should make a few changes on our back-end API
to make it use HTTPS instead of HTTP:

* Put `server.key` and `server.crt` under the `ssl` directory
* Replace `http` package with `https` one
* Load `server.key` and `server.crt`

```javascript
const https = require('https');
const fs = require('fs');
const path = require('path');

// ...

/**
 * Create HTTP server.
 */
const sslDirectory = path.join(__dirname,'..','ssl');
const privateKey = fs.readFileSync(path.join(sslDirectory, 'server.key'), 'utf8');
const certficate = fs.readFileSync(path.join(sslDirectory, 'server.crt'), 'utf8');
const credentials = {key: privateKey, cert: certficate};

var server = https.createServer(credentials, app);

// ...
```

The following command line outputs our certificate fingerprint so that we can
pin it on [Goatlin][0]:

```
openssl x509 -in server.crt -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

Now we have to modify the `create` method of our API service `Client` interface
as shown below:

```kotlin
interface Client {
    @POST("accounts")
    fun signup (@Body data: Account): Call<Void>

    companion object {
        fun create(): Client {
            val certificatePinner = CertificatePinner.Builder()
                    .add("192.169.1.87:8080", "sha256/5Kl14sIBRoArZ8ujwNLWoLOI1QmsvE58nmXTO/9GSJw=")
                    .build()

            val client: OkHttpClient = OkHttpClient.Builder()
                    .certificatePinner(certificatePinner)
                    .build()

            val retrofit = Retrofit.Builder()
                    .addCallAdapterFactory(RxJava2CallAdapterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
                    .baseUrl("https://192.168.1.87:8080")
                    .client(client)
                    .build()

            return retrofit.create(Client::class.java)
        }
    }
}
```

You can test Certificate Pinning by switching to
[feature/m3-insecure-communication branch][8]. Replacing the back-end API
certificates or the fingerprint on [Goatlin][0] source code will break the
signup feature.

## Resources

### Tools

* [Wireshark][1]
* [Burp Suite][2]
* [Let's Encrypt][4]
* [OkHttp][7]

### Readings

* [Certificate Pinning][3]
* [OkHttp Certificate Pinning][6]
* [OWASP Mobile Top 10 2016: M3 - Insecure Communication][9]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://www.wireshark.org/
[2]: https://portswigger.net/
[3]: https://www.owasp.org/index.php/Certificate_and_Public_Key_Pinning
[4]: https://letsencrypt.org/
[5]: https://letsencrypt.org/docs/
[6]: https://github.com/square/okhttp/wiki/HTTPS#certificate-pinning
[7]: https://github.com/square/okhttp
[8]: https://github.com/Checkmarx/Goatlin/tree/feature/m3-insecure-communication
[9]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M3-Insecure_Communication
