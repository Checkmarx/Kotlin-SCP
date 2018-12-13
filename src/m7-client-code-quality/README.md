M7: Client Code Quality
=======================

In this category fit code-level issues like a buffer overflow in C or a
DOM-based XSS in a Webview mobile app. Usually something that requires code
changes to be fixed as it is caused by an improper API or language constructs
usage.

Although Client Code Quality issues are prevalent the exploitation requires
low-level knowledge. The typical primary goal is to execute foreign code within
the mobile code's address space.

* @todo movie

Consistent coding patterns and coding style guidelines broadly accepted in the
organization will help to improve code quality. As these issues are not easily
detected on code review, using a static analysis tool usually results well.
Buffer overflows and memory leaks should be top priorities over other code
quality issues to be solved.

