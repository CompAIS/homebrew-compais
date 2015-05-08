require 'formula'

class Ds10 < Formula
  homepage "http://spacescience.uws.edu.au/~andrew"
  url "http://spacescience.uws.edu.au/~andrew/ds10.7.3.2.tar.gz"
  version "7.3.2"
  sha1 "ce3599bb0d21394c7c9e869478b1f298882b4d5a"

  depends_on :macos => :lion
  depends_on :x11

  def install
    ENV.deparallelize
    # omit code signing as we do not have the signing identity
    inreplace 'ds9/Makefile.unix', '$(CODESIGN) -s "SAOImage DS9" ds9', ''

    if MacOS.version == :lion
      ln_s "make.darwinlion", "make.include"
    elsif MacOS.version == :mountainlion
      ln_s "make.darwinmountainlion", "make.include"
    else
      ln_s "make.darwinmavericks", "make.include"
    end

    system "make"
    # ds9 requires the companion zip file to live in the same location as the binary
    bin.install 'ds9/ds9', 'ds9/ds9.zip'
  end

  test do
    system "ds9 -analysis message 'It works! Press OK to exit.' -exit"
  end
end