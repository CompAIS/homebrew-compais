require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Miriad < Formula
  homepage "http://www.atnf.csiro.au/computing/software/miriad/"
  url "ftp://ftp.atnf.csiro.au/pub/software/miriad/miriad-code.tar.bz2"
  sha256 "3450e52b14e866ca5efc58017c0a6ac4cc5699f4e2caa3cca95d00f5ce9d1f82"

  # depends_on "cmake" => :build
  depends_on "compais/compais/rpfits"
  depends_on "pgplot"
  depends_on "homebrew/science/wcslib" => ['with-pgplot', 'with-fortran']
  depends_on "libpng" => :recommended
  depends_on "readline" => :recommended
  depends_on :x11 # if your formula requires any X11/XQuartz components

  resource "common_code" do
    url "ftp://ftp.atnf.csiro.au/pub/software/miriad/miriad-common.tar.bz2"
    sha256 "33893fa2dfd059dc4a0459ba0d2f385322cd9baf08bbb9f77ed61da33945f657"
  end

  patch :DATA # apply the embedded patch after __END__

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    # install miriad-common into the buildpath.
    resource("common_code").stage { buildpath.install Dir["*"] }

    #ENV["MIR"] = buildpath
    #ENV["MIRARCH"] = `#{ENV["MIR"]}/scripts/mirarch`
    #ENV["MIRBIN"] = "#{ENV["MIR"]}/#{ENV["MIRARCH"]}/bin"

    # Remove unrecognized options if warned by configure
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    #system "cmake", ".", *std_cmake_args
    system "make", "MIR=#{buildpath}"
    inreplace "MIRRC.sh", "#{buildpath}", "#{prefix}"
    prefix.install Dir["*"]
    HOMEBREW_PREFIX.install_symlink "#{prefix}"
  end

  def caveats
    s = <<-EOS.undent
      This script quite annoyingly places a symlink named "code" in your Homebrew prefix directory
      which points to MIRIAD. You should rename this to "miriad".

      To use MIRIAD from any directory, it needs to be added to your path.
      Add the following to the .profile file located in your home directory. If it doesn't exist, create it.

      if [ -e /usr/local/miriad ]; then
        . /usr/local/miriad/MIRRC.sh
        export PATH=$PATH:$MIRBIN
      fi
      EOS
    s
  end
end
__END__
diff --git a/inc/linux64/maxdim.h b/inc/linux64/maxdim.h
index 861172a..5610c87 100644
--- a/inc/linux64/maxdim.h
+++ b/inc/linux64/maxdim.h
@@ -11,7 +11,7 @@ C     is about 260000000; unsuccessful links produce messages about
 C     truncated relocations, imom being the worst offender.
 C     The default value allocates 128MiB (for normal 4-byte INTEGERs).
       INTEGER   MAXBUF
-      PARAMETER(MAXBUF = 32*1024*1024)
+      PARAMETER(MAXBUF = 64*1024*1024)

 C     Maximum image axis length.  Array dimensions are typically a few
 C     times MAXDIM (never MAXDIM**2) so MAXDIM is associated with a much
diff --git a/inc/maxdim.h b/inc/maxdim.h
index ad1471f..990e941 100644
--- a/inc/maxdim.h
+++ b/inc/maxdim.h
@@ -11,7 +11,7 @@ C     is about 260000000; unsuccessful links produce messages about
 C     truncated relocations, imom being the worst offender.
 C     The default value allocates 128MiB (for normal 4-byte INTEGERs).
       INTEGER   MAXBUF
-      PARAMETER(MAXBUF = 32*1024*1024)
+      PARAMETER(MAXBUF = 64*1024*1024)

 C     Maximum image axis length.  Array dimensions are typically a few
 C     times MAXDIM (never MAXDIM**2) so MAXDIM is associated with a much
