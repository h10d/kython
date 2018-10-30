#!/bin/bash
ROOT=$(dirname $(readlink -f $0))

PROJECT_NAME="kython"

BUILD_PATH=$ROOT/build
DOCU_PATH=$ROOT/doc

DOCU_GEN_PATH=$DOCU_PATH/temp
DOCU_OUTPUT_PATH=$DOCU_PATH/doc/
DOXYFILE_PATH=$DOCU_PATH/Doxyfile

TEST_TARGET=${PROJECT_NAME}_test

pushd() {
    command pushd "$@" >/dev/null
}

popd() {
    command popd "$@" >/dev/null
}

pushd $ROOT

clean() {
    echo "Cleaning..."
    rm -rf $BUILD_PATH
    rm -rf $DOCU_GEN_PATH
}

build() {
    mkdir -p $BUILD_PATH
    pushd $BUILD_PATH
    cmake -G "Unix Makefiles" -Dgtest_disable_pthreads=ON ..
    cmake --build . --target $PROJECT_NAME -- -j 8
    popd # leave build-path
}

test() {
    mkdir -p $BUILD_PATH
    pushd $BUILD_PATH
    cmake -G "Unix Makefiles" -Dgtest_disable_pthreads=ON ..
    cmake --build . --target $TEST_TARGET
    ./$TEST_TARGET
    popd # leave build-path
}

docu() {
    command -v doxygen >/dev/null 2>&1 || {
        echo >&2 "I require doxygen but it's not installed.  Aborting."
        exit 1
    }
    pushd $ROOT
    # convert to windows-path for doxygen
    DOCU_GEN_PATH="$(echo "$DOCU_GEN_PATH" | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^./\0:/')"
    DOCU_OUTPUT_PATH="$(echo "$DOCU_OUTPUT_PATH" | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^./\0:/')"

    DOXY_ERROR=$ROOT/doxyerror.log
    DOXY_LOG=$ROOT/doxylog.log
    (
        cat $DOXYFILE_PATH
        echo "" # newline - to avoid problems with config-files with no newline at the end
        echo "OUTPUT_DIRECTORY=$DOCU_GEN_PATH"
        echo "HTML_OUTPUT=$DOCU_OUTPUT_PATH"
    ) | doxygen - >$DOXY_LOG 2>$DOXY_ERROR

    retVal=$?
    if [ $retVal -ne 0 ]; then
        cat $DOXY_ERROR
        cat $DOXY_LOG
        exit $retVal
    fi
    cat $DOXY_ERROR

    popd
}

all() {
    build
    test
    docu
}

usage() {
    echo "usage: make [[--clean] [--build] [--test] [--docu] [--all]]"
}

command -v cmake >/dev/null 2>&1 || {
    echo >&2 "I require cmake but it's not installed.  Aborting."
    exit 1
}

# main loop
while [ "$1" != "" ]; do
    case $1 in
    -b | --build) build=1 ;;
    -c | --clean) clean=1 ;;
    -t | --test) testing=1 ;;
    -d | --docu) docu=1 ;;
    -a | --all) all=1 ;;
    -h | --help)
        usage
        exit
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift
done

if [ "$clean" = "1" ]; then
    clean
fi

if [ "$build" = "1" ]; then
    build
fi

if [ "$docu" = "1" ]; then
    docu
fi

if [ "$testing" = "1" ]; then
    test
fi

if [ "$all" = "1" ]; then
    all
fi
popd # leave root
