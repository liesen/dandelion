cabal.sandbox.config:
	cabal sandbox init
	PKG_CONFIG_PATH="`brew --prefix cairo`/lib/pkgconfig:`brew --prefix pixman`/lib/pkgconfig:`brew --prefix fontconfig`/lib/pkgconfig:`brew --prefix freetype`/lib/pkgconfig:`brew --prefix libpng`/lib/pkgconfig:/opt/X11/lib/pkgconfig:$(PKG_CONFIG_PATH)" \
		cabal install --only-dependencies

dist/build/dandelion/dandelion: cabal.sandbox.config
	cabal build

dandelion.png: cabal.sandbox.config
	cabal run -- -o $@ -h 14200 -w 14400
	gm convert -gravity center -crop 7100x7200+0+0 $@ $@
