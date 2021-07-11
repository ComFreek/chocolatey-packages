Foxit PDF Reader: The Best PDF Reader. With Foxit PDF Reader you can read and annotate PDF documents and fill out PDF forms.

**All open Foxit PDF Reader, Windows Explorer and browser instances must be closed during installation, update and uninstallation.**
Otherwise, you might encounter error dialogs during the process asking you to close all instances.
Windows Explorer must be closed due to Foxit PDF Reader's shell plugins, browser instances shall be closed proactively due to PDFs displayed inline.

### Install arguments

- **Language**: Pass one of the [supported ISO 639-1 two-letter codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), e.g. `/LANG=en` or `/LANG=es` or `/LANG=de`.
- **Tasks, Components**: configure desktop icons, file association, browser plugins, ConnectedPDF among others.<br>
    Foxit PDF Reader uses Inno Setup, from [whose relevant flags](http://jrsoftware.org/ishelp/index.php?topic=setupcmdline) the relevant subset for Foxit PDF Reader in "tasks" and "components" section is [listed here](https://gist.github.com/anonymous/6ab0d828cc626834e2048d9cf4ed30e1).

    For example, you would like no desktop icon, no default file association, no browser plugin and no ConnectedPDF, then run this command:

    ```
    choco install foxitreader --ia '/MERGETASKS="!desktopicon,!setdefaultreader,!displayinbrowser" /COMPONENTS="*pdfviewer,*ffse,*installprint,*ffaddin,*ffspellcheck,!connectedpdf"'
    ```
    Note that contrary to `/MERGETASKS`, you have to specify in `/COMPONENTS` also those components which you would like to retain. You can get those from the link above of Foxit PDF Reader-specific tasks and components. An asterisk (*) prefix results in all sub-components automatically being included as well, cf. Inno Setup's documentation linked above.

