

.DEFAULT : __generate__
.PHONY : __generate__ __clean__
.SUFFIXES :
.SECONDARY :
.POSIX :
.SILENT :


_svg_inputs_root := $(abspath ./svg)
_svg_inputs := $(wildcard $(_svg_inputs_root)/*.svg)

_eps_inputs_root := $(abspath ./eps)
_eps_inputs := $(wildcard $(_eps_inputs_root)/*.eps)

_outputs_root := $(abspath ./.outputs)
_shapes_outputs_root := $(_outputs_root)/shapes
_shapes_sheet_output := $(_outputs_root)/shapes.sheet


__generate__ : $(_outputs_root)

__clean__ :
	test ! -e $(_outputs_root) || rm -R $(_outputs_root)


$(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.svg, $(_svg_inputs)) \
		: $(_shapes_outputs_root)/%.svg \
		: $(_svg_inputs_root)/%.svg makefile
	$(info [xx] [make] $(strip $(patsubst $(_outputs_root)/%, %, $(@))))
	test ! -e $(@) || rm $(@)
	test -e $(@D) || mkdir -p $(@D)
	cp -T $(<) $(@)
	cat <$(@) \
	| tr '\t\n\r' ' ' \
	| tr -s ' ' \
	| sed -E -e 's!( *)<!\n<!g' -e 's!>( *)!>\n!g' \
	| sed -E -e '/^$$/d' \
	| cat >$(@)1
	mv -T $(@)1 $(@)

#$(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.svg, $(_svg_inputs)) \
#		: $(_shapes_outputs_root)/%.svg \
#		: $(_eps_inputs_root)/%.eps makefile
#	$(info [xx] [make] $(strip $(patsubst $(_outputs_root)/%, %, $(@))))
#	test ! -e $(@) || rm $(@)
#	test -e $(@D) || mkdir -p $(@D)
#	#a# epstopdf $(<) --outfile=$(@).pdf
#	#a# inkscape --export-plain-svg $(@) $(@).pdf
#	#b# pstoedit -f plot-svg $(<) $(@)
#	cat <$(@) \
#	| tr '\t\n\r' ' ' \
#	| tr -s ' ' \
#	| sed -E -e 's!( *)<!\n<!g' -e 's!>( *)!>\n!g' \
#	| sed -E -e '/^$$/d' \
#	| cat >$(@)1
#	mv -T $(@)1 $(@)

$(_outputs_root) : $(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.svg, $(_svg_inputs))


$(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.shape, $(_svg_inputs)) \
		: $(_shapes_outputs_root)/%.shape \
		: $(_shapes_outputs_root)/%.svg makefile
	$(info [xx] [make] $(strip $(patsubst $(_outputs_root)/%, %, $(@))))
	test ! -e $(@) || rm $(@)
	test -e $(@D) || mkdir -p $(@D)
	{ \
		name="$$( basename -- $(@F) .shape | sed -r -e 's/AWS_Simple_Icons_//g' | tr '_' ' ' )" ; \
		echo '<?xml version="1.0" encoding="UTF-8"?>' ; \
		echo '<shape' ; \
		echo '		xmlns="http://www.daa.com.au/~james/dia-shape-ns"' ; \
		echo '		xmlns:svg="http://www.w3.org/2000/svg">' ; \
		echo '	<name>'"$${name}"'</name>' ; \
		echo '	<icon>$(strip $(patsubst %.shape, %.png, $(@F)))</icon>' ; \
		echo '	<aspectratio type="fixed" /> ' ; \
		echo '	<default-width>2</default-width>' ; \
		echo '	<default-height>2</default-height>' ; \
		echo '	<connections>' ; \
		echo '		<point x="35" y="35" main="yes" />' ; \
		echo '	</connections>' ; \
		echo '	<textbox x1="0" x2="70" y1="0" y2="70" text="..." align="center" resize="no" />' ; \
		sed -n -E \
				-e '/^<\?xml/d' \
				-e '/^<!DOCTYPE/d' \
				-e '/^<!--/d' \
				-e 's!<([^/:]+[ >])!<svg:\1!g' \
				-e 's!</([^/:]+>)!</svg:\1!g' \
				-e 's!fill="([^"]+)"!style="stroke: foreground; stroke-linecap: round; stroke-linejoin: round; fill: \1;"!g' \
				-e 'p' \
			<$(<) ; \
		echo '</shape>' ; \
	} >$(@)

$(_outputs_root) : $(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.shape, $(_svg_inputs))


$(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.png, $(_svg_inputs)) \
		: $(_shapes_outputs_root)/%.png \
		: $(_shapes_outputs_root)/%.svg makefile
	$(info [xx] [make] $(strip $(patsubst $(_outputs_root)/%, %, $(@))))
	test ! -e $(@) || rm $(@)
	test -e $(@D) || mkdir -p $(@D)
	convert -density 600 -resize 22x22 $(<) $(@)

$(_outputs_root) : $(patsubst $(_svg_inputs_root)/%.svg, $(_shapes_outputs_root)/%.png, $(_svg_inputs))


$(_shapes_sheet_output) : $(_svg_inputs) makefile
	$(info [xx] [make] $(strip $(patsubst $(_outputs_root)/%, %, $(@))))
	test ! -e $(@) || rm $(@)
	test -e $(@D) || mkdir -p $(@D)
	{ \
		echo '<?xml version="1.0" encoding="utf-8"?>' ; \
		echo '' ; \
		echo '<sheet xmlns="http://www.lysator.liu.se/~alla/dia/dia-sheet-ns">' ; \
		echo '	' ; \
		echo '	<name>AWS shapes</name>' ; \
		echo '	<description>AWS shapes</description>' ; \
		echo '	' ; \
		echo '	<contents>' ; \
		for shape in $(_svg_inputs) ; do \
			name="$$( basename -- "$${shape}" .svg | sed -r -e 's/AWS_Simple_Icons_//g' | tr '_' ' ' )" ; \
			echo '		<object name="'"$${name}"'"><description>'"$${name}"'</description></object>' ; \
		done | sort ; \
		echo '	</contents>' ; \
		echo '	' ; \
		echo '</sheet>' ; \
	} >$(@)

$(_outputs_root) : $(_shapes_sheet_output)
