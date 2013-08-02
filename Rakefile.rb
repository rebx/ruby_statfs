
desc "Generate FFI structs"
task :ffi_generate do
  require 'ffi'
  require 'ffi/tools/generator'
  require 'ffi/tools/struct_generator'

  ffi_files = ["lib/ffi/statfs/struct.rb.ffi"]
  ffi_options = {:cflags => "-I/usr/lib"}
  ffi_files.each {|ffi_file|
    rb_file = ffi_file.gsub(/\.ffi$/,'')
    #unless uptodate?(rb_file, ffi_file)
      puts "Generating: #{ffi_file} -> #{rb_file}"
      FFI::Generator.new ffi_file, rb_file, ffi_options
    #end
  }
end
