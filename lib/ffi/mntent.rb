# -*- encoding: utf-8 -*-

require 'ffi'

module FFI

  module MntEnt

    extend FFI::Library
    ffi_lib FFI::Library::LIBC
    attach_function :_getmntent, :getmntent, [:pointer], :int
    attach_function :_setmntent, :setmntent, [:string, :string], :pointer

    #struct mntent {
    #  char *mnt_fsname;   /* name of mounted file system */
    #  char *mnt_dir;      /* file system path prefix */
    #  char *mnt_type;     /* mount type (see mntent.h) */
    #  char *mnt_opts;     /* mount options (see mntent.h) */
    #  int   mnt_freq;     /* dump frequency in days */
    #  int   mnt_passno;   /* pass number on parallel fsck */
    #};
    class FFI::MntEnt::Struct < FFI::Struct
      layout :mnt_fsname, :string,
      :mnt_dir,           :string,
      :mnt_type,          :string,
      :mnt_opts,          :string,
      :mnt_freq,          :int,
      :mnt_passno,        :int
    end

    def self.setmntent(path, opts={:mode => 'r'})
      fp = self._setmntent(path, opts[:mode])
      fp.nil? and raise SystemCallError.new(path.to_s, FFI.errno) 
      fp
    end

    def self.getmntent(path, opts={:mode => 'r'})
      #mntbuf = FFI::MemoryPointer.new(FFI::MntEnt::Struct)
      self._getmntent(self.setmntent(path, opts).get_pointer(0))
    end

  end
end
