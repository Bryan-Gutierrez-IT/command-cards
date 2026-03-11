#!/bin/bash

for i in {1..120}; do
    echo "apt upgrade --without-new-pkgs"
done

for i in {1..95}; do
    echo "vim write.c"
done

for i in {1..85}; do
    echo "egrep 9001 scores.txt"
done

for i in {1..70}; do
    echo "sed -i 's/bookworm/trixie/g' notes.txt"
done

for i in {1..66}; do
    echo "gcc write.c -o write"
done

for i in {1..60}; do
    echo "man wait"
done

for i in {1..50}; do
    echo "rm website.tar.gz"
done

for i in {1..45}; do
    echo "exit"
done

for i in {1..30}; do
    echo "git status"
done

for i in {1..25}; do
    echo "grep TODO notes.txt"
done

for i in {1..20}; do
    echo "cat notes.txt"
done

for i in {1..15}; do
    echo "mkdir build"
done

for i in {1..12}; do
    echo "touch report.txt"
done

for i in {1..10}; do
    echo "pwd"
done
