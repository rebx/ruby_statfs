# -*- encoding: utf-8 -*-

require 'ffi'

module FFI

  module StatFS

    extend FFI::Library
    ffi_lib FFI::Library::LIBC
    attach_function :_statfs, :statfs, [:string, :pointer], :int
    attach_function :_fstatfs, :fstatfs, [:int, :pointer], :int

    #struct statfs {
    #  __SWORD_TYPE f_type;    /* type of file system (see below) */
    #  __SWORD_TYPE f_bsize;   /* optimal transfer block size */
    #  fsblkcnt_t   f_blocks;  /* total data blocks in file system */
    #  fsblkcnt_t   f_bfree;   /* free blocks in fs */
    #  fsblkcnt_t   f_bavail;  /* free blocks available to
    #  unprivileged user */
    #  fsfilcnt_t   f_files;   /* total file nodes in file system */
    #  fsfilcnt_t   f_ffree;   /* free file nodes in fs */
    #  fsid_t       f_fsid;    /* file system id */
    #  __SWORD_TYPE f_namelen; /* maximum length of filenames */
    #  __SWORD_TYPE f_frsize;  /* fragment size (since Linux 2.6) */
    #  __SWORD_TYPE f_spare[5];
    #};
    class FFI::StatFS::Struct < FFI::Struct
      layout :f_type, :int,
      :f_bsize,       :long,
      :f_blocks,      :long,
      :f_bfree,       :long,
      :f_bavail,      :long,
      :f_files,       :long,
      :f_ffree,       :long,
      :f_fsid,        :long,
      :f_namelen,     :int,
      :f_frsize,      :int,
      :f_spare,       [:int, 5]
    end

    def self.statfs(path)
      statbuf = FFI::MemoryPointer.new(FFI::StatFS::Struct)
      FFI.errno = Errno::NOERROR::Errno
      self._statfs(path.to_s, statbuf)
      raise SystemCallError.new(path.to_s, FFI.errno) unless Errno::NOERROR::Errno == FFI.errno
      statbuf
    end

    def self.fstatfs(file_desc_id)
      statbuf = FFI::MemoryPointer.new(FFI::StatFS::Struct)
      FFI.errno = Errno::NOERROR::Errno
      self._statfs(file_desc_id.to_i, statbuf)
      raise SystemCallError.new(path.to_s, FFI.errno) unless Errno::NOERROR::Errno == FFI.errno
      statbuf
    end

  end
end
