#'---
#'title: "Codebook | Corpus der Drucksachen des Deutschen Bundestages (CDRS-BT)"
#'author: Seán Fobbe
#'geometry: margin=3cm
#'papersize: a4
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CDRS-BT_Source_TEX_Definitions.tex,CDRS-BT_Source_TEX_CodebookTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---

#'\newpage

#+ echo = FALSE 
knitr::opts_chunk$set(fig.pos = "center",
                      echo = FALSE,
                      warning = FALSE,
                      message = FALSE)


############################
### Packages
############################

#+
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Automatisierte Tabellen
library(magick)       # Fortgeschrittene Verarbeitung von Grafiken
library(parallel)     # Parallelisierung in Base R
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung

setDTthreads(threads = detectCores()) 


###################################
### Zusätzliche Funktionen einlesen
###################################

source("General_Source_Functions.R")


############################
### Vorbereitung
############################

datasetname <- "CDRS-BT"
doi.concept <- "10.5281/zenodo.4643065" # checked
doi.version <- "10.5281/zenodo.4643066" # checked


files.zip <- list.files(pattern = "\\.zip")

datestamp <- unique(tstrsplit(files.zip,
                              split = "_")[[2]])

prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_")



################################
### Einlesen: Frequenztabellen
################################

table.wahlperiode <- fread(paste0(prefix,
                                  "01_Frequenztabelle_var-wahlperiode.csv"),
                         drop = 3)

table.jahr <- fread(paste0(prefix,
                           "01_Frequenztabelle_var-jahr.csv"),
                    drop = 3)

table.typ <- fread(paste0(prefix,
                           "01_Frequenztabelle_var-drs_typ.csv"),
                    drop = 3)

table.p.urheber <- fread(paste0(prefix,
                           "01_Frequenztabelle_var-p_urheber.csv"),
                    drop = 3)

table.k.urheber <- fread(paste0(prefix,
                           "01_Frequenztabelle_var-k_urheber.csv"),
                         drop = 3)

######################################
### Einlesen: Linguistische Kennwerte
######################################


stats.ling <-  fread(paste0(prefix,
                            "00_KorpusStatistik_ZusammenfassungLinguistisch.csv"))

stats.ling$Sum <- as.numeric(stats.ling$Sum)


stats.docvars <- fread(paste0(prefix,
                              "00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"))



######################################
### Einlesen: Datensatz
######################################

summary.zip <- paste(datasetname,
                     datestamp,
                     "DE_CSV_Metadaten.zip",
                     sep = "_")

summary.corpus <- fread(cmd = paste("unzip -cq",
                                    summary.zip))



data.zip <- paste(datasetname,
                     datestamp,
                     "DE_CSV_Datensatz.zip",
                     sep = "_")

data.corpus <- fread(cmd = paste("unzip -cq",
                                 data.zip))


################################
### Einlesen: Signaturen
################################


hashfile <- paste(datasetname,
                  datestamp,
                  "KryptographischeHashes.csv",
                  sep = "_")

signaturefile <- paste(datasetname,
                       datestamp,
                       "FobbeSignaturGPG_Hashes.gpg",
                       sep = "_")




#'# Einführung



#' Der **Deutsche Bundestag** ist das Parlament der Bundesrepublik Deutschland. Der Bundestag und der Bundesrat bilden gemeinsam die Legislative auf Bundesebene und somit die primäre Quelle für das deutsche Bundesrecht. Beide fungieren auch als einige der wichtigsten öffentlichen und nicht-öffentlichen Foren für gesellschaftliche Debatten.
#' 
#' Der **\datatitle\ (\datashort)** ist eine digitale Zusammenstellung von allen Drucksachen des Deutschen Bundestages der 1. bis 18. Wahlperiode. *Drucksachen* sind schriftliche Dokumente, welche die Beratungen des Bundestages vor- und nachbereiten und als Verhandlungsgegenstand auf die Tagesordnung des Bundestages gesetzt werden können (§ 75 Geschäftsordnung des Bundestages). Die inhaltliche Bandbreite ist hierbei sehr weit und umfasst beispielsweise Gesetzentwürfe, Beschlussvorlagen, kleine Anfragen, Antworten der Bundesregierung, Berichte von Untersuchungsausschüssen und Wahlvorschläge.
#'
#' Dem **Bundesrecht** kommt im Normengefüge der Bundesrepublik Deutschland herausragende Bedeutung zu. Zwar sind die Länder gemäß Art. 30, 70 GG primär für die Gesetzgebung zuständig, im Katalog der Art. 71 ff GG sind aber derart viele Kompetenzen dem Bund zugewiesen, dass das Bundesrecht praktisch jedes rechtliche Problem in der Bundesrepublik dominiert. Ausnahmen sind in der Regel nur die Bereiche innere Sicherheit, Bildung und Kultur, die weitgehend in der Hand der Bundesländer verblieben sind. Aber auch in diesen Bereichen finden sich Regelungen des Bundes. Beispiele dafür sind manche Regelungen des Bundespolizeigesetzes (BPolG) oder das Kulturgutschutzgesetz (KGSG).
#'
#'Die quantitative Analyse von politischen Texten ist mittlerweile fester Bestandteil des Forschungsprogramms der Politikwissenschaften, steht in den Rechtswissenschaften aber noch ganz am Anfang. Drucksachen spielen für die Gesetzgebung eine zentrale Rolle, wurden aber von Rechtswissenschaftler:innen bisher kaum systematisch untersucht. Die einzige frei verfügbare Sammlung (\enquote{Every Single Word}-Korpus) wurde dementsprechend auch von Politikwissenschaftler:innen (Kroeber und Remschel 2020) veröffentlicht.\footnote{Remschel, T. and Kroeber, C. (2020). Every Single Word: A New Data Set Including All Parliamentary Materials Published in Germany. Government and Opposition, 1-20. \url{https://www.doi.org/10.1017/gov.2020.29}; Kroeber, C. and Remschel, T., 2020, Every Single Word - A New Dataset Including All Parliamentary Materials Published in Germany. \url{https://doi.org/10.7910/DVN/7EJ1KI}. Harvard Dataverse. V2.}
#'
#'  Ein weiterer einschlägiger Korpus wurde möglicherweise von der Universität Siegen erstellt, war aber im April 2021 seit über einem Jahr offline.\footnote{\url{https://diskurslinguistik.net/korpus-repository/}} In Anbetracht der flächendeckenden Verfügbarkeit von hochwertigen wissenschaftlichen Repositorien ist ein Datensatz mit einer solchen Erreichbarkeitslücke keine vertretbare Grundlage für reproduzierbare Forschung.
#' 
#'In einem funktionierenden Rechtsstaat muss die Gesetzgebung öffentlich, transparent und nachvollziehbar sein. Im 21. Jahrhundert bedeutet dies auch, dass sie quantitativen Analysen zugänglich sein muss. Der Erstellung und Aufbereitung des Datensatzes liegen daher die Prinzipien der allgemeinen Verfügbarkeit durch Urheberrechtsfreiheit, strenge Transparenz und vollständige wissenschaftliche Reproduzierbarkeit zugrunde. Die FAIR-Prinzipien (Findable, Accessible, Interoperable and Reusable) für freie wissenschaftliche Daten inspirieren sowohl die Konstruktion, als auch die Art der Publikation.\footnote{Wilkinson, M., Dumontier, M., Aalbersberg, I. et al. The FAIR Guiding Principles for Scientific Data Management and Stewardship. Sci Data 3, 160018 (2016). \url{https://doi.org/10.1038/sdata.2016.18}}





#+
#'# Nutzung

#' Die Daten sind in offenen, interoperablen und weit verbreiteten Formaten (CSV, TXT, XML) veröffentlicht. Sie lassen sich grundsätzlich mit allen modernen Programmiersprachen (z.B. R, Python), sowie mit grafischen Programmen nutzen.
#'
#' **Wichtig:** Nicht vorhandene Werte sind sowohl in den Dateinamen als auch in der CSV-Datei mit "NA" codiert.


#+
#'## CSV-Dateien
#' Am einfachsten ist es die **CSV-Dateien** einzulesen. CSV\footnote{Das CSV-Format ist in RFC 4180 definiert, siehe \url{https://tools.ietf.org/html/rfc4180}} ist ein einfaches und maschinell gut lesbares Tabellen-Format. In diesem Datensatz sind die Werte Komma-separiert. Jede Spalte entspricht einer Variable, jede Zeile einer Drucksache. Die Variablen sind unter Punkt \ref{variables} genauer erläutert.
#'
#' Zum Einlesen empfehle ich für **R** dringend das package **data.table** (via CRAN verfügbar). Dessen Funktion **fread()** ist etwa zehnmal so schnell wie die normale **read.csv()**-Funktion in Base-R. Sie erkennt auch den Datentyp von Variablen sicherer. Beispiel:

#+ eval = FALSE, echo = TRUE
library(data.table)
dt <- fread("./filename.csv")






#+
#'## TXT-Dateien
#'Die **TXT-Dateien** inklusive Metadaten können zum Beispiel mit **R** und dem package **readtext** (via CRAN verfügbar) eingelesen werden. Beispiel:

#+ eval = FALSE, echo = TRUE
library(readtext)
txt <- readtext("./*.txt",
                docvarsfrom = "filenames", 
                docvarnames = c("datensatz",
                                "organ",
                                "dokumentart",
                                "wahlperiode",
                                "nummer_dok",
                                "datum",
                                "xml"),
                dvsep = "_", 
                encoding = "UTF-8")



#+
#'## XML-Dateien
#' Das Einlesen der **XML-Rohdaten** ist technisch anspruchsvoller als das Einlesen der CSV- oder TXT-Varianten. Da die XML-Dateien bis zur 18. Wahlperiode keine besonders komplexe Datenstruktur aufweisen, wird sich in den meisten Fällen kein Mehrwert gegenüber dem CSV-Format ergeben. Falls Sie dennoch die XML-Dateien nutzen möchten, lesen Sie bitte die Document Type Definition (DTD) genau und greifen Sie ggf. auf den im Source Code zur Verfügung gestellten XML Parser zurück.



#+
#'# Konstruktion



#+
#'## Beschreibung
#'Der **\datatitle\ (\datashort)** ist eine digitale Zusammenstellung von allen Drucksachen des Deutschen Bundestages, die auf dessen Open Data Portal in maschinenlesbaren XML-Dateien veröffentlicht wurden. Die derzeitige Sammlung beschränkt sich auf die Drucksachen der 1. bis 18. Wahlperiode.
#'
#' Der Stichtag des Abrufs für jede Version entspricht exakt der Versionsnummer.
#'
#'Zusätzlich zu den aufbereiteten maschinenlesbaren Formaten (CSV und TXT) sind die XML-Rohdaten enthalten, damit Analyst:innen gegebenenfalls ihre eigene Konvertierung vornehmen können. Die XML-Rohdaten wurden inhaltlich nicht verändert.



#+
#'## Datenquelle

#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule
#'Datenquelle & Vollzitat\\
#'\midrule

#'Primäre Datenquelle & \url{https://www.bundestag.de/services/opendata} \\


#'\bottomrule

#'\end{longtable}
#'\end{centering}



#+
#'## Sammlung der Daten
#' Die Daten wurden vollautomatisiert gesammelt und mit Abschluss der Verarbeitung kryptographisch signiert. Das Open Data Portal des Bundestages ist ausdrücklich für die vollautomatisierte Datensammlung freigegeben (\enquote{offenen Daten können zur maschinellen Weiterverarbeitung genutzt werden}\footnote{\url{https://www.bundestag.de/services/opendata}}). Der Abruf geschieht ausschließlich über TLS-verschlüsselte Verbindungen.
#'

#+
#'## Source Code und Compilation Report
#' Der gesamte Source Code --- sowohl für die Erstellung des Datensatzes, als auch für dieses Codebook --- ist öffentlich einsehbar und dauerhaft erreichbar im wissenschaftlichen Archiv des CERN hier hinterlegt: \softwareversionurldoi\
#'
#'
#' Mit jeder Kompilierung des vollständigen Datensatzes wird auch ein umfangreicher **Compilation Report** in einem attraktiv designten PDF-Format erstellt. Der Compilation Report enthält den vollständigen Source Code, dokumentiert relevante Rechenergebnisse, gibt sekundengenaue Zeitstempel an und ist mit einem klickbaren Inhaltsverzeichnis versehen. Er ist zusammen mit dem Source Code hinterlegt. Wenn Sie sich für Details der Herstellung interessieren, lesen Sie diesen bitte zuerst.


#'\newpage

#+
#'## Einschränkungen
#'Nutzer sollten folgende wichtige Einschränkungen beachten:
#' 
#'\begin{enumerate}
#' \item Der Datensatz enthält nur das, was der Bundestag auch tatsächlich veröffentlicht (\emph{publication bias}).
#' \item Es werden nur XML-Dateien abgerufen (\emph{file type bias}).
#' \item Einige wenige XML-Dateien waren fehlerhaft und konnten nicht ausgewertet werden (\emph{error bias}).
#'\item Die Sammlung beschränkt sich zunächst auf die 1. bis 18. Wahlperiode (\emph{temporal bias}). Die Frequenztabellen geben hierzu genauer Auskunft. Weitere Wahlperioden werden in Zukunft berücksichtigt.
#'\end{enumerate}

#+
#'## Urheberrechtsfreiheit von Rohdaten und Datensatz 

#'An Drucksachen besteht gem. § 5 UrhG kein Urheberrecht, da sie amtliche Werke sind. § 5 UrhG ist auf amtliche Datenbanken analog anzuwenden (BGH, Beschluss vom 28.09.2006, I ZR 261/03, \enquote{Sächsischer Ausschreibungsdienst}).
#'
#' Alle eigenen Beiträge (z.B. durch Zusammenstellung und Anpassung der Metadaten) und damit den gesamten Datensatz stelle ich gemäß einer \emph{CC0 1.0 Universal Public Domain Lizenz} vollständig urheberrechtsfrei.



#+
#'## Metadaten

#+
#'### Allgemein
#'Die Metadaten wurden fast ausschließlich aus dem Inhalt der XML-Dateien extrahiert bzw. berechnet. Der volle Satz an Metadaten ist nur in den CSV-Dateien enthalten. Alle hinzugefügten Metadaten sind zusammen mit dem Source Code vollständig maschinenlesbar dokumentiert.
#' 
#'Die Dateinamen der TXT-Dateien enthalten den Namen des Datensatzes, den Namen des Organs, die Art des Dokuments, die Wahlperiode, die laufende Nummer des Dokuments, das Datum der Sitzung (Langform nach ISO-8601, d.h. YYYY-MM-DD) und den Namen der XML-Datei aus der sie stammen.


#+
#'### Schema für die TXT-Dateinamen

#'\begin{verbatim}
#'[datensatz]_[organ]_[dokumentart]_[wahlperiode]_[nummer_dok]_[datum]_[xml]
#'\end{verbatim}

#+
#'### Beispiel eines Dateinamens

#'\begin{verbatim}
#' CDRS-BT_Bundestag_Drucksache_1_16_1949-09-14_0100016.txt
#'\end{verbatim}

#+
#'## Qualitätsprüfung

#'Die möglichen Werte der jeweiligen Variablen wurden durch Frequenztabellen und Visualisierungen auf ihre Plausibilität geprüft. Insgesamt werden zusammen mit jeder Kompilierung eine Vielzahl Tests zur Qualitätsprüfung durchgeführt. Alle Ergebnisse der Qualitätsprüfungen sind aggregiert im Compilation Report zusammen mit dem Source Code und einzeln im Archiv \enquote{ANALYSE} zusammen mit dem Datensatz veröffentlicht.






#+
#'# Varianten und Zielgruppen

#' Dieser Datensatz ist in unterschiedlichen Varianten verfügbar, die sich jeweils an verschiedene Zielgruppen richten. Zielgruppe sind nicht nur quantitativ forschende Politik- und Rechtswissenschaftler:innen, sondern auch traditionell arbeitende Forscher:innen. Idealerweise müssen quantitative Methoden ohnehin immer durch qualitative Interpretation, Theoriebildung und kritische Auseinandersetzung verstärkt werden (\emph{mixed methods}).
#'
#' Lehrende werden zudem von den vorbereiteten Tabellen und Diagrammen besonders profitieren, die Zeit im universitären Alltag sparen und bei der Erläuterung der Charakteristika der Daten hilfreich sein werden. Alle Tabellen und Diagramme liegen auch als separate Dateien vor um sie einfach z.B. in Präsentations-Folien oder Handreichungen zu integrieren.


#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule


#'Variante & Zielgruppe und Beschreibung\\

#'\midrule
#'
#'\endhead

#' CSV\_Datensatz & \textbf{Legal Tech/Quantitative Forschung}. Diese CSV-Datei ist die für statistische Analysen empfohlene Variante des Datensatzes. Sie enthält den Volltext aller Dokumente, sowie alle in diesem Codebook beschriebenen Metadaten.\\
#' CSV\_Metadaten & \textbf{Legal Tech/Quantitative Forschung}. Wie die andere CSV-Datei, nur ohne den Inhalt der Dokumente. Sinnvoll für Analyst:innen, die sich nur für die Metadaten interessieren und Speicherplatz sparen wollen.\\
#' TXT & \textbf{Traditionelle Forschung}. Die TXT-Dateien stellen einen Kompromiss zwischen den Anforderungen quantitativer und qualitativer Forschung dar und können sowohl als Lesefassung, als auch als Grundlage für quantitative Analysen benutzt werden. Die Dateinamen sind so konzipiert, dass sie auch für die traditionelle qualitative Arbeit einen erheblichen Mehrwert bieten. Im Vergleich zu den CSV-Dateien enthalten die Dateinamen nur einen reduzierten Umfang an Metadaten, um Kompatibilitätsprobleme unter Windows zu vermeiden und die Lesbarkeit zu verbessern.\\
#' XML & \textbf{Legal Tech/Quantitative Forschung}. Die XML-Rohdaten, so wie sie vom Bundestag veröffentlicht wurden. In der Regel nur für Replikationen von Interesse.\\
#' ANALYSE & \textbf{Alle Lehrenden und Forschenden}. Dieses Archiv enthält alle während dem Kompilierungs- und Prüfprozess erstellten Tabellen (CSV) und Diagramme (PDF, PNG) im Original. Sie sind inhaltsgleich mit den in diesem Codebook verwendeten Tabellen und Diagrammen. Das PDF-Format eignet sich besonders für die Verwendung in gedruckten Publikationen, das PNG-Format besonders für die Darstellung im Internet. Analyst:innen mit fortgeschrittenen Kenntnissen in R können auch auf den Source Code zurückgreifen. Empfohlen für Nutzer:innen die einzelne Inhalte aus dem Codebook für andere Zwecke (z.B. Präsentationen, eigene Publikationen) weiterverwenden möchten.\\


#'\bottomrule

#'\end{longtable}
#'\end{centering}



#+
#'\newpage




#+
#'# Variablen
#'\label{variables}


#+
#'## Datenstruktur 

str(data.corpus)


#+
#'## Hinweise

#'\begin{itemize}
#'\item Fehlende Werte sind immer mit \enquote{NA} codiert
#'\item Strings können grundsätzlich alle in UTF-8 definierten Zeichen (insbesondere Buchstaben, Zahlen und Sonderzeichen) enthalten.
#'\end{itemize}

#'\newpage
#+
#'## Erläuterungen zu den einzelnen Variablen



#'\ra{1.3}
#' 
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}P{3cm}p{8cm}}
#' 
#'\toprule
#' 
#'Variable & Typ & Erläuterung\\
#' 
#'\midrule
#'
#'\endhead
#' 
#'doc\_id & String & (Nur CSV-Datei) Der Name der extrahierten XML-Datei.\\
#'text  & String & (Nur CSV-Datei) Der vollständige Text der Drucksache. Aus der XML-Datei extrahiert.\\
#' wahlperiode & Natürliche Zahl & Die Wahlperiode aus der die Drucksache stammt. Aus der XML-Datei extrahiert.\\
#'datum & Datum (ISO) & Das Datum der Drucksache im Format YYYY-MM-DD (Langform nach ISO-8601). Die Langform ist für Menschen einfacher lesbar und wird maschinell auch öfter automatisch als Datumsformat erkannt.  Aus der XML-Datei extrahiert. In den XML-Rohdaten ist das Datum im Format DD.MM.YYYY dokumentiert und wurde vom Autor des Datensatzes in das ISO-Format transformiert.\\
#'jahr & Natürliche Zahl & (Nur CSV-Datei) Das Jahr der Drucksache im Format YYYY (Langform nach ISO-8601). Vom Autor des Datensatzes aus der Variable \enquote{datum} berechnet.\\
#' dokumentart & Alphabetisch & Es ist nur der Wert \enquote{DRUCKSACHE} vergeben. Wird vor allem dann relevant, wenn dieser Korpus mit einem Korpus der Plenarprotokolle verbunden wird.  Aus der XML-Datei extrahiert.\\
#' drs\_typ & String & (Nur CSV-Datei) Der Typ der Drucksache, beispielsweise \enquote{Gesetzentwurf} oder \enquote{Große Anfrage}. Alle möglichen Typen finden Sie unter Punkt \ref{drstyp}.  Aus der XML-Datei extrahiert.\\
#' p\_urheber & String & (Nur CSV-Datei) Der oder die persönliche Urheber:in der Drucksache. Viele Drucksachen haben mehr als eine/n persönliche/n Urheber:in, diese sind dann in einem einzelnen String dokumentiert, jeweils getrennt durch einen vertikalen Strich (\enquote{|}). Bei schriftlichen Fragen und Fragen für die Fragestunde nicht erfasst. Aus der XML-Datei extrahiert.\\
#' k\_urheber & String & (Nur CSV-Datei) Der körperschaftliche Urheber der Drucksache. Mehrere körperschaftliche Urheber sind in einem einzelnen String dokumentiert, jeweils getrennt durch einen vertikalen Strich (\enquote{|}). Aus der XML-Datei extrahiert. \\
#' titel & String & (Nur CSV-Datei) Der Titel der Drucksache. Aus der XML-Datei extrahiert.\\
#' nummer\_original & String & (Nur CSV-Datei) Eine Kombination von Wahlperiode und laufender Nummer der Drucksache. Beispielsweise steht \enquote{16/121} für die 121. Drucksache der 16. Wahlperiode. Manche Drucksachen sind Zusätze zu anderen Drucksachen und in diesem Fall mit einem \enquote{zu} am Ende der Nummer gekennzeichnet.  Aus der XML-Datei extrahiert.\\
#' nummer\_dok & Natürliche Zahl & Die laufende Nummer der Drucksache. Die Nummerierung beginnt in jeder Wahlperiode bei 1 und steigt bis zur maximalen Anzahl der Drucksachen einer Wahlperiode an. Durch den Autor des Datensatzes aus der Variable \enquote{nummer\_original} berechnet.\\
#' nummer\_zusatz & Alphabetisch & (Nur CSV-Datei) Ob es sich um einen Zusatz zu einem Dokument handelt. Mögliche Werte sind \enquote{ZUSATZ} oder \enquote{NA}. Zusatz-Dokumente haben den gleichen Wert der Variable \enquote{nummer\_dok} wie das Dokument, auf das sie sich beziehen. Durch den Autor des Datensatzes aus der Variable \enquote{nummer\_original} berechnet.\\
#' zeichen & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Zeichen eines Dokumentes. Berechnung durch den Autor des Datensatzes.\\
#' tokens & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch.  Berechnung durch den Autor des Datensatzes.\\
#' typen & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl einzigartiger Tokens (beliebige Zeichenfolge getrennt durch whitespace) eines Dokumentes. Diese Zahl kann je nach Tokenizer und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Tokenisierung und Typenzählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch. Berechnung durch den Autor des Datensatzes.\\
#' saetze & Natürliche Zahl & (Nur CSV-Datei) Die Anzahl Sätze. Entsprechen in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail sehr komplex und in \enquote{Unicode Standard: Annex No 29} beschrieben. Diese Zahl kann je nach Software und verwendeten Einstellungen erheblich schwanken. Für diese Berechnung wurde eine reine Zählung ohne Entfernung von Inhalten durchgeführt. Benutzen Sie diesen Wert eher als Anhaltspunkt für die Größenordnung denn als exakte Aussage und führen sie ggf. mit ihrer eigenen Software eine Kontroll-Rechnung durch. Berechnung durch den Autor des Datensatzes.\\
#' version & Datum (ISO) & (Nur CSV-Datei) Die Versionsnummer des Datensatzes im Format YYYY-MM-DD (Langform nach ISO-8601). Die Versionsnummer entspricht immer dem Datum an dem der Datensatz erstellt und die Daten von der Webseite des Bundestages abgerufen wurden. Eingefügt durch den Autor des Datensatzes.\\
#' doi\_concept & String & (Nur CSV-Datei) Der Digital Object Identifier (DOI) des Gesamtkonzeptes des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer die \textbf{aktuellste Version} des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden. Eingefügt durch den Autor des Datensatzes.\\
#' doi\_version & String &  (Nur CSV-Datei) Der Digital Object Identifier (DOI) der \textbf{konkreten Version} des Datensatzes. Dieser ist langzeit-stabil (persistent). Über diese DOI kann via www.doi.org immer diese konkrete Version des Datensatzes abgerufen werden. Prinzip F1 der FAIR-Data Prinzipien (\enquote{data are assigned globally unique and persistent identifiers}) empfiehlt die Dokumentation jeder Messung mit einem persistenten Identifikator. Selbst wenn die CSV-Dateien ohne Kontext weitergegeben werden kann ihre Herkunft so immer zweifelsfrei und maschinenlesbar bestimmt werden. Eingefügt durch den Autor des Datensatzes.\\
#' 
#'\bottomrule
#' 
#'\end{longtable}
#'\end{centering}




#'\newpage
#'## Konkordanztabelle: XML-Struktur und CSV-Variablen

#'\bigskip

#'\begin{longtable}{p{5cm}p{4.5cm}p{4.5cm}}

#'\toprule

#' CSV-Variable & XPath & Attribut\\

#'\midrule

#' titel & /TITEL & -\\
#' wahlperiode & /WAHLPERIODE & -\\
#' datum & /DATUM & -\\
#' dokumentart & /DOKUMENTART & -\\
#' drs\_typ & /DRS\_TYP & -\\
#' k\_urheber & /K\_URHEBER & -\\
#' p\_urheber & /P\_URHEBER & -\\
#' nummer\_original & /NR & -\\
#' text & /TEXT & -\\

#'\bottomrule

#'\end{longtable}

#'\medskip

#' Diese Konkordanztabelle bezieht sich auf die von der 1. bis zur 18. Wahlperiode gültige Document Type Definition (DTD) des Bundestages. Die DTD ist im Datensatz als separate Datei dokumentiert.







#'\newpage
#+
#'# Computerlinguistische Kennzahlen
#' Zur besseren Einschätzung des inhaltlichen Umfangs des Korpus dokumentiere ich an dieser Stelle die Verteilung der Werte für verschiedene klassische computerlinguistische Kennzahlen:
#'
#' \medskip
#'
#'\begin{centering}
#'\begin{longtable}{P{3.5cm}p{10.5cm}}

#'\toprule

#'Kennzahl & Definition\\

#'\midrule

#' Zeichen & Zeichen entsprechen grob den \emph{Graphemen}, den kleinsten funktionalen Einheiten in einem Schriftsystem. Beispiel: das Wort \enquote{Richterin} besteht aus 9 Zeichen.\\
#' Tokens & Eine beliebige Zeichenfolge, getrennt durch whitespace-Zeichen, d.h. ein Token entspricht in der Regel einem \enquote{Wort}, kann aber auch Zahlen, Sonderzeichen oder sinnlose Zeichenfolgen enthalten, weil es rein syntaktisch berechnet wird.\\
#' Typen & Einzigartige Tokens. Beispiel: wenn das Token \enquote{Verfassungsrecht} zehnmal in einem Dokument vorhanden ist, wird es als ein Typ gezählt.\\
#' Sätze & Entsprechen in etwa dem üblichen Verständnis eines Satzes. Die Regeln für die Bestimmung von Satzanfang und Satzende sind im Detail aber sehr komplex und in \enquote{Unicode Standard: Annex No 29} beschrieben.\\

#'\bottomrule

#'\end{longtable}
#'\end{centering}
#'
#' Es handelt sich bei den Diagrammen jeweils um "Density Charts", die sich besonders dafür eignen die Schwerpunkte von Variablen mit stark schwankenden numerischen Werten zu visualisieren. Die Interpretation ist denkbar einfach: je höher die Kurve, desto dichter sind in diesem Bereich die Werte der Variable. Der Wert der y-Achse kann außer Acht gelassen werden, wichtig sind nur die relativen Flächenverhältnisse und die x-Achse.
#'
#' Vorsicht bei der Interpretation: Die x-Achse it logarithmisch skaliert, d.h. in 10er-Potenzen und damit nicht-linear. Die kleinen Achsen-Markierungen zwischen den Schritten der Exponenten sind eine visuelle Hilfestellung um diese nicht-Linearität zu verstehen.
#'
#'\bigskip

#'## Werte der Kennzahlen

setnames(stats.ling, c("Variable",
                       "Summe",
                       "Min",
                       "Quart1",
                       "Median",
                       "Mittel",
                       "Quart3",
                       "Max"))

kable(stats.ling,
      format.args = list(big.mark = ","),
      digits = 2,
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)






#'## Verteilung Zeichen


#+ CDRS-BT_07_Density_Zeichen, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = zeichen),
                 fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^7))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Zeichen je Drucksache"),
        caption = paste("DOI:",
                        doi.version),
        x = "Zeichen",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )





#'## Verteilung Tokens

#+ CDRS-BT_08_Density_Tokens, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = tokens),
                 fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^7))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Tokens je Drucksache"),
        caption = paste("DOI:",
                        doi.version),
        x = "Tokens",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'## Verteilung Typen

#+ CDRS-BT_09_Density_Typen, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = typen),
                 fill ="black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^7))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Typen je Drucksache"),
        caption = paste("DOI:",
                        doi.version),
        x = "Typen",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




#'## Verteilung Sätze


#+ CDRS-BT_10_Density_Saetze, fig.height = 6, fig.width = 9
ggplot(data = summary.corpus) +
    geom_density(aes(x = saetze),
                 fill ="black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    coord_cartesian(xlim = c(1, 10^7))+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Sätze je Drucksache"),
        caption = paste("DOI:",
                        doi.version),
        x = "Sätze",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )




    
#' \newpage
#' \ra{1.4}
#+
#'# Inhalt


#+
#'## Zusammenfassung

setnames(stats.docvars, c("Variable",
                          "Anzahl",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mittel",
                          "Quart3",
                          "Max"))




kable(stats.docvars,
      digits = 2,
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)

#'\vspace{1cm}

#'## Nach Wahlperiode

freqtable <- table.wahlperiode[-.N][order(-wahlperiode)]
freqtable <- freqtable[,lapply(.SD, as.numeric)]




#+ CDRS-BT_02_Barplot_Wahlperiode, fig.height = 5, fig.width = 8
ggplot(data = freqtable) +
    geom_bar(aes(x = wahlperiode,
                 y = N),
             stat = "identity",
             fill = "black",
             color = "black",
             width = 0.5) +
    theme_bw()+
    scale_x_continuous(breaks = seq(1,
                                    max(freqtable$wahlperiode),
                                    1)) +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Drucksachen je Wahlperiode"),
        caption = paste("DOI:",
                        doi.version),
        x = "Wahlperiode",
        y = "Drucksachen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\vspace{1cm}

kable(table.wahlperiode,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable =TRUE,
      col.names = c("Wahlperiode",
                    "Drucksachen",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")




#'\newpage
#'## Nach Jahr

freqtable <- table.jahr[-.N][,lapply(.SD, as.numeric)]

#+ CDRS-BT_03_Barplot_Jahr, fig.height = 7, fig.width = 11
ggplot(data = freqtable) +
    geom_bar(aes(x = jahr,
                 y = N),
             stat = "identity",
             fill = "black") +
    theme_bw() +
    scale_x_continuous(breaks = seq(1945,
                                    max(freqtable$jahr),
                                    10)) +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Drucksachen je Jahr"),
        caption = paste("DOI:",
                        doi.version),
        x = "Jahr",
        y = "Drucksachen"
    )+
    theme(
        text = element_text(size = 16),
        plot.title = element_text(size = 16,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\vspace{1cm}

kable(table.jahr,
      format = "latex",
      align = 'P{3cm}',
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Jahr",
                    "Drucksachen",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")




#'\newpage
#'## Nach Typ der Drucksache

#'\label{drstyp}

freqtable <- table.typ[-.N]

#+ CDRS-BT_04_Barplot_DrucksachenTyp, fig.height = 10, fig.width = 14
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(drs_typ,
                             N),
                 y = N),
             stat = "identity",
             fill = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Dokumente je Typ der Drucksache"),
        caption = paste("DOI:",
                        doi.version),
        x = "Typ",
        y = "Drucksachen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )


#'\vspace{1cm}


kable(table.typ,
      format = "latex",
      align = c("p{7cm}",
                "P{2cm}",
                "P{2cm}",
                "P{3cm}"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Typ",
                    "Drucksachen",
                    "% Gesamt",
                    "% Kumulativ")) %>% kable_styling(latex_options = "repeat_header")





#'\newpage
#'## Top 50 Persönliche Urheber:innen


#' **Hinweis:** Aus Gründen der Lesbarkeit werden an dieser Stelle nur die 50 meistgenannten persönlichen Urheber:innen dargestellt. Die vollständige Frequenztabelle finden Sie als Lesefassung im Compilation Report abgedruckt und in einer maschinenlesbaren Fassung als CSV-Datei im ZIP-Archiv \enquote{ANALYSE} dokumentiert.
#'
#' Berücksichtigt sind alle Drucksachen in denen die Person mindestens einmal als persönliche/r (Mit-)Urheber:in genannt ist.

#'\vspace{0.5cm}


freqtable <- table.p.urheber[-.N][order(-N)][1:50]

#+ CDRS-BT_05_Barplot_Top50PersoenlicheUrheber, fig.height = 10, fig.width = 12
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(p_urheber,
                             N),
                 y = N),
             stat = "identity",
             fill = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Top 50 Persönliche Urheber:innen"),
        caption = paste("DOI:",
                        doi.version),
        x = "Persönliche Urheber:innen",
        y = "Drucksachen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\vspace{0.5cm}

kable(table.p.urheber[-.N][order(-N)][1:50][,-4],
      format = "latex",
      align = c("p{6cm}",
                "P{3cm}",
                "P{3cm}"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Persönliche Urheber:in",
                    "Drucksachen",
                    "% Gesamt")) %>% kable_styling(latex_options = "repeat_header")





#'\newpage
#'## Top 50 Körperschaftliche Urheber


#' **Hinweis:** Aus Gründen der Lesbarkeit werden an dieser Stelle nur die 50 meistgenannten körperschaftlichen Urheber dargestellt. Die vollständige Frequenztabelle finden Sie als Lesefassung im Compilation Report abgedruckt und in einer maschinenlesbaren Fassung als CSV-Datei im ZIP-Archiv \enquote{ANALYSE} dokumentiert.
#'
#' Berücksichtigt sind alle Drucksachen in denen die Entität mindestens einmal als körperschaftlicher (Mit-)Urheber genannt ist.


#'\vspace{0.5cm}


freqtable <- table.k.urheber[-.N][order(-N)][1:50]

#+ CDRS-BT_06_Barplot_Top50KoerperschaftlicheUrheber, fig.height = 10, fig.width = 12
ggplot(data = freqtable) +
    geom_bar(aes(x = reorder(k_urheber,
                             N),
                 y = N),
             stat = "identity",
             fill = "black") +
    coord_flip()+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Top 50 Körperschaftliche Urheber"),
        caption = paste("DOI:",
                        doi.version),
        x = "Körperschaftliche Urheber",
        y = "Drucksachen"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )


#'\vspace{0.5cm}


kable(table.k.urheber[-.N][order(-N)][1:50][,-4],
      format = "latex",
      align = c("p{7cm}",
                "P{3cm}",
                "P{3cm}"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Körperschaftlicher Urheber",
                    "Drucksachen",
                    "% Gesamt")) %>% kable_styling(latex_options = "repeat_header")







#'# Dateigrößen



#+
#'## Verteilung XML-Dateigrößen

#' ![](ANALYSE/CDRS-BT_11_DensityChart_Dateigroessen_XML-1.pdf)


#+
#'## Verteilung TXT-Dateigrößen

#' ![](ANALYSE/CDRS-BT_12_DensityChart_Dateigroessen_TXT-1.pdf)

#'\newpage


#+
#'## Gesamtgröße je ZIP-Archiv
files.zip <- fread(hashfile)$filename
filesize <- round(file.size(files.zip) / 10^6, digits = 2)

table.size <- data.table(files.zip, filesize)

kable(table.size,
      format = "latex",
      digits = 2,
      format.args = list(big.mark = ","),
      align = c("l", "r"),
      booktabs = TRUE,
      longtable = TRUE,
      col.names = c("Datei",
                    "Größe in MB"))






#'\newpage
#+
#'# Prüfung kryptographischer Signaturen

#+
#'## Allgemeines
#' Die Integrität und Echtheit der einzelnen Archive des Datensatzes sind durch eine Zwei-Phasen-Signatur sichergestellt.
#'
#' In **Phase I** werden während der Kompilierung für jedes ZIP-Archiv Hash-Werte in zwei verschiedenen Verfahren (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei dokumentiert.
#'
#' In **Phase II** wird diese CSV-Datei mit meinem persönlichen geheimen GPG-Schlüssel signiert. Dieses Verfahren stellt sicher, dass die Kompilierung von jedermann durchgeführt werden kann, insbesondere im Rahmen von Replikationen, die persönliche Gewähr für Ergebnisse aber dennoch vorhanden bleibt.
#'
#' Dieses Codebook ist vollautomatisch erstellt und prüft die kryptographisch sicheren SHA3-512 Signaturen (\enquote{hashes}) aller ZIP-Archive, sowie die GPG-Signatur der CSV-Datei, welche die SHA3-512 Signaturen enthält. SHA3-512 Signaturen werden durch einen system call zur OpenSSL library auf Linux-Systemen berechnet. Eine erfolgreiche Prüfung meldet \enquote{Verifiziert!}. Eine gescheiterte Prüfung meldet \enquote{FEHLER!}

#+
#'## Persönliche GPG-Signatur
#' Die während der Kompilierung des Datensatzes erstellte CSV-Datei mit den Hash-Prüfsummen ist mit meiner persönlichen GPG-Signatur versehen. Der mit dieser Version korrespondierende Public Key ist sowohl mit dem Datensatz als auch mit dem Source Code hinterlegt. Er hat folgende Kenndaten:
#' 
#' **Name:** Sean Fobbe (fobbe-data@posteo.de)
#' 
#' **Fingerabdruck:** FE6F B888 F0E5 656C 1D25  3B9A 50C4 1384 F44A 4E42

#+
#'## Import: Public Key
#+ echo = TRUE
system2("gpg2", "--import GPG-Public-Key_Fobbe-Data.asc",
        stdout = TRUE,
        stderr = TRUE)





#'\newpage
#+
#'## Prüfung: GPG-Signatur der Hash-Datei

#+ echo = TRUE

# CSV-Datei mit Hashes
print(hashfile)
# GPG-Signatur
print(signaturefile)

# GPG-Signatur prüfen
testresult <- system2("gpg2",
                      paste("--verify", signaturefile, hashfile),
                      stdout = TRUE,
                      stderr = TRUE)

# Anführungsstriche entfernen um Anzeigefehler zu vermeiden
testresult <- gsub('"', '', testresult)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable = TRUE, col.names = c("Ergebnis"))


#'\newpage
#+
#'## Prüfung: SHA3-512 Hashes der ZIP-Archive
#+ echo = TRUE

# Prüf-Funktion definieren
sha3test <- function(filename, sig){
    sig.new <- system2("openssl",
                       paste("sha3-512", filename),
                       stdout = TRUE)
    sig.new <- gsub("^.*\\= ", "", sig.new)
    if (sig == sig.new){
        return("Signatur verifiziert!")
    }else{
        return("FEHLER!")
    }
}



# Ursprüngliche Signaturen importieren
table.hashes <- fread(hashfile)
filename <- table.hashes$filename
sha3.512 <- table.hashes$sha3.512

# Signaturprüfung durchführen 
sha3.512.result <- mcmapply(sha3test, filename, sha3.512, USE.NAMES = FALSE)

# Ergebnis anzeigen
testresult <- data.table(filename, sha3.512.result)

#+ echo = TRUE
kable(testresult, format = "latex", booktabs = TRUE,
      longtable = TRUE, col.names = c("Datei", "Ergebnis"))




#+
#'# Changelog
#'
#'\ra{1.3}
#'
#' 
#'\begin{centering}
#'\begin{longtable}{p{2.5cm}p{11.5cm}}
#'\toprule
#'Version &  Details\\
#'\midrule
#'

#' \version &
#'
#' \begin{itemize}
#' \item Erstveröffentlichung
#' \end{itemize}\\
#' 
#'\bottomrule
#'\end{longtable}
#'\end{centering}





#'\newpage
#+
#'# Parameter für strenge Replikationen

system2("openssl",  "version", stdout = TRUE)

sessionInfo()






#'# Literaturverzeichnis
