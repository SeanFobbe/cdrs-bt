#'---
#'title: "Compilation Report | Corpus der Drucksachen des Deutschen Bundestages (CDRS-BT)"
#'author: Seán Fobbe
#'papersize: a4
#'geometry: margin=3cm
#'fontsize: 11pt
#'output:
#'  pdf_document:
#'    toc: true
#'    toc_depth: 3
#'    number_sections: true
#'    pandoc_args: --listings
#'    includes:
#'      in_header: General_Source_TEX_Preamble_DE.tex
#'      before_body: [CDRS-BT_Source_TEX_Definitions.tex,CDRS-BT_Source_TEX_CompilationTitle.tex]
#'bibliography: packages.bib
#'nocite: '@*'
#' ---


#'\newpage
#+
#'# Einleitung
#'
#+
#'## Überblick
#' Dieses R-Skript lädt die im XML-Format veröffentlichten Drucksachen des Deutschen Bundestags von dessen Open Data Portal\footnote{\url{https://www.bundestag.de/services/opendata}} herunter und verarbeitet sie in einen reichhaltigen menschen- und maschinenlesbaren Korpus. Es ist die Basis für den \textbf{\datatitle\ (\datashort )}.
#'
#' Alle mit diesem Skript erstellten Datensätze werden dauerhaft kostenlos und urheberrechtsfrei auf Zenodo, dem wissenschaftlichen Archiv des CERN, veröffentlicht. Jede Version ist mit ihrem eigenen, persistenten Digital Object Identifier (DOI) versehen. Die neueste Version des Datensatzes ist immer über diesen Link erreichbar: \dataconcepturldoi


#+
#'## Funktionsweise

#' Primäre Endprodukte des Skripts sind folgende ZIP-Archive:
#' 
#' \begin{enumerate}
#' \item Der volle Datensatz im CSV-Format
#' \item Die reinen Metadaten im CSV-Format (wie unter 1, nur ohne \enquote{text}-Variable)
#' \item Der volle Datensatz im TXT-Format (reduzierter Umfang an Metadaten)
#' \item Die Rohdaten im XML-Format
#' \item Alle Analyse-Ergebnisse (Tabellen als CSV, Grafiken als PDF und PNG)
#' \item Der Source Code und alle weiteren Quelldaten
#' \end{enumerate}
#'
#' Zusätzlich werden für alle ZIP-Archive kryptographische Signaturen (SHA2-256 und SHA3-512) berechnet und in einer CSV-Datei hinterlegt. Weiterhin kann optional ein PDF-Bericht erstellt werden (siehe unter "Kompilierung").



#+
#'## Systemanforderungen
#' Das Skript in seiner veröffentlichten Form kann nur unter Linux ausgeführt werden, da es Linux-spezifische Optimierungen (z.B. Fork Cluster) und Shell-Kommandos (z.B. OpenSSL) nutzt. Das Skript wurde unter Fedora Linux entwickelt und getestet. Die zur Kompilierung benutzte Version entnehmen Sie bitte dem **sessionInfo()**-Ausdruck am Ende dieses Berichts.
#'
#' In der Standard-Einstellung wird das Skript vollautomatisch die maximale Anzahl an Rechenkernen/Threads auf dem System nutzen. Wenn die Anzahl Threads (Variable "fullCores") auf 1 gesetzt wird, ist die Parallelisierung deaktiviert.
#'
#' Auf der Festplatte sollten 20 GB Speicherplatz vorhanden sein. Eine CPU mit 8 Kernen und 64 GB Arbeitsspeicher (RAM) sind empfohlen.
#' 
#' Um die PDF-Berichte kompilieren zu können benötigen Sie das R package **rmarkdown**, eine vollständige Installation von \LaTeX\ und alle in der Präambel-TEX-Datei angegebenen \LaTeX\ Packages.




#+
#'## Kompilierung
#' Mit der Funktion **render()** von **rmarkdown** können der **vollständige Datensatz** und das **Codebook** kompiliert und die Skripte mitsamt ihrer Rechenergebnisse in ein gut lesbares PDF-Format überführt werden.
#'
#' Alle Kommentare sind im roxygen2-Stil gehalten. Die beiden Skripte können daher auch **ohne render()** regulär als R-Skripte ausgeführt werden. Es wird in diesem Fall kein PDF-Bericht erstellt und Diagramme werden nicht abgespeichert.

#+
#'### Datensatz 
#' 
#' Um den **vollständigen Datensatz** zu kompilieren und einen PDF-Bericht zu erstellen, kopieren Sie bitte alle im Source-Archiv bereitgestellten Dateien in einen leeren Ordner und führen mit R diesen Befehl aus:

#+ eval = FALSE

rmarkdown::render(input = "CDRS-BT_Source_CorpusCreation.R",
                  output_file = paste0("CDRS-BT_",
                                       Sys.Date(),
                                       "_CompilationReport.pdf"),
                  envir = new.env())



#'### Codebook
#' Um das **Codebook** zu kompilieren und einen PDF-Bericht zu erstellen, führen Sie im Anschluss an die Kompilierung des Datensatzes (!) untenstehenden Befehl mit R aus.
#'
#' Bei der Prüfung der GPG-Signatur wird ein Fehler auftreten und im Codebook dokumentiert, weil die Daten nicht mit meiner Original-Signatur versehen sind. Dieser Fehler hat jedoch keine Auswirkungen auf die Funktionalität und hindert die Kompilierung nicht.

#+ eval = FALSE

rmarkdown::render(input = "CDRS-BT_Source_CodebookCreation.R",
                  output_file = paste0("CDRS-BT_",
                                       Sys.Date(),
                                       "_Codebook.pdf"),
                  envir = new.env())







#'\newpage
#+
#'# Parameter

#+
#'## Name des Datensatzes
datasetname <- "CDRS-BT"


#'## DOI des Datensatz-Konzeptes
doi.concept <- "10.5281/zenodo.4643065" # checked


#'## DOI der konkreten Version
doi.version <- "10.5281/zenodo.4643066" # checked


#'## Verzeichnis für Analyse-Ergebnisse
#' **Wichtiger Hinweis:** Muss mit einem Schrägstrich enden!
outputdir <- paste0(getwd(),
                    "/ANALYSE/") 



#'## Debugging-Modus
#' Der Debugging-Modus reduziert den Download-Umfang auf den in der Variable "debug.sample" definierten Umfang ausgewählter Wahlperioden. Nur für Test- und Demonstrationszwecke. 

mode.debug <- FALSE
debug.sample <- sample(18, 3)




#'## Optionen: Quanteda
tokens_locale <- "de_DE"


#'## Optionen: Knitr

#+
#'### Ausgabe-Format
dev <- c("pdf",
         "png")

#'### DPI für Raster-Grafiken
dpi <- 300

#'### Ausrichtung von Grafiken im Compilation Report
fig.align <- "center"




#'## Frequenztabellen: Ignorierte Variablen
#'
#' Diese Variablen werden bei der Erstellung der Frequenztabellen nicht berücksichtigt.
#'
#' Persönliche Urheber:innen und Körperschaftliche Urheber werden in separaten Frequenztabellen ausgewertet, denn diese müssen vor der Zählung in einzelne Werte aufgespalten werden.

varremove <- c("text",
               "doc_id",
               "datum",
               "titel",
               "nummer_original",
               "nummer_dok",
               "p_urheber",
               "k_urheber")





#'# Vorbereitung

#'## Datumsstempel
#' Dieser Datumsstempel wird in alle Dateinamen eingefügt. Er wird am Anfang des Skripts gesetzt, für den Fall, dass die Laufzeit die Datumsbarriere durchbricht.

datestamp <- Sys.Date()
print(datestamp)


#'## Datum und Uhrzeit (Beginn)

begin.script <- Sys.time()
print(begin.script)


#'## Ordner für Analyse-Ergebnisse erstellen
dir.create(outputdir)


#+
#'## Packages Laden

library(rvest)        # HTML-Extraktion
library(xml2)         # XML-Extraktion
library(doParallel)   # Parallelisierung
library(knitr)        # Professionelles Reporting
library(kableExtra)   # Verbesserte Kable Tabellen
library(ggplot2)      # Fortgeschrittene Datenvisualisierung
library(scales)       # Skalierung von Diagrammen
library(data.table)   # Fortgeschrittene Datenverarbeitung
library(quanteda)     # Fortgeschrittene Computerlinguistik




#'## Zusätzliche Funktionen einlesen
#' **Hinweis:** Die hieraus verwendeten Funktionen werden jeweils vor der ersten Benutzung in vollem Umfang angezeigt um den Lesefluss zu verbessern.

source("General_Source_Functions.R")


#'## Quanteda-Optionen setzen
quanteda_options(tokens_locale = tokens_locale)


#'## Knitr-Optionen setzen
knitr::opts_chunk$set(fig.path = outputdir,
                      dev = dev,
                      dpi = dpi,
                      fig.align = fig.align)




#'## Vollzitate statistischer Software
knitr::write_bib(c(.packages()),
                 "packages.bib")





#'## Parallelisierung aktivieren
#' Parallelisierung wird zur Beschleunigung des Parsens der XML-Strukturen und der Datenanalyse mittels **quanteda** und **data.table** verwendet. Die Anzahl Threads wird automatisch auf das verfügbare Maximum des Systems gesetzt, kann aber auch nach Belieben angepasst werden. Die Parallelisierung kann deaktiviert werden, indem die Variable \enquote{fullCores} auf 1 gesetzt wird.
#'
#' Der Download der Dateien ist bewusst nicht parallelisiert, damit das Skript nicht versehentlich als DoS-Tool verwendet wird.
#'
#' Die hier verwendete Funktion **makeForkCluster()** ist viel schneller als die Alternativen, funktioniert aber nur auf Unix-basierten Systemen (Linux, MacOS).

#+
#'### Logische Kerne

fullCores <- detectCores()
print(fullCores)

#'### Quanteda
quanteda_options(threads = fullCores) 

#+
#'### Data.table
setDTthreads(threads = fullCores)  







#+
#'# Download

#+
#'## Links zu den Datenquellen einlesen

links <- fread("CDRS-BT_Source_DatenquelleLinks.csv")$links



#'## Nur Debugging-Modus --- Reduzierung des Download-Umfangs

if (mode.debug == TRUE){
    links <- links[debug.sample]
    }




#'## Zeitstempel (Download Beginn)

begin.download <- Sys.time()
print(begin.download)



#'## Download durchführen

mapply(download.file,
       links,
       basename(links))



#'## Zeitstempel (Download Ende)

end.download <- Sys.time()
print(end.download)



#'## Dauer (Download) 
end.download - begin.download



#'## Download-Ergebnis

#+
#'### Anzahl herunterzuladender Dateien
length(links)

#'### Anzahl heruntergeladener Dateien
files.zip <- list.files(pattern = "\\.zip")
length(files.zip)

#'### Fehlbetrag
N.missing <- length(links) - length(files.zip)
print(N.missing)

#'### Fehlende Dateien
missing <- setdiff(basename(links),
                   files.zip)
print(missing)





#'# Originale ZIP-Archive verarbeiten

#+
#'## Vektor der originalen ZIP-Archive erstellen

files.zip <- list.files(pattern = "\\.zip")


#'## Entpacken

result <- lapply(files.zip,
                 unzip)


#'## Originale ZIP-Archive löschen
unlink(files.zip)



#'## Document Type Definition umbenennen

file.rename("BUNDESTAGSDOKUMENTE.dtd",
            paste(datasetname,
                  datestamp,
                  "DE_XML_DocumentTypeDefinition.dtd",
                  sep = "_"))







#'# XML-Dateien verarbeiten

#+
#'## Vektor der XML-Dateien erstellen
files.xml <- list.files(pattern = "\\.xml")


#'## Anzahl XML-Dateien
N.xml <- length(files.xml)
print(N.xml)

#'## Zeitstempel (XML Parse Beginn)

begin.parse <- Sys.time()
print(begin.parse)


#'## Fork Cluster starten

cl <- makeForkCluster(fullCores)
registerDoParallel(cl)


#'## XML Parsen

list.out <- foreach(i = seq_along(files.xml),
                    .errorhandling = 'pass') %dopar% {
                        
                        ## Dateinamen speichern
                        doc_id <- files.xml[i]


                        ## XML einlesen
                        XML <- tryCatch({
                            read_xml(doc_id)},
                            error = function(cond) {
                                return(NA)}
                            )

                        if (is.na(XML) != TRUE){
                            
                            ## Metadaten extrahieren
                            wahlperiode <- xml_nodes(XML,
                                                     xpath = "//WAHLPERIODE") %>%
                                xml_text()
                            
                            dokumentart <- xml_nodes(XML,
                                                     xpath = "//DOKUMENTART") %>%
                                xml_text()
                            
                            nummer_original <- xml_nodes(XML,
                                                         xpath = "//NR") %>%
                                xml_text()

                            drs_typ <- xml_nodes(XML,
                                                 xpath = "//DRS_TYP") %>%
                                xml_text()

                            k_urheber <- xml_nodes(XML,
                                                   xpath = "//K_URHEBER") %>%
                                xml_text()

                            k_urheber  <- paste(k_urheber, collapse = "|")

                            p_urheber <- xml_nodes(XML,
                                                   xpath = "//P_URHEBER") %>%
                                xml_text()

                            p_urheber <- paste(p_urheber, collapse = "|")
                            
                            datum <- xml_nodes(XML,
                                               xpath = "//DATUM") %>%
                                xml_text()
                            
                            titel <- xml_nodes(XML,
                                               xpath = "//TITEL") %>%
                                xml_text()
                            
                            text <- xml_nodes(XML,
                                              xpath = "//TEXT") %>%
                                xml_text()
                            
                            dt.temp <- data.table(doc_id,
                                                  wahlperiode,
                                                  dokumentart,
                                                  nummer_original,
                                                  drs_typ,
                                                  k_urheber,
                                                  p_urheber,
                                                  datum,
                                                  titel,
                                                  text)
                            
                            return(dt.temp)
                            
                        }else{
                            return(NA)
                        }

                        
                    }


#'## Fork Cluster anhalten
stopCluster(cl)


#'## Zeitstempel (XML Parse Ende)

end.parse <- Sys.time()
print(end.parse)



#'## Dauer (XML Parse)
end.parse - begin.parse


#'## Fehlerhafte XML-Dokumente anzeigen
files.xml[is.na(list.out)]


#'## Fehlerhafte XML-Dokumente von weiterer Analyse ausschließen

index.corrupted  <- which(is.na(list.out))

if (length(index.corrupted) > 0){
    list.out <- list.out[-index.corrupted]
}



#'## Liste zu Data Table konvertieren
txt.drs <- rbindlist(list.out)


#'## XML Parse Ergebnis

#+
#'### Zu parsende XML-Dateien
print(N.xml)

#'### Geparste XML-Dateien 
txt.drs[,.N]


#'### Fehlbetrag
N.xml - txt.drs[,.N]




#'## Datum formatieren

txt.drs[, datum := lapply(.SD,
                          function(x){as.IDate(x,
                                               format = "%d.%m.%Y")}),
         .SDcols = "datum"]




#'## Wahlperiode als numerische Variable definieren
txt.drs$wahlperiode <- as.numeric(txt.drs$wahlperiode)





#'## Variable "k_urheber" normalisieren

txt.drs$k_urheber <- gsub("BÜNDNIS 90/DIE GRÜNEN",
                          "Bündnis 90/Die Grünen",
                          txt.drs$k_urheber)

txt.drs$k_urheber <- gsub("^$",
                          "NA",
                          txt.drs$k_urheber)




#'## Variable "p_urheber" normalisieren

txt.drs$p_urheber <- gsub("^$",
                          "NA",
                          txt.drs$p_urheber)




#'# Variablen hinzufügen

#+
#'## Variable "jahr" hinzufügen
txt.drs$jahr <- year(txt.drs$datum)


#'## Variable "nummer_zusatz" hinzufügen

txt.drs$nummer_zusatz <- rep("NA",
                             txt.drs[,.N])

txt.drs[grep("zu",
             txt.drs$nummer_original)]$nummer_zusatz <- "ZUSATZ"



#'## Variable "nummer_dok" hinzufügen

txt.drs$nummer_dok <- gsub("[0-9]*/([0-9]*)",
                          "\\1",
                          txt.drs$nummer_original)

txt.drs$nummer_dok <- gsub("zu",
                           "",
                           txt.drs$nummer_dok)


txt.drs$nummer_dok <- as.numeric(txt.drs$nummer_dok)




#'## Variable "doi_concept" hinzufügen

txt.drs$doi_concept <- rep(doi.concept,
                              txt.drs[,.N])


#'## Variable "doi_version" hinzufügen

txt.drs$doi_version <- rep(doi.version,
                              txt.drs[,.N])


#'## Variable "version" hinzufügen

txt.drs$version <- as.character(rep(datestamp,
                                       txt.drs[,.N]))









#'# Frequenztabellen erstellen

#+
#'## Funktion anzeigen

#+ results = "asis"
print(f.fast.freqtable)


#'## Ignorierte Variablen
print(varremove)



#'## Liste zu prüfender Variablen

varlist <- names(txt.drs)

varlist <- setdiff(varlist,
                   varremove)

print(varlist)



#'## Frequenztabellen erstellen

prefix <- paste0(datasetname,
                 "_01_Frequenztabelle_var-")


#+ results = "asis"
f.fast.freqtable(txt.drs,
                 varlist = varlist,
                 sumrow = TRUE,
                 output.list = FALSE,
                 output.kable = TRUE,
                 output.csv = TRUE,
                 outputdir = outputdir,
                 prefix = prefix,
                 align = c("p{6cm}",
                           rep("r", 4)))








#'\newpage
#'## Körperschaftliche Urheber

k_urheber <- txt.drs[k_urheber != "NA"]$k_urheber

k_urheber <- paste(k_urheber, collapse = "|")

k_urheber <- tstrsplit(k_urheber, split = "\\|")

k_urheber <- unlist(k_urheber)
k_urheber <- as.data.table(k_urheber)

prefix <- paste0(datasetname,
                 "_01_Frequenztabelle_var-")

#+ results = "asis"
f.fast.freqtable(k_urheber,
                 sumrow = TRUE,
                 output.list = FALSE,
                 output.kable = TRUE,
                 output.csv = TRUE,
                 outputdir = outputdir,
                 prefix = prefix,
                 align = c("p{6cm}",
                           rep("r", 4)))





#'\newpage
#'## Persönliche Urheber:innen


p_urheber <- txt.drs[p_urheber != "NA"]$p_urheber

p_urheber <- paste(p_urheber, collapse = "|")

p_urheber <- tstrsplit(p_urheber, split = "\\|")

p_urheber <- unlist(p_urheber)
p_urheber <- as.data.table(p_urheber)



prefix <- paste0(datasetname,
                 "_01_Frequenztabelle_var-")

#+ results = "asis"
f.fast.freqtable(p_urheber,
                 sumrow = TRUE,
                 output.list = FALSE,
                 output.kable = TRUE,
                 output.csv = TRUE,
                 outputdir = outputdir,
                 prefix = prefix,
                 align = c("p{6cm}",
                           rep("r", 4)))









#'# Frequenztabellen visualisieren


#+
#'## Präfix erstellen
prefix <- paste0("ANALYSE/",
                 datasetname,
                 "_")


#'## Frequenztabellen einlesen
table.wahlperiode <- fread(paste0(prefix,
                                  "01_Frequenztabelle_var-wahlperiode.csv"))

table.jahr  <- fread(paste0(prefix,
                            "01_Frequenztabelle_var-jahr.csv"))

table.typ  <- fread(paste0(prefix,
                            "01_Frequenztabelle_var-drs_typ.csv"))

table.p.urheber  <- fread(paste0(prefix,
                            "01_Frequenztabelle_var-p_urheber.csv"))

table.k.urheber  <- fread(paste0(prefix,
                            "01_Frequenztabelle_var-k_urheber.csv"))


#'\newpage
#'## Wahlperiode
    
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


#'\newpage
#'## Jahr

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


#'\newpage
#'## Typ der Drucksachen

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


#'\newpage
#'## Persönliche Urheber:innen

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


#'\newpage
#'## Körperschaftliche Urheber

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





#'# Korpus-Analytik


#+
#'## Berechnung linguistischer Kennwerte
#' An dieser Stelle werden für jedes Dokument die Anzahl Zeichen, Tokens, Typen und Sätze berechnet und mit den jeweiligen Metadaten verknüpft. Das Ergebnis ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Drucksachen.


#+
#'### Funktion anzeigen

#+ results = "asis"
print(f.summarize.iterator)





#'### Berechnung durchführen
summary.corpus <- f.summarize.iterator(txt.drs,
                                       threads = fullCores,
                                       chunksize = 1)






#'\newpage
#'### Variablen-Namen anpassen

setnames(summary.corpus,
         old = c("nchars",
                 "ntokens",
                 "ntypes",
                 "nsentences"),
         new = c("zeichen",
                 "tokens",
                 "typen",
                 "saetze"))

setnames(txt.drs,
         old = "nchars",
         new = "zeichen")







#'## Kennwerte dem Korpus hinzufügen

txt.drs$tokens <- summary.corpus$tokens
txt.drs$typen <- summary.corpus$typen
txt.drs$saetze <- summary.corpus$saetze







#'## Anzahl Variablen im Korpus
length(txt.drs)


#'## Namen aller Variablen im Korpus
names(txt.drs)





#'\newpage
#'## Linguistische Kennwerte
#' **Hinweis:** Typen sind definiert als einzigartige Tokens und werden für jedes Dokument gesondert berechnet. Daher ergibt es an dieser Stelle auch keinen Sinn die Typen zu summieren, denn bezogen auf den Korpus wäre der Kennwert ein anderer. Der Wert wird daher manuell auf "NA" gesetzt.

#+
#'### Zusammenfassungen berechnen

dt.summary.ling <- summary.corpus[,
                                  lapply(.SD,
                                           function(x)unclass(summary(x))),
                                  .SDcols = c("zeichen",
                                              "tokens",
                                              "saetze",
                                              "typen")]

dt.sums.ling <- summary.corpus[,
                               lapply(.SD, sum),
                               .SDcols = c("zeichen",
                                           "tokens",
                                           "saetze",
                                           "typen")]

dt.sums.ling$typen <- NA



dt.stats.ling <- rbind(dt.sums.ling,
                       dt.summary.ling)

dt.stats.ling <- transpose(dt.stats.ling,
                           keep.names = "names")


setnames(dt.stats.ling, c("Variable",
                          "Sum",
                          "Min",
                          "Quart1",
                          "Median",
                          "Mean",
                          "Quart3",
                          "Max"))


#'\newpage
#'### Zusammenfassungen anzeigen

kable(dt.stats.ling,
      format.args = list(big.mark = ","),
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)




#'### Zusammenfassungen speichern

fwrite(dt.stats.ling,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungLinguistisch.csv"),
       na = "NA")






#'\newpage
#'## Quantitative Variablen


#+
#'### Datum

summary.corpus$datum <- as.IDate(summary.corpus$datum)

summary(summary.corpus$datum)





#'### Zusammenfassungen berechnen

dt.summary.docvars <- summary.corpus[,
                                     lapply(.SD,
                                            function(x)unclass(summary(na.omit(x)))),
                                     .SDcols = c("wahlperiode",
                                                 "jahr",
                                                 "nummer_dok")]



dt.unique.docvars <- summary.corpus[,
                                    lapply(.SD,
                                             function(x)length(unique(na.omit(x)))),
                                    .SDcols = c("wahlperiode",
                                                "jahr",
                                                "nummer_dok")]


dt.stats.docvars <- rbind(dt.unique.docvars,
                          dt.summary.docvars)



dt.stats.docvars <- transpose(dt.stats.docvars,
                              keep.names = "names")


setnames(dt.stats.docvars, c("Variable",
                             "Unique",
                             "Min",
                             "Quart1",
                             "Median",
                             "Mean",
                             "Quart3",
                             "Max"))



#'\newpage
#'### Zusammenfassungen anzeigen

kable(dt.stats.docvars,
      format = "latex",
      booktabs = TRUE,
      longtable = TRUE)


#'### Zusammenfassungen speichern

fwrite(dt.stats.docvars,
       paste0(outputdir,
              datasetname,
              "_00_KorpusStatistik_ZusammenfassungDocvarsQuantitativ.csv"),
       na = "NA")






#'\newpage
#'## Density



#+
#'### Density Zeichen

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






#'\newpage
#'### Density Tokens

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



#'\newpage
#'### Density Typen

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




#'\newpage
#'### Density Sätze

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





#'# Beispiel-Werte für alle Variablen anzeigen
str(txt.drs)






#'# CSV-Dateien erstellen

#'## CSV mit vollem Datensatz speichern

csvname.full <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Datensatz.csv",
                      sep = "_")

fwrite(txt.drs,
       csvname.full,
       na = "NA")




#'## CSV mit Metadaten speichern
#' Diese Datei ist grundsätzlich identisch mit dem eigentlichen Datensatz, nur ohne den Text der Drucksachen.

csvname.meta <- paste(datasetname,
                      datestamp,
                      "DE_CSV_Metadaten.csv",
                      sep = "_")

fwrite(summary.corpus,
       csvname.meta,
       na = "NA")






#'# TXT-Dateien erstellen

#+
#'## Dateinamen erstellen

names.txt <-   paste0(datasetname,
                     "_",
                     "Bundestag_Drucksache",
                     "_",
                     txt.drs$wahlperiode,
                     "_",
                     txt.drs$nummer_dok,
                     "_",
                     txt.drs$datum,
                     "_",
                     gsub("\\.xml",
                          "",
                          txt.drs$doc_id),
                     ".txt")

names.txt <- gsub("/",
                 "-",
                 names.txt)


#'## Fork Cluster starten

cl <- makeForkCluster(fullCores)
registerDoParallel(cl)

#'## TXT-Dateien speichern

out <- foreach(i = seq_len(txt.drs[,.N]),
               .errorhandling = 'pass') %dopar% {
                   write.table(txt.drs$text[i],
                               names.txt[i],
                               row.names = FALSE,
                               col.names = FALSE)
               }


#'## Fork Cluster anhalten
stopCluster(cl)





#'# Dateigrößen analysieren

#+
#'## Gesamtgröße

#+
#'### Korpus-Objekt in RAM (MB)

print(object.size(corpus(txt.drs)),
      standard = "SI",
      humanReadable = TRUE,
      units = "MB")


#'### CSV --- Voller Datensatz (MB)
file.size(csvname.full) / 10^6


#'### CSV --- Nur Metadaten (MB)
file.size(csvname.meta) / 10^6


#'### XML-Dateien (Anzahl)

files.xml <- list.files(pattern = "\\.xml$",
                        ignore.case = TRUE)

length(files.xml)


#'### XML-Dateien (MB)

xml.MB <- file.size(files.xml) / 10^6
sum(xml.MB)


#'### TXT-Dateien (Anzahl)

files.txt <- list.files(pattern = "\\.txt$",
                        ignore.case = TRUE)

length(files.txt)



#'### TXT-Dateien (MB)

txt.MB <- file.size(files.txt) / 10^6
sum(txt.MB)






#'\newpage
#'## Verteilung der Dateigrößen (XML)

#+ CDRS-BT_11_DensityChart_Dateigroessen_XML, fig.height = 6, fig.width = 9
ggplot(data = data.table(xml.MB),
       aes(x = xml.MB)) +
    geom_density(fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (XML)"),
        caption = paste("DOI:",
                        doi.version),
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )



#'\newpage
#'## Verteilung der Dateigrößen (TXT)


#+ CDRS-BT_12_DensityChart_Dateigroessen_TXT, fig.height = 6, fig.width = 9
ggplot(data = data.table(txt.MB),
       aes(x = txt.MB)) +
    geom_density(fill = "black") +
    scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                  labels = trans_format("log10", math_format(10^.x)))+
    annotation_logticks(sides = "b")+
    theme_bw() +
    labs(
        title = paste(datasetname,
                      "| Version",
                      datestamp,
                      "| Verteilung der Dateigrößen (TXT)"),
        caption = paste("DOI:",
                        doi.version),
        x = "Dateigröße in MB",
        y = "Dichte"
    )+
    theme(
        text = element_text(size = 14),
        plot.title = element_text(size = 14,
                                  face = "bold"),
        legend.position = "none",
        plot.margin = margin(10, 20, 10, 10)
    )






#'# Erstellen der ZIP-Archive



#'## Verpacken der CSV-Dateien

#+ results = 'hide'
csvname.full.zip <- gsub(".csv",
                    ".zip",
                    csvname.full)

zip(csvname.full.zip,
    csvname.full)

unlink(csvname.full)


#+ results = 'hide'
csvname.meta.zip <- gsub(".csv",
                    ".zip",
                    csvname.meta)

zip(csvname.meta.zip,
    csvname.meta)


unlink(csvname.meta)






#+
#'## Verpacken der XML-Dateien

#+ results = 'hide'
files.xml <- list.files(pattern = "\\.xml",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_XML_Datensatz.zip",
          sep = "_"),
    files.xml)

unlink(files.xml)




#'## Verpacken der TXT-Dateien


#+ results = 'hide'
files.txt <- list.files(pattern = "\\.txt",
                        ignore.case = TRUE)

zip(paste(datasetname,
          datestamp,
          "DE_TXT_Datensatz.zip",
          sep = "_"),
    files.txt)

unlink(files.txt)




#'## Verpacken der Analyse-Dateien

zip(paste0(datasetname,
           "_",
           datestamp,
           "_DE_",
           basename(outputdir),
           ".zip"),
    basename(outputdir))





#'## Verpacken der Source-Dateien

files.source <- c(list.files(pattern = "Source"),
                  "buttons")


files.source <- grep("spin",
                     files.source,
                     value = TRUE,
                     ignore.case = TRUE,
                     invert = TRUE)

zip(paste(datasetname,
           datestamp,
           "Source_Files.zip",
           sep = "_"),
    files.source)






#'# Kryptographische Hashes
#' Dieses Modul berechnet für jedes ZIP-Archiv zwei Arten von Hashes: SHA2-256 und SHA3-512. Mit diesen kann die Authentizität der Dateien geprüft werden und es wird dokumentiert, dass sie aus diesem Source Code hervorgegangen sind. Die SHA-2 und SHA-3 Algorithmen sind äußerst resistent gegenüber *collision* und *pre-imaging* Angriffen, sie gelten derzeit als kryptographisch sicher. Ein SHA3-Hash mit 512 bit Länge ist nach Stand von Wissenschaft und Technik auch gegenüber quantenkryptoanalytischen Verfahren unter Einsatz des *Grover-Algorithmus* hinreichend resistent.

#+
#'## Liste der ZIP-Archive erstellen
files.zip <- list.files(pattern = "\\.zip$",
                        ignore.case = TRUE)


#'## Funktion anzeigen
#+ results = "asis"
print(f.dopar.multihashes)

#'## Hashes berechnen
multihashes <- f.dopar.multihashes(files.zip)


#'## In Data Table umwandeln
setDT(multihashes)



#'## Index hinzufügen
multihashes$index <- seq_len(multihashes[,.N])


#'\newpage
#'## In Datei schreiben
fwrite(multihashes,
       paste(datasetname,
             datestamp,
             "KryptographischeHashes.csv",
             sep = "_"),
       na = "NA")


#'## Leerzeichen hinzufügen
#' Hierbei handelt es sich lediglich um eine optische Notwendigkeit. Die normale 128 Zeichen lange Zeichenfolge wird ansonsten nicht umgebrochen und verschwindet über die Seitengrenze. Das Leerzeichen erlaubt den automatischen Zeilenumbruch und damit einen für Menschen sinnvoll lesbaren Abdruck im Codebook. Diese Variante wird nur zur Anzeige verwendet und danach verworfen.

multihashes$sha3.512 <- paste(substr(multihashes$sha3.512, 1, 64),
                              substr(multihashes$sha3.512, 65, 128))



#'## In Bericht anzeigen

kable(multihashes[,.(index,filename)],
      format = "latex",
      align = c("p{1cm}",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)


#'\newpage

kable(multihashes[,.(index,sha2.256)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)




kable(multihashes[,.(index,sha3.512)],
      format = "latex",
      align = c("c",
                "p{13cm}"),
      booktabs = TRUE,
      longtable = TRUE)






#'# Abschluss


#+
#'## Datumsstempel
print(datestamp)


#'## Datum und Uhrzeit (Anfang)
print(begin.script)


#'## Datum und Uhrzeit (Ende)
end.script <- Sys.time()
print(end.script)

#'## Laufzeit des gesamten Skripts
print(end.script - begin.script)


#'## Warnungen
warnings()



#'# Parameter für strenge Replikationen

system2("openssl",  "version", stdout = TRUE)

sessionInfo()


#'# Literaturverzeichnis

