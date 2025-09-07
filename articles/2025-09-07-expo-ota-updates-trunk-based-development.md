---
title: 2025-09-07-expo-ota-updates-trunk-based-development
author: Sindre J.I Sivertsen
date: 07-09-2025
read-time: 5
categories:
  - Blogging
  - Opinion
tags:
  - favicon
published: false
---

Introduksjon: Hvorfor er jeg i denne situasjonen?
For noen måneder tilbake fikk jeg ansvaret for en React Native Expo app. 

Expo har støtte for noe de kalle for [over-the-air updates](https://docs.expo.dev/deploy/send-over-the-air-updates/) (OTA), som kort fortalt lar deg oppdatere appen din som om det var en nettside, uten å måtte dytte et nytt build gjennom App Store eller Google Play. Når brukerne dine går inn på appen din etter du har dyttet en ny oppdatering med OTA, vil den siste oppdateringen bli lastet ned fra en CDN.

Det er viktig å poengtere at du kun kan dytte Javascript oppdateringer på denne måten. Hvis du gjør noen endringer i appen som krever et nytt native build, så må det gjøres på vanlig måte.

Dette innlegget er en veldig kort oppsummering for hvordan vi konfigurerte OTA oppdateringer for våre miljøer: dev, stage, og production. Med Trunk based development.

# Mål

Under utvikling så ønsker vi å bruke trunk based development. Så vi ønsker at alle deployments skal komme ut av main branchen. 
Vi ønsker et dev miljø for utviklerne og QA. Vi ønsker et stage miljø for å testere, og til slutt så ønsker vi et produksjonsmiljø som sluttbrukerne våre bruker.

# Setup

Først så må vi sette opp channel ene våre. Expo knytter av en eller annen grunn  automatisk hver channel til en git branch. Dette er sikkert fint hvis man ønsker å bruke git-flow. Men ubrukelig, og forvirrende ellers. Vi må derfor lage 3 git brancher som vi tenker å ALDRI bruke.
Hvis vi for eksempel lager en production channel på en production branch i git, så vil all kode som dyttes til denne branchen automatisk publiseres til alle EAS bygg som er koblet til denne channelen. Vi ønsker istedenfor å dytte ut oppdateringer manuelt fra main til de respektive channels.

![E](https://docs.expo.dev/static/images/eas-update/channel-branch-link.png)

[src](https://docs.expo.dev/eas-update/eas-cli/)

Vi kan lage en dev channel

`git checkout -b dev`
`eas channel:create dev`

En stage channel

`git checkout -b stage`
`eas channel:create stage`

Og en production channel

`git checkout -b production`
`eas channel:create production`


Etter det kan vi redigere eas.json for å koble våre 3 bygg opp til hver sin channel:

`./eas.json`
```json
{
  "cli": {
    "version": ">= 7.1.2",
    "appVersionSource": "remote"
  },
  "build": {
	"dev": {
	  "distribution": "internal", // Internal because we won't submit the build to App Store.
	  "developmentClient": true, // Expo dev client is added to the app binary.
	  "channel": "dev", // Important to target the dev OTA channel.
	  "android": {
		"image": "latest"
	  },
	  "env": {
		"APP_VARIANT": "dev"
	  }
	},

    "stage": {
      "channel": "stage", // Important to target the stage OTA channel
      "distribution": "internal",
      "autoIncrement": true,
      "android": {
        "image": "latest",
        "resourceClass": "large"
      },
      "env": {
        "APP_VARIANT": "stage"
      }
    },

    "production": {
      "channel": "production", // Important to target the production OTA channel
      "autoIncrement": true,
      "android": {
        "image": "latest",
        "resourceClass": "large"
      },
    }
  },
  "submit": {
  ...
  }
}

```

Runtime policy
```
const version = '7.0.0'
export default {
  expo: {
    name: app_environment.name,
    version: version,
	...
    runtimeVersion: {
      policy: 'appVersion',
    },
```
``
`eas update --auto --non-interactive --channel dev`

`eas update --auto --non-interactive --channel production`

`eas build --platform all --auto-submit --profile production
`

Expo:

- Hva er build profiles?
- Hva er channels?
- Hva er OTA updates?
- Hva betyr app versjonering for prosessen?
- Når kjører man app versjonering?