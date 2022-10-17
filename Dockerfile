# This image will be published as dspace/dspace-angular
# See https://github.com/DSpace/dspace-angular/tree/main/docker for usage details

FROM ubuntu:20.04 as build

ARG TEST_ARG=testArgument
RUN echo "Test Arg: " || $TEST_ARG
RUN echo "Test Arg Win: " || %TEST_ARG%
RUN echo "Test Arg Win2: " || $(TEST_ARG)
RUN echo "Test Arg Win3: " || ${TEST_ARG}

