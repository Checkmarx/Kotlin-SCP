M5: Insufficient Cryptography
=============================

Let's assume that an application collects some Personal Identifiable Information
(PII) which should be stored locally. Due to data relevance, it is encrypted.
Now let's think about an adversary "physically attaining" the mobile device
where such data is stored. The adversary will have access to all third-party
application directories; therefore, they'll also have access to the stored data.
In this scenario, whenever the adversary is able to return the encrypted data to
its original unencrypted form, your cryptography was insufficient.

There are two fundamental mistakes in the development process leading to
Insufficient Cryptography: either the encryption/decryption process relies on a
flawless underlying process/library or the application may implement or leverage
a weak encryption algorithm.

Keep in mind that encryption depends on secrets (keys) and even the best
encryption algorithm will be useless if your application fails to keep its
secrets by making the keys available to the attacker.

In the movie below you'll see how [Goatlin][0] cryptography fails by enabling
the adversary to get the unencrypted version of stored data.

{% youtube src="https://www.youtube.com/watch?v=FbIj2hBMeaE" %}{% endyoutube %}

To address Insufficient Cryptography, we will replace the encryption algorithm
by the [AES - Advanced Encrypt Standard (Rijndael)][1]. As many other symmetric
ciphers, AES can be implemented in different modes. In this case, we will use
the GCM (Galoi Counter Mode).
GCM is preferable to most popular CBC/ECB modes because the former is an
authenticated cipher mode; meaning that after the encryption stage, an
authentication tag is added to the ciphertext, which will then be validated
prior to message decryption and ensuring the message has not been tampered with.

All major changes were done in the [CryptoHelper class][5] which was given two
new methods: `createUserKey()` and `getUserKey()`. `encrypt()` and `decrypt()`
methods were also changed to receive a `usernane` argument:

```kotlin
package com.cx.goatlin.helpers
// ...
class CryptoHelper {
    companion object {
        fun createUserKey(username: String) { /* ... */ }
        private fun getUserKey(username: String): SecretKey? { /* ... */ }
        fun encrypt(original: String, username: String): String { /* ... */ }
        fun decrypt(message: String, username: String): String { /* ... */ }
    }
}
```

As previously stated, encryption depends on secrets (keys), which should be
handled carefully. In this case, on successful signup, a random key is created
and persisted in [Android Keystore][2]. This key is user specific (see
[SignupActivity][6]) and it is used to encrypt/decrypt a user's notes only.

Every time encryption/decryption is required, the `username` should be provided
to the appropriate `CryptoHelper` method, since it is used as an alias to
locate the user's key in Android Keystore (see [CryptoHelper.getUserKey()][7]):

```kotlin
package com.cx.goatlin.helpers
// ...
class CryptoHelper {
    companion object {
        private fun getUserKey(username: String): SecretKey? {
            val ks: KeyStore = KeyStore.getInstance("AndroidKeyStore").apply {
                load(null)
            }
            val entry = ks.getEntry(username, null) as? KeyStore.SecretKeyEntry
            // @todo handle null entry
            return entry?.secretKey
        }
    }
}
```

There is another implementation detail worth mentioning, since it may prove
challenging. AES GCM encryption requires an [Initialization Vector][8] (IV). By
default this is a random value. The value used during encryption should then be
used on the corresponding decryption operation. Although randomness can be
disabled (see [`setRandomizedEncryptionRequired()`][9]), replacing random IV by
a constant value will reduce encryption security.

In our implementation we kept IV random, prepending it to the encrypted message.
Then, while decrypting, the first 12 bytes correspond to the IV and the rest
corresponds to the message. Note that IV is not secret.

## Resources

### Readings

* [Android Keystore System][2]
* [Using the Android Keystore system to store and retrieve sensitive information][3]
* [Securely Storing Secrets in an Android Application][4]
* [OWASP Mobile Top 10 2016: M5 - Insufficient Cryptography][10]

[0]: https://github.com/Checkmarx/Goatlin
[1]: https://en.wikipedia.org/wiki/Advanced_Encryption_Standard
[2]: https://developer.android.com/training/articles/keystore
[3]: https://medium.com/@josiassena/using-the-android-keystore-system-to-store-sensitive-information-3a56175a454b
[4]: https://medium.com/@ericfu/securely-storing-secrets-in-an-android-application-501f030ae5a3
[5]: https://github.com/Checkmarx/Goatlin/blob/feature/m5-insufficient-cryptography/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/CryptoHelper.kt
[6]: https://github.com/Checkmarx/Goatlin/blob/feature/m5-insufficient-cryptography/packages/clients/android/app/src/main/java/com/cx/goatlin/SignupActivity.kt#L63
[7]: https://github.com/Checkmarx/Goatlin/blob/feature/m5-insufficient-cryptography/packages/clients/android/app/src/main/java/com/cx/goatlin/helpers/CryptoHelper.kt#L35
[8]: https://en.wikipedia.org/wiki/Initialization_vector
[9]: https://developer.android.com/reference/android/security/keystore/KeyGenParameterSpec.Builder.html#setRandomizedEncryptionRequired(boolean)
[10]: https://www.owasp.org/index.php/Mobile_Top_10_2016-M5-Insufficient_Cryptography
