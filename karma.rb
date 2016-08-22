require "formula"

class Karma < Formula
  homepage 'http://www.atnf.csiro.au/computing/software/karma/'
  url 'ftp://ftp.atnf.csiro.au/pub/software/karma/karma-1.7.20-common.tgz'
  sha256 '001a7de57f00da5423b8e59b06d16405e99ed4dd1c9298783007e9610a91f5a2'

  resource 'darwin' do
    url 'ftp://ftp.atnf.csiro.au/pub/software/karma/karma-1.7.20-x86_64_Darwin-15.5.tgz'
    sha256 'e7a5bcbad484277537e1ef081baa387842319e100bab6ec2dc1cfa74291bc1eb'
  end

  depends_on :x11 # if your formula requires any X11/XQuartz components

  patch :DATA

  def install
     ENV.deparallelize  # if your formula fails when building in parallel

     # download karma-darwin to the temporary buildpath
     resource("darwin").stage { buildpath.install Dir.glob("*", File::FNM_DOTMATCH) - %w[. ..] }
     prefix.install Dir.glob("*", File::FNM_DOTMATCH) - %w[. ..]

     # symlink bin and lib into KARMABASE
     prefix.install_symlink "x86_64_Darwin-15.5/bin"
     prefix.install_symlink "x86_64_Darwin-15.5/lib"

     # create the karma symlink into /usr/local
     ln_s "#{prefix}", HOMEBREW_PREFIX/"karma"
  end

  def caveats
    s = <<-EOS.undent
      Karma will not work unless there is a symlink to the installation at /usr/local/karma.
      This has been created for you, however it will not be deleted when you remove Karma.
      You will have to delete the link yourself if you ever delete Karma.

      To use Karma from any directory, it needs to be added to your path.
      Add the following to the .profile file located in your home directory. If it doesn't exist, create it.

      if [ -e /usr/local/karma/.karmarc ]; then
        . /usr/local/karma/.karmarc
      fi
      EOS
    s
  end
end
__END__
diff --git a/.karmarc b/.karmarc
index c25d8a0..1969045 100644
--- a/.karmarc
+++ b/.karmarc
@@ -98,7 +98,7 @@ else
     fi
 fi

-PATH=${KARMABASE}/cm_script:${KARMABASE}/csh_script:$KARMABASE/site/$MACHINE_OS/bin:$KARMABINPATH:$PATH
+PATH=$PATH:${KARMABASE}/cm_script:${KARMABASE}/csh_script:$KARMABASE/site/$MACHINE_OS/bin:$KARMABINPATH
 export PATH

 unset i
