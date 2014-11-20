require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Miriad < Formula
  homepage "http://www.atnf.csiro.au/computing/software/miriad/"
  url "ftp://ftp.atnf.csiro.au/pub/software/miriad/miriad-code.tar.bz2"
  sha1 "17c9cad8412db1821fc0cef34481867e6a46c55c"

  # depends_on "cmake" => :build
  depends_on "rpfits"
  depends_on "pgplot"
  depends_on "homebrew/science/wcslib"
  depends_on "libpng" => :recommended
  depends_on "readline" => :recommended
  depends_on :x11 # if your formula requires any X11/XQuartz components
  
  resource "common_code" do
    url "ftp://ftp.atnf.csiro.au/pub/software/miriad/miriad-common.tar.bz2"
    sha1 "d31256734daace5d6c3b8a5c92504eb218d71d53"
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
    inreplace "MIRRC.sh", "#{buildpath}", "#{prefix}/miriad"
    prefix.install Dir["#{buildpath}"]
    HOMEBREW_PREFIX.install_symlink "#{prefix}/miriad"
  end

  def caveats
    s = <<-EOS.undent
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
index 971aff2..fa77944 100644
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
index 1bc4b62..7def649 100644
--- a/inc/maxdim.h
+++ b/inc/maxdim.h
@@ -5,7 +5,7 @@ C     Size of an INTEGER array used to implement a memory heap.  This
 C     array is the sole variable in blank COMMON in Miriad.  The default
 C     value allocates 4MiB (for normal 4-byte INTEGERs).
       INTEGER   MAXBUF
-      PARAMETER(MAXBUF = 1024*1024)
+      PARAMETER(MAXBUF = 64*1024*1024)
 
 C     Maximum image axis length.  Array dimensions are typically a few
 C     times MAXDIM (never MAXDIM**2) so MAXDIM is associated with a much
@@ -15,7 +15,7 @@ C     segvs in mfclean.  Note that, depending on the algorithm, MAXBUF
 C     may also play an important role in determining the maximum image
 C     size that can be handled.
       INTEGER   MAXDIM
-      PARAMETER(MAXDIM = 16*1024)
+      PARAMETER(MAXDIM = 32*1024)
 
 C     Maximum number of antennas (ATA=64).
       INTEGER   MAXANT
