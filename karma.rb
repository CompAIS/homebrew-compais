require "formula"

# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Karma < Formula
  homepage "http://www.atnf.csiro.au/computing/software/karma/"
  url "ftp://ftp.atnf.csiro.au/pub/software/karma/karma-1.7.20-x86_64_Darwin-11.2.tar.bz2"
  sha1 "e78aac1214cb9dcd7887f3fa19a279d05d3c5f21"
  
  resource 'common' do
    url 'ftp://ftp.atnf.csiro.au/pub/software/karma/karma-1.7.20-common.tar.bz2'
    sha1 'f549ab0c0103800e6883c71d1c2cecefce242e45'
  end  

  depends_on :x11 # if your formula requires any X11/XQuartz components

  def install
     ENV.deparallelize  # if your formula fails when building in parallel
     prefix.install Dir["*"]
     prefix.install resource('common')
     prefix.install ".karmarc"
     ##prefix.install Dir.glob("x86_64_Darwin-11.2/.[a-z]*", File::FNM_DOTMATCH)
  end
end
