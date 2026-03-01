osm-fhrs-filtering
==================

This source code repository will contain a prototype attempt to generate a
dataset of identifiers for likely-closed food establishments in the United
Kingdom.

The code here is licensed under the GNU Affero GPL license, version three or
greater.

Data sources
------------

The [Food Standards Agency](https://ratings.food.gov.uk) is the source provider
of Food Hygiene Ratings in the United Kingdom.  It makes that information
available to the public as [Open Data](https://ratings.food.gov.uk/open-data),
under the terms of the [Open Government License](https://www.food.gov.uk/our-data#open-government-licence).

[OpenStreetMap](https://www.openstreetmap.org) is a community-edited map,
[copyright licensed](https://www.openstreetmap.org/copyright) under version one
of the [Open Database License](https://opendatacommons.org/licenses/odbl/), and
attributed to the [OpenStreetMap Foundation](https://osmfoundation.org).

Many mappers in the United Kingdom use the [FHODOT](https://github.com/gregrs-uk/fhodot)
web-based utility, that re-uses that data and attempts to match the businesses
within it to locations in the OpenStreetMap dataset.

[Geofabrik GmbH](https://www.geofabrik.de) in Germany makes subsets
('extracts') of the OpenStreetMap global map ('planet') available -- some of
these extracts are available to the general public, and some of them that
contain additional metadata (including personally-identifiable information)
are only available for internal use and to authenticated users.

Objectives
----------

The code in this repository will attempt to create a derived work of
OpenStreetMap, under the same Open Database License terms, from the public
(non-authenticated, absent PII) datasets of the United Kingdom map area
made available by Geofabrik.

The derived work will contain FHRS identifiers that are believed to be likely
to be of closed food businesses - in other words, food businesses that have
ceased operating.

The purpose of this is to allow those closed businesses to be suitably
highlighted or filtered from display in applications such as FHODOT, so that
mappers can focus on finding and updating active businesses that do provide
food services.

FHRS identifiers are only one narrow aspect of OpenStreetMap editing in the
United Kingdom, and so the overall objective is to make it easier to keep
those identifiers up-to-date, freeing up more time for other mapping activities
and allowing the community to scale.

Prior work / see also
---------------------

 - https://wiki.openstreetmap.org/wiki/UK_Food_Hygiene_Rating_Scheme
 - https://github.com/gregrs-uk/fhodot
 - https://github.com/gregrs-uk/python-fhrs-osm
 - https://osm.mathmos.net/survey
