require "formula"

class Rpfits < Formula
  homepage "http://www.atnf.csiro.au/computing/software/rpfits.html"
  url "ftp://ftp.atnf.csiro.au/pub/software/rpfits/rpfits-2.24.tar.gz"
  sha256 "fe25759fb1093e327cdf04739dc30e0f3193c21e2b44deb7ead62d335bd54b25"

  depends_on :fortran

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    ENV['RPARCH'] = "darwin"
    ENV['PREFIX'] = "#{prefix}"
    ENV['FFLAGS'] = "-g -O -fimplicit-none -Wall"
    ENV['CFLAGS'] = "-arch x86_64 -g -O -Wall"
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
