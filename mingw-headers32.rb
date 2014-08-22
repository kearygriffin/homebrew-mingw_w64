require "formula"

class MingwHeaders32 < Formula
  homepage "http://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  depends_on "gcc48" => :build

  def install
    install_prefix="/usr/local/mingw"
    args = %W[
      --host=i686-w64-mingw32
      --prefix=#{install_prefix}
    ]

    system "./mingw-w64-headers/configure", *args
    system "make"
    system "make install-strip"
  end

end
