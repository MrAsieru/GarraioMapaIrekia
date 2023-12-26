#! /bin/bash

# Si graph.obj es más nuevo que todos los archivos GTFS cargarlo directamente
if [ $(find /var/garraiomapairekia/gtfs -name "*.zip" | wc -l) -gt 0 ] && { [ ! -f /var/garraiomapairekia/graphs/graph.obj ] || [ $(find /var/garraiomapairekia/gtfs -name "*.zip" -newer /var/garraiomapairekia/graphs/graph.obj | wc -l) -gt 0 ] ;} then
    rm -f /var/opentripplanner/*gtfs.zip
    cp -r /var/garraiomapairekia/osm/* /var/opentripplanner
    cp -r /var/garraiomapairekia/gtfs/* /var/opentripplanner
    /docker-entrypoint.sh --build --save --serve
elif [ -f /var/garraiomapairekia/graphs/graph.obj ]; then
    /docker-entrypoint.sh --load --serve
else
    tail -f /dev/null
fi