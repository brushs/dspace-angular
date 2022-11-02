# This image will be published as dspace/dspace-angular
# See https://github.com/DSpace/dspace-angular/tree/main/docker for usage details

FROM ubuntu:18.04 as build

ARG TEST_ARG=testArgument
RUN echo "Test Arg: " || $TEST_ARG
RUN echo "Test Arg Format B: " || %TEST_ARG%
RUN echo "Test Arg Format C: " || $(TEST_ARG)
RUN echo "Test Arg Format D: " || ${TEST_ARG}

