# Teapot v2.2.0 configuration generated at 2017-10-07 23:42:48 +1300

required_version "2.0"

# Project Metadata

define_project "botan" do |project|
	project.title = "Botan"
	project.summary = 'A cryptography library providing TLS/DTLS, PKIX certificate handling, PKCS#11 and TPM hardware support, password hashing, and post quantum crypto schemes.'
	
	project.license = 'Simplified BSD License'
end

# Build Targets

define_target 'botan-library' do |target|
	target.build do
		source_files = Files::Directory.join(target.package.path, "upstream")
		cache_prefix = environment[:build_prefix] / environment.checksum + "botan"
		package_files = environment[:install_prefix] / "lib/libbotan-2.a"
		
		copy source: source_files, prefix: cache_prefix
		
		configure prefix: cache_prefix do
			run! "./configure.py",
				"--prefix=#{environment[:install_prefix]}",
				"--cc-bin=#{environment[:cxx]}",
				"--cc-abi-flags=#{environment[:cxxflags].join(' ')}",
				"--disable-shared",
				*environment[:configure],
				chdir: cache_prefix
		end
		
		make prefix: cache_prefix, package_files: package_files
	end
	
	target.depends 'Build/Files'
	target.depends 'Build/Clang'
	
	target.depends "Build/Make", private: true
	
	target.depends :platform
	target.depends 'Language/C++11', private: true
	
	target.provides 'Library/botan' do
		append linkflags [
			->{install_prefix + 'lib/libbotan-2.a'},
		]
	end
end

# Configurations

define_configuration 'development' do |configuration|
	configuration[:source] = "https://github.com/kurocha"
	configuration.import "botan"
	
	# Provides all the build related infrastructure:
	configuration.require 'platforms'
	
	configuration.require 'build-make'
	
	configuration.require "generate-project"
	configuration.require "generate-travis"
end

define_configuration "botan" do |configuration|
	configuration.public!
	
	configuration.require 'build-make'
end
