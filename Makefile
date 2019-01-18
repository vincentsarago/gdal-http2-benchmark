
SHELL = /bin/bash

################################################################################
# BUILD
build:
	docker build --tag gdaltest:latest .

################################################################################
# DEBUG
shell: build
	docker run --name gdaltest  \
		--volume $(shell pwd)/scripts:/scripts \
		--env GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR \
		--env VSI_CACHE=FALSE \
		--env VSI_CACHE_SIZE=0 \
		--env GDAL_CACHEMAX=0 \
		--env CPL_DEBUG=ON \
		--rm -it gdaltest:latest /bin/bash


################################################################################
run1:
	docker run -w /scripts/ \
		--name gdaltest \
		--volume $(shell pwd)/scripts:/scripts \
		--env GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR \
		--env GDAL_HTTP_MERGE_CONSECUTIVE_RANGES=NO \
		--env GDAL_HTTP_MULTIPLEX=NO \
		--env GDAL_HTTP_VERSION=2 \
		--env VSI_CACHE=FALSE \
		--env VSI_CACHE_SIZE=0 \
		--env GDAL_CACHEMAX=0 \
		--env CPL_DEBUG=ON \
		-itd gdaltest:latest /bin/bash


run2:
	docker run -w /scripts/ \
		--name gdaltest \
		--volume $(shell pwd)/scripts:/scripts \
		--env GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR \
		--env GDAL_HTTP_MERGE_CONSECUTIVE_RANGES=YES \
		--env GDAL_HTTP_MULTIPLEX=YES \
		--env GDAL_HTTP_VERSION=2 \
		--env VSI_CACHE=FALSE \
		--env VSI_CACHE_SIZE=0 \
		--env GDAL_CACHEMAX=0 \
		--env CPL_DEBUG=ON \
		-itd gdaltest:latest /bin/bash


geotiff="https://s3-us-west-2.amazonaws.com/remotepixel-pub/cbers/CBERS_4_MUX_20160416_217_063_L2_BAND5.tif"
test-http1: build run1
	docker exec -it gdaltest bash -c './main.sh ${geotiff}'
	docker stop gdaltest
	docker rm gdaltest

test-http2: build run2
	docker exec -it gdaltest bash -c './main.sh ${geotiff}'
	docker stop gdaltest
	docker rm gdaltest

################################################################################
clean:
	docker stop gdaltest
	docker rm gdaltest
