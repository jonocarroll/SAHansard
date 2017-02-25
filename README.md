
SA Hansard
==========

![](http://www.parliament.sa.gov.au/_layouts/PII3.InternetStyles/LACQUER/hdrCrest.jpg)

[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/SAHansard)](https://cran.r-project.org/package=SAHansard)

Wraps the SA Hansard API (<http://parliament-api-docs.readthedocs.io/en/latest/south-australia/>).

<!-- README.md is generated from README.Rmd. Please edit that file -->
Examples
--------

Obtain all SA Hansard records for a given year

``` r
hansard_year(year = "2017")
#> <Hansard 2017>
#>         date             chamber         PdfDocId         TocDocId
#> 1 2017-02-16 Legislative Council HANSARD-10-20106 HANSARD-10-20107
#> 2 2017-02-16   House of Assembly HANSARD-11-25481 HANSARD-11-25482
#> 3 2017-02-15   House of Assembly HANSARD-11-25420 HANSARD-11-25421
#> 4 2017-02-15 Legislative Council HANSARD-10-20049 HANSARD-10-20050
#> 5 2017-02-14 Legislative Council HANSARD-10-19979 HANSARD-10-19980
#> 6 2017-02-14   House of Assembly HANSARD-11-25353 HANSARD-11-25354
#>   Uncorrected
#> 1       FALSE
#> 2       FALSE
#> 3       FALSE
#> 4       FALSE
#> 5       FALSE
#> 6       FALSE
```

From these, a given Table of Contents can be obtained

``` r
glimpse(hansard_toc(docid = 'HANSARD-10-19980'))
#> <Hansard HANSARD-10-19980>
#> Observations: 72
#> Variables: 8
#> $ pdfid   <chr> "HANSARD-10-19979", "HANSARD-10-19979", "HANSARD-10-19...
#> $ date    <chr> "2017-02-14", "2017-02-14", "2017-02-14", "2017-02-14"...
#> $ chamber <chr> "Legislative Council", "Legislative Council", "Legisla...
#> $ name    <chr> "Parliamentary Committees", "Ministerial Statement", "...
#> $ name.1  <chr> "Crime and Public Integrity Policy Committee", "Crysta...
#> $ docid   <chr> "HANSARD-10-19939", "HANSARD-10-19940", "HANSARD-10-19...
#> $ name.2  <chr> "The Hon. D.G.E. HOOD", "The Hon. P. MALINAUSKAS", "Th...
#> $ id      <chr> "3126", "5084", "1820", "3122", "1820", "3122", "2742"...
```

From these, a HTML fragment can be obtained

``` r
hansard_fragment(pdfid = 'HANSARD-10-19961')$content
```

\[1\] "&lt;fragment.text&gt;
<body>
<p class="\&quot;SubDebate-H\&quot;" style="\&quot;
" text-align:\" xmlns="\&quot;http://www.w3.org/1999/xhtml\&quot;">
<span>South Road Tram Overpass</span>
</p>
<a name=\"member\" data-mode=\"member\" data-value=\"5084\" xmlns=\"http://www.w3.org/1999/xhtml\" data-type=\"article\" data-article=\"speech\" data-talktime=\"2017-02-14T16:19:45\" />
<p class="\&quot;Normal-P\&quot;" style="\&quot;direction:ltr;unicode-bidi:normal;\&quot;" xmlns="\&quot;http://www.w3.org/1999/xhtml\&quot;">
<span class=\"Normal-H\"><span style="\&quot;
" margin-left:26pt&#xa;="" \"=""><span class="\"MemberSpeech-H\"">The Hon. P. MALINAUSKAS</span><span class="\"MinisterialTitles-H\""> (Minister for Police, Minister for Correctional Services, Minister for Emergency Services, Minister for Road Safety)</span><span class="\"GeneralBold-H\""> (</span><span class="\"Time-H\"">16:19</span><span class="\"HiddenTime-H\"">:45</span><span class="\"GeneralBold-H\"">):</span> I table a copy of a ministerial statement relating to the tram overpass made earlier today in another place by my colleague the Minister for Transport and Infrastructure.</span>
</p>
</body>
&lt;/fragment.text&gt;"
