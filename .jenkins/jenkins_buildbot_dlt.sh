#!/bin/bash

BUILDBOT_DIR=$WORKSPACE/nightly_build
source $HOME/.bashrc

mkdir -p ${BUILDBOT_DIR}

date
COMPILEDIR=$WORKSPACE/compile/lisa_theano_compile_dir_deeplearning
NOSETESTS=${BUILDBOT_DIR}/Theano/bin/theano-nose
XUNIT="--with-xunit --xunit-file="

FLAGS=warn.ignore_bug_before=0.5,compiledir=${COMPILEDIR}
export PYTHONPATH=${BUILDBOT_DIR}/Theano:${BUILDBOT_DIR}/Pylearn:$PYTHONPATH

cd ${BUILDBOT_DIR}
if [ ! -d ${BUILDBOT_DIR}/Theano ]; then
  git clone git://github.com/Theano/Theano.git
fi
# update repo
cd ${BUILDBOT_DIR}/Theano; git pull

cd ${WORKSPACE}/data
./download.sh

cd ${BUILDBOT_DIR}/Theano
echo "git version for Theano:" `git rev-parse HEAD`
cd ${WORKSPACE}/code
echo "git version:" `git rev-parse HEAD`

echo "executing nosetests speed with mode=FAST_RUN"
FILE=${BUILDBOT_DIR}/dlt_speed_tests.xml
THEANO_FLAGS=${FLAGS},mode=FAST_RUN ${NOSETESTS} ${XUNIT}${FILE} test.py:speed
echo "executing nosetests with mode=FAST_RUN,floatX=float32"
FILE=${BUILDBOT_DIR}/dlt_float32_tests.xml
THEANO_FLAGS=${FLAGS},mode=FAST_RUN,floatX=float32 ${NOSETESTS} ${XUNIT}${FILE}
