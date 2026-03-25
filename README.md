\# mTORQUE Flutter



Flutter migration of the existing mTORQUE Android app.



\## Project goal



1:1 functional migration of the current Android app to Flutter.



\### Requirements



\- No functional regressions

\- No UI simplification

\- No performance regression

\- iOS support must be considered from the beginning

\- Later release with the same app ID as the existing app



\## Current technical setup



\- Flutter: 3.41.5

\- Gradle: 8.13

\- Android SDK: `C:\\Android\\Sdk`

\- `GRADLE\_USER\_HOME` configured

\- Dev package: `app.mtorque.flutter`

\- Future release package: `app.mtorque`



\## Architecture principles



\- Clean separation: UI / State / Domain / Data

\- No monolithic `main.dart`

\- Feature-based structure

\- Performance-critical functionality may stay in native plugins

\- Modern Flutter best practices only

\- No unnecessary redesign of working Kotlin app behavior



\## Naming conventions



Main sections:



\- Dashboard

\- Strength

\- Endurance

\- Stats

\- Settings



Within Endurance:



\- Indoor

\- Outdoor



\## Localization



Localization is required from the beginning.



\- Default language: English

\- Additional language: German

\- No hardcoded UI strings



\## Migration rule



Do not guess existing app behavior.



If Flutter decisions depend on the current Android/Kotlin implementation, the relevant source files must be reviewed first.



\## Windows / Gradle note



On Windows 11 + Sophos, Gradle transform caching can cause errors such as:



`Could not move temporary workspace to immutable location`



Preferred mitigations:



\- Android SDK path without spaces

\- `GRADLE\_USER\_HOME` set

\- Gradle 8.13

\- Whitelist Java / Gradle in Sophos if needed



\## Status



Current state:



\- Flutter project created

\- Initial app shell created

\- Bottom navigation scaffold in place

\- GitHub repository connected



\## Workflow



\- Prefer complete files or CTRL+F-safe patches

\- Keep migration close to the existing Android app

\- Optimize only where useful for maintainability, structure, and redundancy reduction

