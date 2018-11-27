M5: Insufficient Cryptography
=============================

Let's assume that an application collects some Personal Identifiable Information
(PII) which should be stored locally. Due to data relevance, it is encrypted.
Now let's think about an adversary physically attaining the mobile device where
such data is stored. The adversary will have access to all third-party
application directories and therefore to the stored data. In this scenario,
whenever the adversary is able to return the encrypted data to its original
unencrypted form, cryptography was insufficient.

There are two fundamental mistakes in the development process leading to
Insufficient Cryptography: either the encryption/decryption process relies on a
flawless underlying process/library or the application may implement or leverage
a weak encryption algorithm.

Keep in mind that encryption depends on secrets (keys) and even the best
encryption algorithm will be worthless if your application fails to keep its
secrets, making the keys available to the attacker.

In the movie below you'll see how our Kotlin application cryptography fails
allowing access to the unencrypted version of stored data.

@todo movie

To address Insecure Cryptography we will replace the encryption algorithm by the
[AES - Advanced Encrypt Standard (Rijndael)][1]. As many other symmetric
ciphers, AES can be implemented in different modes: we will use the GCM (Galoi
Counter Mode). GCM is preferable to most popular CBC/ECB modes because the
former is an authenticated cipher mode, meaning that after the encryption stage,
an authentication tag is added to the ciphertext, which will then be validated
prior to message decryption, ensuring the message has not been tampered with.

@todo how to manage encryption key

@todo fix


[1]: https://en.wikipedia.org/wiki/Advanced_Encryption_Standard

