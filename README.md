# GDAL HTTP2 benchmark

```
$ git clone http://github.com/vincentsarago/gdal-http2-benchmark
$ cd gdal-http2-benchmark

$ docker login

$ make build

$ make test-http1

$ make test-http2
```

## Benchmark

Since GDAL 2.3, HTTP2 is available is compiled against libcurl+nghttp2. AS GDAL [docs](https://trac.osgeo.org/gdal/wiki/ConfigOptions#GDAL_HTTP_VERSION) says, enabling HTTP2 can be positive when working with Cloud Optimized GeoTIFFs to save some range requests.

> The interest of enabling HTTP/2 is the use of HTTP/2 multiplexing when reading GeoTIFFs stored on /vsicurl/ and related virtual file systems

type | HTTP1 | HTTP2
--- | ---   | ---  
**HTTP call** | 482 | 26
**Bytes transfered** | 1 244 826 | 1 245 282


#### GDAL_HTTP_MERGE_CONSECUTIVE_RANGES set to "NO" (HTTP1)
```
docker exec -it gdaltest bash -c './main.sh s3://remotepixel-pub/cbers/CBERS_4_MUX_20160416_217_063_L2_BAND5.tif'
Nb requests: 482
Nb bytes: 1 244 826
```

#### GDAL_HTTP_MERGE_CONSECUTIVE_RANGES set to "YES" (HTTP2)
```
docker exec -it gdaltest bash -c './main.sh s3://remotepixel-pub/cbers/CBERS_4_MUX_20160416_217_063_L2_BAND5.tif'
Nb requests: 26
Nb bytes: 1 245 282
```
