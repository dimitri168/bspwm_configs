#!/bin/bash

# Simple script to switch text in clipboard from cyrillic to latin alphabet
# and back again.

    xclip -selection clipboard -o | \
    perl -CS -Mutf8 -pe "tr/\'&qwertyuiop[]asdfghjkl;'zxcvbnm,.\/~QWERTYUIOP{}ASDFGHJKL;'ZXCVBNM,.\/ё?йцукенгшщзхъфывапролджэячсмитьбю.ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ./ё?йцукенгшщзхъфывапролджэячсмитьбю.ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ.\'&qwertyuiop[]asdfghjkl;'zxcvbnm,.\/~QWERTYUIOP{}]ASDFGHJKL;'ZXCVBNM,./;" | \
    xclip -selection clipboard -i
