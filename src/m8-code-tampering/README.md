M8: Code Tampering
==================

Once a mobile application is delivered and installed on a device both the code
and data will be available there. This gives the adversary the chance to
directly modify the code, manipulate memory content, change or replace system
APIs or simply modify application's data and resources.

Rogue mobile applications play an important place on fraud attacks becoming even
more prevalent than malware. Typically attackers exploit code modification via
malicious forms of an application tricking users to install the app via phishing
attacks.

Notice that Kotlin has no advantage over plain Java when it comes to avoiding
reverse engineering.

@todo movie

Technically, all mobile applications are vulnerable to code tampering but some
are historically more targeted (e.g. mobile games) than others. Deciding whether
or not to address this risk is a matter of business impact that can range from
revenue loss to reputational damage.

[OWASP Reverse Engineering and Code Modification Prevention Project][1] is a
great reference on how to detect and prevent Reverse Engineering and Code
Modification. Generally speaking applications should be able to detect at
runtime whether code was added or removed to what they know about their
integrity at compile time.

## References

* [OWASP Reverse Engineering and Code Modification Prevention Project][1]

[1]: https://www.owasp.org/index.php/OWASP_Reverse_Engineering_and_Code_Modification_Prevention_Project

