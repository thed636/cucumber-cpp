#!/bin/sh
set -e #break script on non-zero exitcode from any command
gem install bundler

cmake -E make_directory build
if [ -z ${GMOCK_PATH+x} ]; then 
    cmake -E chdir build cmake -DCUKE_ENABLE_EXAMPLES=on -DCUKE_GMOCK_VER=${GMOCK_VER}  .. ;
else
    cmake -E chdir build cmake -DCUKE_ENABLE_EXAMPLES=on -DCUKE_GMOCK_DIR=${GMOCK_PATH} -DGTEST_INCLUDE_DIR=/usr/src/gmock/gtest/include/  .. ;
fi
cmake --build build
cmake --build build --target test
cmake --build build --target features

GTEST=build/examples/Calc/GTestCalculatorSteps 
BOOST=build/examples/Calc/BoostCalculatorSteps
if [ -f $GTEST ]; then
    $GTEST >/dev/null &
    cucumber examples/Calc
fi
if [ -f $BOOST ]; then 
    $BOOST >/dev/null &
    cucumber examples/Calc
fi

