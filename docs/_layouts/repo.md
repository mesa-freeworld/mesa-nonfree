[{{ site.title }}]
SigLevel = Optional TrustAll
Server = {{ page.url | prepend: site.baseurl | prepend: site.url | append: '$arch' }}
