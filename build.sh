#!/bin/sh

# osm-fhrs-filtering scripts
# Copyright (C) 2026 James Addison

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# TODO
#  - pre-filter PBF files into PBF files containing only required items?
#    - all files: places with fhrs:id
#               $ osmium tags-filter -o scotland-260212.fhrs.osm.pbf scotland-260212.osm.pbf 'n/fhrs:id'
#    - all-except-first-file: disused places (mainly amenity:disused)
#               $ osmium tags-filter -o scotland-260212.fhrs.osm.pbf scotland-260212.osm.pbf 'n/fhrs:id' 'n/*disused*'
#    - rationale: a smaller dataset may be significantly quicker to (re)load
#                 and to develop with
#
#  - load each PBF file into postgresql
#    - multiple databases, or a single database with temporal versioning?
#               $ osm2pgsql --hstore --prefix planet_osm_20260212 --extra-attributes scotland-260212.fhrs.osm.pbf
#
#  - query across the multi-PBF datasets using SQL to extract likely-unused IDs
#
#    - nodes: simple OSM-id-to-OSM-id INNER JOIN
#      - suggestion: inspect LEFT JOIN results at a later date (deleted places)
#
#    - areas: ??
#      - maybe join by way ID -- or perhaps check for shared nodes in common?
#      - suggestion: leave area-matching for a later date

psql -c "WITH dataset_20260212 (osm_id, revision, name, fhrs_id) AS (SELECT osm_id, tags->'osm_version', name, tags->'fhrs:id' FROM planet_osm_20260212_point WHERE tags ? 'fhrs:id'),
     dataset_20260227 (osm_id, revision, name, fhrs_id) AS (SELECT osm_id, tags->'osm_version', name, tags->'fhrs:id' FROM planet_osm_20260227_point WHERE tags ? 'fhrs:id'),
     datasets_combined (osm_id, revision, name, fhrs_id) AS (SELECT * from dataset_20260212 UNION ALL SELECT * from dataset_20260227),
     fhrs_recency AS (
         SELECT
             osm_id,
             name,
             fhrs_id,
             LAST_VALUE(name) OVER (
                 PARTITION BY osm_id
                 ORDER BY revision::int ASC
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
             ) AS latest_name,
             LAST_VALUE(fhrs_id) OVER (
                 PARTITION BY osm_id
                 ORDER BY revision::int ASC
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
             ) AS latest_fhrs_id
         FROM datasets_combined
     )
SELECT
    osm_id,
    name,
    fhrs_id AS superseded_fhrs_id
FROM fhrs_recency
WHERE fhrs_id <> latest_fhrs_id
ORDER BY
    fhrs_id ASC;"
