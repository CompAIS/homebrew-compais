require "formula"

class Rpfits < Formula
  homepage "http://www.atnf.csiro.au/computing/software/rpfits.html"
  url "ftp://ftp.atnf.csiro.au/pub/software/rpfits/rpfits-2.23.tar.gz"
  sha1 "16e4b14ea6cbdeedbc7f47adec3ff2b0aec621de"

  depends_on :fortran

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV['RPARCH'] = "darwin"
    ENV['PREFIX'] = "#{prefix}"
    system "make", "install" # if this fails, try separate make/make install steps
  end
end
