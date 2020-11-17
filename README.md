# Playground: AppKit StatusBarItem integration in Catalyst app

Tested on Catalina and Big Sur (11.0.1)

![Demo](https://github.com/vox-humana/AppKitCatalystPlayground/raw/main/demo.gif)

## Next possible steps
- Hide newly created UIWindow somehow before showing it at the right spot
- Save and restore state (lilke `value` from SwiftUI form) or just keep whole NSWindow hiding it via `orderOut` method (see GIF)
- Make NSWindow detection hack more reliable (maybe move new NSWindow detection on AppKit side)
- Pass AppStore review 😅

## Usefull links
- https://www.highcaffeinecontent.com/blog/20190607-Beyond-the-Checkbox-with-Catalyst-and-AppKit
- https://www.kairadiagne.com/2019/11/19/adding-support-for-multiple-windows.html
- https://stackoverflow.com/questions/58882047/open-a-new-window-in-mac-catalyst
- https://stackoverflow.com/questions/57123554/mac-catalyst-minimum-window-size-for-mac-catalyst-app
- https://www.craft.do/maccatalyst-guide/b/E0ADDD39-AE32-4040-B0AC-08E9BCAC6812/Windows,_Tabs
- https://github.com/lukakerr/NSWindowStyles
