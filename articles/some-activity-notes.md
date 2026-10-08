# Vanmniljø activities

Vannmiljø’s Aktivitet names/IDs correspond both to formal monitoring
campaigns with associated reports (e.g. MILKYS), as well as other
sources of data. Vannmiljø gives a list of activities in its [kodeverk
website](https://vannmiljokoder.miljodirektoratet.no/activity?q=)
(undated).

In their own words:

> All miljøovervåking og -kartlegging har som utgangspunkt å fremskaffe
> tilstrekkelig kunnskap til å kunne utøve en best mulig forvaltning av
> naturmiljøet. Det enkelte overvåkingsprosjekt eller -program er
> innrettet for å oppnå mer spesifikke forvaltningsmål, f.eks. å
> kontrollere at avbøtende tiltak faktisk fører til forbedring i
> miljøtilstanden. For å sikre en best mulig utnyttelse av ressursene
> til overvåking av miljøtilstanden i vann, er det viktig å ha oversikt
> over alle pågående og avsluttede overvåkingsaktiviteter. Det gir bedre
> grunnlag for å samordne aktiviteter gjennom felles prøvetaking og
> sammenholde ferske data med resultater fra tidligere overvåking.
> Derfor skal alle overvåkingsdata (vannregistreringer) i Vannmiljø
> knyttes til en overvåkingsaktivitet. En vannregistrering kan bare
> tilhøre en overvåkingsaktivitet, mens en vannlokalitet kan ha mange
> vannregistreringer med forskjellige aktiviteter.

> I tabellen nedenfor er det gitt en oversikt over alle gyldige
> aktivitetskoder (ActivityID) med utfyllende beskrivelse av
> aktivitetene. Listen er ment å skulle være så uttømmende som mulig,
> men kan utvides ved behov. Vi vil imidlertid være restriktive med
> stadige utvidelser siden det motvirker formålet med listen, nemlig å
> gi oversikt.

Let’s do a quick exploration of the available list of activities. I’m
using a local version from 2026 here, although you could also get a live
version from the API, if you wanted.

Code

``` r

library(arrow)
library(tidyverse)
library(here)
library(sf)
library(readxl)
library(knitr)

vm_activities <- read_parquet(
  here(
    "inst",
    "example_datasets",
    "codelists",
    "Vannmiljo_Aktivitet_2026-10-05.parquet"
  )
)

vm_activities |> kable()
```

| ActivityID | Name | Description |
|:---|:---|:---|
| ANLA | Overvåking av anadrom laksefisk | Nasjonal overvåking av laksebestander for å dokumentere bestandssammensetningen m.m. hos voksen laks, herunder andelen rømt oppdrettsfisk. Etablert bl.a. for å kunne fastsette forskrift om fisketider, tillatt redskap og soner for fiske. |
| ANNE | Annet | Annen type overvåking eller kartlegging som det ikke er naturlig å gruppere under noen av aktivitetene i listen. Gi en nærmere beskrivelse i kommentarfeltet. |
| AREA | Effekter av planlagt arealbruk | Arealplanlegging som krever konsekvensutredning etter Plan- og bygningsloven. |
| BADE | Overvåking av badevann | Overvåking av hygienisk kvalitet i badesesongen. |
| BAPO | Basisovervåking - påvirka områder | Overvåking av langsiktige endringer som følge av omfattende menneskelig virksomhet, jf. Vannforskriftens vedlegg V, avsnitt 1.3.1. Karakterisert ved et fast nettverk av overvåkingslokaliteter med lav prøvetakingsfrekvens hvor alle kvalitetselementer overvåkes. |
| BARE | Basisovervåking - referanseforhold | Representativ overvåking av tilnærmet upåvirket tilstand (naturtilstand) for å vurdere langsiktige endringer i de naturlige forholdene, jf. Vannforskriftens vedlegg V, avsnitt 1.3.1. Karakterisert ved et fast nettverk av overvåkingslokaliteter med lav prøvetakingsfrekvens hvor alle kvalitetselementer overvåkes. |
| BIOM | Overvåking av biologisk mangfold | Nasjonalt program for kartlegging og overvåking av biologisk mangfold i ferskvann og marint miljø. |
| CEMP | Miljøgifter langs norskekysten | Statlig program for forurensningsovervåking: Coordinated Environmental Monitoring Programme (CEMP). Trendovervåking av miljøgifter i marine organismer og bunnsedimenter i påvirkede områder, samt stadfesting av bakgrunnsnivåer og trender i ikke påvirkede områder, langs hele norskekysten. Programmet ble avsluttet i 2011 og er videreført i programmet Milkys fra og med 2012. |
| DEPO | Overvåking av avrenning fra landdeponi | Overvåking av sigevann og grunnvann som er påvirket av avrenning fra landdeponi (forurenset grunn). |
| DRIK | Overvåking av drikkevann | Overvåking (limnologisk undersøkelse) av råvannskilden, dvs. vannforekomsten (elv, innsjø eller grunnvann) som råvannet hentes fra. |
| EDKR | Overvåking av edelkreps | Statlig miljøovervåking: Overvåking av edelkrepsbestander ble startet opp i 2001. Et nytt program ble startet i 2018 med formål å overvåke status og trender for et utvalg av de viktigste endelkrepsbestandene i Norge. I tillegg skal prosjektet gjennom bruk av ny teknologi (eDNA) implementere overvåkning av spredning av signalkreps. |
| ELMU | Overvåking av elvemusling | Statlig miljøovervåking: Overvåkingen dokumenterer utviklingen i bestander av elvemusling over tid i hele landet og behovet for tiltak. Elvemusling overvåkes i 40 lokaliteter fordelt på hele landet. Programperiode: 2000-2015 og 2018-2023. |
| ELVE | Elveovervåkingsprogrammet | Statlig miljøovervåking: Elveovervåkingsprogrammet startet i 2017 og er en arvtager av Elvetilførselsprogrammet (RID). Programmet består av 46 av Norges største vassdrag og dekker dermed de største nedbørsfeltene i landet. Biologiske parametere (bunndyr, begroingsalger og fisk) undersøkes hvert tredje år, mens vannkvaliteten (miljøgifter, næringssalter, andre vannkvalitetsparametere) overvåkes månedlig i 20 av elvene. Formålet med programmet er å måle vannkvalitet og effekter av klimaendringer i norske elver, samt beregne totale tilførsler av næringssalter, organisk materiale og miljøgifter til norske havområder. |
| ELVS | Elveserien. Kjemisk overvåking av norske vassdrag. | Kjemisk overvåking av et utvalg elver på Sørlandet i forbindelse med oppfølging av vassdragsforsuring startet i 1965/66. Denne overvåkingen ble ledet av daværende Fiskeforskningen, Direktoratet for jakt, viltstell og ferskvannsfisk, senere Direktoratet for naturforvaltning. Målet for denne undersøkelsen var å registrere eventuelle endringer i elvenes forsuringsforhold over tid. Fra begynnelsen av 1990-tallet er antall vassdrag gradvis redusert og flere lokaliteter er etter hvert avviklet. En del vassdrag som fram til 1980-tallet var inkludert i Elveserien, ble siden innlemmet i kalkingsovervåkingen og rapporteres som en del av denne. Elveserien har siden 1995 bestått av 20 lokaliteter fordelt på 18 vassdrag. |
| EMUD | Effekter av mudring, utfylling og dumping | Pålagte undersøkelser for å vurdere effekten av mudring, utfylling og dumping av masser som kan medføre forurensning, jf. forurensningsforskriftens § 22. |
| EUTR | Landsomfattende trofiundersøkelse | Statlig program for forurensningsovervåking: Landsomfattende/regional undersøkelse av trofitilstanden i norske innsjøer (EUREGI). Programmet ble avsluttet i 2001. |
| FLYP | Overvåking av påvirkning fra flyplasser | Overvåking i regi av Forsvarsbygg og Avinor for å spore effekter av avrenning til grunnvann og vassdrag fra flyplasser. |
| FORS | Forsuringsovervåking | Statlig program for forurensningsovervåking: Overvåking av effekter av langtransportert forurenset luft og nedbør. Programmet skal ivareta registrering av endringer i forsuringsforhold i større nedbørfelt (elver), innsjøer og feltforskningsområder. |
| FOSJ | Overvåking av forurenset sjøbunn | Kartlegging av sedimenter langs norskekysten som har forhøyede konsentrasjoner av miljøgifter eller myndighetspålagt overvåking i områder hvor det planlegges eller gjennomføres oppryddingstiltak. |
| FREM | Overvåking av fremmede arter | Overvåking av arter som opptrer på «Fremmedartlista 2018» publisert av Artsdatabanken. |
| FULM | JAMP Fullmar Plastic North Sea | Monitoring and Assessment of plastic particles in stomachs of fulmars in the North Sea area. OSPAR agreement 2015-03. |
| GEOS | Geologi i Oslo-regionen (GEOS) | En omfattende geologisk kartlegging og prøvetakning i Oslo-regionen 2003 - 2009. I regi av GEOS-prosjektet har NGU foretatt en heldekkende maringeologisk kartlegging av Oslofjorden. Målet med kartleggingen var blant annet å skaffe informasjon om dybdeforhold, lage kart over bunntyper, definere sedimentmektigheter og akkumulasjonsområder, og å kartlegge miljøtilstanden. I 53 kjerneprøver av bunnsedimenter ble det ved kjemiske analyser målt konsentrasjoner av tungmetaller og andre miljøelementer. |
| GRUV | Overvåking av gruvepåvirka vassdrag | Kartlegging og overvåking av forurensninger fra aktive og nedlagte gruver og overvåking av effekter av gjennomførte tiltak for å redusere avrenning av tungmetaller fra gruveområder. |
| GRVN | Overvåking av grunnvann | Overvåking i regi av NGU: «Landsomfattende mark- og grunnvannsnett (LGN)» og «Kartlegging og overvåkning av typelokaliteter for grunnvann med antropogen belastning». |
| HAVF | Overvåking av havforsuring | Statlig miljøovervåking: Havforsuring er en ganske nyoppdaget problemstilling, og denne typen overvåkning er derfor også ny. I første omgang er det derfor viktig å finne ut mer om hvordan tilstanden er i norske havområder, både hvor store de naturlige svingningene er, men også hvor fort havet blir surere på grunn av menneskeskapte CO2-utslipp. Programmer omfatter prøvetaking i overflaten og i vannsøylen langs faste transekter i Skagerrak, Norskehavet og Barentshavet. |
| IKOS | IKO Svalbard | Statlig miljøovervåking: Uttesting av konsept for integrert klimaovervåking i vann (2022-2026). Formålet med prosjektet er å teste ut om konsept for integrert klimaovervåking i vann kan være en god tilnærming for langsiktig dokumentasjon på eksisterende/pågående klimaeffekter. Data som samles inn vil være viktige for modellering av klimaendringenes effekt på akvatiske økosystemer i Arktis og på fastlandet. |
| INDU | Overvåking av påvirkning fra industri | Myndighetspålagt overvåking av industri med utslippstillatelse, jf. Forurensningslovens § 51 eller Forurensningsforskriften. |
| INNL | Overvåking av innlandsfisk | Overvåking av fiskebestander for å fastsette lokale forskrifter om fisketider, tillatt redskap og soner for fiske. |
| IOFJ | Overvåking av indre Oslofjord | Miljøovervåkning i Ytre Oslofjord gjennomføres i regi av Fagrådet for Ytre Oslofjord. |
| JOVA | Jord- og vannovervåking i landbruket | Nasjonalt overvåkingsprogram (JOVA-programmet) for landbruksdominerte nedbørfelt. Har et landsdekkende nett av målestasjoner i små nedbørfelt dominert av jordbruk, hvor det måles avrenning og analyseres for vannkvalitet i bekker i jordbrukslandskapet. |
| JRBN | Overvåking av påvirkning fra jernbane | Overvåking i regi av Bane NOR og andre utbyggere for å undersøke miljøeffektene av utbygging av jernbane før og under anleggsperioden og i etterfølgende driftsfase. |
| KAKA | Kartlegging av kalksjøer | Undersøkelser i innsjøer omtalt som viktig naturtype (Kalksjø E07) i ferskvann/våtmark, jf. DN-håndbok 13-2006. |
| KALK | Tiltaksovervåking i kalkede laksevassdrag | Nasjonalt program for biologisk og vannkjemisk overvåking av effekten av kalking i laksevassdrag. De overordnede målene for kalkingsvirksomheten_x000d\_ |

er å sikre eller gjenskape «god økologisk tilstand» etter
vannforskriften med hensyn til forsuring, og å_x000d\_ sikre god
tilgjengelighet til fritidsfiske (høstbart overskudd) i
forsuringsrammede områder. \| \|KALL \|Lokal overvåking av kalka
vassdrag \|Lokalt program for overvåking av effekten av kalking og gi
grunnlag for å evaluere og eventuelt kunne justere kalkingsstrategien.
\| \|KART \|Kartlegging av arter \|Nasjonal kartlegging av
funksjonsområder til arter i ferskvann og sjø. \| \|KAVE \|Overvåking av
påvirkning fra vegtrafikk \|Overvåking i regi av Statens vegvesen, Nye
Veger AS og andre utbyggere for å undersøke miljøeffektene av utbygging
av veg før og under anleggsperioden og i etterfølgende driftsfase. \|
\|KOMM \|Overvåking av påvirkning fra avløp \|Overvåking i regi av
kommuner for å undersøke miljøeffekter i resipienter av utslipp fra
renseanlegg, overløp eller andre urensede utslipp. \| \|KYST
\|Kystovervåkingsprogrammet \|Statlig program for
forurensningsovervåking: Langtidsovervåking av miljøkvaliteten i
kystområdene av Norge. Programmet gir oversikt over miljøtilstanden
m.h.p. næringssalter og dokumenterer effekter av næringssalter på
utviklingen og tilstanden i hard- og bløtbunnssamfunnene. Programmet ble
avsluttet i 2010 og er videreført sammen med overvåking av sukkertare i
programmet ØkoKyst fra og med 2013. \| \|LANG \|Lange tidsserier \|Årlig
tilskudd fra Klima- og miljødepartementet (KLD) til finansiering av
lange overvåkingstidsserier for å sikre den grunnleggende
forskningsinfrastrukturen som lange tidsserier representerer. \| \|LTAM
\|Langtransporterte atmosfæriske miljøgifter \|Statlig miljøovervåking:
Programmet omfatter overvåking av et utvalg organiske miljøgifter og
tungmetaller i luft på Birkenes, Andøya og Zeppelinfjellet (Svalbard).
Aktiviteten omfatter også overvåkingsprogrammet Norge - Russland
representert ved målestasjonene Svanvik og Karpdalen. \| \|MARE
\|Kartlegging av miljøgifter i sedimenter - MAREANO \|MAREANO kartlegger
dybde, bunnforhold, biologisk mangfold, naturtyper og forurensning i
sedimentene i norske kyst- og havområder. \| \|MGKK \|Marine grunnkart i
kystsonen \|Et samarbeid mellom Kartverket, Norges geologiske
undersøkelse og Havforskningsinstituttet om å samle inn og dele kunnskap
og data langs kysten av Norge. \| \|MIFE \|Miljøgifter i ferskvann
\|Statlig program for forurensningsovervåking: Overvåking av miljøgifter
i innsjøsedimenter og ferskvannsfisk. Programmet følger utviklingen i
konsentrasjonen av enkelte tungmetaller og organiske miljøgifter i
utvalgte innsjøer over hele Norge. Programmet er avsluttet og videreført
i MilFersk fra og med 2015. \| \|MILK \|Miljøgifter i kystområdene
(MilKys) \|Statlig miljøovervåking: Programmet følger med på de mest
miljøfarlige tungmetallene og organiske miljøgifter i marine organismer
langs kysten fra Oslofjorden til Varangerfjorden. I tillegg undersøkes
biologisk effekter på et utvalg av stasjonene. Biologisk
effektovervåking er inkludert i programmet for å vurdere hvilken
påvirkning miljøgifter har på organismer. Programmet er en direkte
videreføring av “Miljøgifter langs norskekysten” (CEMP). \| \|MINN
\|Miljøgifter i ferskvann (MilFersk) \|Statlig miljøovervåking:
Miljøgifter i næringsnett i en stor norsk innsjø (delprogram 1) og
basisovervåking av miljøgifter i ferskvannsfisk (delprogram 2).
Hensikten med delprogram 1 er å gi informasjon om forekomst og skjebne
til miljøgifter i norske ferskvannsøkosystem. Programmet omfatter
prøvetaking og analyse av prøver fra ulike nivåer i næringskjeden
(abiotiske prøver, plankton og fisk) i en utvalgt stor innsjø. Det vil
også måles miljøgiftnivåer i toppredator i en referansesjø for
sammenligning. Hensikten med delprogram 2 er å gi informasjon om
forekomst og nivå av EUs prioriterte stoffer i ferskvannsfisk. \| \|MIPL
\|Mikroplast i kystområder, elver og innsjøer (Mikronor) \|Statlig
miljøovervåking: Dette overvåkingsprogrammet måler nivåer og typer av
mikroplast i norsk kystvann, elver og innsjøer. Mikroplast er definert
som faststoffpartikler som inneholder syntetiske eller bearbeidede
polymerer i størrelsesorden 5 mm og mindre. Siden mikroplast er en
heterogen gruppe med partikler i ulike størrelser, bestående av ulike
materialer, med ulik form, tetthet og farge, analyseres hver prøve for
størrelse, type plast, form og farge. \| \|MIPR \|Miljøgifter i
produkter \|NA \| \|MITE \|Miljøgifter i terrestrisk og bynært miljø
(Milby) \|Statlig miljøovervåking: Programmet søker å besvare spørsmål
om miljøgiftene oppfører seg likt i vann som på land, eller om de har en
annen skjebne i terrestriske næringskjeder, og om det er forskjeller i
miljøgiftnivåer mellom bygd og by. Resultatene fra programmet vil bli
brukt i nasjonal og internasjonal regulering av miljøgifter, samt
artsforvaltning. \| \|MIUR \|Miljøgifter i en urban fjord \|Programmet
omfatter undersøkelse av kilder til miljøgifter og hvordan miljøgifter
oppfører seg i næringskjeden. Indre Oslofjord brukes som modell for
andre fjorder i Norge med lignende påvirkning. Programmet skal også se
på om stoffene hoper seg opp i næringskjeden. Disse artene er valgt ut
til å representere næringsnettet i Indre Oslofjord: børstemark, reker,
flatfisk, torsk, blåskjell og gråmåke. I tillegg skal det tas prøver av
overvann og avrenning. Resultatene skal brukes i nasjonal og
internasjonal regulering av miljøgifter, kildesporing, i tiltak mot
utslipp, og i artsforvaltningen. \| \|MOMC \|Miljøovervåking
akvakulturanlegg \|Miljøovervåking knyttet til alle akvakulturanlegg.
Det omfatter flytende akvakulturanlegg (jf. NS 9410:2016),
settefiskanlegg med punktutslipp og landbaserte anlegg. \| \|MONS
\|Feltspesifikk miljøovervåking på norsk sokkel \|Overvåking av sediment
og biota for å påvise og kartlegge forurensning omkring de enkelte
installasjonene på norsk sokkel. \| \|MOSE \|Moseprogrammet \|Statlig
miljøovervåking: Overvåking av tungmetaller og organisk miljøgifter i
etasjemose (Hylocomium splendens). \| \|MYFO \|Myndighetspålagt
forurensningsovervåking \|Karteggingsundersøkelser eller overvåking av
effekter av forurensende virksomhet, jf. Forurensningslovens § 51 eller
Forurensningsforskriften. Benytt fortrinnsvis mer spesifikke aktiviteter
som «Miljøovervåking akvakulturanlegg» (MOMC), «Effekter av
vassdragsinngrep» (VASS), «Overvåking av avrenning fra landdeponi»
(DEPO), «Overvåking av forurenset sjøbunn» (FOSJ), «Overvåking av
påvirkning fra industri (INDU)», «Overvåking av påvirkning fra avløp
(KOMM)», «Overvåking av påvirkning fra flyplasser» (FLYP), «Overvåking
av påvirkning fra jernbane» (JRNB), «Overvåking av påvirkning fra
vegtrafikk» (KAVE) eller «Overvåking av påvirkning fra skytefelt» (SKYT)
dersom de passer. \| \|OEKF \|Økosystemovervåkning i ferskvann
(ØkoFersk) \|Statlig miljøovervåking: Programmet startet i 2013 og
består av to deler som tidligere har vært separate
overvåkningsprogrammer, “Overvåkning av langtransportert forurenset luft
og nedbør - vannkjemisk og biologisk del” og “Basisovervåking i
ferskvann”. Hensikten med programmet er å vurdere tilstand og utvikling
i forhold til Vannforskriftens mål i et utvalg av norske
vannforekomster, og å kunne vurdere utvikling når det gjelder
forsuringsstatus i norsk natur. \| \|OEKK \|Økosystemovervåking i
kystvann (ØkoKyst) \|Statlig miljøovervåking: Overvåkingsprogrammet
startet i 2013 som en arvtager til Kystovervåkingsprogrammet (KYO) og
Sukkertareoveråkingen (KYS). Programmet omfatter områdene: Skagerrak,
Rogaland, Hordaland, Møre og Romsdal, Trøndelag, Helgeland, Nordland og
Finnmark. I områdene Skagerrak og Rogaland er det særlig fokus på
overvåking av sukkertare. Økokyst dekker inn deler av den nasjonale
basisovervåkingen i henhold til vannforskriften og danner grunnlaget for
utvikling av klassifiseringssystemet under vannforskriften. \| \|OEKS
\|Økosystemovervåking i store innsjøer (ØkoStor) \|Statlig
miljøovervåking: Økosystemovervåking i store innsjøer (ØKOSTOR) startet
i 2015. Totalt inngår 24 innsjøer i programmet. Hver innsjø skal
undersøkes hvert 4. år. I fire av innsjøene gjennomføres et redusert
program hvert år. Formålet med programmet er å fastsette økologisk
tilstand i sjøene, styrke datagrunnlaget for fastsettelse av
referanseverdier for de ulike kvalitetselementene i store innsjøer og å
tilpasse metodikk for overvåkning og klassifisering til bruk i store
innsjøer. Disse kvalitetselementer undersøkes i innsjøene:
Planteplankton, dyreplankton, bunndyr, vannplanter, fisk og
fysisk-kjemiske parametere. \| \|OESA \|Vannovervåking med satellitt
(ØKOSAT) \|Statlig miljøovervåking: Utvikling av komplementær metode for
å måle vannkvalitetsparametre fra satellitt i innsjøer og kystvann for
vanndirektivet. \| \|OMAS \|Organiske miljøgifter i norsk avløpsslam
\|NA \| \|PASV \|Pasvikprogrammet \|Vannovervåking i Pasvikvassdraget og
innsjøer på Jarfjordfjellet (Pasvikprogrammet), Sør-Varanger kommune.
Overvåkingen inngår i det trilaterale vannovervåkingsprogrammet for
grenseområdet mellom Norge, Finland og Russland, og er en del av
arbeidsprogrammet for den norsk-russiske miljøvernkommisjonen (DGS-1).
Hovedformålet er å kartlegge virkninger av forurensning fra smelteverket
i Nikel, Russland. \| \|PROB \|Problemkartlegging \|Overvåking iverksatt
for å klarlegge årsaken til eventuelle overskridelser eller at
vannforekomsten(e) ikke oppfyller miljømålene, jf. Vannforskriftens
vedlegg V, avsnitt 1.3.3. Overvåkingen skal danne grunnlag for å
utarbeide tiltaksprogram. Kan om nødvendig erstattes av tiltaksorientert
overvåking når årsaksforholdene er klarlagt og det er behov for å
iverksette tiltak. \| \|RELV \|Referanseelver \|Statlig miljøovervåking:
Overvåking av referanseelver omfatter vassdrag med ingen eller
ubetydelig menneskelig påvirkning. Vassdragene er antatte
referanselokaliteter. De overvåkes for å gi kunnskap om
referansetilstand i ulike vanntyper og er en viktig del av
basisovervåkingen som følger av Vannforskriften. Data fra overvåkingen
brukes også til å verifisere og videreutvikle klassifiseringssystemet
for miljøtilstand i vann. Parametergruppene som inngår i overvåkingen er
miljøgifter, påvekstalger, bunndyr, fisk og vannkjemiske parametere. \|
\|RENS \|Regional miljøovervåking på norsk sokkel \|Overvåking av
bakgrunnsnivåer av forurensningskomponenter fra oljevirksomheten på
norsk sokkel. Omfatter både referansestasjoner og regionale stasjoner.
\| \|RIDD \|Elvetilførselsprogrammet \|Statlig program for
forurensningsovervåking: Overvåking av elvetilførsler til norske
havområder (RID). Programmet gir en årlig kvantitativ vurdering av
tilførsler til norske kystområder via vassdrag, arealavrenning og
direkte utslipp av utvalgte forurensningskomponenter. Programmet ble
avsluttet i 2016 og for en stor del videreført i
Elveovervåkingsprogrammet. \| \|SCRE \|Kartlegging av nye miljøgifter
\|Statlig program for forurensningsovervåking: Kartlegging (screening)
av utvalgte nye miljøgifter. Programmet skal bidra til tidlig varsling
av mulige problemer om potensielt helse- og miljøfarlige stoffer, og
skal gi grunnlag for å avgjøre om et stoff bør innlemmes i langsiktige
overvåkingsprogrammer. \| \|SJOM \|Sjømatdata \|Program for
dokumentasjon og overvåkning ved NIFES startet i 1994. Målet er å
tilfredsstille behov for uavhengig data for Mattilsynet,
fiskerimyndigheter, fiskeribransjen, oppdrettsindustrien, og
matvaremarkeder. Det jobbes også for å etablere trender over tid, og
avdekke mulige forskningsområder. Omfatter også prosjektet
”Basisundersøkelser av fremmedstoffer i viktige fiskearter i perioden
2009–2010” finansiert av Fiskeri- og havbruksnæringens forskningsfond
(FHF). \| \|SKYT \|Overvåking av påvirkning fra skytefelt \|Overvåking
av forsvarets skyte- og øvingsfelt \| \|SOFP \|Samordnet overvåking av
flere påvirkninger \|Lokal eller regional overvåking etablert som
resultat av et spleiselag mellom statlige myndigheter og forurenser.
Denne overvåkingsaktiviteten dekker flere typer påvirkninger. \| \|SPFO
\|Statlig program 1980-2000 \|Basisundersøkelser og rutineovervåking av
enkeltresipienter i regi av Statlig program for forurensingsovervåking
(SPFO) i tidsrommet 1980 - 2000. Finansiert utelukkende med statlige
midler. \| \|SUKK \|Sukkertareovervåkingsprogrammet \|Statlig program
for forurensningsovervåking: Miljøovervåking av sukkertare langs
norskekysten er et miljøovervåkingsprogram for indre kystområder med
fokus på sukkertare. Programmet ble avsluttet i 2012 og er videreført i
programmet ØkoKyst fra og med 2013. \| \|TILF \|Tilførselsprogrammet
\|Statlig program for forurensningsovervåking: Overvåking av tilførsler
av miljøfarlige stoffer til forvaltningsplanområdene Barentshavet,
Norskehavet og Nordsjøen. Programmet ble avsluttet i 2013. Overvåkingen
av havforsuring er videreført i eget program for
havforsuringsovervåking. \| \|TILT \|Tiltaksorientert overvåking
\|Overvåking for å fastslå tilstanden til vannforekomster som anses å
stå i fare for ikke å nå miljømålene, og vurdere eventuelle endringer i
tilstanden til slike vannforekomster som følge av tiltaksprogrammer, jf.
Vannforskriftens vedlegg V, avsnitt 1.3.2. Overvåkingen vil være
kjennetegnet ved et større antall overvåkingslokaliteter med hyppig
prøvetakingsfrekvens, hvor overvåkingen er konsentrert om de biologiske
kvalitetselementene eller det hydromorfologiske kvalitetselementet som
er mest følsomt for den identifiserte belastningen. \| \|TRUA
\|Overvåking av trua arter \|Overvåking av utvalgte trua arter, bl.a.
elvemusling, damfrosk og ferskvannskreps. \| \|VASS \|Effekter av
vassdragsinngrep \|Myndighetspålagt overvåking fastsatt i konsesjon
eller krav om konsekvensutredning etter Plan- og bygningsloven. Gjelder
særlig overvåking av effekter etter vannkraftutbygginger. \| \|WALI
\|Watch List \|Overvåkingslisten for overflatevann under Vanndirektivet
(«Watch List») er et verktøy for å samle inn gode data om nye stoffer
som kan være en risiko for vannmiljøet i EU. Listen brukes når vi har
for lite informasjon til å vite hvor stor risikoen faktisk er. \| \|YOFJ
\|Overvåking av Ytre Oslofjord \|Miljøovervåkning i Ytre Oslofjord
gjennomføres i regi av Fagrådet for Ytre Oslofjord. Overvåkningen er del
av et omfattende program som har pågått siden 2001, og det gjennomføres
i programperioder av fem år. Området som undersøkes er avgrenset av
Drøbaksterskelen mot Indre Oslofjord, Grenlandsområdet i vest og
Iddefjorden i øst. \|

These descriptions are a useful starting point. Some important points:

1.  Not all activities are of equal importance
2.  Some activities focus on the same (or similar) sites each year
    (e.g. reference activities such as
    `Basisovervåking - påvirka områder`/`Basisovervåking - referanseforhold`,
    which are designed to provide long-term data on reference
    contaminated and uncontaminated sites)
3.  Some activities are formal sampling campaigns conducted on behalf of
    the NEA
    (e.g. [Milkys](https://www.miljodirektoratet.no/ansvarsomrader/overvaking-arealplanlegging/miljoovervaking/overvakingsprogrammer/forurensning-og-klimagasser/miljogifter-langs-kysten/)),
    and have yearly reports and lots of metadata
4.  Other activities are data collected by other sources for other
    purposes, and are stored in Vannmiljø because it’s the easiest way
    to make such data available (even if it isn’t relevant to water)

So, we come into this with a bunch of assumptions that we need to test.
In order to properly understand the data, we need to review both the
datasets we have and available reporting about monitoring campaigns and
other activities. This is easier said than done.

Because the scope of the work I’m currently doing is associated with
Arctic/marine ecosystems, we will focus on the campaigns that most
contribute to these datasets. We’ve defined our criteria elsewhere:

1.  Medium = `Saltvann` or `Sediment saltvann`
2.  Latitude `< 66.5636` (once reprojected to CRS 4326)

Also as elsewhere, we’ll examine the data structure from several
subsets.

### Saltvann, 2010 - 2025

`WaterRegistrationExport_NO_Jan10_Jan25_SV` represents the data
extracted from Vannmiljø’s `Søk i miljøgifter` frontend for Jan 01
2010 - Jan 01 2025, with `Medium` set to `Saltvann`. It is assumed that
this data is a representative sample.

The returned file has 83,277 rows. Once we filter it to Arctic sites
we’re working with about 10%: 7,168 rows.

Code

``` r

library(arrow)

# 83,277 rows
WaterRegistrationExport_NO_Jan10_Jan25_SV <- read_parquet(
  here(
    "inst",
    "example_datasets",
    "registrations",
    "WaterRegistrationExport-NO-Jan10-Jan25-SV.parquet"
  )
)

arctic_circle_lat <- 66.5636 # approximate latitude of the Arctic Circle

reproject_4326 <- function(dataset) {
  dataset |>
    filter(
      !is.na(`UTM33 Ost (X)`) &
        !is.na(`UTM33 Nord (Y)`)
    ) |>
    st_as_sf(
      coords = c("UTM33 Ost (X)", "UTM33 Nord (Y)"),
      crs = 25833,
      remove = FALSE
    ) |>
    st_transform(4326) |>
    mutate(LATITUDE = st_coordinates(geometry)[, 2])
}

WaterRegistrationExport_NO_Jan10_Jan25_SV_reproj <- WaterRegistrationExport_NO_Jan10_Jan25_SV |>
  reproject_4326() |>
  mutate(arctic = LATITUDE >= arctic_circle_lat)
# drop rows without spatial data, 82,467 rows

WaterRegistrationExport_NO_Jan10_Jan25_SV_reproj |>
  filter(arctic) |>
  st_drop_geometry() |>
  reframe(.by = Aktivitet_navn, n = n(), Aktivitet_id = unique(Aktivitet_id)) |>
  arrange(desc(n))
```

Here we get some bad news. The single biggest dataset is `Mikronor` /
`MILP`, which monitors microplastics. Let’s join the pollution lookup
and filter down to our main groups of interest.

Based on pollutants.qmd, I expect the main groups of interest to be:

1.  Metals (MET)
2.  PAHs (PAH)
3.  PCBs
4.  Organic substances (ORG)
5.  PFAS (PFA)
6.  Tinorganic substances (TIN)

Code

``` r

pollutants <- read_excel(
  here("data", "raw", "vannmiljo", "Vannmiljø_Miljøgifter_2026-09-29.xlsx")
)

relevant_pollutants <- c("MET", "PAH", "PCB", "ORG", "PFA", "TIN")
```

Code

``` r

sv_pollutants <- left_join(
  WaterRegistrationExport_NO_Jan10_Jan25_SV_reproj,
  pollutants,
  by = join_by(Parameter_id == ParameterID)
)

sv_pollutants_relevant <- sv_pollutants |>
  filter(SubGroupID %in% relevant_pollutants, arctic)

sv_pollutants_relevant |>
  group_by(SubGroupID) |>
  reframe(n = n()) |>
  arrange(desc(n))
```

This leaves us with not a great deal of data. 4,700 data points of
saltwater, relevant stressors.

## Basisovervåking

According to
https://www.vannportalen.no/kunnskapsgrunnlaget/overvaking2/basisovervaking/,
Basisovervåking consists of the following activities:

Kystvann:

    Økosystemovervåking i kystvann (Økokyst) (miljødirektoratet)
    Miljøgifter i kystområdene (Milkys) (miljødirektoratet) ()
    Havforsuringsprogrammet (miljødirektoratet)

Ferskvann (elver og innsjøer):

    Overvåking av elvetilførsler og direkte utslipp til norske kystområder (Elvetilførselsprogrammet):
        Elveovervåkningsprogrammet – vannkvalitetsstatus og trender
        Kildefordelte tilførsler av nitrogen og fosfor til norske kystområder
    Økosystemovervåking i store sjøer (ØKOSTOR)
    Økosystemovervåking i ferskvann (ØKOFERSK)
    Referanseelver
    Grunnvann

## Aquaculture

Aquaculture facilities are required to conduct frequent monitoring of
the sediment below their sites for contamination. In some areas (such as
the Arctic), this is the single largest source of pollution data, and
eclipses formal monitoring campaigns.

https://www.vannportalen.no/veiledere/veiledning-i-bruk-av-data-fra-miljoundersokelser-ved-akvakulturanlegg-i-sjo-til-klassifisering-av-vannforekomster/

However, when we’ve looked at actual Vm data (see for example the
horizontal/vertical slices), basisovervåkning is its own activity.
