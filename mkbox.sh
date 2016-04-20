#!/usr/bin/env bash

set -eu

OUTDIR=dot

# basic boxed off versions
IN=templates/b-taggers.template.dot
MVAIN=templates/b-taggers-mva.template.dot
HNODE=templates/hbb-node.dot
HBASE=templates/higgs-base.dot
HBASE2=templates/higgs-base2.dot
L0=templates/higgs-l0.dot
L1=templates/higgs-l1.dot

CALO=templates/calo-base.dot
ANA0=templates/ana0.dot
ANA1=templates/ana1.dot
ANA2=templates/ana2.dot

_file() {
    echo templates/${1%%.dot}.dot
}

mkbox() {
    mkdir -p $OUTDIR
    local TEMP=$(mktemp -t dotfile.XXX)
    cat >> $TEMP
    local BOX
    for BOX in ${@:2} ; do
	local TEMP2=$(mktemp -t dotfile.XXX)
	sed "s/COLOR_${BOX^^}/red/g" $TEMP > $TEMP2
	mv $TEMP2 $TEMP
    done
    local OUT=$OUTDIR/btag-${1,,}.dot
    echo 'digraph g {' > $OUT
    echo '' >> $OUT
    cat $TEMP | sed "s/COLOR_[A-Z0-9]*/grey/" >> $OUT
    echo '' >> $OUT
    echo '}' >> $OUT
}

# mkbox primary   $IN $MVAIN
# mkbox secondary $IN $MVAIN
# mkbox multi     $IN $MVAIN
# mkbox mvb       $IN $MVAIN
cat $IN $MVAIN     | mkbox basic
cat $IN $HNODE     | mkbox htag
cat $IN $HNODE     | mkbox htag-ip primary
cat $IN $HNODE     | mkbox htag-trk mvb
cat $IN $HNODE     | mkbox htag-sv secondary multi

cat $CALO $ANA0  | mkbox ana-base
cat $CALO $ANA1  | mkbox ana-1nn
cat $CALO $ANA2  | mkbox ana-2nn
cat $IN $HBASE2 $L0        | mkbox l05
cat $IN $HBASE2 $L1        | mkbox l1
for HL in mvb multi secondary primary substructure times2 ; do
    cat $IN $HBASE2 $L1 | mkbox l3-$HL $HL
done
cat $IN $HBASE2 $L1 | mkbox l3-vertex multi secondary
cat $IN $HBASE2 $L1 | mkbox l3-track mvb primary

# version with clusters added

