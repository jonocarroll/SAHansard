# library(httr)
# library(jsonlite)
# library(tidyjson)
# library(dplyr)

#' Obtain the year's Hansard records
#'
#' @param year year for which the records should be obtained
#'
#' @return full response (invisibly)
#' @export
#'
#' @import dplyr
#' @import httr
#' @import tidyjson
#'
#' @examples
#' hansard_year(year = "2017")
hansard_year <- function(year) {
    # https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetYearlyEvents/2016
    url <- build_url(parse_url(paste0("https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetYearlyEvents/", year)))
    resp <- GET(url)

    if (http_type(resp) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    jsonDF <- content(resp) %>%
        gather_array() %>%
        spread_values(date = jstring("date")) %>%
        enter_object("Events") %>% gather_array() %>%
        spread_values(chamber = jstring("Chamber"),
                      PdfDocId = jstring("PdfDocId"),
                      TocDocId = jstring("TocDocId"),
                      Uncorrected = jstring("Uncorrected")) %>%
        select_(quote(-document.id), quote(-array.index))

    structure(
        list(
            content = jsonDF,
            year = year,
            response = resp
        ),
        class = "hansard_year"
    )

}

#' @export
print.hansard_year <- function(x, ...) {
    cat("<Hansard ", x$year, ">\n", sep = "")
    print(x$content)
    invisible(x)
}


## get TOC

#' Obtain a Hansard Table of Contents
#'
#' @param docid Document ID
#'
#' @return full response (invisibly)
#' @export
#'
#' @import httr
#' @import tidyjson
#' @import dplyr
#'
#' @examples
#' hansard_toc(docid = 'HANSARD-10-19980')
hansard_toc <- function(docid) {
    # curl "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetByDate" -H "Content-Type: application/json; charset=UTF-8" -H "Accept: */*" --data-binary "{""DocumentId"" : ""HANSARD-11-22597""}"
    url <- build_url(parse_url("https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetByDate"))
    bodytxt <- paste0('{"DocumentId" : "', docid, '"}')
    resp <- POST(url, accept("*/*"), content_type_json(), body = bodytxt)

    if (http_type(resp) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    jsonDF <- content(resp) %>%
        gather_array() %>%
        spread_values(pdfid = jstring("pdfid"),
                      type = jstring("type"),
                      expanded = jstring("expanded"),
                      date = jstring("date"),
                      chamber = jstring("chamber")) %>%
        enter_object("item") %>% gather_array() %>%
        spread_values(name = jstring("name"),
                      type = jstring("type"),
                      expanded = jstring("expanded")) %>%
        enter_object("item") %>% gather_array() %>%
        spread_values(name = jstring("name"),
                      type = jstring("type"),
                      docid = jstring("docid"),
                      expanded = jstring("expanded")) %>%
        enter_object("item") %>% gather_array() %>%
        spread_values(xref = jstring("xref"),
                      name = jstring("name"),
                      type = jstring("type"),
                      id = jstring("id")) %>%
        select_(quote(-document.id), quote(-array.index),
               -starts_with("type"), -starts_with("expanded"), -starts_with("xref"))

    structure(
        list(
            content = jsonDF,
            docid = docid,
            response = resp
        ),
        class = "hansard_toc"
    )

}

#' @export
print.hansard_toc <- function(x, ...) {
    cat("<Hansard ", x$docid, ">\n", sep = "")
    print(x$content)
    invisible(x)
}

#' @export
glimpse.hansard_toc <- function(x, width = NULL, ...) {
    cat("<Hansard ", x$docid, ">\n", sep = "")
    glimpse(x$content)
    invisible(x)
}

# get FRAGMENT

#' Obtain a HTML fragment of a Hansard record
#'
#' @param pdfid Document ID
#'
#' @import httr
#' @import dplyr
#' @importFrom jsonlite fromJSON
#'
#' @return full response (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' hansard_fragment(pdfid = 'HANSARD-10-19961')
#' }
hansard_fragment <- function(pdfid) {
    # curl "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetFragmentHtml" -H "Content-Type: application/json; charset=UTF-8" -H "Accept: application/json, text/javascript, */*; q=0.01" -H "X-Requested-With: XMLHttpRequest" --data-binary "{""DocumentId"" : ""HANSARD-11-22542""}"
    url <- build_url(parse_url("https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetFragmentHtml"))
    bodytxt <- paste0('{"DocumentId" : "', pdfid, '"}')
    resp <- POST(url, accept("application/json, text/javascript, */*; q=0.01"), add_headers(.headers = c(`X-Requested-With` = "XMLHttpRequest")), content_type_json(), body = bodytxt)

    if (http_type(resp) != "application/json") {
        stop("API did not return json", call. = FALSE)
    }

    htmldat <- fromJSON(content(resp))$DocumentHtml

    structure(
        list(
            content = htmldat,
            pdfid = pdfid,
            response = resp
        ),
        class = "hansard_fragment"
    )

}

#' @importFrom rstudioapi viewer
#' @export
#'
print.hansard_fragment <- function(x, ...) {
    cat("Loading <Hansard ", x$pdfid, "> in Viewer\n", sep = "")
    tf <- tempfile(fileext = ".html")
    write(x$content, tf)
    header = paste(readLines("inst/header.txt"), "\n")
    cat(header, sub("</fragment.text>", "",
                    sub("<fragment.text>\r\n  <body>\r\n    ", "", x$content)
                    ), "</html>", file = tf)
    rstudioapi::viewer(tf)
    invisible(x)
}

### CSS

# <!DOCTYPE html >
# <html dir="ltr" lang="en-AU">
# <head id="ctl00_Head1"><meta http-equiv="X-UA-Compatible" content="IE=10" /><meta name="GENERATOR" content="Microsoft SharePoint" /><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><meta http-equiv="Expires" content="0" />
#     <title>Hansard From API</title>
#
# <link id="CSSRegistration2" rel="stylesheet" type="text/css" href="https://hansardpublic.parliament.sa.gov.au/Style%20Library/kendo.common.min.css"/>
# <link id="CSSRegistration3" rel="stylesheet" type="text/css" href="https://hansardpublic.parliament.sa.gov.au/Style%20Library/kendo.parliament.min.css"/>
# <link id="CSSRegistration4" rel="stylesheet" type="text/css" href="https://hansardpublic.parliament.sa.gov.au/Style%20Library/hansard.search.css"/>
# <link id="CSSRegistration5" rel="stylesheet" type="text/css" href="https://hansardpublic.parliament.sa.gov.au/Style%20Library/hansard.publish.css"/>
# <link id="CssRegistration1" rel="stylesheet" type="text/css" href="https://hansardpublic.parliament.sa.gov.au/_layouts/15/1033/styles/Themable/corev15.css?rev=DHzjGJKbtAsTIA4uW3YOqA%3D%3D"/>
# </head>
#
# <body>
