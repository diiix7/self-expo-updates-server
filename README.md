# Self expo updates server with an app client example

## NB: Arborescence
custom-expo-updates-server — expo-updates-server
                           - app
                           - README.md


## Application:
1. expo build:configure
2. expo update configure
3. Éditer le fichier app.json:
	"runtimeVersion": "1.0.0",
    "updates": {
        "url": "http://192.168.86.118:3000/api/manifest",
        "enabled": true,
        "fallbackToCacheTimeout": 30000,
        "codeSigningCertificate": "./code-signing/certificate.pem",
        "codeSigningMetadata": {
            "keyid": "main",
            "alg": "rsa-v1_5-sha256"
        }
    },
    "plugins": [
        [
            "expo-build-properties",
            {
                "android": {
                    "usesCleartextTraffic": true
                },
                "ios": {}
            }
        ]
    ]

4. Remplacer « 192.168.86.118:3000 » par le bon url

5. Ajouter le nom du package a android dans app.json: "package": "com.—.— »

6. Choisir le bon runtimeVersion, c’est l’identité de l’applications dans le serveur (il est unique et ne changea pas et ne dois pas être dupliqué)

7. Ne pas commettre le fichier ./code-signing/certificate.pem (le certificat se trouve dans le manifest après avoir exécuté npx expo prebuild (plus tard)) 

8. Installer les packages expo-build-properties et exécuter yarn android --variant release pour la version release de l’application, ou utiliser eas build pour construire l’apk (en spécifiant les environnements, le buildType et le gradleCommand dans eas.json



## Serveur:

1. Modifier la variable d’environnement HOSTNAME dans le fichier .env.local

2. Dans le fichier scripts/exportClientExpoConfig.js, modifier projectDir en renommant le dossier (dernier element) pas le nom du dossier le l’application (en spécifiant le chemin correct si le serveur n’est pas déployé)

3. Dans le meme dossier que exportClientExpoConfig.js., rééditer le script publish.sh en modifiant le nom du dossier le l’application (en spécifiant le chemin correct si le serveur n’est pas déployé)
	…	
	cd ../applications/app
	npx expo export
	cd ../expo-updates-server
	rm -rf updates/$directory/
	cp -r ../applications/app/dist/ updates/$directory
	…

4. Dans le package.json du serveur, ajouter le script d’export propre a l’application en y complétant le nom du projet (du dossier de l’application), et son runtimeVersion. Ce dernier sera le nom du dossier de mis a jour de l’application dans le dossier updates/ du serveur
    * Ex: expo-publish-<nom_app>: "./scripts/publish.sh -d <runtimeVersion>/$(date +%s)"



## Procedure:

1. Apres avoir complété ces points, faire les modifications dans l’application

2. Exécuter yarn <script> dans le dossier du serveur, (<script> est le script propre a l’application ajouté dans le package.json)

3. Démarrer le serveur en exécutant yarn dev 

4. Fermer l’application en arrière plan sur le device et la réouvrir, elle fera une requête vers le serveur et récupérera les mises a jour la concernant puis les appliquerai (s’il y en a)
