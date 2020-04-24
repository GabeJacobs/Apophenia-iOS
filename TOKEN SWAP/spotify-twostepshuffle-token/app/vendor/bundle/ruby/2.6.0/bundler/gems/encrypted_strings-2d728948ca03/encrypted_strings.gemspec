# -*- encoding: utf-8 -*-
# stub: encrypted_strings 0.3.3 ruby lib

Gem::Specification.new do |s|
  s.name = "encrypted_strings".freeze
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Pfeifer".freeze]
  s.date = "2020-04-24"
  s.description = "Dead-simple string encryption/decryption syntax".freeze
  s.email = "aaron@pluginaweek.org".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze, "CHANGELOG.rdoc".freeze, "LICENSE".freeze]
  s.files = [".gitignore".freeze, ".travis.yml".freeze, "CHANGELOG.rdoc".freeze, "Gemfile".freeze, "LICENSE".freeze, "README.rdoc".freeze, "Rakefile".freeze, "encrypted_strings.gemspec".freeze, "init.rb".freeze, "lib/encrypted_strings.rb".freeze, "lib/encrypted_strings/asymmetric_cipher.rb".freeze, "lib/encrypted_strings/cipher.rb".freeze, "lib/encrypted_strings/extensions/string.rb".freeze, "lib/encrypted_strings/sha_cipher.rb".freeze, "lib/encrypted_strings/symmetric_cipher.rb".freeze, "lib/encrypted_strings/version.rb".freeze, "test/asymmetric_cipher_test.rb".freeze, "test/cipher_test.rb".freeze, "test/keys/encrypted_private".freeze, "test/keys/private".freeze, "test/keys/public".freeze, "test/sha_cipher_test.rb".freeze, "test/string_test.rb".freeze, "test/symmetric_cipher_test.rb".freeze, "test/test_helper.rb".freeze]
  s.homepage = "http://www.pluginaweek.org".freeze
  s.rdoc_options = ["--line-numbers".freeze, "--inline-source".freeze, "--title".freeze, "encrypted_strings".freeze, "--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Encrypts strings".freeze
  s.test_files = ["test/asymmetric_cipher_test.rb".freeze, "test/cipher_test.rb".freeze, "test/keys/encrypted_private".freeze, "test/keys/private".freeze, "test/keys/public".freeze, "test/sha_cipher_test.rb".freeze, "test/string_test.rb".freeze, "test/symmetric_cipher_test.rb".freeze, "test/test_helper.rb".freeze]

  s.installed_by_version = "3.0.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
