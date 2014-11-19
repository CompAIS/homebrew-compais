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
