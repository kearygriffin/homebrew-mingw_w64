require "formula"

class GccCrossMingw64 < Formula
  homepage "https://gcc.gnu.org"
  url "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.3/gcc-4.8.3.tar.bz2"
  sha256 "6a8e4f11b185f4fe2ed9d7fc053e80f8c7e73f800c045f51f9d8bea33f080f1e"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/gcc-mingw64"
  depends_on "cosmo0920/mingw_w64/runtime-mingw64"

  def install
    install_prefix="#{HOMEBREW_PREFIX}/mingw"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "x86_64-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      rm "mingw" if Dir.exist?("mingw")
      ln_s "#{target_arch}", "mingw"
    end

    args = %W[
      CC=gcc-4.8
      CXX=g++-4.8
      CPP=cpp-4.8
      LD=gcc-4.8
      --target=#{target_arch}
      --prefix=#{install_prefix}
      --with-sysroot=#{install_prefix}
      --disable-multilib
      --with-system-zlib
      --enable-version-specific-runtime-libs
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --enable-lto
      --enable-threads=win32
      --enable-languages=c,c++,objc,obj-c++
      --with-gmp=#{Formula["gmp4"].opt_prefix}
      --with-mpfr=#{Formula["mpfr2"].opt_prefix}
      --with-mpc=#{Formula["libmpc08"].opt_prefix}
      --with-cloog=#{Formula["cloog018"].opt_prefix}
      --with-isl=#{Formula["isl011"].opt_prefix}
    ]

    mkdir "build64" do
      system "../configure", *args
      system "make all"
      system "make install"
    end

    chdir "#{install_prefix}/#{target_arch}/lib" do
      ln_s "../../lib/gcc/#{target_arch}/lib/libgcc_s.a", "./"
    end

    # restore PATH
    ENV["PATH"] = path
  end

end
