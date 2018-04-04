Foxit Reader: The Best PDF Reader. With Foxit Reader you can read and annotate PDF documents and fill out PDF forms.
### Important Notes
1. **All open FoxitReader, Windows Explorer and browser instances** must be closed during installation, update and uninstallation.<br>
   Otherwise, you might encounter error dialogs during the process asking you to close all instances.<br>
   Windows Explorer must be closed due to Foxit Reader's shell plugins, browser instances shall be closed proactively due to PDFs displayed inline.
2. Only the English version is provided because it is bundled with the highest version of Foxit Reader among all languages.

### Install arguments
FoxitReader uses Inno Setup, the available flags can be seen at http://jrsoftware.org/ishelp/index.php?topic=setupcmdline.
You might be especially interested in the "tasks" and "components" sections.
The FoxitReader-specific tasks and components from which you can choose from are: https://gist.github.com/anonymous/6ab0d828cc626834e2048d9cf4ed30e1.

For example, you would like no desktop icon, no default file association, no browser plugin and no ConnectedPDF, then run this command:

```
choco install foxitreader --ia '/MERGETASKS="!desktopicon,!setdefaultreader,!displayinbrowser /COMPONENTS=*pdfviewer,*ffse,*installprint,*ffaddin,*ffspellcheck,!connectedpdf"'
```
Note that contrary to `/MERGETASKS`, you have to specify in `/COMPONENTS` also those components which you would like to retain. You can get those from the link above of Foxit Reader-specific tasks and components. An asterisk (*) prefix results in all sub-components automatically being included as well, cf. Inno Setup's documentation linked above.
