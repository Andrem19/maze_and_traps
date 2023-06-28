build:
	flutter build apk --build-name=1.0 --build-number=1
buildbundle:
	flutter build appbundle
ksignrelese:
	(C:\Program Files\Java\jdk-18.0.2.1\bin).\keytool -genkey -v -keystore D:\CODE\GAMES\mazeandtraps\android\app\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload

.PHONY: build buildbundle